require 'bundler/setup'
Bundler.require(:default)
require 'logger'
TOKEN = ENV['TOKEN']
raise "no TOKEN specified" if TOKEN.nil?
logger = Logger.new('bot.log')

logger.info "starting bot"
bot = TelegramBot.new(token: TOKEN)

bot.get_updates(fail_silently: true) do |message|
  logger.debug "@#{message.from.username}: #{message.text}"
  command = message.get_command_for(bot)
  message.reply do |reply|

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
    when /придется.*джойнить/i
      "@#{message.from.username} ну ахуеть теперь"
    when /просто мне кажется/i
      "@#{message.from.username} ты наверное не понял"
    when "/start"
      "@#{message.from.username} сам ты бот"
    end

    if response != nil
      reply.text = response
      logger.debug "sending #{reply.text.inspect} to @#{message.from.username}"
      reply.send_with(bot)
    end
  end
end
