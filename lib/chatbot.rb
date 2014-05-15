require 'net/http'

class Chatbot

  attr_reader :bot_id, :post_uri, :last_res, :last_msg

  attr_accessor :name, :interval

  def initialize(bot_id, group_id, name = 'punchbot', interval = nil)
    @bot_id = bot_id
    @group_id = group_id
    @name = name

    @base_uri = 'https://api.groupme.com/v3/'
    @post_uri = "#{@base_uri}/bots/post"
    @interval = interval || $redis.get(interval_key) || 45.minutes
  end

  def post_message(msg)
    @text = msg

    if Rails.env.development?
      Rails.logger.info @post_uri
      Rails.logger.info self.params
    else
      uri = URI(@post_uri)
      @last_res = Net::HTTP.post_form(uri, self.params)
    end
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
    Rails.logger.info msg
    @last_msg = msg

    if (match = /^(?:pb|punchbot) (.*)/i.match(msg[:text]))
      exec_command(match[1])
    elsif /^(hello|hi|greetings|sup|hey) punchbot/i =~ msg[:text]
      post_message("Hey #{msg[:name]}. How's it going?")
    elsif /thank(?:s| you)?,?[\s]?(punchbot|pb)/i =~ msg[:text]
      post_message("You're welcome, #{msg[:name]}.")
    elsif (punchline = $redis[joke_key(@last_msg[:user_id])])
      post_message punchline
      $redis.del(joke_key(@last_msg[:user_id]))
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
    when 'joke'
      tell_joke
    when 'wisdom'
      reply_to_user('wisdom')
    when 'features'
      features
    when 'shouldi'
      shouldi
    end
  end

  def tell_joke
    audience = @last_msg[:user_id]
    joke = Reply.random_with_type 'joke'
    joke.mark_sent
    post_message joke.interpolate @last_msg[:name]
    $redis.set(joke_key(audience), joke.interpolate(@last_msg[:name], :second_text))
  end

  def shouldi
    response = Reply.random_with_type 'shouldi'
    response.mark_sent
    post_message response.interpolate @last_msg[:name]
  end

  def features
    post_message '"punchbot compliment" to hear a compliment. "punchbot insult" to hear how i really feel. you can call me "pb" for short.'
  end

  def reply_to_user(type, user = nil)
    user ||= @last_msg[:name]
    reply = Reply.random_with_type(type)
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

  def joke_key(audience)
    "punchbot:joke:#{audience}"
  end

  def interval_key
    "punchbot:interval"
  end

end
