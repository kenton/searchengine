require 'mongoid'

Mongoid.configure do |config|
  config.master = Mongo::Connection.new.db("searchengine")
end
