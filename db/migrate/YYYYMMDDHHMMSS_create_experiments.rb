class CreateExperiments < ActiveRecord::Migration[7.1]
  def change
    create_table :experiments do |t|
      t.references :chromosome, null: false, foreign_key: true
      t.string :external_entity_id
      t.string :external_entity_type
      t.string :status
      t.references :current_generation, null: true, foreign_key: { to_table: :generations }
      t.jsonb :configuration, null: false, default: {}

      t.timestamps
    end

    add_index :experiments, [:external_entity_id, :external_entity_type], name: 'index_experiments_on_external_entity'
  end
end
