class AddAutoEvolveCriteriaToExperiments < ActiveRecord::Migration[7.1]
  def change
    add_column :experiments, :feedback_percentage_threshold, :float, default: 0.75, null: false
    add_column :experiments, :min_organisms_with_feedback, :integer, default: 2, null: false
    add_column :experiments, :suggestion_count_threshold_multiplier, :float, default: 3.0, null: false
  end
end
