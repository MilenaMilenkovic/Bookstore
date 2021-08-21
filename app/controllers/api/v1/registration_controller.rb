module Api
  module V1
    class RegistrationController < Api::V1::ApplicationController
      include InteractorConcern

      def create
        if new_object && interactor.save
          render json: { message: 'User is successfully created.' }, status: :ok
        else
          render_errors(interactor)
        end
      end

      private

        def wrapped_class; User; end

    end
  end
end
