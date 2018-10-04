require 'rails_helper'

describe '<%= @param %> api' do
  let(:headers) {{"ACCEPT" => "application/json"}}
  let(:<%= @param %>) {create :<%= @param %>}
  let(:<%= @param.pluralize %>) {create_list :<%= @param %>, 3}

  describe 'GET index' do
    before do
      <%= @param.pluralize %>
      get '/<%= @param.pluralize %>'
    end

    it 'returns success status' do
      expect(response).to be_success
    end

    it 'sets @<%= @param.pluralize %>' do
      expect(assigns['<%= @param.pluralize %>']).to eq <%= @param.pluralize %>
    end

    it_behaves_like 'returns content as json' do
      let(:action) {get '/<%= @param.pluralize %>'}
    end
  end

  describe 'GET show' do
    before {get "/<%= @param.pluralize %>/#{<%= @param %>.id}"}

    it 'returns success status' do
      expect(response).to be_success
    end

    it 'sets @article' do
      expect(assigns[:<%= @param %>]).to eq <%= @param %>
    end

    it_behaves_like 'returns content as json' do
      let(:action) {get "/<%= @param.pluralize %>/#{<%= @param %>.id}"}
    end
  end

  describe 'POST create' do
    context 'successful' do
      before {post '/<%= @param.pluralize %>', params: {<%= @param %>: {}}, headers: headers}

      it 'returns created status' do
        expect(response).to have_http_status :created
      end

      it 'sets @<%= @param %>' do
        expect(assigns[:<%= @param %>]).to be_instance_of <%= @param.camelize %>
      end

      it_behaves_like 'returns content as json' do
        let(:action) {post '/<%= @param.pluralize %>', params: {<%= @param %>: {}}, headers: headers}
      end
    end

    context 'unsuccessful' do
      before {post '/<%= @param.pluralize %>', params: {<%= @param %>: {}}, headers: headers}

      it 'returns unprocessable_entity status' do
        expect(response).to have_http_status :unprocessable_entity
      end

      it 'sets @<%= @param %>' do
        expect(assigns[:<%= @param %>]).to be_a_new <%= @param.camelize %>
      end
      it_behaves_like 'returns content as json' do
        let(:action) {post '/<%= @param.pluralize %>', params: {<%= @param %>: {}}, headers: headers}
      end
    end
  end

  describe 'PUT update' do
    context 'successful' do
      before {put "/<%= @param.pluralize %>/#{<%= @param %>.id}", params: {<%= @param %>: {}}, headers: headers}

      it 'returns success status' do
        expect(response).to have_http_status :success
      end

      it 'sets @<%= @param %>' do
        expect(assigns['<%= @param %>']).to eq <%= @param %>
      end

      it_behaves_like 'returns content as json' do
        let(:action) {put "/<%= @param.pluralize %>/#{<%= @param %>.id}", params: {<%= @param %>: {}}}
      end
    end

    context 'unsuccessful' do
      before {put "/<%= @param.pluralize %>/#{<%= @param %>.id}", params: {<%= @param %>: {}}, headers: headers}

      it 'returns unprocessable_entity status' do
        expect(response).to have_http_status :bad_request
      end

      it 'sets @<%= @param %>' do
        expect(assigns[:<%= @param %>]).to eq <%= @param %>
      end

      it_behaves_like 'returns content as json' do
        let(:action) {put "/<%= @param.pluralize %>/#{<%= @param %>.id}", params: {<%= @param %>: {}}, headers: headers}
      end
    end
  end
end
