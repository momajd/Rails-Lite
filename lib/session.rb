require 'json'

class Session

  def initialize(req)
    #grab the '_rails_lite_app' cookie if it has been previously set
    cookie = req.cookies['_rails_lite_app']

    if cookie
      @data = JSON.parse(cookie)
    else
      @data = {}
    end
  end

  def [](key)
    @data[key]
  end

  def []=(key, val)
    @data[key] = val
  end

  def store_session(res)
    res.set_cookie('_rails_lite_app', {path: "/", value: @data.to_json} )
  end
end
