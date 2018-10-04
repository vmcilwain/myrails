FactoryBot.define do
  factory :<%= @name.gsub("/", "_") %>, class: "<%= @name.camelize %>" do

  end
end
