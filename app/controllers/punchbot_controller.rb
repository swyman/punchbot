class PunchbotController < ApplicationController
  protect_from_forgery except: :message


  def hello
  end

  def message
    @message = params
  end
end
