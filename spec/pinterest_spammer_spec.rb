require 'spec_helper'
require 'pinterest_spammer'

describe PinterestSpammer do
  let(:agent) { PinterestSpammer.new }

  describe '#sign_in' do
    it 'sign in to Pinterest using username and password' do
      stub_request(:post, 'https://www.pinterest.com/resource/UserSessionResource/create/').to_return(:status => 200, :body => "", :headers => {})
      result = agent.sign_in 'username_test', 'password_test'
      expect(result[:success]).to eq true
    end

    it 'returns error message on fail' do
      allow(agent).to receive(:sign_in) { raise StandardError }
      result = agent.sign_in 'username_test', 'password_test'
      expect(result[:success]).to eq false
      expect(result[:error_msg]).to_not eq nil
    end
  end

  it 'creates a pin'
end
