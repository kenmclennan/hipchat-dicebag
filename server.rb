require 'sinatra/base'
require 'json'


module HipChatDiceBag
  class Server < Sinatra::Base

    ROLLER = Random.new

    get '/' do
      'OK!'
    end

    post '/roll' do
      sides    = Integer(params.fetch(:d){ 20 })
      quantity = Integer(params.fetch(:q){ 1 })
      roll     = quantity.times.inject(0) { |total,_| total + ROLLER.rand(1...sides) }

      name = if request.content_type=="application/json"
        body = JSON.parse(request.body.read)
        body['item']['message']['from']['name']
      else
        'you'
      end
      
      status 200
      
      body JSON.generate({
        color: "green",
        message: "#{name} rolled a #{roll}!",
        notify: false,
        message_format: "text"
      })
    end
  end
end