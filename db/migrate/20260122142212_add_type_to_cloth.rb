class AddTypeToCloth < ActiveRecord::Migration[8.1]
  def change
    add_column :cloths, :type, :string
  end
end
