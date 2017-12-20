shared_examples 'supports file type' do
  require 'rack/test'

  before {action}

  subject(:a){assigns[:article]}

  it 'redirects to :show' do
    expect(response).to redirect_to Article.last
  end

  it {is_expected.to be_instance_of Article}

  it 'sets flash[:success]' do
    expect(flash[:success]).to_not be_nil
  end

  it 'tags the current_user as creator' do
    expect(a.user).to eq admin_user
  end

  it 'has an attachment' do
    expect(a.attachments.size).to eq 1
  end
end