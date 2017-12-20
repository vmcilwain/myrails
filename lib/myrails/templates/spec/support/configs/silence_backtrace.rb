# Supress stacktrace when specs fail
RSpec.configure do |config|
  config.backtrace_exclusion_patterns = [/\/lib\d*\/ruby\//,
                                          /org\/jruby\//,
                                          /bin\//,
                                          /gems\//,
                                          /lib\/rspec\/(core|expectations|matchers|mocks)/]
end
