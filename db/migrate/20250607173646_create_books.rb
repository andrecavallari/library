class CreateBooks < ActiveRecord::Migration[8.0]
  def up
    create_table :books do |t|
      t.string :title, null: false
      t.string :author, null: false
      t.string :genre, null: false
      t.string :isbn, null: false
      t.tsvector :tsv, null: true
      t.index :isbn, unique: true
      t.index :tsv, using: :gin
      t.timestamps
    end
  end

  def down
    drop_table :books
  end
end
