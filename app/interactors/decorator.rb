# Wraps object reading
# NOTE: xDecorator decorates x class
class Decorator
  class << self
    def display_keys(*keys)
      @display_keys ||= begin
        d_keys = (keys.flatten || [])
        # Delegate method unless it is defined
        delegate *(d_keys - self.instance_methods(false)), to: :subject
        d_keys
      end
    end
  end

  attr_reader :subject

  delegate :errors, to: :subject

  def initialize(subject)
    @subject = subject
  end

  def as_json(*)
    self.class.display_keys.inject({}) do |json, m|
      json[m] = self.public_send(m)
      json
    end || {}
  end
end
