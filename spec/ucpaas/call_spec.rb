require File.expand_path('../../spec_helper', __FILE__)

RSpec.describe Ucpaas::Call do
  let(:target_class) do
    Class.new do
      include Ucpaas::Call
    end
  end

  subject { target_class.new }

  it :dull_call do
    client_resp = {
      'clientNumber' => '1111'
    }
    call_resp = {
      'resp' => {
        'callback' => {
          'callId' => '1111'
        }
      }
    }
    expect(subject).to receive(:find_or_create_client).and_return(client_resp)
    expect(subject).to receive(:post).and_return(call_resp)
    result = subject.dull_call('appid', 'from', 'to')
    expect(result).to have_key('callId')
  end
end
