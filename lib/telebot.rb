class Telebot
  attr_reader :logger

  def initialize token, logger, replies
    @token = token
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
            bot.api.sendMessage(chat_id: message.chat.id, text: response)
            break
          end
        end
      end
    end
  end
end
