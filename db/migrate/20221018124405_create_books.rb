class CreateBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :books do |t|
      t.string :asin
      t.string :title
      t.string :image
      t.string :url
      t.integer :page
      t.string :released_at
    end

    add_index :books, :asin, unique: true
  end
end
