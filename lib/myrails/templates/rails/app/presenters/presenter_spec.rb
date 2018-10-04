require 'rails_helper'
#
describe <%= @name.camelize %>Presenter do
  include_behavior

  let(:presenter) {<%= @name.camelize %>Presenter.new(<%= @name %>, view)}
  let(:<%= @name %>) {create :<%= @name %>}

  it 'returns name' do
    expect(presenter.name).to eq object.attribute + " " + object.attribute
  end

  it 'returns edit path' do
    expect(presenter.edit_link).to eq link_to :Edit, edit_<%= @name %>_path(<%= @name %>)
  end
end
