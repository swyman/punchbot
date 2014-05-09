class Reply < ActiveRecord::Base

  def interpolate(filler)
    text.gsub('!!s', filler)
  end

  def self.add_compliment(comps)
    if String === comps
      comps = [comps]
    end
    comps.map {|text| Reply.create({text: text, reply_type: 'compliment'})}
  end

  def self.add_insult(comps)
    if String === comps
      comps = [comps]
    end
    comps.map {|text| Reply.create({text: text, reply_type: 'insult'})}
  end
end
