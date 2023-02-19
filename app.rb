# app.rb
require 'sinatra'
require 'line/bot'

def client
  @client ||= Line::Bot::Client.new { |config|
    config.channel_id = "1657922839"
    config.channel_secret = "d48966219a7601f8c30841dee4a14743"
    config.channel_token = "QxDM6a7qSthkGWqt76EOwedCuWZRtf2p4O00VCGqTtViywRNlqptFtj4XIlRXQ69AVjDaHsCxvX/hsY3rr4138lK5cQmtT2kWA+LvNVlH6VW5zeg97YHzB8mhew789PI6feieQHZ6iMxaBmTswsh+AdB04t89/1O/w1cDnyilFU="
  }
end

post '/callback' do
  body = request.body.read

  signature = request.env['HTTP_X_LINE_SIGNATURE']
  unless client.validate_signature(body, signature)
    error 400 do 'Bad Request' end
  end

  events = client.parse_events_from(body)
  events.each do |event|
    case event
    when Line::Bot::Event::Message
      case event.type
      when Line::Bot::Event::MessageType::Text
        message = {
          type: 'text',
          text: "kjhhkjhkjhjkh"
        }
        client.reply_message(event['replyToken'], message)
      when Line::Bot::Event::MessageType::Image, Line::Bot::Event::MessageType::Video
        response = client.get_message_content(event.message['id'])
        tf = Tempfile.open("content")
        tf.write(response.body)
      end
    end
  end

  # Don't forget to return a successful response
  "OK"
end