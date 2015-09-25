# 云之讯 UCPAAS Ruby REST API Client
[![Circle CI](https://circleci.com/gh/lazing/ucpaas-rb.svg?style=svg)](https://circleci.com/gh/lazing/ucpaas-rb)

https://github.com/lazing/ucpaas-rb

针对云之讯 Rest 接口（http://docs.ucpaas.com/doku.php） 做实现

## 使用方式
````ruby
gem 'ucpaas'

# worker.rb

client = Ucpaas::Client.new 'sid', 'token'

# 短信
client.send_sms 'appid', 'tmp_id', 'mobile', 'param1', 'param2', ...

# 根据手机号码创建或获取账户
client.find_or_create_client 'appid', '+8618888888888'

# 根据号码创建双向回拨(未使用的号码会自动创建账号)，最后的 hash 用于提供可选参数，参考 ucpaas 文档
client.dull_call('appid', 'from_mobile', 'to_mobile', fromSerNum: '400xxxxxxx')

````


## 贡献
新功能请直接提交 Merge Request