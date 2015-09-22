module Ucpaas
  # sms client api
  module Sms
    def send_sms(app_id, tmp_id, mobile, *params)
      data = {
        templateSMS: {
          appId: app_id,
          templateId: tmp_id,
          to: mobile,
          params: params.map(&:to_s).join(',')
        }
      }
      post '/Messages/TemplateSMS.json', data
    end
  end
end
