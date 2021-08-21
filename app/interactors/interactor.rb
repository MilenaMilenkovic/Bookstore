# Wraps object writing and reading
# NOTE: xInteractor interacts x class
class Interactor < Decorator
  class << self
    def permitted_keys(*keys)
      @permitted_keys ||= (keys.flatten || [])
    end
  end

  delegate :save,    to: :subject
  delegate :destroy, to: :subject

  def update(params)
    subject.update(params.permit(self.class.permitted_keys))
  end
end
