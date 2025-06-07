class CreateBorrows < ActiveRecord::Migration[8.0]
  def change
    create_table :borrows do |t|
      t.references :user, null: false, foreign_key: true
      t.references :book, null: false, foreign_key: true
      t.date :return_at, null: false, default: -> { "NOW() + INTERVAL '2 weeks'" }
      t.datetime :returned_at
      t.timestamps
    end

    add_index :borrows, [:user_id, :book_id], unique: true, name: 'index_borrows_on_user_and_book'
    add_index :borrows, :return_at, name: 'index_borrows_on_return_at', using: :brin
  end
end
