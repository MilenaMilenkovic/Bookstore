module Api
  module V1
    class BooksController < Api::V1::ApplicationController
      include InteractorConcern

      before_action :require_valid_session
      before_action :validate_interactor, only: %i[show update destroy]

      def index
        render json: { books: paginated_interactor_list, page: params[:page] }, status: :ok
      end

      def show
        render json: interactor, status: :ok
      end

      def create
        if new_object && interactor.save
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
          @wrapped_list = (params[:category] && Book.category(params[:category])) || Book.all
        end

        def validate_interactor
          raise RecordNotFoundException unless interactor
        end
    end
  end
end
