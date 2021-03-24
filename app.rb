require 'sinatra/base'

sleep 5

class App < Sinatra::Base
  get '/hello' do
    "world #{Time.now.to_i}\n"
  end

  get '/slow' do
    sleep 5

    "slow\n"
  end
end
