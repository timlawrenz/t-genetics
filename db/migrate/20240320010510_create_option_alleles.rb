class CreateOptionAlleles < ActiveRecord::Migration[7.1]
  def change
    create_table :option_alleles do |t|
      t.json :choices, null: false, default: {}

      t.timestamps
    end
  end
end
