shared_examples 'requires authentication' do
  before do
    sign_out admin_user
    action
  end

  it 'redirects to new session path' do
    expect(response).to redirect_to new_user_session_path
  end

  it 'sets flash[:alert]' do
    expect(flash[:alert]).to_not be_nil
  end
end