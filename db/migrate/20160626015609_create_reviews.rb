class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.references :reviewer, index: true, polymorphic: true
      t.integer :rating
      t.text :content

      t.timestamps null: false
    end
  end
end
