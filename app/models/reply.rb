class Reply < ActiveRecord::Base

  def self.add_compliment(comps)
    Reply.add_things(comps, 'compliment')
  end

  def self.add_insult(comps)
    Reply.add_things(comps, 'insult')
  end

  def self.add_wisdom(comps)
    Reply.add_things(comps, 'wisdom')
  end

  def self.add_joke(call, response)
    Reply.create({text: call, second_text: response, reply_type: 'joke'})
  end

  def self.add_things(things, type)
    if String === things
      things = [things]
    end
    things.map {|text| Reply.create({text: text, reply_type: type})}
  end

  def self.random_with_type(type)
    Reply.where("reply_type like ? AND (last_sent_at is null OR ( last_sent_at >= current_timestamp - interval '1 hour'))", type).order("RANDOM()").first
  end

  def mark_sent(time = nil)
    time ||= Time.now
    update_attribute(:last_sent_at, time)
  end

  def interpolate(filler, attr = :text)
    self.send(attr).gsub('!!s', filler)
  end

end
