#!/usr/bin/env ruby

require 'bundler/setup'
Bundler.require(:default)
require 'daemons'

DAEMON_OPTS = {
  app_name: 'sergstranger_bot',
  dir_mode: :normal,
  dir: 'pids',
  backtrace: true,
  monitor: true,
  log_output: true
}

Daemons.run File.join("./lib/run.rb"), DAEMON_OPTS
