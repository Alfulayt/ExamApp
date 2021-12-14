# frozen_string_literal: true

module ApiManager
  class AuthService < BaseService
    class << self
      def login(email, password)
        user = User.find_by_email(email)

        return { success: false } if user.nil?
        return { success: false } if user.valid_password?(password) == false

        return { success: false, message: 'your account is a teacher account you could not take an exam!' } if user.teacher?

        refresh_token = ApiManager::RefreshTokenServices.execute(user.id)

        {
          success: true,
          user_details: {
            email: user.email,
            name: user.name,
            role: user.role,
            token: ApiManager::TokenGeneratorService.encode(email: user.email),
            refresh_token: refresh_token
          }
        }


      end

      def refresh_token(refresh_token_params)
        user = User.find_by_id(refresh_token_params[:user_id])
        refresh_token_model = RefreshToken.where(
          user_id: user.id,
          token: refresh_token_params[:token]
        ).first
        return { success: false } if refresh_token_model.blank?

        refresh_token_encoded = ApiManager::TokenGeneratorService.encode(
          user_id: user.id,
          token: refresh_token_params[:token]
        )
        new_access_token = ApiManager::TokenGeneratorService.encode({ email: user.email })


        ApiManager::RefreshTokenServices.execute(
          user.id,
          token: refresh_token_params[:token],
          refresh_token: refresh_token_encoded
        )

        { success: true,
          refresh_token: refresh_token_encoded,
          token: new_access_token
        }
      end

    end
  end
end
