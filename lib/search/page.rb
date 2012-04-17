class Page

  attr_accessor :response

  include Mongoid::Document
  field :url
  field :title
  embedded_in :word
  embeds_many :locations
  field :created_at, :type => DateTime
  field :updated_at, :type => DateTime

  COMMON_WORDS = YAML.load_file('./config/common.yml')

  def words_on_page
    #doc = Nokogiri::HTML(open(url))
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

  def response
    @response ||= Nokogiri::HTML(open(url))
  end

  def title
    response.css('title').children.first.text
  end
end
