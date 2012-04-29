require 'spec_helper'

describe Page do

  describe "#keywords" do
    context "memoizes the list of keywords on the page" do
      it "calls words_on_page method if @keywords isn't set" do
        expected_keywords = ["foo", "bar", "baz"]
        page = Page.new(:url => "http://kentonnewby.com")
        page.stub(:words_on_page).and_return(expected_keywords)
        page.should_receive(:words_on_page)

        page.keywords.should == expected_keywords
      end

      it "returns @keywords if @keywords is set" do
        expected_keywords = ["foo", "bar", "baz"]
        page = Page.new(:url => "http://kentonnewby.com")
        page.instance_variable_set('@keywords', expected_keywords)

        page.keywords.should == expected_keywords
      end
    end
  end

  describe "#words_on_page" do
    it "returns a lowercase list of the unique words on the page" do
      doc = Nokogiri::HTML(open('spec/support/test_page.html'))
      Nokogiri::HTML::Document.stub!(:parse)
      Nokogiri::HTML::Document.should_receive(:parse).and_return(doc)
      page = Page.new(:url => "http://example.com")
      words = ["quick", "quick", "brown", "fox", "jumps", "over", "lazy", "dog"]

      page.words_on_page.should == words.uniq
    end

    it "removes text in script tags" do
      doc = Nokogiri::HTML(open('spec/support/script_page.html'))
      Nokogiri::HTML::Document.stub!(:parse)
      Nokogiri::HTML::Document.should_receive(:parse).and_return(doc)
      page = Page.new(:url => "http://example.com")
      words = ["quick", "quick", "brown", "fox", "jumps", "over", "lazy", "dog"]

      page.words_on_page.should == words.uniq
    end

    it "removes common words" do
      doc = Nokogiri::HTML(open('spec/support/common_words_page.html'))
      Nokogiri::HTML::Document.stub!(:parse)
      Nokogiri::HTML::Document.should_receive(:parse).and_return(doc)
      page = Page.new(:url => "http://example.com")
      words = ["quick", "quick", "brown", "fox", "jumps", "over", "lazy", "dog"]

      page.words_on_page.should == words.uniq
    end

    it "removes numbers from the list of words on the page" do
      doc = Nokogiri::HTML(open('spec/support/numbers_page.html'))
      Nokogiri::HTML::Document.stub!(:parse)
      Nokogiri::HTML::Document.should_receive(:parse).and_return(doc)
      page = Page.new(:url => "http://example.com")
      words = ["quick", "quick", "brown", "fox", "jumps", "over", "lazy", "dog"]

      page.words_on_page.should == words.uniq

    end
  end

  describe "#response" do
    it "memoizes the response for an HTTP request"
  end

  describe "#title" do
    it "returns the title of the page" do
      doc = Nokogiri::HTML(open('spec/support/title_page.html'))
      Nokogiri::HTML::Document.stub!(:parse)
      Nokogiri::HTML::Document.should_receive(:parse).and_return(doc)
      page = Page.new(:url => "http://example.com")

      page.title.should == "My Test Page"
    end
  end

  describe "#clean_text" do
    it "removes newline characters" do
      doc = Nokogiri::HTML(open('spec/support/newline_page.html'))
      Nokogiri::HTML::Document.stub!(:parse)
      Nokogiri::HTML::Document.should_receive(:parse).and_return(doc)
      page = Page.new(:url => "http://example.com")
      words = ["quick", "quick", "brown", "fox", "jumps", "over", "lazy", "dog"]

      page.clean_text.should_not include("\n")
    end
    it "removes multiple spaces"
    it "strips trailing spaces"
  end

  describe ".search" do
    it "returns a list of pages that match a single keyword" do
      page1 = Page.new(:url => "http://firstpage.com")
      page2 = Page.new(:url => "http://secondpage.com")
      pages = [page1, page2]
      Page.should_receive(:all).and_return(pages)
      search_result = pages.map { |p| p.url  }

      Page.search("foobar").should == search_result
    end
    it "returns a list of pages that match multiple keywords"
    it "returns a list of pages that match a keyword phrase"
  end

  describe "#links" do
    it "memoizes the list of links on the page"
  end

  describe "#links_on_page", :vcr do

    before(:each) do
      @page = Page.new(:url => "http://kentonnewby.com")
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

      @page.links_on_page.should == array_of_urls
    end

    it "adds hostname to relative links relative links" do
      @page.links.should include("http://kentonnewby.com/about")
    end
  end

  describe "#add" do
    it "outputs a message to STDOUT"
    it "adds the page to the database"
  end

  describe "#update" do
    it "outputs a message to STDOUT"
    it "updates the page's info in the database"
  end

  describe "#ignore" do
    it "outputs a message to STDOUT"
  end
end
