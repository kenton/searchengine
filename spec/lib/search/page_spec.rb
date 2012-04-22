require 'spec_helper'

describe Page do

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

  describe "#clean_text" do
    it "removes newline characters" do
      doc = Nokogiri::HTML(open('spec/support/newline_page.html'))
      Nokogiri::HTML::Document.stub!(:parse)
      Nokogiri::HTML::Document.should_receive(:parse).and_return(doc)
      page = Page.new(:url => "http://example.com")
      words = ["quick", "quick", "brown", "fox", "jumps", "over", "lazy", "dog"]

      page.clean_text.should not_include("\n")
    end
    it "removes multiple spaces"
    it "strips trailing spaces"
  end

  describe "#remove_trailing_characters" do
    it "removes trailing '.' from words"
    it "removes trailing ':' from words"
    it "removes trailing ',' from words"
  end

  describe "#filter_common_words" do
    it "removes common words"
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
end
