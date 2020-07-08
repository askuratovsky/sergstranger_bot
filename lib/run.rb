require 'logger'
require 'yaml'
require_relative 'telebot'

config = YAML::load_file File.join(__dir__, '../config/config.yaml')
token = config["token"]
raise "no TOKEN specified" if token.nil?
logger = Logger.new(STDOUT, Logger::DEBUG)

begin
  bot = Telebot.new(token, logger)
  bot.start
rescue => exception
  logger.error exception.message + "\n\t" + exception.backtrace.first(20).join("\n\t")
  sleep 5
  retry
end
