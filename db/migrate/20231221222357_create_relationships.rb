class CreateRelationships < ActiveRecord::Migration[7.1]
  def change
    create_table :relationships do |t|
      t.references :parent, null: false, foreign_key: { to_table: :chromosomes }
      t.references :child, null: false, foreign_key: { to_table: :chromosomes }

      t.timestamps
    end
  end
end
