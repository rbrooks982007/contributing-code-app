class CreateJoinRequests < ActiveRecord::Migration
  def change
    create_table :join_requests do |t|
      t.string :user_handle
      t.integer :team_id
      t.integer :user_id
      t.timestamps
    end
  end
end
