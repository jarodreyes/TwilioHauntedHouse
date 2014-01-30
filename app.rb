require 'sinatra'
require 'twilio-ruby'
require 'pusher'

before do
  # Setup 
  Pusher.app_id = ENV['PUSHER_APP_ID']
  Pusher.key = ENV['PUSHER_KEY']
  Pusher.secret = ENV['PUSHER_SECRET']
end

introClips = ["intro500.mp3", "intro501.mp3", "intro1299.mp3", "intro1300.mp3", "intro1302.mp3", "intro1328.mp3", "intro1330.mp3", "intro1331.mp3", "intro1339.mp3", "intro1390.mp3", "intro1343.mp3", "intro1346.mp3", "intro1347.mp3", "intro1349.mp3", "intro1350.mp3", "intro1352.mp3", ]
hosts = ["luke", "jen", "andrew", "sean"]
language = ["da-DK", "de-DE", "en-AU", "ca-ES", "en-US", "es-MX", "fi-FI", "fr-FR", "js-JP", "ko-KR", "nl-NL", "pl-PL", "zh-HK"]

get '/chaos/' do
  erb :chaos
end

get '/live?*' do
  erb :live
end

get '/tbtl-twiml?*' do
  response = Twilio::TwiML::Response.new do |r|
    r.Play "http://hauntedhack.herokuapp.com/sounds/welcome.mp3"
    r.Gather :action => "http://hauntedhack.herokuapp.com/tbtl", :method => "GET" do |g|
      g.Say "Press 1 for one T.B.T.L intro.... Press 2 for a random soundbite from T.B.T.L ."
    end
  end
  response.text
end

get '/tbtl?*' do
  lang = language.sample
  command = params['Digits']
  begin
    case command
    when '1'
      media = introClips.sample
    when '2'
      num = rand(23)
      media = "random#{num}.mp3"
    else
      media = "luke1.mp3"
    end
  rescue
  end
  response = Twilio::TwiML::Response.new do |r|
    r.Play "http://hauntedhack.herokuapp.com/sounds/#{media}"
    r.Say "Remember, no mountain to tall. And"
    r.Say "good luck to all!", :voice => "alice", :language => lang
  end
  response.text
end

get '/tbtl-sms?*' do
  response = Twilio::TwiML::Response.new do |r|
    r.Sms "Thanks for texting TBTL-BOT. What features should we add?"
  end
  response.text
end

get '/trick/?' do
  output = "Our ghoulish ghosts have heard your wish. Happy Halloween! Text 'trick' to see a list of haunted commands."
  begin
    Pusher['trick_channel'].trigger('starting:', {:message => 'starting up trick'})
  rescue Pusher::Error => e
    output = "Failed: #{e.message}"
  end
  # Switch colors
  begin
    command = params['Body'].downcase
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
    when 'orange'
      puts Pusher['trick_channel'].trigger('orange', {:message => 'orange'})
    when 'chaos'
      puts Pusher['trick_channel'].trigger('chaos', {:message => 'unleash'})
    when 'trick'
      output = "Available Tricks: orange, blue, red, green, purple, trex, sing or chaos."
    else
      puts Pusher['trick_channel'].trigger(command, {:message => command})
    end
  rescue
    command = "no message"
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
