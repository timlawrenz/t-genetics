class CreateValues < ActiveRecord::Migration[7.1]
  def change
    create_table :values do |t|
      t.references :organism, null: false, foreign_key: true
      t.references :allele, null: false, foreign_key: true

      t.string :valuable_type
      t.integer :valuable_id

      t.timestamps
    end
  end
end
