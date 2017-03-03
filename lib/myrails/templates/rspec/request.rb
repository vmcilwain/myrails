require 'rails_helper'

describe '<%= options[:name] %> api' do
  let(:headers) {{"ACCEPT" => "application/json"}}
  let(:<%= options[:name] %>) {create :<%= options[:name] %>}
  let(:<%= options[:name].pluralize %>) {create_list :<%= options[:name] %>, 3}

  describe 'GET index' do
    before do
      <%= options[:name].pluralize %>
      get '/<%= options[:name].pluralize %>'
    end

    it 'returns success status' do
      expect(response).to be_success
    end

    it 'sets @<%= options[:name].pluralize %>' do
      expect(assigns['<%= options[:name].pluralize %>']).to eq <%= options[:name].pluralize %>
    end

    it_behaves_like 'returns content as json' do
      let(:action) {get '/<%= options[:name].pluralize %>'}
    end
  end

  describe 'GET show' do
    before {get "/<%= options[:name].pluralize %>/#{<%= options[:name] %>.id}"}

    it 'returns success status' do
      expect(response).to be_success
    end

    it 'sets @article' do
      expect(assigns[:<%= options[:name] %>]).to eq <%= options[:name] %>
    end

    it_behaves_like 'returns content as json' do
      let(:action) {get "/<%= options[:name].pluralize %>/#{<%= options[:name] %>.id}"}
    end
  end

  describe 'POST create' do
    context 'successful' do
      before {post '/<%= options[:name].pluralize %>', params: {<%= options[:name] %>: {}}, headers: headers}

      it 'returns created status' do
        expect(response).to have_http_status :created
      end

      it 'sets @<%= options[:name] %>' do
        expect(assigns[:<%= options[:name] %>]).to be_instance_of <%= options[:name].camelize %>
      end

      it_behaves_like 'returns content as json' do
        let(:action) {post '/<%= options[:name].pluralize %>', params: {<%= options[:name] %>: {}}, headers: headers}
      end
    end

    context 'unsuccessful' do
      before {post '/<%= options[:name].pluralize %>', params: {<%= options[:name] %>: {}}, headers: headers}

      it 'returns unprocessable_entity status' do
        expect(response).to have_http_status :unprocessable_entity
      end

      it 'sets @<%= options[:name] %>' do
        expect(assigns[:<%= options[:name] %>]).to be_a_new <%= options[:name].camelize %>
      end
      it_behaves_like 'returns content as json' do
        let(:action) {post '/<%= options[:name].pluralize %>', params: {<%= options[:name] %>: {}}, headers: headers}
      end
    end
  end

  describe 'PUT update' do
    context 'successful' do
      before {put "/<%= options[:name].pluralize %>/#{<%= options[:name] %>.id}", params: {<%= options[:name] %>: {}}, headers: headers}

      it 'returns success status' do
        expect(response).to have_http_status :success
      end

      it 'sets @<%= options[:name] %>' do
        expect(assigns['<%= options[:name] %>']).to eq <%= options[:name] %>
      end

      it_behaves_like 'returns content as json' do
        let(:action) {put "/<%= options[:name].pluralize %>/#{<%= options[:name] %>.id}", params: {<%= options[:name] %>: {}}}
      end
    end

    context 'unsuccessful' do
      before {put "/<%= options[:name].pluralize %>/#{<%= options[:name] %>.id}", params: {<%= options[:name] %>: {}}, headers: headers}

      it 'returns unprocessable_entity status' do
        expect(response).to have_http_status :bad_request
      end

      it 'sets @<%= options[:name] %>' do
        expect(assigns[:<%= options[:name] %>]).to eq <%= options[:name] %>
      end

      it_behaves_like 'returns content as json' do
        let(:action) {put "/<%= options[:name].pluralize %>/#{<%= options[:name] %>.id}", params: {<%= options[:name] %>: {}}, headers: headers}
      end
    end
  end
end
