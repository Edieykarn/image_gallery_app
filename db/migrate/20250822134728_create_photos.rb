class CreatePhotos < ActiveRecord::Migration[8.0]
  def change
    create_table :photos do |t|
      t.string :title
      t.text :description
      t.references :gallery, null: false, foreign_key: true
      t.integer :likes_count

      t.timestamps
    end
  end
end
