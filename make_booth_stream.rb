#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'rubygems'
require 'bundler'
Bundler.require
require 'json' unless defined? JSON
require 'open-uri'

EventMachine.run do
  uri = 'ws://ws.makebooth.com:5678/'
  image_host = 'http://img.makebooth.com/scale/c.50x50.'
  icon_dir = File.join(File.dirname(__FILE__), 'icon')

  con = EventMachine::WebSocketClient.connect(uri)

  con.stream do |message|
    json = JSON.parse(message)
    $stdout.puts json.inspect

    text = json['text'].gsub(/<\/?[^>]*>/, '')

    options = {}
    if json['user_image_file_name']
      icon_name = json['user_image_file_name']
      icon_path = File.join(icon_dir, icon_name)
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
end
