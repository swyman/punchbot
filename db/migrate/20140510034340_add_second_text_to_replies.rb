class AddSecondTextToReplies < ActiveRecord::Migration
  def change
    add_column :replies, :second_text, :text
  end
end
