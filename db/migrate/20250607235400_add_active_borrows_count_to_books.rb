class AddActiveBorrowsCountToBooks < ActiveRecord::Migration[8.0]
  def self.up
    add_column :books, :active_borrows_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :books, :active_borrows_count
  end
end
