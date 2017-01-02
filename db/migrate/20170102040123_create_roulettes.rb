class CreateRoulettes < ActiveRecord::Migration[5.0]
  def change
    create_table :roulettes do |t|
      t.references :gamer, foreign_key: true
      t.date :fecha
      t.float :apuesta
      t.boolean :resultado

      t.timestamps
    end
  end
end
