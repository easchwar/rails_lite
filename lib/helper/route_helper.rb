module RouteHelper
  def link_to(name = nil, url = nil, options = {})
    defaults = {}
    options = defaults.merge(options)
  end

  def button_to(name = nil, url = nil, options = {})
    defaults = {}
    options = defaults.merge(options)
  end

  def self.define_url_helper(pattern)
    method_name = make_method_name(pattern)

    define_method(method_name) do |*args|
      ary = pattern.split('/')
      num_params = ary.select { |el| el.starts_with?(':') }.count

      ary_with_params = ary.map do |el|
        el.starts_with?(':') ? args.shift : el
      end
      url = ary_with_params.join('/')
      url = url[0..-2] if url[-1] == '/'
      url
    end
  end

  def self.make_method_name(pattern)
    ary = pattern[1..-1].split('/')
    num_args = ary.select { |el| el.starts_with?(':') }.count
    ary.reject! { |el| el.starts_with?(':') }
    "#{ary.join('_')}_url".to_sym
  end
end
