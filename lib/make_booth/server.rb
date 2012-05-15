# -*- coding: utf-8 -*-

module MakeBooth
  module Server
    HOST     = 'localhost'
    PORT     = 5678
    INTERVAL = 10

    @connections = []
    @data = JSON.load(open(DATA_PATH)) rescue []

    module_function

    def start(options = {})
      interval = options.fetch :interval, INTERVAL

      EventMachine.run do
        EventMachine::WebSocket.start(:host => HOST, :port => PORT) do |con|
          con.onopen do
            $stdout.puts "MakeBooth#Server: connection opened #{con}"

            @connections.push(con) unless @connections.include?(con)
          end

          con.onclose do
            $stderr.puts "MakeBooth#Server: connection closed #{con}"

            @connections.delete(con)
          end
        end

        EventMachine.add_periodic_timer(interval) do
          $stdout.puts "MakeBooth#Server: send data to #{@connections.size} connections"

          datum = @data.shift
          @data << datum

          @connections.each do |con|
            con.send(datum.to_json)
          end
        end

        $stdout.puts "MakeBooth#Server: start web socket server on ws://#{HOST}:#{PORT}"
      end
    end
  end
end
