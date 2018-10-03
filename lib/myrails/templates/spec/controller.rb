require 'rails_helper'

describe <%= @name.pluralize.camelize %>Controller do
  # let(:user) {create :user}
  let(:<%= @name.pluralize %>) {create_list :<%= @name %>, 3 }
  let(:<%= @name.singularize %>) {create :<%= @name.singularize %>}

  # before {sign_in user}

  describe 'GET index' do
    before do
      <%= @name.pluralize %>
      get :index
    end
    
    subject {assigns[:<%= @name.pluralize %>]}
    
    it {is_expected.to eq <%= @name.pluralize %>}
  end

  describe 'GET show' do
    before {get :show, params: {id: <%= @name.singularize %>}}

    subject(:<%= @name.first %>) {assigns[:<%= @name.singularize %>]}
    
    it {is_expected.to eq <%= @name.singularize %>}
  end

  describe 'GET new' do
    before {get :new}

    subject(:<%= @name.first %>) {assigns[:<%= @name.singularize %>]}
    
    it {is_expected.to be_a_new <%= @name.singularize.camelize %>}
  end

  describe 'POST create' do
    context 'successful create' do
      before {post :create, params: {<%= @name.singularize %>: attributes_for(:<%= @name.singularize %>)}}

      subject(:<%= @name.first %>){assigns[:<%= @name.singularize %>]}

      it 'redirects to :show'      
      it {is_expected.to be_instance_of <%= @name.singularize.camelize %>}
      
      it 'sets flash message' do
        expect(flash[:success]).to_not be_nil
      end
        
      it 'tags the current_user as creator'
    end

    context 'unsuccessful create' do
      before {post :create, params: {<%= @name.singularize %>: attributes_for(:<%= @name.singularize %>, attr: nil)}}
      
      subject(:<%= @name.first %>){assigns[:<%= @name.singularize %>]}
      
      it 'renders :new template'
      it {is_expected.to be_a_new <%= @name.singularize.camelize %>}

      it 'sets flash message' do
        expect(flash[:error]).to_not be_nil
      end
    end
  end

  describe 'GET edit' do
    before {get :edit, params: {id: <%= @name.singularize %>}}

    subject(:<%= @name.first %>){assigns[:<%= @name.singularize %>]}
    
    it {is_expected.to eq <%= @name.singularize %>}
  end

  describe 'PUT/PATCH update' do
    context 'successful update' do
      before {put :update, params: {id: <%= @name.singularize %>, <%= @name.singularize %>: attributes_for(:<%= @name.singularize %>)}}

      subject(:<%= @name.first %>) {assigns[:<%= @name.singularize %>]}

      it 'redirects to :show'
      it {is_expected.to eq <%= @name.singularize %>}
      
      it 'sets flash message' do
        expect(flash[:success]).to_not be_nil
      end
      it 'tags current_user as updater'
    end

    context 'unsuccessful update' do
      before {put :update, params: {id: <%= @name.singularize %>, <%= @name.singularize %>: attributes_for(:<%= @name.singularize %>, attr: nil)}}

      subject(:<%= @name.first %>) {assigns[:<%= @name.singularize %>]}
      
      it 'renders :edit template'
      it {is_expected.to eq <%= @name.singularize %>}
      
      it 'sets flash message' do
        expect(flash[:error]).to_not be_nil
      end
    end
  end

  describe 'DELETE destroy' do
    before {delete :destroy, params: {id: <%= @name.singularize %>}}
    
    subject(:<%= @name.first %>) {assigns[:<%= @name.singularize %>]}
   
    it 'redirects to :index' do
      expect(response).to redirect_to <%= @name.pluralize %>_path
    end
    
    it {is_expected.to eq <%= @name.singularize %>}
    
    it 'deletes @<%= @name.singularize %>' do
      expect(<%= @name.singularize.camelize %>.find_by_id(<%= @name.singularize %>.id)).to be_nil
    end
    
    it 'sets flash message' do
      expect(flash[:success]).to_not be_nil
    end
  end
end
