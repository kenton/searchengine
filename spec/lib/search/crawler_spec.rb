require 'spec_helper'

describe Crawler do
  it "loads a list of seed URLs from a .yml file" do
    url_file = File.open("./fixtures/urls.yml")
    crawler = Crawler.new(url_file)
    crawler.urls.should == ["http://news.google.com", "http://cnn.com", "http://loyola.edu"]
  end
  
  it "sets the USER_AGENT" do
    robot = Robots.new Crawler::USER_AGENT
    crawler = Crawler.new
    crawler.robot.should be_a(Robots)
  end

  describe "allowed_to_crawl?" do
    it "returns true if user_agent is allowed to crawl the site" do
      page = "http://www.google.com"
      Robots.any_instance.stub(:allowed?).with(page).and_return(true)
      crawler = Crawler.new
      crawler.allowed_to_crawl?(page).should == true
    end

    it "returns false if user_agent is not allowed to crawl the site" do
      page = "http://www.google.com"
      Robots.any_instance.stub(:allowed?).with(page).and_return(false)
      crawler = Crawler.new
      crawler.allowed_to_crawl?(page).should == false
    end
  end
  
  describe "check urls" do
    #it "retrieves each url that can be added to the index" do
      #crawler.check_urls.should == 
    #end
  end

  describe "it processes the pages in the seed URL list and any newly found pages until no more pages can be found" do
    #it "determines if a page can be added to the index"
    it "retrieves each page that can be added to the index"
    it "parses the URLs on each page and saves them to a collection"
    it "prints a general error message if an exception is raised"
    it "prints a timeout error message if a TimeoutException is raised"
    it "writes the URLs for the newly found pages to the end of the .yml file"

  end
end
