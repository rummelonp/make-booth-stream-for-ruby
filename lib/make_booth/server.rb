# -*- coding: utf-8 -*-

module MakeBooth
  HOST = 'localhost'
  PORT = 5678

  DATA_DIR = File.join(File.dirname(__FILE__), '..', '..', 'data')

  module Server
    module_function

    def start
      EventMachine::WebSocket.start(:host => HOST, :port => PORT) do |server|
        server.onopen    &method(:onopen)
        server.onmessage &method(:onmessage)
        server.onclose   &method(:onclose)

        data_path = File.join(DATA_DIR, 'data.json')
        data = JSON.parse(open(data_path).read) rescue []
        EventMachine.add_periodic_timer(1) do
          server.send data.shuffle.first.to_json
        end
      end
    end

    def onopen
      $stderr.puts 'open'
    end

    def onmessage(message)
      $stderr.puts "message: #{message}"
    end

    def onclose
      $stderr.puts "onclose"
    end
  end
end
