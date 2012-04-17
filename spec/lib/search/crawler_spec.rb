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
  describe "#links_on_page", :vcr do

    before(:each) do
      @url = "http://kentonnewby.com"
      @crawler = Crawler.new
    end

    it "returns empty unless requested URL allows crawler to crawl page" do
      @crawler.stub(:allowed_to_crawl?).and_return(false)

      @crawler.links_on_page(@url).should == []
    end

    it "parses the URL for a page that can be added to the index and returns a list of external links" do
      array_of_urls = ["http://kentonnewby.com",
                       "http://kentonnewby.com/about",
                       "http://kentonnewby.com/profile",
                       "http://kentonnewby.com/bucket-list",
                       "http://kentonnewby.com/contact",
                       "http://kentonnewby.com",
                       "http://kentonnewby.com",
                       "http://kentonnewby.com/blog/categories/web-development",
                       "http://kentonnewby.com/blog/categories/ruby",
                       "http://kentonnewby.com/blog/categories/rails",
                       "http://kentonnewby.com/blog/categories/jquery",
                       "http://kentonnewby.com/blog/categories/backbonejs",
                       "http://kentonnewby.com/blog/categories/nodejs",
                       "http://kentonnewby.com/blog/categories/mobile-development",
                       "http://kentonnewby.com/blog/categories/ios",
                       "http://kentonnewby.com/blog/categories/mobile-web",
                       "http://kentonnewby.com/blog/categories/business",
                       "http://kentonnewby.com/blog/categories/marketing",
                       "http://kentonnewby.com/blog/categories/sales",
                       "http://kentonnewby.com/blog/categories/lifestyle-design",
                       "http://kentonnewby.com/blog/categories/inner-game",
                       "http://kentonnewby.com/blog/categories/productivity",
                       "http://kentonnewby.com/blog/categories/inspirational",
                       "http://kentonnewby.com/blog/categories/books",
                       "http://feeds.feedburner.com/kentonnewby",
                       "http://twitter.com/kentonnewby",
                       "http://kentonnewby.com/quick-git-summaries-using-git-shortlog",
                       "http://kentonnewby.com/blog/categories/git",
                       "http://kentonnewby.com/quick-git-summaries-using-git-shortlog",
                       "http://kentonnewby.com/benefits-of-tdd",
                       "http://kentonnewby.com/blog/categories/rails",
                       "http://kentonnewby.com/blog/categories/ruby",
                       "http://kentonnewby.com/benefits-of-tdd",
                       "http://kentonnewby.com/are-you-a-producer-or-a-consumer",
                       "http://kentonnewby.com/blog/categories/inner-game",
                       "http://kentonnewby.com/are-you-a-producer-or-a-consumer",
                       "http://kentonnewby.com/amending-last-git-commit",
                       "http://kentonnewby.com/blog/categories/git",
                       "http://kentonnewby.com/amending-last-git-commit",
                       "http://kentonnewby.com/ios-development-workflow",
                       "http://kentonnewby.com/blog/categories/ios",
                       "http://kentonnewby.com/blog/categories/mobile-development",
                       "http://kentonnewby.com/ios-development-workflow",
                       "http://kentonnewby.com/page/2",
                       "http://kentonnewby.com/blog/archives",
                       "http://kentonnewby.com/about",
                       "http://codecanyon.net?ref=kentonnewby",
                       "http://themeforest.net?ref=kentonnewby",
                       "http://f52f6a2culudsoi0rj6a0h3rbu.hop.clickbank.net",
                       "http://www.mailchimp.com",
                       "http://www.railscasts.com",
                       "http://www.peepcode.com",
                       "http://www.destroyallsoftware.com/screencasts",
                       "http://www.practicingruby.com",
                       "http://www.startupsfortherestofus.com",
                       "http://kentonnewby.com/privacy",
                       "http://kentonnewby.com/earnings-disclaimer",
                       "http://kentonnewby.com/terms-of-use",
                       "http://kentonnewby.com/sitemap.xml",
                       "http://octopress.org"
                      ]

      @crawler.links_on_page(@url).should == array_of_urls
    end

    it "adds hostname to relative links relative links" do
      @crawler.links_on_page(@url).should include("http://kentonnewby.com/about")
    end
  end

  describe "#save_newly_found_pages" do
    it "writes the list of newly found pages to the file that stores the list of URLs" do
      url_file = "./fixtures/urls.yml"
      new_url_list = url_file = "./fixtures/new_url_list.yml"
      new_pages = ["http://kentonnewby.com", "http://rubyonrails.org", "http://mailchimp.com"]
      crawler = Crawler.new(url_file)
      crawler.stub(:links_on_page).and_return(new_pages)

      crawler.save_newly_found_pages(new_pages)
      YAML.load_file(url_file).should == new_pages
    end
  end

  describe "#crawl" do
    it "crawls the list of URLs looking for new links if the URLs allow crawler to index the site" do

    end
  end

  describe "it processes the pages in the seed URL list and any newly found pages until no more pages can be found" do
    #it "determines if a page can be added to the index"
    #it "retrieves each page that can be added to the index"
    #it "parses the URLs on each page and saves them to a collection"
    it "prints a general error message if an exception is raised"
    it "prints a timeout error message if a TimeoutException is raised"
    #it "writes the URLs for the newly found pages to the end of the .yml file"
    # File.open(URL_LIST, "w") { |file| YAML.dump(stuff, file) }
  end

  describe "#add_to_or_update_index" do
    it "adds new pages to the index"
    # tries to find a page in the database that matches that url
    # does a find_or_create_by_url
    # if the page is a new_record?
    #    #... index it
    # else if the page is stale, 
    #   #...update it
    # else 
    #     #...do nothing
    #    
    # Word.where("pages.url" => "http://kentonnewby.com")
  end

  describe "#index_page" do
    # get all words on the page
    # ********  need to see if word is new or already in the dB
    # words.each do |word|
    #   w = Word.new(:stem => word)
    #   new_page = Page.new(:url => self.url, 
    #                       :title => self.title
    #                       :created_at => DateTime.now
    #                       :updated_at => DateTime.now)
    #   new_location = Location.new(:position => the word's index)
    #   new_page.locations.push(new_location)
    #   w.pages.push(new_page)
    #
    # end
  end

  describe "#update_page" do

  end



end
