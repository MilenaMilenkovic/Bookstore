class Category < ApplicationRecord
  # Relations
  belongs_to :parent, class_name: self.name, optional: true
end
