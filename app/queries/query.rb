# Holds query logic
class Query
  attr_reader :relation

  class << self
    delegate :call, to: :new
  end

  # Should return ActiveRecord::Relation of the same type as relation passed in constructor
  def call; end
end
