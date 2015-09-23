require File.expand_path('../../spec_helper', __FILE__)

RSpec.describe Ucpaas::Manage do
  let(:target_class) do
    Class.new do
      include Ucpaas::Manage
    end
  end

  subject { target_class.new }

  it :find_or_create_client do
    get_resp = {
      'resp' => {
        'respCode' => '000000',
        'client' => nil
      }
    }
    post_resp = {
      'resp' => {
        'respCode' => '000000',
        'client' => { 'clientNumber' => '11111' }
      }
    }
    expect(subject).to receive(:get).and_return(get_resp)
    expect(subject).to receive(:post).and_return(post_resp)
    client = subject.find_or_create_client 'appid', '+8618888888888'
    expect(client).to have_key('clientNumber')
  end
end
