require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'

class ControllerBase #equivalent to Rails' ActionController::Base - MAM
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res)
    @req = req
    @res = res
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response ||= false
  end

  # Set the response status code and header
  def redirect_to(url)
    raise "Already built response" if already_built_response?

    @res["location"] = url
    @res.status = 302
    session.store_session(@res) #store session info into cookie after response is built

    @already_built_response = true
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    raise "Already built response" if already_built_response?

    @res['Content-Type'] = content_type
    @res.write(content) #append the body of the response - MAM
    session.store_session(@res) #store session info into cookie after response is built


    @already_built_response = true
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    controller_name = self.class.name.underscore #underscore is from Active Support
    path = "views/#{controller_name}/#{template_name.to_s}.html.erb"

    template = File.read(path)
    erb_template = ERB.new(template).result(binding)

    render_content(erb_template, 'text/html')
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(@req)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
  end
end
