# Make::Booth Stream

Make::Booth のストリームをアレコレするアプリ

## 必要なもの

    Ruby
    Growl

### RubyGems

    eventmachine
    em-websocket
    em-websocket-client
    json (Ruby 1.9 未満の場合)
    growl
    thor

## インストール

    git clone git://github.com/mitukiii/make-booth-stream-for-ruby.git make-booth-stream
    cd make-booth-stream
    bundle install

## 使い方

Make::Booth のストリームを受信し Growl 通知

    $ ./make_booth.rb stream

Make::Booth のストリームをエミュレートする WebSocket サーバを起動

    $ ./make_booth.rb server

## ヘルプ

ヘルプ

    $ ./make_booth.rb 
    Tasks:
      make_booth.rb help [TASK]  # Describe available tasks or one specific task
      make_booth.rb server       # Emulate Make::Booth activity stream server
      make_booth.rb stream       # Start receive Make::Booth activity stream.

stream のヘルプ

    $ ./make_booth.rb help stream
    Usage:
      make_booth.rb stream

    Options:
      -d, [--debug]  # Connect to emulated local server.
      -s, [--save]   # Save received json data. (No save if debug mode.)
                     # Default: true
      -g, [--growl]  # Notify received data.
                     # Default: true
      -l, [--log]    # Log received data.
                     # Default: true
    
    Start receive Make::Booth activity stream.

server のヘルプ

    $ ./make_booth.rb help server
    Usage:
      make_booth.rb server
    
    Options:
      -i, [--interval=N]  # Interval between send the json data.
                          # Default: 10
    
    Emulate Make::Booth activity stream server

## コピーライト

Released under the MIT license  
[http://www.opensource.org/licenses/MIT](http://www.opensource.org/licenses/MIT)
