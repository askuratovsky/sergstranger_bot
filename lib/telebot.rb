class Telebot
  attr_reader :logger

  def initialize token, logger
    @token = token
    @logger = logger
  end

  def start
    logger.debug "starting bot..."
    Telegram::Bot::Client.run(@token) do |bot|
      bot.listen do |message|
        logger.debug "#{message.chat.id} | message | @#{message.from.username}: #{message.text}"
        command = message.text
        response = case command
        when /я сделал/i
          "@#{message.from.username} отлично, но придется переделать"
        when /предлагаю/i
          "@#{message.from.username} принял во внимание но пока нет"
        when /я перепутал|я ошибся|я забыл|не понимаю/i
          [ "сраный позор!",
          "бля если так тупо никто не понимает проекта может кто-то не на своем месте?"].sample
        when /внутренн(ем|ий) аукционe?/i
          "засуньте себе куда-нить внутренний аукцион"
        when /раньше было/i
          "ну было и было"
        when /как (спарсить|вычислить)/i
          "давай товарищ программист, научу тебя программировать, хули мне осталось"
        when /успешно пройден/i
          "ай е"
        when /подстраивались под нас/i
          ["нахуй мне отдел разработки если я должен ждать что кто-то там под чет подстроится",
          ":) бляяяяя просто ад, господи дай мне это развидеть)"].sample
        when /ужасная логика/i
          "@#{message.from.username} ужасная логика с которой ты читаешь API чужие"
        when /[)]{5}|ахаха/i
          "@#{message.from.username} че ты ржешь интегратор года"
        when /таблицу.*джойнить/i
          "@#{message.from.username} ну ахуеть теперь"
        when /просто мне кажется/i
          "@#{message.from.username} ты наверное не понял"
        when /может кофе/i
          "только тяжелые наркотики!"
        when /релиз/i
          "все хуйня давай по новой"
        when "/start", /(^| )бот($| )/i
          "@#{message.from.username} сам ты бот, пидор"
        end

        if response != nil
          logger.info "#{message.chat.id} | response | sending \"#{response}\" to @#{message.from.username}"
          bot.api.sendMessage(chat_id: message.chat.id, text: response)
        end
      end
    end
  end
end
