#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'rubygems'
require 'bundler'
Bundler.require
require 'json' unless defined? JSON
require 'open-uri'

module MakeBooth
  ACTIVITY_URI = 'ws://ws.makebooth.com:5678/'
  IMAGE_HOST   = 'http://img.makebooth.com'
  IMAGE_SMALL  = IMAGE_HOST + '/scale/c.50x50.'

  ICON_DIR     = File.join(File.dirname(__FILE__), 'icon')

  module Stream
    module_function
    def connect
      EventMachine.run do
        con = EventMachine::WebSocketClient.connect ACTIVITY_URI
        con.stream     &method(:stream)
        con.disconnect &method(:disconnect)
      end
    end

    def stream(message)
      data = JSON.parse(message)
      $stdout.puts data.inspect

      text = data['text'].gsub(/<\/?[^>]*>/, '')

      options = {}
      if data['user_image_file_name']
        icon_name = data['user_image_file_name']
        icon_path = File.join(ICON_DIR, icon_name)
        unless File.exists? icon_path
          image_uri = image_host + icon_name
          open(icon_path, 'w') do |icon|
            icon.print open(image_uri).read
          end
        end
        options[:icon] = icon_path
      end

      Growl.notify text, options
    end

    def disconnect
      $stderr.puts 'disconnect'
      EventMachine.stop_event_roop
    end
  end
end

MakeBooth::Stream.connect
