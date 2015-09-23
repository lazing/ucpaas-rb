module Ucpaas
  # call client api
  module Call
    def dull_call(app_id, from_number, to_number, options = {})
      client = find_or_create_client(app_id, from_number)
      client_number = client['clientNumber']
      data = {
        appId: app_id,
        fromClient: client_number,
        to: to_number
      }.merge(options)
      response = post('/Calls/callBack', data)
      response['resp']['callback']
    end

    private
  end
end
