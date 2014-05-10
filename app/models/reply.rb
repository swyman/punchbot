class Reply < ActiveRecord::Base

  def interpolate(filler)
    text.gsub('!!s', filler)
  end

  def self.add_compliment(comps)
    Reply.add_things(comps, 'compliment')
  end

  def self.add_insult(comps)
    Reply.add_things(comps, 'insult')
  end

  def self.add_wisdom(comps)
    Reply.add_things(comps, 'wisdom')
  end

  def self.add_joke(comps)
    Reply.add_things(comps, 'joke')
  end

  def self.add_things(things, type)
    if String === things
      things = [things]
    end
    things.map {|text| Reply.create({text: text, reply_type: type})}
  end
end
