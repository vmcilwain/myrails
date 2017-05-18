require 'rails_helper'
#
describe <%= options[:name].camelize %>Presenter do
  include_behavior

  let(:presenter) {<%= options[:name].camelize %>Presenter.new(<%= options[:name] %>, view)}
  let(:<%= options[:name] %>) {create :<%= options[:name] %>}

  it 'returns name' do
    expect(presenter.name).to eq object.attribute + " " + object.attribute
  end

  it 'returns edit path' do
    expect(presenter.edit_link).to eq link_to :Edit, edit_<%= options[:name] %>_path(<%= options[:name] %>)
  end
end
