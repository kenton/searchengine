require 'yaml'
require 'robots'
require 'net/http'
require 'nokogiri'

class Crawler

  USER_AGENT = "foo-spider"

  attr_accessor :urls, :robot

  def initialize(url_file = "./lib/search/urls.yml")
    @urls = YAML::load_file(File.open(url_file))
    @robot = Robots.new USER_AGENT
  end

  def allowed_to_crawl?(page)
    robot.allowed?(page)
  end

  def links_on_page(requested_url)
    return [] unless allowed_to_crawl?(requested_url)

    webpage = Net::HTTP.get(URI(requested_url))
    page = Nokogiri::HTML(webpage)
    all_anchor_tags = page.css('a')
    all_links = all_anchor_tags.map { |tag| tag.attributes["href"].value}

    all_links.select do |link| 
      link.gsub!(/^\//, requested_url + "/") if link.match(/^\/.*/)
    end

    all_links
  end
end
