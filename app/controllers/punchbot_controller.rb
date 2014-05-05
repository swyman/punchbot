class PunchbotController < ApplicationController
  protect_from_forgery except: :message

  before_action :init_punchbot

  def hello
    puts params
    @bot.post_message params[:text]
  end

  def message
    #puts params
    logger.error 'params'
    logger.error params
    if params[:text] == 'go ahead'
      @bot.post_message 'ping'
    end
  end

  private

  def init_punchbot
    @bot = Punchbot::Punchbot.new
  end

end
