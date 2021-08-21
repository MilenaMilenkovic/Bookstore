module Api
  module V1
    class ApplicationController < ActionController::Base
      skip_before_action :verify_authenticity_token if Rails.env.development?

      include ResponseConcern

      helper_method :current_user

      def current_user
        @current_user ||= begin
          User.find(session[:user_id]) if session[:user_id]
        end
      end

      def require_valid_session
        raise InvalidSessionException unless current_user
      end
    end
  end
end
