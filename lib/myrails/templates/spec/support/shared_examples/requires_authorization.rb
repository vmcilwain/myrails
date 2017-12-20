shared_examples 'requires authorization' do
  let(:user) {create :user}
  before do
    sign_out admin_user
    sign_in user
    action
  end

  it 'redirects to root path' do
    expect(response).to redirect_to root_path
  end

  it 'sets flash[:alert]' do
    expect(flash[:alert]).to_not be_nil
  end
end
