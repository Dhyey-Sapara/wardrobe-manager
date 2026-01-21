class CreateCloths < ActiveRecord::Migration[8.1]
  def change
    create_table :cloths do |t|
      t.string :name
      t.text :description
      t.string :location
      t.string :color
      t.string :company

      t.timestamps
    end
  end
end
