class NewsletterMailer < ActionMailer::Base
  default from: 'newsletter@bookstore.com'

  def new_book_release_notification
    to      = params[:to]
    book_id = params[:book_id]

    return if book_id.nil? || to.empty?
    @book = Book.find(book_id)

    mail(to: to, subject: 'New book released', content_type: 'text/html')
  end
end
