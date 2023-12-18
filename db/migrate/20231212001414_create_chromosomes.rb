class CreateChromosomes < ActiveRecord::Migration[7.1]
  def change
    create_table :chromosomes do |t|
      t.string :name

      t.timestamps
    end
  end
end
