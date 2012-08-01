class AddcolToWinner < ActiveRecord::Migration
  def up
  	add_column :winners, :image, :text
  end

  def down
  end
end
