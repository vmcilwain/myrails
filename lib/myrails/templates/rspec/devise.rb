RSpec.configure do |config|
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::TestHelpers, type: :view
end

# Authenticate without going through the login process
RSpec.configure do |config|
  config.include Warden::Test::Helpers
  config.before :suite do
    Warden.test_mode!
  end
end

RSpec.configure do |config|
  config.after :each do
    Warden.test_reset!
  end
end
#
=begin
Reference: https://github.com/plataformatec/devise/wiki/How-To:-Test-with-Capybara

To use authentication bypass use the following for loging in:

user = FactoryGirl.create(:user)
login_as(user, :scope => :user)

if within a test you need to sign_out a user use:
sign_out(:user)
=end

def set_session(user=create(:user))
  login_as(user, :scope => :user)
end

def sign_in_with(user)
  click_link 'Sign In'
  fill_in 'user_email', with: user.email
  fill_in 'user_password', with: 'somepassword'
  click_button 'Log in'
end
