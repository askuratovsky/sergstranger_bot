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

  def reply(message)
    logger.debug "#{message.chat&.id} | message | @#{message.from&.username}: #{message.text}"
    command = message.text

    chat_id = message.chat.id

    chat_id = -411111792 if command =~ /(^|\s)тестчат\s/
    chat_id = -277090382 if command =~ /(^|\s)вчат\s/

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
      bot.api.sendVoice chat_id: chat_id, voice: path
    end
  rescue => e
    logger.error "#{e.message}\n\t" + e.backtrace.join("\n\t")
  end

  def start
    logger.debug "starting bot..."
    Telegram::Bot::Client.run(@token) do |bot|
      bot.listen do |message|
        reply(message)
      end
    end
  end
end
