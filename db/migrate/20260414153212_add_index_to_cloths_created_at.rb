class AddIndexToClothsCreatedAt < ActiveRecord::Migration[8.1]
  def change
    add_index :cloths, [ :user_id, :created_at ]
  end
end
