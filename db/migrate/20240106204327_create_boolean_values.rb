class CreateBooleanValues < ActiveRecord::Migration[7.1]
  def change
    create_table :boolean_values do |t|
      t.boolean :data

      t.timestamps
    end
  end
end
