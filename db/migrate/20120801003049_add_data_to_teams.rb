class AddDataToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :app_desc, :text
    add_column :teams, :tech, :string
    add_column :teams, :snapshot, :string
    add_column :teams, :title, :string
  end
end
