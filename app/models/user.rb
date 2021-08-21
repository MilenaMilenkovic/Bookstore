class User < ApplicationRecord
  include PasswordConcern

  # Validations
  validates :email, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
