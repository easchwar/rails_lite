module Controller
  class Flash
    # find the cookie for this app
    # deserialize the cookie into a hash
    def initialize(req)
      @cookie = {}
      cookie = req.cookies.find { |c| c.name == '_rails_lite_flash'}
      if cookie
        @now_flash = JSON.parse(cookie.value)
      else
        @now_flash = {}
      end
    end

    def [](key)
      @cookie[key] || @now_flash[key]
    end

    def []=(key, val)
      @cookie[key] = val
    end

    def now()
      @now_flash
    end

    # serialize the hash into json and save in a cookie
    # add to the response's cookies
    def store_flash(res)
      #overwrite flash cookie
      cook = WEBrick::Cookie.new('_rails_lite_flash', @cookie.to_json)

      cook.expires = 1.minute.ago if @cookie.empty? # set to expire if empty

      cook.path = '/'
      res.cookies << cook
    end
  end
end
