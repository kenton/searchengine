require 'mongoid'

Mongoid.configure do |config|
  config.master = Mongo::Connection.new.db("searchengine_dev")
  config.master = Mongo::Connection.new.db("searchengine_test") if ENV["SEARCHENGINE_ENV"] = 'test'
end
