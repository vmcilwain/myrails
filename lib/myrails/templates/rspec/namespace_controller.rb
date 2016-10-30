require 'rails_helper'

module <%= options[:namespace].camelize %>
  # Does this controller require authentication?
  describe <%= options[:name].pluralize.camelize %>Controller do
    # let(:user) {create :user}
    let(:<%= options[:name].pluralize %>) {[]}
    let(:<%= options[:name].singularize %>) {create :<%= options[:name].singularize %>}

    # before {sign_in user}

    describe 'GET index' do
      before do
        3.times {<%= options[:name].pluralize %> << create(:<%= options[:name].singularize %>)}
        get :index
      end

      it 'sets @<%= options[:name].pluralize %>' do
        expect(assigns[:<%= options[:name].pluralize %>]).to eq <%= options[:name].pluralize %>
      end
    end

    describe 'GET show' do
      before {get :show, params: {id: <%= options[:name].singularize %>.id}}

      it 'sets @<%= options[:name].singularize %>' do
        expect(assigns[:<%= options[:name].singularize %>]).to eq <%= options[:name].singularize %>
      end
    end

    describe 'GET new' do
      before {get :new}

      it 'sets @<%= options[:name].singularize %>' do
        expect(assigns[:<%= options[:name].singularize %>]).to be_a_new <%= options[:name].singularize.camelize %>
      end
    end

    describe 'POST create' do
      context 'successful create' do
        before {post :create, params: {<%= options[:name].singularize %>: attributes_for(:<%= options[:name].singularize %>)}}

        subject(:<%= options[:name].first %>){assigns[:<%= options[:name].singularize %>]}

        it 'redirects to :show'
        it 'sets @<%= options[:name].singularize %>'
        it 'sets flash[:success]'
        it 'tags the current_user as creator'
      end

      context 'unsuccessful create' do
        before {post :create, params: {<%= options[:name].singularize %>: attributes_for(:<%= options[:name].singularize %>, attr: nil)}}

        it 'renders :new template'
        it 'sets @<%= options[:name].singularize %>'
        it 'sets flash[:error]'
      end
    end

    describe 'GET edit' do
      before {get :edit, params: {id: <%= options[:name].singularize %>.id}}

      it 'sets @<%= options[:name].singularize %>' do
        expect(assigns[:<%= options[:name].singularize %>]).to eq <%= options[:name].singularize %>
      end
    end

    describe 'PUT/PATCH update' do
      context 'successful update' do
        before {put :update, params: {id: <%= options[:name].singularize %>.id, <%= options[:name].singularize %>: attributes_for(:<%= options[:name].singularize %>)}}

        subject(:<%= options[:name].first %>) {assigns[:<%= options[:name].singularize %>]}

        it 'redirects to :show'
        it 'sets @<%= options[:name].singularize %>'
        it 'sets flash[:success]'
        it 'tags current_user as updater'
      end

      context 'unsuccessful update' do
        before {put :update, params: {id: <%= options[:name].singularize %>.id, <%= options[:name].singularize %>: attributes_for(:<%= options[:name].singularize %>, attr: nil)}}

        it 'renders :edit template'
        it 'sets @<%= options[:name].singularize %>'
        it 'sets flash[:error]'
      end
    end

    describe 'DELETE destroy' do
      before {delete :destroy, params: {id: <%= options[:name].singularize %>.id}}

      it 'redirects to :index' do
        expect(response).to redirect_to <%= options[:name].pluralize %>_path
      end
      it 'sets @<%= options[:name].singularize %>'
      it 'deletes @<%= options[:name].singularize %>'
      it 'sets flash[success]'
    end
  end
end
