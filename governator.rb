require 'zulip'

module Ahhnold
  config = {streams: File.read('./governator_streams').lines.map(&:chomp)}

  zulip = Zulip::Client.new do |config|
    config.email_address = ENV.fetch( 'ZULIP_GOVERNATOR_EMAIL' )
    config.api_key = ENV.fetch( 'ZULIP_GOVERNATOR_API_KEY' )
  end

  config.fetch(:streams).each do |stream|
    zulip.subscribe(stream)
  end
 
  zulip.stream_messages do |message|
    stream = message.stream
    if message.content.match(/in hopper/) and message.sender_email != ENV.fetch( 'ZULIP_GOVERNATOR_EMAIL' )
      puts message.content

      zulip.send_message(message.subject, "GET TO THE HOPPPAA", stream)
    end
  end
end
