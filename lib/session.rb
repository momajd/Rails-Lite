require 'json'

class Session
  # find the cookie for this app
  # deserialize the cookie into a hash
  def initialize(req)
    cookie_val = req.cookies['_rails_lite_app']

    if cookie_val
      @session = JSON.parse(cookie_val)
    else
      @session = {}
    end
  end

  def [](key)
    @session[key]
  end

  def []=(key, val)
    @session[key] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)
  end
end
