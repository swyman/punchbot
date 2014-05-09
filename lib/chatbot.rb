require 'net/http'

class Chatbot

  attr_reader :bot_id, :post_uri, :last_res, :last_msg

  attr_accessor :name

  def initialize(name = 'punchbot')
    @name = name
    @base_uri = 'https://api.groupme.com/v3/'

    @bot_id = '118fb11ee75af2083a1bfbaa1d'
    @post_uri = 'https://api.groupme.com/v3/bots/post'
    @group_id = '8197513'
    @interval = 45.minutes
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
    elsif /^(hello|hi|greetings|sup|hey) punchbot/i =~ msg[:text]
      post_message("Hey #{msg[:name]}. How's it going?")
    end
  end

  def exec_command(cmd)
    puts cmd
    pieces = cmd.split
    action = pieces[0]
    case action
    when 'compliment'
      reply_to_user('compliment')
      @compliment_sent = true
    when 'insult'
      reply_to_user('insult')
    when 'wisdom'
      reply_to_user('wisdom')
    when 'features'
      features
    end
  end

  def features
    post_message '"punchbot compliment" to hear a compliment. "punchbot insult" to hear how i really feel. you can call me "pb" for short.'
  end

  def reply_to_user(type, user = nil)
    user ||= @last_msg[:name]
    reply = Reply.where("reply_type like ? AND (last_sent_at is null OR ( last_sent_at >= current_timestamp - interval '1 hour'))", type).order("RANDOM()").first
    reply.update_attribute(:last_sent_at, Time.now)
    post_message reply.interpolate user
  end

  def compliment_user(groupme_id, name)
    if name != 'punchbot' && !@compliment_sent
      user = User.find_or_create_by(groupme_id: groupme_id)
      if !user.last_complimented || user.last_complimented + @interval < Time.now
        reply_to_user 'compliment', name
        user.update_attribute(:last_complimented, Time.now)
      end
    end
  end

end
