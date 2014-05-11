class AdminController < ApplicationController
  protect_from_forgery except: [:admin]

  before_action :log_params
  before_action :init_punchbot

  def admin
    if /(?:pb|punchbot sleep)/i =~ params[:pb_dadmin][:text]
      $redis.set(sleep_key, 1)
    elsif /((?:pb|punchbot) wakeup)/i =~ params[:pb_dadmin][:text]
      $redis.del(sleep_key)
    end
  end

  private

  def init_punchbot
    @bot = Chatbot.new
  end

  def log_params
    puts params
  end

  def sleep_key
    'admin-pb-sleep'
  end

end
