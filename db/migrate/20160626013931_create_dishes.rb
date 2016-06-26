class CreateDishes < ActiveRecord::Migration
  def change
    create_table :dishes do |t|
      t.string :name
      t.string :image
      t.references :creator, index: true, polymorphic: true

      t.timestamps null: false
    end
  end
end
