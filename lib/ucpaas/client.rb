require 'faraday'
require 'logger'
require 'ucpaas/manage'
require 'ucpaas/sms'
require 'ucpaas/call'

# Ucpaas
module Ucpaas
  # Ucpaas Error
  class UcpaasError < RuntimeError; end
  class AccountError < UcpaasError; end
  class DevelopError < UcpaasError; end
  class ApplicationError < UcpaasError; end
  class CallError < UcpaasError; end
  class SmsError < UcpaasError; end

  ERRORS = {
    '100' => AccountError,
    '101' => DevelopError,
    '102' => ApplicationError,
    '103' => ApplicationError,
    '104' => CallError,
    '105' => SmsError
  }

  # client for ucpass service
  class Client
    include Sms
    include Call

    ATTRIBUTES = %w(base_url sid token soft_version).freeze
    attr_reader(*ATTRIBUTES)

    attr_accessor :logger

    def initialize(sid, token)
      @sid, @token = sid, token
      @base_url = 'https://api.ucpaas.com'
      @soft_version = '2014-06-30'
      @logger = Logger.new(STDOUT)
      @logger.level = Logger::INFO
    end

    def get(origin, params = {})
      logger.info { format('GET: %s %s', origin, params) }
      resp = connection.get do |request|
        time = formated_time
        request.url path(origin), params.merge(sign: sign(time))
        request.headers.merge!(headers(time))
      end
      handle(resp)
    end

    def post(origin, params)
      logger.info { format('POST: %s %s', origin, params) }
      resp = connection.post do |request|
        time = formated_time
        request.url path(origin), sign: sign(time)
        request.headers.merge!(headers(time))
        request.body = MultiJson.dump(params)
      end
      handle(resp)
    end

    def handle(resp)
      logger.debug { resp }
      response = MultiJson.load(resp.body)
      resp_code = response['resp']['respCode']
      return response if resp_code == '000000'
      handle_error(response)
    end

    def handle_error(response)
      logger.error response
      code = response['resp']['respCode']
      fail ERRORS[code[0..2]], code
    end

    def path(origin)
      format('%s/%s/Accounts/%s%s', base_url, soft_version, sid, origin)
    end

    def headers(time)
      {
        accept: 'json',
        content_type: 'application/json;charset=utf-8;',
        authorization: authorization(time)
      }
    end

    def sign(time)
      data = format('%s%s%s', sid, token, time)
      Digest::MD5.hexdigest(data).upcase
    end

    def authorization(time)
      Base64.strict_encode64(format('%s:%s', sid, time))
    end

    def formated_time
      Time.now.getlocal('+08:00').strftime('%Y%m%d%H%M%S')
    end

    private

    def connection
      @connection ||= begin
        Faraday.new do |faraday|
          faraday.adapter Faraday.default_adapter
        end
      end
    end
  end
end
