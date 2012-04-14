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

  def parse_page(url_to_request)
    webpage = Net::HTTP.get(URI(url_to_request))
    page = Nokogiri::HTML(webpage)
    all_anchor_tags = page.css('a')
    all_links = all_anchor_tags.map { |tag| tag.attributes["href"].value}
    #absolute_links = all_links.select { |link| link.match(/^https?:.*/) }

    all_links.select do |link| 
      link.gsub!(/^\//, url_to_request + "/") if link.match(/^\/.*/)
    end

    all_links
  end
end
