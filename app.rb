require 'thin'
require 'em-websocket'
require 'sinatra/base'

EM.run do
    class App < Sinatra::Base
        get '/' do
            erb :index
        end
        set :bind, '0.0.0.0'
    end

    @clients = []

    EM::WebSocket.start(:host => '192.168.43.210', :port => '3001') do |ws|
        ws.onopen do |handshake|
            @clients << ws
            ws.send "Connected to #{handshake.path}."
            puts "Connected"
        end

        ws.onclose do
            ws.send "Closed."
            puts "closed"
            @clients.delete ws
        end

        ws.onmessage do |msg|
            puts "Received Message: #{msg}"
            @clients.each do |socket|
                socket.send msg
            end
        end
    end

    App.run! :port => 3000
end
