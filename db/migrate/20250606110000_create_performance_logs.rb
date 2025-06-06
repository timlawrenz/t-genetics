class CreatePerformanceLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :performance_logs do |t|
      t.references :experiment, null: false, foreign_key: true
      t.references :organism, null: false, foreign_key: true
      t.datetime :suggested_at, null: false
      t.datetime :outcome_recorded_at
      t.jsonb :outcome_metrics
      t.float :fitness_input_value

      t.timestamps
    end
  end
end
