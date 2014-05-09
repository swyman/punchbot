require 'net/http'

class Chatbot

  attr_reader :bot_id, :post_uri, :last_res

  attr_accessor :name

  def initialize(name = 'Gerald')
    @name = name
    @base_uri = 'https://api.groupme.com/v3/'

    @bot_id = '118fb11ee75af2083a1bfbaa1d'
    @post_uri = 'https://api.groupme.com/v3/bots/post'
    @group_id = '8197513'
  end

  def post_message(msg)
    @text = msg

    uri = URI(@post_uri)
    @last_res = Net::HTTP.post_form(uri, self.params)

  end

  def params
    { text: @text, bot_id: @bot_id }
  end

  def greet(user)
    post_message("hi #{user}")
  end

  def introduce_yourself
    post_message("Sup. I'm #{@name}.")
  end

  def do_eet(msg)
    if /hello punchbot/i =~ msg[:text]
      post_message("hi #{msg[:name]}")
    elsif /i like your shoes/i =~ msg[:text]
      post_message("i like your slipper socks")
    elsif /ping/i =~ msg[:text]
      post_message("pong")
    end
  end

end