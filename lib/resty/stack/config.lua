-- Copyright (C) Anton heryanto.

local ok, config = pcall(require, "config")
if not ok then config = {} end

local _M = {}
_M.base = config.base or "/"
_M.base_length = _M.base:len() + 1

local redis = config.redis or {}
_M.redis = {
  host = redis.host or "127.0.0.1",
  port = redis.port or 6379,
  timeout = redis.timeout or 1000,
  keep_size = redis.keep_size or 1024,
  keep_idle = redis.keep_idle or 0
}
_M.modules = config.modules or {}
_M.services = { auth = require "resty.stack.auth" }

for k,v in pairs(_M.modules) do
  if type(v) == "table" then
    for i=1,#v do
      local ns = k ..".".. v[i]
      _M.services[ns] = require (ns)
    end
  else
    _M.services[v] = require (v)
  end
end

return _M

