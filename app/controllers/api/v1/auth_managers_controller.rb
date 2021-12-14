# frozen_string_literal: true

module Api
  module V1
    class AuthManagersController < Api::V1::ApplicationController

      before_action :authenticate_api_user!, except: %i[create refresh_token], :raise => false

      def create
        response = ApiManager::AuthService.login(login_params[:email], login_params[:password])
        if response[:success]
          render_success_response(data: response)
        else
          render_failed_response({message: response[:message]})
        end
      end

      def refresh_token
        refresh_token_decoded = ApiManager::TokenGeneratorService.decode(refresh_token_params[:refresh_token])
        if refresh_token_decoded[:token].blank? || refresh_token_decoded[:user_id].blank?
          raise StandardError, 'Refresh token not found'
        end

        response = ApiManager::AuthService.refresh_token(refresh_token_decoded)

        if response[:success]
          render_success_response(
            refresh_token: response[:refresh_token],
            token: response[:token]
          )
        else
          render_failed_response
        end
      end



      def destroy
        RefreshToken.where(user_id: current_user.id).destroy_all
        render_success_response
      end

      private

      def login_params
        raise StandardError, 'Email or password is empty' if params[:email].nil? || params[:password].nil?

        params.permit(:email, :password)
      end

      def refresh_token_params
        raise StandardError, 'refresh token missing' if params.permit(:refresh_token).blank?

        params.permit(:refresh_token)
      end

    end
  end
end

