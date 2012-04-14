require 'yaml'
require 'robots'

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
end
