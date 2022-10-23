class CreateBookshelves < ActiveRecord::Migration[5.2]
  def change
    create_table :bookshelves do |t|
      t.string :title
      t.string :user_name
      t.string :h
      t.string :twitter_id
    end
  end
end
