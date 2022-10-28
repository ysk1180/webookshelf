class AddMigrateToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :migrated, :boolean, default: false
  end
end
