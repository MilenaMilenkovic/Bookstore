class Book < ApplicationRecord
  include ImageUploader::Attachment :cover_image

  class InvalidBooksSearchException < Exception; end

  # Relations
  belongs_to :category

  # Scopes
  # Search category by name. NOTE: Category name is not unique. Example: Comedy (Fantacy) & Comedy (Romance)
  scope :category, -> (category) { CategoryBooksQuery.call(category) }
  scope :search,   -> (qk, q) do
    raise InvalidBooksSearchException unless ActiveRecord::Base.connection.column_exists?(Book.table_name, qk)

    Book.where("MATCH (#{qk}) AGAINST (?)", q)
  end

  # Hooks
  after_create :notify_users

  private

  def notify_users
    NewsletterWorker.perform_async(self.id)
  end
end
