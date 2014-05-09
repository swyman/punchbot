class PunchbotController < ApplicationController
  protect_from_forgery except: [:send_msg, :receive_msg]

  before_action :init_punchbot

  def hello
    puts params
    @bot.post_message params[:text]
  end

  def receive_msg
    puts 'puts'
    puts params
    logger.error 'params'
    logger.error params
    if params[:text] == 'go ahead'
      @bot.post_message 'ping'
    end
    render text: 'done'
  end

  def send_msg
    puts 'puts'
    puts params
    logger.error 'params'
    logger.error params
    @bot.post_message params[:msg]
    render text: 'done'
  end

  private

  def init_punchbot
    @bot = Punchbot::Punchbot.new
  end

end
