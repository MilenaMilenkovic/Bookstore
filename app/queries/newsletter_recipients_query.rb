class NewsletterRecipientsQuery < Query

  def initialize(relation = User)
    @relation = relation
  end

  def call
    @relation.select(:email)
  end
end
