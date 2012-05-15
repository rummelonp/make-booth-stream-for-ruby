# -*- coding: utf-8 -*-

require 'open-uri'

module MakeBooth
  ACTIVITY_URI = 'ws://ws.makebooth.com:5678/'
  HOST         = 'http://makebooth.com'
  IMAGE_HOST   = 'http://img.makebooth.com'
  IMAGE_SMALL  = IMAGE_HOST + '/scale/c.50x50.'

  DATA_DIR     = File.join(File.dirname(__FILE__), '..', '..', 'data')
  ICON_DIR     = File.join(File.dirname(__FILE__), '..', '..', 'icon')

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
      datum = JSON.parse(message)

      data_path = File.join(DATA_DIR, 'data.json')
      data = JSON.parse(open(data_path).read) rescue []
      data << datum
      open(data_path, 'w') { |f| f.puts JSON.pretty_generate(data) }

      text = datum['text'].gsub(/<\/?[^>]*>/, '')
      date = DateTime.parse(datum['created_at'])

      $stdout.puts text
      $stdout.puts '  link: ' + HOST + datum['image_file_link_path']
      $stdout.puts '  date: ' + date.strftime('%Y/%m/%d %H:%M')

      if datum['user_image_file_name']
        icon_name = datum['user_image_file_name']
        image_uri = IMAGE_SMALL + icon_name
      else
        icon_name = 'default_icon.png'
        image_uri = HOST + '/img/' + icon_name
      end
      icon_path = File.join(ICON_DIR, icon_name)
      unless File.exists? icon_path
        open(icon_path, 'w') do |icon|
          icon.print open(image_uri).read
        end
      end

      Growl.notify text, :icon => icon_path
    end

    def disconnect
      $stderr.puts 'disconnect'
      EventMachine.stop_event_loop
    end
  end
end
