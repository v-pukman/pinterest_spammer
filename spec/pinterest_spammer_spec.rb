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
      allow(agent).to receive(:default_headers) { raise StandardError }
      result = agent.sign_in 'username_test', 'password_test'
      expect(result[:success]).to eq false
      expect(result[:error_msg]).to_not eq nil
    end

    it 'grabs csrftoken' do
      cookie = double()
      allow(cookie).to receive(:name).and_return('csrftoken')
      allow(cookie).to receive(:value).and_return('1234')
      allow(agent.agent).to receive(:cookies).and_return([cookie])
      stub_request(:post, 'https://www.pinterest.com/resource/UserSessionResource/create/').to_return(:status => 200, :body => "", :headers => {})
      result = agent.sign_in 'username_test', 'password_test'
      expect(agent.csrftoken).to eq '1234'
    end
  end

  it 'creates a pin' do
    stub_request(:post, 'https://www.pinterest.com/resource/PinResource/create/').to_return(:status => 200, :body => { resource_response: { data: { id: 1 }}}.to_json, :headers => {})
    board_id = 1234
    link = 'https://xyz.xyz/'
    image_url = 'http://rubyonrails.org/images/rails.png'
    description = 'Spammer!'
    result = agent.create_pin(board_id, link, image_url, description)
    expect(result[:success]).to eq true
    expect(result[:pin_id]).to_not eq nil
  end
end
