require 'rails_helper'

# Does this controller require authentication?
describe SamController do
  # let(:user) {create :user}
  let(:sams) {[]}
  let(:sam) {create :sam}

  # before {sign_in user}

  describe 'GET index' do
    before do
      3.times {sams << create(:sam)}
      get :index
    end

    it 'sets @sams' do
      expect(assigns[:sams]).to eq sams
    end
  end

  describe 'GET show' do
    before {get :show, params: {id: sam.id}}

    it 'sets @sam' do
      expect(assigns[:sam]).to eq sam
    end
  end

  describe 'GET new' do
    before {get :new}

    it 'sets @sam' do
      expect(assigns[:sam]).to be_a_new Sam
    end
  end

  describe 'POST create' do
    context 'successful create' do
      before {post :create, params: {sam: attributes_for(:sam)}}

      subject(:s){assigns[:sam]}

      it 'redirects to :show'
      it 'sets @sam'
      it 'sets flash[:success]'
      it 'tags the current_user as creator'
    end

    context 'unsuccessful create' do
      before {post :create, params: {sam: attributes_for(:sam, attr: nil)}}

      it 'renders :new template'
      it 'sets @sam'
      it 'sets flash[:error]'
    end
  end

  describe 'GET edit' do
    before {get :edit, params: {id: sam.id}}

    it 'sets @sam' do
      expect(assigns[:sam]).to eq sam
    end
  end

  describe 'PUT/PATCH update' do
    context 'successful update' do
      before {put :update, params: {id: sam.id, sam: attributes_for(:sam)}}

      subject(:s) {assigns[:sam]}

      it 'redirects to :show'
      it 'sets @sam'
      it 'sets flash[:success]'
      it 'tags current_user as updater'
    end

    context 'unsuccessful update' do
      before {put :update, params: {id: sam.id, sam: attributes_for(:sam, attr: nil)}}

      it 'renders :edit template'
      it 'sets @sam'
      it 'sets flash[:error]'
    end
  end

  describe 'DELETE destroy' do
    before {delete :destroy, params: {id: sam.id}}

    it 'redirects to :index' do
      expect(response).to redirect_to sams_path
    end
    it 'sets @sam'
    it 'deletes @sam'
    it 'sets flash[success]'
  end
end
