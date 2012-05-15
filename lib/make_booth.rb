# -*- coding: utf-8 -*-

module MakeBooth
  ROOT      = File.join(File.dirname(__FILE__), '..')
  DATA_DIR  = File.join(ROOT, 'data')
  ICON_DIR  = File.join(ROOT, 'icon')
  DATA_PATH = File.join(DATA_DIR, 'data.json')

  autoload :CLI,    'make_booth/cli'
  autoload :Server, 'make_booth/server'
  autoload :Stream, 'make_booth/stream'
end
