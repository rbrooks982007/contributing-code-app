class AddCheckinToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :checkin, :boolean, :default=>false
  end
end
