require File.expand_path('../../spec_helper', __FILE__)

RSpec.describe Ucpaas::Client do
  subject { Ucpaas::Client.new('APPID', 'APPSECRET') }

  before do
    subject.logger.level = Logger::DEBUG
  end

  context :initialize do
    let(:time) { Time.now.strftime('%Y%m%d%H%M%S') }

    it :path do
      expect(subject.path('/root/')).to match(/ucpaas.+root/)
    end

    its :formated_time do
      is_expected.to match(/2015/)
    end

    it :headers do
      headers = subject.headers(time)
      expect(headers).to have_key(:authorization)
    end

    it :sign do
      sign = subject.sign(time)
      expect(sign).not_to be_nil
    end
  end

  context :request do
    it :get do
      stub_request(:get, /api\.ucpaas\.com.*/)
        .with { |req| req.headers.key?('Authorization') }
        .to_return(body: '{"resp": {"respCode": "000000"}}')
      subject.get '/'
    end

    it :post do
      stub_request(:post, /api\.ucpaas\.com.*/)
        .with { |req| req.headers.key?('Authorization') }
        .to_return(body: '{"resp": {"respCode": "000000"}}')
      subject.post '/', '{appId: 1}'
    end
  end

  context :handle_error do
    it :develop do
      response = {
        'resp' => {
          'respCode' => '101001'
        }
      }
      expect { subject.handle_error(response) }
        .to(raise_error(Ucpaas::DevelopError))
    end
  end
end
