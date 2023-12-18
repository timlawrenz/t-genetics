class CreateIntegerValues < ActiveRecord::Migration[7.1]
  def change
    create_table :integer_values do |t|
      t.integer :data

      t.timestamps
    end
  end
end
