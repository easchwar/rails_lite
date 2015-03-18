module Controller
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    #
    # You haven't done routing yet; but assume route params will be
    # passed in as a hash to `Params.new` as below:
    def initialize(req, route_params = {})
      @params = route_params

      unless req.query_string.nil?
        query_params = parse_www_encoded_form(req.query_string)
        @params.merge!(query_params)
      end

      unless req.body.nil?
        body_params = parse_www_encoded_form(req.body)
        @params.merge!(body_params)
      end
    end

    def [](key)
      @params[key.to_s]
    end

    def to_s
      @params.to_json.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
    def parse_www_encoded_form(www_encoded_form)
      query_params = {}
      ary = URI::decode_www_form(www_encoded_form)

      ary.each do |keyval|
        val = keyval[1]
        keys = parse_key(keyval[0])

        cur_node = query_params
        keys.each_with_index do |key, i|
          if i == keys.length - 1
            cur_node[key] = val
            break
          end
          cur_node[key] ||= {}
          cur_node = cur_node[key]
        end
      end
      query_params
    end

    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      key.split(/\]\[|\[|\]/)
    end
  end
end
