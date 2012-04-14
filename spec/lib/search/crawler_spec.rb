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
     # stub Nokogiri call here...
     # get HTML page:
     #   webpage = Net::HTTP.get(URI("http://kentonnewby.com"))
     # parse a page:
     #   page = Nokogiri::HTML(webpage)
     # all links:
     #   page.css('a')
     # external links:
     #   links.map { |l| l.attributes["href"].value }.select { |l| l.match(/^http:*/) }
  describe "parse_url(url)", :vcr do

    before(:each) do
      @url_to_request = "http://kentonnewby.com"
      @crawler = Crawler.new
    end

    it "parses the URL for a page that can be added to the index and returns a list of external links" do
      array_of_urls = ["http://kentonnewby.com/", 
                       "http://kentonnewby.com/about", 
                       "http://kentonnewby.com/profile", 
                       "http://kentonnewby.com/bucket-list", 
                       "http://kentonnewby.com/contact", 
                       "http://kentonnewby.com/", 
                       "http://kentonnewby.com/", 
                       "http://kentonnewby.com/blog/categories/web-development/", 
                       "http://kentonnewby.com/blog/categories/ruby/",
                       "http://kentonnewby.com/blog/categories/rails/",
                       "http://kentonnewby.com/blog/categories/jquery/",
                       "http://kentonnewby.com/blog/categories/backbonejs/",
                       "http://kentonnewby.com/blog/categories/nodejs/",
                       "http://kentonnewby.com/blog/categories/mobile-development/",
                       "http://kentonnewby.com/blog/categories/ios/",
                       "http://kentonnewby.com/blog/categories/mobile-web/",
                       "http://kentonnewby.com/blog/categories/business/",
                       "http://kentonnewby.com/blog/categories/marketing/",
                       "http://kentonnewby.com/blog/categories/sales/",
                       "http://kentonnewby.com/blog/categories/lifestyle-design/",
                       "http://kentonnewby.com/blog/categories/inner-game/",
                       "http://kentonnewby.com/blog/categories/productivity/",
                       "http://kentonnewby.com/blog/categories/inspirational/",
                       "http://kentonnewby.com/blog/categories/books/",
                       "http://feeds.feedburner.com/kentonnewby",
                       "http://twitter.com/kentonnewby",
                       "http://kentonnewby.com/quick-git-summaries-using-git-shortlog",
                       "http://kentonnewby.com/blog/categories/git/",
                       "http://kentonnewby.com/quick-git-summaries-using-git-shortlog",
                       "http://kentonnewby.com/benefits-of-tdd",
                       "http://kentonnewby.com/blog/categories/rails/",
                       "http://kentonnewby.com/blog/categories/ruby/",
                       "http://kentonnewby.com/benefits-of-tdd",
                       "http://kentonnewby.com/are-you-a-producer-or-a-consumer",
                       "http://kentonnewby.com/blog/categories/inner-game/",
                       "http://kentonnewby.com/are-you-a-producer-or-a-consumer",
                       "http://kentonnewby.com/amending-last-git-commit",
                       "http://kentonnewby.com/blog/categories/git/",
                       "http://kentonnewby.com/amending-last-git-commit",
                       "http://kentonnewby.com/ios-development-workflow",
                       "http://kentonnewby.com/blog/categories/ios/",
                       "http://kentonnewby.com/blog/categories/mobile-development/",
                       "http://kentonnewby.com/ios-development-workflow",
                       "http://kentonnewby.com/page/2/",
                       "http://kentonnewby.com/blog/archives",
                       "http://kentonnewby.com/about",
                       "http://codecanyon.net?ref=kentonnewby",
                       "http://themeforest.net?ref=kentonnewby",
                       "http://f52f6a2culudsoi0rj6a0h3rbu.hop.clickbank.net/",
                       "http://www.mailchimp.com",
                       "http://www.railscasts.com",
                       "http://www.peepcode.com",
                       "http://www.destroyallsoftware.com/screencasts",
                       "http://www.practicingruby.com",
                       "http://www.startupsfortherestofus.com/",
                       "http://kentonnewby.com/privacy",
                       "http://kentonnewby.com/earnings-disclaimer",
                       "http://kentonnewby.com/terms-of-use",
                       "http://kentonnewby.com/sitemap.xml",
                       "http://octopress.org"
                      ]

      @crawler.parse_page(@url_to_request).should == array_of_urls
    end

    it "adds hostname to relative links relative links" do
      @crawler.parse_page(@url_to_request).should include("http://kentonnewby.com/about")
    end
  end

  describe "it processes the pages in the seed URL list and any newly found pages until no more pages can be found" do
    #it "determines if a page can be added to the index"
    #it "retrieves each page that can be added to the index"
    it "parses the URLs on each page and saves them to a collection"
    it "prints a general error message if an exception is raised"
    it "prints a timeout error message if a TimeoutException is raised"
    it "writes the URLs for the newly found pages to the end of the .yml file"

  end
end
