class Location
  include Mongoid::Document
  field :position, :type => Integer
  embedded_in :page
end
