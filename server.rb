require 'sinatra/base'
require 'json'
require "awesome_print"
require 'logger'


module HipChatDiceBag
  class Server < Sinatra::Base

    ROLLER = Random.new
    LOG    = Logger.new(STDOUT)

    LOG.level = Logger.const_get ENV['LOG_LEVEL'] || 'DEBUG'

    get '/' do
      'OK!'
    end

    post '/roll' do
      sides    = Integer(params.fetch(:d){ 20 })
      quantity = Integer(params.fetch(:q){ 1 })
      roll     = quantity.times.inject(0) { |total,_| total + ROLLER.rand(1...sides) }

      name = if request.content_type=="application/json"
        body = JSON.parse(request.body.read)
        LOG.debug body
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