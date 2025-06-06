class ChangeFitnessToFloatInOrganisms < ActiveRecord::Migration[7.1]
  def change
    change_column :organisms, :fitness, :float
  end
end
