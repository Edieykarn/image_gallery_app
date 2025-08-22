class CreateGalleries < ActiveRecord::Migration[8.0]
  def change
    create_table :galleries do |t|
      t.string :title
      t.text :description
      t.references :user, null: false, foreign_key: true
      t.integer :status
      t.integer :views_count
      t.integer :likes_count
      t.integer :photos_count

      t.timestamps
    end
  end
end
