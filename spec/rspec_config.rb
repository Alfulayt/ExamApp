require 'factory_bot_rails'

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  config.before(:all, type: :request) do
    Rails.application.load_seed
    user = User.find_by_email("teacher@example.com")
    access_token = ApiManager::TokenGeneratorService.encode({ email: user.email })
    @final_access_token = "Bearer #{access_token}"
    @headers = { ACCEPT: :'application/json', AUTHORIZATION: @final_access_token }
    @headers_with_no_auth = { ACCEPT: :'application/json' }
  end

end
