class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :title1
      t.string :image1
      t.string :url1
      t.string :title2
      t.string :image2
      t.string :url2
      t.string :title3
      t.string :image3
      t.string :url3
      t.string :title4
      t.string :image4
      t.string :url4
      t.string :title5
      t.string :image5
      t.string :url5
      t.string :title
      t.string :name
      t.string :h

      t.timestamps
    end
  end
end
