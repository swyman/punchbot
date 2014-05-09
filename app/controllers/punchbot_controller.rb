class PunchbotController < ApplicationController
  protect_from_forgery except: [:send_msg, :receive_msg, :bot_exec]

  before_action :log_params
  before_action :init_punchbot

  def hello
    puts params
    @bot.post_message params[:text]
  end

  def receive_msg
    @bot.do_eet(params[:punchbot])
    if Time.now.strftime('%A') == 'Friday' && params[:punchbot][:text] != 'And so it begins'
      @bot.compliment_user(params[:punchbot][:user_id], params[:punchbot][:name])
    end
    render text: 'done'
  end

  def send_msg
    @bot.post_message params[:msg]
    render text: 'done'
  end

  def bot_exec
    @bot.send(params[:bot_action])
    render text: 'done'
  end

  private

  def init_punchbot
    @bot = Chatbot.new
  end

  def log_params
    puts params
  end

end
