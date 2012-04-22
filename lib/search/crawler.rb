require 'yaml'
require 'robots'
require 'net/http'
require 'nokogiri'


Mongoid.configure do |config|
  config.master = Mongo::Connection.new.db("searchengine")
end

class Crawler

  USER_AGENT = "foo-spider"

  attr_accessor :url_file, :urls, :robot

  def initialize(url_file = "./lib/search/urls.yml")
    @url_file = url_file
    @urls = YAML::load_file(File.open(@url_file))
    @robot = Robots.new USER_AGENT
  end

  def allowed_to_crawl?(page)
    robot.allowed?(page)
  end

  def links_on_page(requested_url)
    return [] unless allowed_to_crawl?(requested_url)

    webpage = Net::HTTP.get(URI(requested_url))
    parsed_page = Nokogiri::HTML(webpage)
    all_anchor_tags = parsed_page.css('a')
    all_links = all_anchor_tags.map { |tag| tag.attributes["href"].value unless tag.attributes["href"].nil? }

    all_links.select do |link|
      link.gsub!(/^\//, requested_url + "/") if link.match(/^\/.*/) unless link.nil?
      link.chop! if link.end_with?("/") unless link.nil?
    end

    all_links
  end

  def save_newly_found_pages(new_pages)
    File.open(url_file, "w") { |file| YAML.dump(new_pages, file) }
  end

  # seed
  # - news.google.com => google.com, plus.google.com, reader.google.com

  def crawl
    new_pages = []

    urls.each do |url|
      add_to_index(url)
      new_pages.concat(links_on_page(url))
    end

    self.urls = new_pages.uniq

    save_newly_found_pages(new_pages)

    new_pages.uniq
  end

  def add_to_index(url)
    page = Page.find_or_initialize_by(:url => url)
    if page.new_record?
      # save new record to database
      puts "Adding the following URL to the index: #{url}"
      page.update_attributes!(:title      => page.title,
                              :keywords   => page.keywords,
                              :created_at => Time.now,
                              :updated_at => Time.now)
    else
      # update existing record in database
      puts "Updating the following URL in the index: #{url}"
      page.keywords = nil
      page.title    = nil
      page.update_attributes!(:title      => page.title,
                              :keywords   => page.keywords,
                              :updated_at => Time.now)

    end
  end

end
