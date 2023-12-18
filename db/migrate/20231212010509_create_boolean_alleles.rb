class CreateBooleanAlleles < ActiveRecord::Migration[7.1]
  def change
    create_table :boolean_alleles do |t|
      t.timestamps
    end
  end
end
