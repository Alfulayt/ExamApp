# frozen_string_literal: true

module ApiManager
  class RefreshTokenServices < BaseService

    def initialize(user_id, token: nil, refresh_token: nil)

      @user_id = user_id
      @token = token
      @refresh_token = refresh_token
    end

    def execute
      return if @user_id.blank?

      @token.nil? ? create_new_refresh_token : update_refresh_token
    end

    private

    def update_refresh_token
      result = RefreshToken.where(token: @token, user_id: @user_id).first
      result.update!(encoded_token: @refresh_token) if result.present?
      result
    end

    def create_new_refresh_token
      random_uuid = SecureRandom.uuid
      token = ApiManager::TokenGeneratorService.encode(token: random_uuid,user_id: @user_id)
      refresh_token = RefreshToken.create!(
        user_id: @user_id,
        token: random_uuid,
        encoded_token: token
      )
      refresh_token&.encoded_token
    end


  end
end