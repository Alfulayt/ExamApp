# frozen_string_literal: true

module Api
  module V1
    class ApplicationController < ActionController::API

      rescue_from ActionController::RoutingError, with: :render_404
      rescue_from ActiveRecord::RecordNotFound, with: :render_404

      def authenticate_api_user!
        return render_unauthenticated_errors if bearer_token.nil?

        decoded = ApiManager::TokenGeneratorService.decode(bearer_token)
        return render_unauthenticated_errors if decoded.blank?

        user = User.find_by(email: decoded[:email])
        return render_unauthenticated_errors if user.nil?

        login(user)
      end

      # 404 error
      def render_404
        render json: {
          status: 'failed',
          message: '404 Not Found',
        }, status: 404
      end

      # success response
      def render_success_response(options = { })
        render json: {
          status: 'success'
        }.merge!(options)
      end

      # failed response
      def render_failed_response(options = { })
        render json: {
          status: 'failed'
        }.merge!(options)
      end

      # Unauthorized error
      def render_unauthenticated_errors
        render json: {
          message: 'Unauthorized'
        }, status: 401
      end

      def current_user
        @current_user = login_from_session || nil unless defined?(@current_user)
        @current_user
      end

      def current_user=(user)
        @current_user = user
      end

      def login(user)
        session[:user_email] = user.email
        @current_user = user
      end

      protected

      def login_from_session
        @current_user = (User.find_by_email(session[:user_email]) if session[:user_email])
      end

      def bearer_token
        token = request.env['HTTP_AUTHORIZATION']

        bearer_pattern = /^Bearer /
        token&.match(bearer_pattern) ? token.gsub(bearer_pattern, '') : nil
      end
      
      
    end
  end
end