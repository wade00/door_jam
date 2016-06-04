require "rubygems"
require "bundler"
require "sinatra"
require "httparty"
require "json"

Bundler.require

get "/check-door" do
end

put "/update-door" do
  puts params
end
