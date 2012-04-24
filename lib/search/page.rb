

class Page

  attr_accessor :response, :links

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

  def self.search(search_term)
    matching_pages = Page.all(:conditions => { :keywords => search_term })
    matching_pages.map { |page| page.url }
  end
  
  def links
    @links ||= links_on_page
  end

  def links_on_page
    #return [] unless allowed_to_crawl?(url)

    webpage = Net::HTTP.get(URI(url))
    parsed_page = Nokogiri::HTML(webpage)
    all_anchor_tags = parsed_page.css('a')
    all_links = all_anchor_tags.map { |tag| tag.attributes["href"].value unless tag.attributes["href"].nil? }

    all_links.select do |link|
      link.gsub!(/^\//, url + "/") if link.match(/^\/.*/) unless link.nil?
      link.chop! if link.end_with?("/") unless link.nil?
    end

    all_links
  end

  # save new record to database
  def add
    puts "Adding the following URL to the index: #{url}"
    update_attributes!(:title      => title,
                            :keywords   => keywords,
                            :created_at => Time.now,
                            :updated_at => Time.now)
  end

  # update existing record in database
  def update
    puts "Updating the following URL in the index: #{url}"
    keywords = nil
    title    = nil
    update_attributes!(:title      => title,
                            :keywords   => keywords,
                            :updated_at => Time.now)

  end

  def ignore
    puts "Ignoring the following URL which was recently added/updated: #{url}"
  end
end
