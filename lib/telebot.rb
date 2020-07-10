require 'net/http'
require 'json'
require_relative 'polly'

class Telebot
  attr_reader :logger

  def initialize config, logger, replies
    @config = config
    @token = config["token"]
    @logger = logger
    @replies = replies
  end

  def start
    logger.debug "starting bot..."
    Telegram::Bot::Client.run(@token) do |bot|
      bot.listen do |message|
        logger.debug "#{message.chat.id} | message | @#{message.from.username}: #{message.text}"
        command = message.text
        @replies.each do |regex, replies|
          if command =~ /#{regex}/i
            response = replies.sample
            response.gsub!('%username%', "@#{message.from.username}")
            logger.info "#{message.chat.id} | response | sending \"#{response}\" to @#{message.from.username}"
            bot.api.sendMessage chat_id: message.chat.id, text: response
            break
          end
        end
        if command =~ /(^|\s)(кот(ик|ов|иков|ики|ика|а|ы)?|кошка)($| )/
          logger.debug "cats command execute"
          photo_url = JSON.parse(Net::HTTP.get('api.thecatapi.com', '/v1/images/search')).first["url"]
          bot.api.sendPhoto chat_id: message.chat.id, photo: photo_url, caption: "держи кота"
        end
        if command =~ /(сер.га,?)?\s*скажи ублюдкам/i
          phrase = command.scan(/скажи ублюдкам[:\s+]?\s*(.*)/i).flatten.first
          logger.debug("generate phraze: #{phrase}")
          filename = Polly.new(@config, phrase).generate
          path = "https://monoti.ru/public_uploads/#{filename}"
          logger.debug("send voice file: #{path}")
          bot.api.sendVoice chat_id: message.chat.id, voice: path
        end
      end
    end
  end
end
