# == Schema Information
#
# Table name: users
#
#  id                :integer          not null, primary key
#  groupme_id        :string(255)
#  last_complimented :datetime
#  created_at        :datetime
#  updated_at        :datetime
#

class User < ActiveRecord::Base
end
