require 'net/http'

class Chatbot

  attr_reader :bot_id, :post_uri, :last_res, :last_msg

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
    @last_msg = msg
    if (match = /^(?:pb|punchbot) (.*)/i.match(msg[:text]))
      exec_command(match[1])
    elsif /^(hello|hi|greetings|sup) punchbot/i =~ msg[:text]
      post_message("hi #{msg[:name]}")
    end
  end

  def exec_command(cmd)
    puts cmd
    pieces = cmd.split
    action = pieces[0]
    case action
    when 'compliment'
      reply_to_user('compliment')
    when 'insult'
      reply_to_user('insult')
    end
  end

  def reply_to_user(type, user = nil)
    user ||= @last_msg[:name]
    reply = Reply.where(:reply_type => type).order("RANDOM()").first
    post_message reply.interpolate user
  end

end