module PasswordConcern
  extend ActiveSupport::Concern

  PASSWORD_REGEX = /\A(?=[^\s]*[a-zA-Z])(?=[^\s]*[0-9])[^\s]{8,}\Z/

  included do
    has_secure_password

    validates :password, format: {
      with: PASSWORD_REGEX,
      message: "should be at least eight characters long, containing
                at least one number and one letter, and without spaces."
     }
  end
end
