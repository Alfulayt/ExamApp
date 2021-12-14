# frozen_string_literal: true
module ApiManager
  class TokenGeneratorService

    def self.encode(token_data, expiring = false)
      token_data[:exp] = 30.day.from_now.to_i if expiring
      JWT.encode(token_data,
                 ENV['JWT_KEY'],
                 'HS256')
    end

    def self.decode(token)
      
      decoded_info = JWT.decode(token, nil, false).first
      rescue Exception => e
        {success: false}
      else
      decoded_info.present? ? decoded_info.with_indifferent_access : {}
      
    end

  end
end
