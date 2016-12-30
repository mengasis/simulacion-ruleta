class CreateGamers < ActiveRecord::Migration[5.0]
  def change
    create_table :gamers do |t|
      t.string :usuario
      t.integer :saldo, :default => 10000

      t.timestamps
    end
  end
end
