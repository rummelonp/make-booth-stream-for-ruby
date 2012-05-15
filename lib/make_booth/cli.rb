# -*- coding: utf-8 -*-

module MakeBooth
  class CLI < Thor
    desc 'stream', 'Start receive Make::Booth activity stream'
    def stream
      MakeBooth::Stream.connect
    end

    desc 'server', 'Emulate Make::Booth activity stream server'
    def server
      MakeBooth::Server.start
    end
  end
end
