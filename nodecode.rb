require 'rubygems'
require 'mqtt'

# Publish example
MQTT::Client.connect('192.168.1.101') do |c|
  c.publish('YantraData', 'message')
end

# Subscribe example
MQTT::Client.connect('192.168.1.101') do |c|
  # If you pass a block to the get method, then it will loop
  c.get('YantraData') do |topic,message|
    puts "#{topic}: #{message}"
  end
end

