require 'yaml'
require 'robots'
require 'net/http'
require 'nokogiri'

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

  def save_newly_found_pages(new_pages)
    File.open(url_file, "w") { |file| YAML.dump(new_pages, file) }
  end

  # seed
  # - news.google.com => google.com, plus.google.com, reader.google.com

  def crawl
    new_pages = []

    urls.each do |url|
      begin
        page = Page.find_or_initialize_by(:url => url)
        if page.new_record?
          page.add
        elsif page.stale?
          page.update
        else
          page.ignore
        end

        new_pages.concat(page.links)
      rescue
        next
      end
    end

    self.urls = new_pages.uniq

    save_newly_found_pages(new_pages.uniq)

    new_pages.uniq
  end

end
