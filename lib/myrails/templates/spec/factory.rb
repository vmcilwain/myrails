FactoryBot.define do
  factory :<%= options[:name].gsub("/", "_") %>, class: "<%= options[:name].camelize %>" do

  end
end
