# -*- coding: utf-8 -*-

require 'open-uri'

module MakeBooth
  module Stream extend self
    ACTIVITY_URI = 'ws://ws.makebooth.com:5678'
    HOST         = 'http://makebooth.com'
    IMAGE_HOST   = 'http://img.makebooth.com'
    IMAGE_SMALL  = IMAGE_HOST + '/scale/c.50x50.'

    DEBUG_URI    = 'ws://localhost:5678'

    def start(options = {})
      debug = options.fetch :debug, false
      save  = options.fetch :save,  true
      growl = options.fetch :growl, true
      log   = options.fetch :log,   true

      save  = false if debug

      EventMachine.run do
        uri = debug ? DEBUG_URI : ACTIVITY_URI
        con = EventMachine::WebSocketClient.connect(uri)

        con.stream do |msg|
          $stdout.puts "MakeBooth#Stream: receive message"

          datum = JSON.parse(msg)

          save_datum(datum)  if save
          growl_datum(datum) if growl
          log_datum(datum)   if log
        end

        con.disconnect do
          $stderr.puts 'MakeBooth#Stream: disconnected'
          EventMachine.stop_event_loop
        end
      end
    end

    private
    def save_datum(datum)
      data = JSON.load(open(DATA_PATH)) rescue []
      data << datum
      open(DATA_PATH, 'w') { |f| f.puts JSON.pretty_generate(data) }
    end

    def growl_datum(datum)
      text = strip_tags(datum['text'])

      if datum['user_image_file_name']
        icon_name = datum['user_image_file_name']
        image_uri = IMAGE_SMALL + icon_name
      else
        icon_name = 'default_icon.png'
        image_uri = HOST + '/img/' + icon_name
      end

      icon_path = File.join(ICON_DIR, icon_name)

      unless File.exists? icon_path
        open(icon_path, 'w') { |f| f.print open(image_uri).read }
      end

      Growl.notify text, :icon => icon_path
    end

    def log_datum(datum)
      text = strip_tags(datum['text'])
      date = DateTime.parse(datum['created_at'])
      $stdout.puts '  ' + text
      $stdout.puts '    link: ' + HOST + datum['image_file_link_path']
      $stdout.puts '    date: ' + date.strftime('%Y/%m/%d %H:%M')
    end

    def strip_tags(text)
      text.gsub(/<\/?[^>]*>/, '')
    end
  end
end
