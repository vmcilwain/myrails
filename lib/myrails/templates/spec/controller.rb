require 'rails_helper'

describe <%= options[:name].pluralize.camelize %>Controller do
  # let(:user) {create :user}
  let(:<%= options[:name].pluralize %>) {create_list :<%= options[:name] %>, 3 }
  let(:<%= options[:name].singularize %>) {create :<%= options[:name].singularize %>}

  # before {sign_in user}

  describe 'GET index' do
    before do
      <%= options[:name].pluralize %>
      get :index
    end
    
    subject {assigns[:<%= options[:name].pluralize %>]}
    
    it {is_expected.to eq <%= options[:name].pluralize %>}
  end

  describe 'GET show' do
    before {get :show, params: {id: <%= options[:name].singularize %>}}

    subject(:<%= options[:name].first %>) {assigns[:<%= options[:name].singularize %>]}
    
    it {is_expected.to eq <%= options[:name].singularize %>}
  end

  describe 'GET new' do
    before {get :new}

    subject(:<%= options[:name].first %>) {assigns[:<%= options[:name].singularize %>]}
    
    it {is_expected.to be_a_new <%= options[:name].singularize.camelize %>}
  end

  describe 'POST create' do
    context 'successful create' do
      before {post :create, params: {<%= options[:name].singularize %>: attributes_for(:<%= options[:name].singularize %>)}}

      subject(:<%= options[:name].first %>){assigns[:<%= options[:name].singularize %>]}

      it 'redirects to :show'      
      it {is_expected.to be_instance_of <%= options[:name].singularize.camelize %>}
      
      it 'sets flash[:success]' do
        expect(flash[:success]).to_not be_nil
      end
        
      it 'tags the current_user as creator'
    end

    context 'unsuccessful create' do
      before {post :create, params: {<%= options[:name].singularize %>: attributes_for(:<%= options[:name].singularize %>, attr: nil)}}
      
      subject(:<%= options[:name].first %>){assigns[:<%= options[:name].singularize %>]}
      
      it 'renders :new template'
      it {is_expected.to be_a_new <%= options[:name].singularize.camelize %>}

      it 'sets flash[:error]' do
        expect(flash[:error]).to_not be_nil
      end
    end
  end

  describe 'GET edit' do
    before {get :edit, params: {id: <%= options[:name].singularize %>}}

    subject(:<%= options[:name].first %>){assigns[:<%= options[:name].singularize %>]}
    
    it {is_expected.to eq <%= options[:name].singularize %>}
  end

  describe 'PUT/PATCH update' do
    context 'successful update' do
      before {put :update, params: {id: <%= options[:name].singularize %>, <%= options[:name].singularize %>: attributes_for(:<%= options[:name].singularize %>)}}

      subject(:<%= options[:name].first %>) {assigns[:<%= options[:name].singularize %>]}

      it 'redirects to :show'
      it {is_expected.to eq <%= options[:name].singularize %>}
      
      it 'sets flash[:success]' do
        expect(flash[:success]).to_not be_nil
      end
      it 'tags current_user as updater'
    end

    context 'unsuccessful update' do
      before {put :update, params: {id: <%= options[:name].singularize %>, <%= options[:name].singularize %>: attributes_for(:<%= options[:name].singularize %>, attr: nil)}}

      subject(:<%= options[:name].first %>) {assigns[:<%= options[:name].singularize %>]}
      
      it 'renders :edit template'
      it {is_expected.to eq <%= options[:name].singularize %>}
      
      it 'sets flash[:error]' do
        expect(flash[:error]).to_not be_nil
      end
    end
  end

  describe 'DELETE destroy' do
    before {delete :destroy, params: {id: <%= options[:name].singularize %>}}
    
    subject(:<%= options[:name].first %>) {assigns[:<%= options[:name].singularize %>]}
   
    it 'redirects to :index' do
      expect(response).to redirect_to <%= options[:name].pluralize %>_path
    end
    
    it {is_expected.to eq <%= options[:name].singularize %>}
    
    it 'deletes @<%= options[:name].singularize %>' do
      expect(<%= options[:name].singularize.camelize %>.find_by_id(<%= options[:name].singularize %>.id)).to be_nil
    end
    
    it 'sets flash[success]' do
      expect(flash[:success]).to_not be_nil
    end
  end
end
