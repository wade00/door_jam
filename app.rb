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
  outgoing_token: ENV["OUTGOING_TOKEN"],
  slack_team_id:  ENV["SLACK_TEAM_ID"]
}

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
    puts response
  end
end

get "/update-door/:status" do |status|
  door = Door.first
  if door
    door.update_attributes({ status: status })
  else
    Door.create!({ status: status })
  end
end
