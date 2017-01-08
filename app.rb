require "rubygems"
require "bundler"
require "sinatra"
require "sinatra/activerecord"
require "httparty"
require "json"
require "dotenv"
require "base64"
require "./models/door"

Bundler.require
Dotenv.load

config = {
  outgoing_token: ENV["OUTGOING_TOKEN"]
}

get "/" do
  "Hello world! Welcome to the Doorman app. This is the Ruby part of an IoT project that will tell a user if a door is open or closed."
end

get "/check-door" do
  if params[:token] == config[:outgoing_token]
    door_status = Door.first.status
    color =  door_status == 'open' ? '37A651' : 'BF4040'
    body  = { response_type: "ephemeral",
              text: "Checking the bathroom door...",
              attachments: [
                {
                  color: color,
                  text: "It's #{Door.first.status}!"
                }
              ]
            }

    response = HTTParty.post(params[:response_url], body: body.to_json)
    puts "Request sent"
  end
end

put "/update-door/:status" do |status|
  if ['open', 'closed'].include?(status)
    door = Door.first
    if door
      door.update_attributes({ status: status })
    else
      Door.create!({ status: status })
    end
  end
end
