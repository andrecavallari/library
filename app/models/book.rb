# frozen_string_literal: true

class Book < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :search, against: [:tsv],
    using: {
      tsearch: {
        tsvector_column: 'tsv',
        dictionary: 'english',
        prefix: true,
        any_word: true
      }
    }

  validates :title, presence: true
  validates :author, presence: true
  validates :genre, presence: true
  validates :isbn, presence: true, uniqueness: true

  before_save :update_tsvector

  has_many :borrows, dependent: :destroy

  private
    def update_tsvector
      concatenated = [title, author, genre].compact.join(' ')
      self.tsv = ActiveRecord::Base.connection.execute(
        Book.sanitize_sql_array(["SELECT to_tsvector('english', ?)", concatenated])
      ).values.first.first
    end
end
