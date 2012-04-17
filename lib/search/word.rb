class Word
  include Mongoid::Document
  field :stem
  embeds_many :pages
end
