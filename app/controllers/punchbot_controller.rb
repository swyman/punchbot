class PunchbotController < ApplicationController
  protect_from_forgery except: :message

  before_action :init_punchbot

  def hello
    @bot.post_message params[:text]
  end

  def message
    @bot.post_message params[:text]
  end

  private

  def init_punchbot
    @bot = Punchbot::Punchbot.new
  end

end
