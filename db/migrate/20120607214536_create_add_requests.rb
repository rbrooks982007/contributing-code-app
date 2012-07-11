class CreateAddRequests < ActiveRecord::Migration
  def change
    create_table :add_requests do |t|
      t.integer :user_id
      t.integer :team_id
      t.string :team_name

      t.timestamps
    end
  end
end
