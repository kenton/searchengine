require 'spec_helper'

describe Page do

  describe "#words_on_page" do
    it "returns a lowercase list of the unique words on the page"
    it "removes text in script tags"
  end

  describe "#clean_text" do
    it "removes newline characters"
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

end
