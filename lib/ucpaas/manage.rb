module Ucpaas
  # sms client api
  module Manage
    def find_or_create_client(app_id, mobile, options = {})
      mob = mobile.gsub(/^\+?86/, '')
      client_info = get('/ClientsByMobile.json', appId: app_id, mobile: mob)
      return client_info['resp']['client'] if client_info['resp']['client']
      params = {
        appId: app_id,
        clientType: 0,
        mobile: mob
      }.merge(options)
      new_client = post('/Clients.json', params)
      new_client['resp']['client']
    end

    def clients(app_id, start = 0, limit = 10)
      params = {
        client: {
          appId: app_id,
          start: start,
          limit: limit
        }
      }
      response = post('/clientList.json', params)
      response['resp']['client']
    end
  end
end
