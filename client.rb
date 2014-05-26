require_relative 'em-websocket-client'
require 'arduino_firmata'

arduino = ArduinoFirmata.connect

EM.run do
    conn = EventMachine::WebSocketClient.connect("ws://0.0.0.0:3001/")

    conn.callback do
        conn.send_msg "connected!"
    end

    conn.errback do |e|
        puts "Got error: #{e}"
    end

    conn.stream do |msg|
        puts msg
        if String(msg) == "f"
            arduino.digital_write 13, true
        elsif String(msg) == 'b'
            arduino.digital_write 13, false
        end
    end

    conn.disconnect do
        puts "disconnected!"
        EM::stop_event_loop
    end
end
