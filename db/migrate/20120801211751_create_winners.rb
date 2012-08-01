class CreateWinners < ActiveRecord::Migration
  def change
    create_table :winners do |t|
      t.string :pic

      t.timestamps
    end
  end
end
