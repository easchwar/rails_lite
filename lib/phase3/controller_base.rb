require_relative '../phase2/controller_base'
require 'active_support'
require 'active_support/inflector'
require 'active_support/core_ext'
require 'erb'

module Phase3
  class ControllerBase < Phase2::ControllerBase
    # use ERB and binding to evaluate templates
    # pass the rendered html to render_content
    def render(template_name)
      template_path = "views/#{self.class.name.underscore}/#{template_name.to_s}.html.erb"
      erb_string = File.read(template_path)
      erb_template = ERB.new(erb_string).result(binding)
      render_content(erb_template, 'text/html')
    end
  end
end
