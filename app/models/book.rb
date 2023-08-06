class Book < ApplicationRecord
  include ImageUploader::Attachment :cover_image

  class InvalidBooksSearchException < Exception; end

  # Relations
  belongs_to :category

  # Scopes
  # Search category by name. NOTE: Category name is not unique.
  # Example: Comedy (Fantacy) & Comedy (Romance)
  scope :category, -> (category) { CategoryBooksQuery.call(category) }
  scope :search,   -> (qk, q) do
    case qk.to_sym
    when :author
      Book.where(author: q)
      break
    when :title
      Book.where(title: q)
      break
    when :short_description
      Book.where(short_description: q)
      break
    else
      Book.none
    end
  end
end
