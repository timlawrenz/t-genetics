class CreateIntegerAlleles < ActiveRecord::Migration[7.1]
  def change
    create_table :integer_alleles do |t|
      t.integer :minimum, null: false, default: 0
      t.integer :maximum, null: false, default: 100

      t.timestamps
    end
  end
end
