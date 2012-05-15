# -*- coding: utf-8 -*-

module MakeBooth
  class CLI < Thor
    desc 'stream', 'Start receive Make::Booth activity stream.'
    method_option :debug, :aliases => '-d', :type => :boolean, :default => false,
      :desc => 'Connect to emulated local server.'
    method_option :save,  :aliases => '-s', :type => :boolean, :default => true,
      :desc => 'Save received json data. (No save if debug mode.)'
    method_option :growl, :aliases => '-g', :type => :boolean, :default => true,
      :desc => 'Notify received data.'
    method_option :log,   :aliases => '-l', :type => :boolean, :default => true,
      :desc => 'Log received data.'
    def stream
      MakeBooth::Stream.start(symbolize_keys(options))
    end

    desc 'server', 'Emulate Make::Booth activity stream server'
    method_option :interval, :aliases => '-i', :type => :numeric, :default => Server::INTERVAL,
      :desc => 'Interval between send the json data.'
    def server
      MakeBooth::Server.start(symbolize_keys(options))
    end

    private
    def symbolize_keys(hash)
      other = {}
      hash.keys.each do |key|
        other[key.to_sym] = hash[key]
      end
      other
    end
  end
end
