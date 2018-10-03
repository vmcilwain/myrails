require 'rails_helper'

describe '<%= @name %> api' do
  let(:headers) {{"ACCEPT" => "application/json"}}
  let(:<%= @name %>) {create :<%= @name %>}
  let(:<%= @name.pluralize %>) {create_list :<%= @name %>, 3}

  describe 'GET index' do
    before do
      <%= @name.pluralize %>
      get '/<%= @name.pluralize %>'
    end

    it 'returns success status' do
      expect(response).to be_success
    end

    it 'sets @<%= @name.pluralize %>' do
      expect(assigns['<%= @name.pluralize %>']).to eq <%= @name.pluralize %>
    end

    it_behaves_like 'returns content as json' do
      let(:action) {get '/<%= @name.pluralize %>'}
    end
  end

  describe 'GET show' do
    before {get "/<%= @name.pluralize %>/#{<%= @name %>.id}"}

    it 'returns success status' do
      expect(response).to be_success
    end

    it 'sets @article' do
      expect(assigns[:<%= @name %>]).to eq <%= @name %>
    end

    it_behaves_like 'returns content as json' do
      let(:action) {get "/<%= @name.pluralize %>/#{<%= @name %>.id}"}
    end
  end

  describe 'POST create' do
    context 'successful' do
      before {post '/<%= @name.pluralize %>', params: {<%= @name %>: {}}, headers: headers}

      it 'returns created status' do
        expect(response).to have_http_status :created
      end

      it 'sets @<%= @name %>' do
        expect(assigns[:<%= @name %>]).to be_instance_of <%= @name.camelize %>
      end

      it_behaves_like 'returns content as json' do
        let(:action) {post '/<%= @name.pluralize %>', params: {<%= @name %>: {}}, headers: headers}
      end
    end

    context 'unsuccessful' do
      before {post '/<%= @name.pluralize %>', params: {<%= @name %>: {}}, headers: headers}

      it 'returns unprocessable_entity status' do
        expect(response).to have_http_status :unprocessable_entity
      end

      it 'sets @<%= @name %>' do
        expect(assigns[:<%= @name %>]).to be_a_new <%= @name.camelize %>
      end
      it_behaves_like 'returns content as json' do
        let(:action) {post '/<%= @name.pluralize %>', params: {<%= @name %>: {}}, headers: headers}
      end
    end
  end

  describe 'PUT update' do
    context 'successful' do
      before {put "/<%= @name.pluralize %>/#{<%= @name %>.id}", params: {<%= @name %>: {}}, headers: headers}

      it 'returns success status' do
        expect(response).to have_http_status :success
      end

      it 'sets @<%= @name %>' do
        expect(assigns['<%= @name %>']).to eq <%= @name %>
      end

      it_behaves_like 'returns content as json' do
        let(:action) {put "/<%= @name.pluralize %>/#{<%= @name %>.id}", params: {<%= @name %>: {}}}
      end
    end

    context 'unsuccessful' do
      before {put "/<%= @name.pluralize %>/#{<%= @name %>.id}", params: {<%= @name %>: {}}, headers: headers}

      it 'returns unprocessable_entity status' do
        expect(response).to have_http_status :bad_request
      end

      it 'sets @<%= @name %>' do
        expect(assigns[:<%= @name %>]).to eq <%= @name %>
      end

      it_behaves_like 'returns content as json' do
        let(:action) {put "/<%= @name.pluralize %>/#{<%= @name %>.id}", params: {<%= @name %>: {}}, headers: headers}
      end
    end
  end
end
