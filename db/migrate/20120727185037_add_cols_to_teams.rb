class AddColsToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :repo, :string
    add_column :teams, :site, :string
  end
end
