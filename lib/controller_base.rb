require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'

class ControllerBase #equivalent to Rails' ActionController::Base
  attr_reader :req, :res, :params

  def initialize(req, res, route_params = {})
    @req = req
    @res = res
    @params = route_params.merge(req.params)
  end

  def already_built_response?
    @already_built_response ||= false
  end

  def redirect_to(url)
    raise "Already built response" if already_built_response?

    @res["Location"] = url
    @res.status = 302
    session.store_session(@res) #store session info into cookie after response is built

    @already_built_response = true
  end

  def render_content(content, content_type)
    raise "Already built response" if already_built_response?

    @res['Content-Type'] = content_type
    @res.write(content)
    session.store_session(@res)
    @already_built_response = true
  end

  def render(template_name)
    controller_name = self.class.name.underscore #underscore is from active_support
    path = "views/#{controller_name}/#{template_name.to_s}.html.erb"

    template = File.read(path)
    erb_template = ERB.new(template).result(binding)

    render_content(erb_template, 'text/html')
  end

  def session
    @session ||= Session.new(@req)
  end

  def invoke_action(name)
    send(name)
    render(name) unless already_built_response?
  end
end
