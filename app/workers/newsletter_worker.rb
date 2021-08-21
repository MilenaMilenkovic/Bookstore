class NewsletterWorker
  include Sidekiq::Worker

  sidekiq_options queue: :newsletter

  # SendGrid limit is 10.000!
  EMAIL_SERVICE_LIMIT = 1000

  def perform(new_book_id)
    NewsletterRecipientsQuery.call
                             .in_batches(of: EMAIL_SERVICE_LIMIT) do |relation|

      recipients =  relation.pluck(:email)

      # It is better to be handled by subcribers group, and to delegate sending to external service (SendGrid or Mandrill, etc)
      # NOTE: In that case responses like 408, 429, etc. needs to be handled properly
      recipients.each do |email|
        NewsletterMailer.with(to: email, book_id: new_book_id).new_book_release_notification.deliver_later
      end
    end
  end
end
