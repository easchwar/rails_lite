module Controller
  class Session
    # find the cookie for this app
    # deserialize the cookie into a hash
    def initialize(req)
      cookie = req.cookies.find { |c| c.name == '_rails_lite_session'}
      if cookie
        @cookie = JSON.parse(cookie.value)
      else
        @cookie = {}
      end
    end

    def [](key)
      @cookie[key]
    end

    def []=(key, val)
      @cookie[key] = val
    end

    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    def store_session(res)
      cook = WEBrick::Cookie.new('_rails_lite_session', @cookie.to_json)
      cook.path = '/'
      res.cookies << cook
    end
  end
end
