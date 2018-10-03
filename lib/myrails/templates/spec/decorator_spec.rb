require 'rails_helper'

describe <%= @name.camelize %>Decorator do
  include_behavior

  let(:decorator) {<%= @name.camelize %>Decorator.new(<%= @name %>, view)}
  let(:<%= @name %>) {create :<%= @name %>}

  it 'returns name' do
    expect(decorator.name).to eq object.attribute + " " + object.attribute
  end

  it 'returns edit path' do
    expect(decorator.edit_link).to eq link_to :Edit, edit_<%= @name %>_path(<%= @name %>)
  end
end
