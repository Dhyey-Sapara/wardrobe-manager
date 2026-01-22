class ChangeTypeAndLocationToInteger < ActiveRecord::Migration[8.1]
  def change
    # Remove existing type and location columns
    remove_column :cloths, :type, :string
    remove_column :cloths, :location, :string

    # Add new integer columns for enums
    add_column :cloths, :cloth_type, :integer, default: 0
    add_column :cloths, :location, :integer, default: 0
  end
end
