class CreateAlleles < ActiveRecord::Migration[7.1]
  def change
    create_table :alleles do |t|
      t.string :name
      t.references :chromosome, null: false, foreign_key: true

      t.timestamps
    end
  end
end
