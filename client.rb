require_relative 'em-websocket-client'

EM.run do
  conn = EventMachine::WebSocketClient.connect("ws://localhost:3001/")

  conn.callback do
    conn.send_msg "connected!"
  end

  conn.errback do |e|
    puts "Got error: #{e}"
  end

  conn.stream do |msg|
    puts "<#{msg}>"
  end

  conn.disconnect do
    puts "disconnected!"
    EM::stop_event_loop
  end
end
