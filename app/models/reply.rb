class Reply < ActiveRecord::Base

  def interpolate(filler)
    text.gsub('!!s', filler)
  end

  def self.add_compliment(text)
    Reply.create({text: text, reply_type: 'compliment'})
  end
end
