# Controller test doesn't seem to use default url option when redirecting to an associated record. Uses http://test.com. This is an attmept to unify this and capybara which uses http://www.example.com.
# Add this method to the before action of any controller specs that needed it. Found it useful to use this when using shared examples.
RSpec.configure do |config|
  config.before :each, type: :controller do
    @request.host = 'localhost:3000'
  end
end
