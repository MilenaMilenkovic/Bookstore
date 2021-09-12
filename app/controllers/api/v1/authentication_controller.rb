module Api
  module V1
    class AuthenticationController < Api::V1::ApplicationController
      before_action :require_valid_session, only: :logout
      
      def login
        if user&.authenticate(params[:password])
          session[:user_id] = user.id
          render json: { message: 'User is successfully logged in.' }, status: :ok
        else
          render json: { message: 'Invalid username or password.' }, status: :bad_request
        end
      end

      def logout
        session[:user_id] = nil
        render json: { message: 'User is successfully logged out.' }, status: :ok
      end

      private

        def user
          @user ||= User.find_by(email: params[:username])
        end
    end
  end
end
