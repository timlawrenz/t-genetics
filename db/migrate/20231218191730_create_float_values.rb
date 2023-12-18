class CreateFloatValues < ActiveRecord::Migration[7.1]
  def change
    create_table :float_values do |t|
      t.float :data

      t.timestamps
    end
  end
end
