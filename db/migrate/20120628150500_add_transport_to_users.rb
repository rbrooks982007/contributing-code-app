class AddTransportToUsers < ActiveRecord::Migration
  def change
    add_column :users, :transport, :integer
  end
end
