module Punchbot
  class Punchbot

    attr_reader :bot_id, :post_uri, :last_res

    def initialize
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

    end

  end
end