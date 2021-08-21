class UserInteractor < Interactor
  # Depending on UI/UX experts, potentionally password_confirmation should be added
  permitted_keys %i[email password first_name last_name]

  delegate :authenticate, to: :subject
end
