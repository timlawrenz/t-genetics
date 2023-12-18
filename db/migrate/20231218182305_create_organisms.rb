class CreateOrganisms < ActiveRecord::Migration[7.1]
  def change
    create_table :organisms do |t|
      t.references :generation, null: false, foreign_key: true
      t.integer :fitness

      t.timestamps
    end
  end
end
