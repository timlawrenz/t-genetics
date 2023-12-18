class AddInheritableTypeInheritableIdToAlleles < ActiveRecord::Migration[7.1]
  def change
    add_column :alleles, :inheritable_type, :string, null: false
    add_column :alleles, :inheritable_id, :integer, null: false
  end
end
