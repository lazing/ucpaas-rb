module Ucpaas
  # sms client api
  module Manage
    def find_or_create_client(app_id, mobile, options = {})
      mob = mobile.gsub(/^\+?86/, '')
      client_info = get('/ClientsByMobile', appId: app_id, mobile: mob)
      return client_info['resp']['client'] if client_info['resp']['client']
      params = {
        appId: app_id,
        clientType: 0,
        mobile: mob
      }.merge(options)
      new_client = post('/Clients', params)
      new_client['resp']['client']
    end
  end
end
