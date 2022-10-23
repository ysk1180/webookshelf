class CreateBookshelfBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :bookshelf_books do |t|
      t.integer :book_id
      t.integer :bookshelf_id
    end
  end
end
