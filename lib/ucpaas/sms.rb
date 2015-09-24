module Ucpaas
  # sms client api
  module Sms
    def send_sms(app_id, tmp_id, mobile, *params)
      data = {
        templateSMS: {
          appId: app_id,
          templateId: tmp_id,
          to: mobile,
          param: params.flatten.map(&:to_s).join(',')
        }
      }
      post '/Messages/templateSMS.json', data
    end
  end
end
