class AddLastSentAtToReplies < ActiveRecord::Migration
  def change
    add_column :replies, :last_sent_at, :timestamp
  end
end
