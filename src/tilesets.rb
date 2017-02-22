require 'json'

TILESETS = File.open('assets/tilesets.json') do |data|
  JSON.parse(data.read).freeze
end
