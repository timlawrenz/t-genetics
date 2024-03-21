class CreateOptionValues < ActiveRecord::Migration[7.1]
  def change
    create_table :option_values do |t|
      t.string :data

      t.timestamps
    end
  end
end
