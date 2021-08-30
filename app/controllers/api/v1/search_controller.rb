module Api
  module V1
    class SearchController < Api::V1::ApplicationController
      include InteractorConcern

      before_action :require_valid_session

      def books
        @wrapped_class = Book
        @wrapped_list  = wrapped_class.search(params[:qk], params[:q])

        begin
          render json: paginated_interactor_list, status: :ok
        rescue InvalidSearchException
          render json: { message: 'Invalid book search parameters.' }, status: :bad_request
        end
      end
    end
  end
end
