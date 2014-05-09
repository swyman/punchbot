class CreateReplies < ActiveRecord::Migration
  def change
    create_table :replies do |t|
      t.text :text
      t.string :reply_type

      t.timestamps
    end
  end
end
