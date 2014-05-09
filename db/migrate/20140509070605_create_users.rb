class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :groupme_id
      t.datetime :last_complimented

      t.timestamps
    end
  end
end
