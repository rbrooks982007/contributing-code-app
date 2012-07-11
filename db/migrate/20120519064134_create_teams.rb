class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string  :name
      t.integer :owner_id
      t.string  :owner_handle
      t.integer :member_count 
      t.string  :desc
      t.timestamps
    end
  end
end
