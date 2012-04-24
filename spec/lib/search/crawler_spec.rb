require 'spec_helper'

describe Crawler do
  describe "initialization steps" do
    it "saves the url_file parameter to an instance variable" do
      url_file = "./fixtures/urls.yml"
      crawler = Crawler.new(url_file)
      crawler.url_file.should == "./fixtures/urls.yml"
    end

    it "loads a list of seed URLs from a .yml file" do
      url_file = "./fixtures/urls.yml"
      crawler = Crawler.new(url_file)
      crawler.urls.should == ["http://news.google.com", "http://cnn.com", "http://loyola.edu"]
    end

    it "sets the USER_AGENT" do
      robot = Robots.new Crawler::USER_AGENT
      crawler = Crawler.new
      crawler.robot.should be_a(Robots)
    end
  end

  describe "#allowed_to_crawl?" do
    it "returns true if user_agent is allowed to crawl the requested site" do
      page = "http://www.google.com"
      Robots.any_instance.stub(:allowed?).with(page).and_return(true)
      crawler = Crawler.new
      crawler.allowed_to_crawl?(page).should == true
    end

    it "returns false if user_agent is not allowed to crawl the requested site" do
      page = "http://www.google.com"
      Robots.any_instance.stub(:allowed?).with(page).and_return(false)
      crawler = Crawler.new
      crawler.allowed_to_crawl?(page).should == false
    end
  end

  # stub Nokogiri call here...
  # get HTML page:
  #   webpage = Net::HTTP.get(URI("http://kentonnewby.com"))
  # parse a page:
  #   page = Nokogiri::HTML(webpage)
  # all links:
  #   page.css('a')
  # external links:
  #   links.map { |l| l.attributes["href"].value }.select { |l| l.match(/^http:*/) }

  describe "#save_newly_found_pages" do
    it "writes the list of newly found pages to the file that stores the list of URLs" do
      url_file = "./fixtures/urls.yml"
      new_url_list = url_file = "./fixtures/new_url_list.yml"
      new_pages = ["http://kentonnewby.com", "http://rubyonrails.org", "http://mailchimp.com"]
      crawler = Crawler.new(url_file)
      Page.any_instance.stub(:links).and_return(new_pages)

      crawler.save_newly_found_pages(new_pages)
      YAML.load_file(url_file).should == new_pages
    end
  end

  describe "#crawl" do
    it "crawls the list of URLs looking for new links if the URLs allow crawler to index the site" do
      crawler = Crawler.new
      crawler.urls = ["http://kentonnewby.com"]
      newly_found_pages = ["http://kentonnewby.com/about", "http://kentonnewby.com", "http://kentonnewby.com/contact", "http://twitter.com/kentonnewby"]
      Page.any_instance.stub(:links).and_return(newly_found_pages)

      crawler.crawl.should == newly_found_pages
    end
  end

end
