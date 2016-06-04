require "rubygems"
require "bundler"
require "sinatra"
require "sinatra/activerecord"
require "httparty"
require "json"
require "./models/door"

Bundler.require

get "/check-door" do
  puts "Checking status..."
  puts Door.first.status
end

put "/update-door/:status" do |status|
  puts "Hitting update..."
  door = Door.first
  if door
    door.update_attributes({ status: status })
  else
    Door.create!({ status: status })
  end
end
