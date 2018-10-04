# Use with Pundit Matches: https://github.com/chrisalley/pundit-matchers
require 'rails_helper'

describe <%= @name.camelize %>Policy do
  subject { <%= @name.camelize %>Policy.new(user, <%= @name.split("/").last %>) }

  let(:<%= @name.split("/").last %>) { create :<%= @name.gsub("/", "_") %> }

  context 'for a visitor' do
    it {is_expected.to permit_action(:new)}
    it {is_expected.to permit_action(:create)}
    it {is_expected.to permit_action(:show)}
    it {is_expected.to forbid_action(:edit)}
    it {is_expected.to forbid_action(:update)}
    it {is_expected.to forbid_action(:destroy)}
  end

  context "for an admin" do

    let(:user) { <%= @name.split("/").last %>.user }

    it {is_expected.to permit_action(:new)}
    it {is_expected.to permit_action(:create)}
    it {is_expected.to permit_action(:show)}
    it {is_expected.to permit_action(:edit)}
    it {is_expected.to permit_action(:update)}
    it {is_expected.to permit_action(:destroy)}
  end
end
