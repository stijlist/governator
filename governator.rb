require 'zulip'

module Ahhnold
  zulip = Zulip::Client.new do |config|
    config.email_address = ENV.fetch( 'ZULIP_GOVERNATOR_EMAIL' )
    config.api_key = ENV.fetch( 'ZULIP_GOVERNATOR_API_KEY' )
  end

  File.read('./governator_streams').lines.map(&:chomp).
    fetch(:streams).each { |stream| zulip.subscribe(stream) }
 
  zulip.stream_messages do |message|
    if message.content.match(/in hopper/) and message.sender_email != ENV.fetch( 'ZULIP_GOVERNATOR_EMAIL' )
      zulip.send_message(message.subject, "GET TO THE HOPPPAA", message.stream)
    end
  end
end
