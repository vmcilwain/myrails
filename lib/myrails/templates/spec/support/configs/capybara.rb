Capybara.app_host = "http://localhost:3000"
Capybara.server_host = "localhost"
Capybara.server_port = "3000"

# use firefox + selenium-webdriver
unless ENV['NOCHROME']
  Capybara.register_driver :selenium do |app|
    Capybara::Selenium::Driver.new(app, :browser => :chrome)
  end
end