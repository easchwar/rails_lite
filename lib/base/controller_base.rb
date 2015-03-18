require 'active_support'
require 'active_support/inflector'
require 'active_support/core_ext'
require 'erb'
require_relative '../aux/aux_require'
require_relative '../helper/route_helper'

module Controller
  class Base
    include RouteHelper

    attr_reader :req, :res, :params

    # Setup the controller
    def initialize(req, res, route_params = {})
      @params = Params.new(req, route_params)
      @req = req
      @res = res
    end

    # Helper method to alias @already_built_response
    def already_built_response?
      !!@already_built_response
    end

    # Set the response status code and header
    def redirect_to(url)
      session.store_session(@res)
      flash.store_flash(@res)

      if already_built_response?
        raise 'Multiple render actions detected'
      end
      @res.status = 302
      @res['Location'] = url
      @already_built_response = true
    end

    # Populate the response with content.
    # Set the response's content type to the given type.
    # Raise an error if the developer tries to double render.
    def render_content(content, content_type)
      session.store_session(@res)
      flash.store_flash(@res)

      if already_built_response?
        raise 'Multiple render actions detected'
      end
      @already_built_response = true
      @res.content_type = content_type
      @res.body = content
    end

    # use ERB and binding to evaluate templates
    # pass the rendered html to render_content
    def render(template_name)
      template_path = "views/#{self.class.name.underscore}/#{template_name.to_s}.html.erb"
      erb_string = File.read(template_path)
      erb_template = ERB.new(erb_string).result(binding)
      render_content(erb_template, 'text/html')
    end

    # use this with the router to call action_name (:index, :show, :create...)
    def invoke_action(name)
      self.send(name)
      unless @already_built_response
        render(name)
      end
    end

    # method exposing a `Session` object
    def session
      @session ||= Session.new(@req)
    end

    #method exposing a Flash object
    def flash
      @flash ||= Flash.new(@req)
    end
  end
end
