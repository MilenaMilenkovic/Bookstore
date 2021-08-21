module Api
  module V1
    class AuthenticationController < Api::V1::ApplicationController

      def login
        if user&.authenticate(params[:password])
          session[:user_id] = user.id
          render json: { message: 'User is successfully logged in.' }, status: :ok
        else
          render json: { message: 'Invalid email or password' }, status: :bad_request
        end
      end

      def logout
        session[:user_id] = nil
        render json: { message: 'User is successfully logged out.' }, status: :ok
      end

      private

        def user
          @user ||= User.find_by(email: params[:email])
        end
    end
  end
end
