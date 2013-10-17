require 'sinatra'
require 'twilio-ruby'
require 'pusher'

before do
  Pusher.app_id = ENV['PUSHER_APP_ID']
  Pusher.key = ENV['PUSHER_KEY']
  Pusher.secret = ENV['PUSHER_SECRET']
end

get '/chaos/' do
  Pusher['trick_channel'].trigger('chaos', {:message => 'chaos ensued'})
  erb :chaos
end

post '/trick/?' do
  output = "Message transmitted"
  command = params['Body'].downcase
  begin
    Pusher['trick_channel'].trigger('starting:', {:message => command})
  rescue Pusher::Error => e
    output = "Failed: #{e.message}"
  end
  # Switch colors
  case command
  when 'purple'
    puts Pusher['trick_channel'].trigger('purple', {:message => 'purple'})
  when 'blue'
    puts Pusher['trick_channel'].trigger('blue', {:message => 'blue'})
  when 'red'
    puts Pusher['trick_channel'].trigger('red', {:message => 'red'})
  when 'green'
    puts Pusher['trick_channel'].trigger('green', {:message => 'green'})
  when 'bats'
    puts Pusher['trick_channel'].trigger('bats', {:message => 'go bats'})
  when 'chaos'
    redirect to("/chaos/")
  else
    puts Pusher['trick_channel'].trigger('orange', {:message => 'orange'})
    resp = Twilio::TwiML::Response.new do |r|
      r.Sms "Available Commands: orange, blue, red, green, purple, chaos"
    end
    resp.text
  end

  if params['SmsSid'] == nil
    erb :index, :locals => {:msg => output}
  else
    response = Twilio::TwiML::Response.new do |r|
      r.Sms output
    end
    response.text
  end
end

get '/' do
  erb :index, :locals => {:msg => "Haunted Hack"}
end