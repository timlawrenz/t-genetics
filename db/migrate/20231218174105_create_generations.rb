class CreateGenerations < ActiveRecord::Migration[7.1]
  def change
    create_table :generations do |t|
      t.references :chromosome, null: false, foreign_key: true
      t.integer :iteration, null: false, default: -1

      t.timestamps
    end
  end
end
