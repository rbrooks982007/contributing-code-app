class AddTeeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :tee, :string
  end
end
