require File.expand_path('../../spec_helper', __FILE__)

RSpec.describe Ucpaas::Sms do
  let(:target_class) do
    Class.new do
      include Ucpaas::Sms
    end
  end
  subject { target_class.new }

  it :send_sms do
    expect(subject).to receive(:post)
    subject.send_sms('appid', 'tmpid', 'mobile', '1', '2')
  end
end
