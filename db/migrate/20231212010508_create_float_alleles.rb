class CreateFloatAlleles < ActiveRecord::Migration[7.1]
  def change
    create_table :float_alleles do |t|
      t.float :minimum, null: false, default: 0
      t.float :maximum, null: false, default: 1

      t.timestamps
    end
  end
end
