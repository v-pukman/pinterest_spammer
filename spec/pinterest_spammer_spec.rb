require 'spec_helper'
require 'pinterest_spammer'

describe PinterestSpammer do
  let(:agent) { PinterestSpammer.new }

  it 'sign in to Pinterest using username and password' do
    stub_request(:post, 'https://www.pinterest.com/resource/UserSessionResource/create/').to_return(:status => 200, :body => "", :headers => {})
    result = agent.sign_in 'username_test', 'password_test'
    expect(result['status']).to eq 'success'
  end

  it 'creates a pin'
end
