class Page

  attr_accessor :response

  include Mongoid::Document
  field :url
  field :title
  field :keywords, :type => Array
  embeds_many :locations
  field :created_at, :type => DateTime
  field :updated_at, :type => DateTime

  COMMON_WORDS = YAML.load_file('./config/common.yml')

  def keywords
    @keywords ||= words_on_page
  end

  def words_on_page
    response.search('script').each {|el| el.unlink}
    words = response.text.gsub("\n", " ").squeeze(" ").strip.split(" ").map(&:downcase)
    words.select do |word|
      word.chop! if word.end_with?(".") or word.end_with?(":") or word.end_with?(",")
    end

    words.delete_if do |word|
      COMMON_WORDS.include?(word) or
        word.length > 25 or
        word.to_i != 0
    end

    words.uniq
  end

  # TODO: move this to initialize? and make it an attr_reader instead?
  def response
    @response ||= Nokogiri::HTML(open(url))
  end


  def title
    @title ||= response.css('title').children.first.text
  end

  def clean_text
    response.text.gsub("\n", " ").squeeze(" ").strip.split(" ").map(&:downcase)
  end

  def self.with_keyword(search_term)
    matching_pages = Page.all(:conditions => { :keywords => search_term })
    matching_pages.map { |page| page.url }
  end
end
