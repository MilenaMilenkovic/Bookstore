module Api
  module V1
    class BooksController < Api::V1::ApplicationController
      include InteractorConcern

      before_action :require_valid_session
      before_action :validate_interactor, only: %i[show update destroy]

      def index
        render json: paginated_interactor_list, status: :ok
      end

      def show
        render json: interactor, status: :ok
      end

      def create
        if new_object && interactor.save
          NewsletterWorker.perform_async(interactor.subject.id)
          
          render json: { message: 'Book is successfully created.' }, status: :ok
        else
          render_errors(interactor)
        end
      end

      def update
        if interactor.update(params)
          render json: { message: 'Book is successfully updated.' }, status: :ok
        else
          render_errors(interactor)
        end
      end

      def destroy
        interactor.destroy
        render json: { message: 'Book is successfully removed.' }, status: :ok
      end

      private

        def wrapped_list
          @wrapped_list = begin
            (params[:category] && Book.category(params[:category]).includes(category: :parent)) ||
            Book.includes(category: :parent)
          end
        end

        def validate_interactor
          raise RecordNotFoundException unless interactor
        end
    end
  end
end
