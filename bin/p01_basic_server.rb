require 'rack'

app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new

  res['Content-Type'] = 'text/html'

  res.write(req.path) #puts things into the response
  res.finish #returns rack standard format
end


Rack::Server.start(
  app: app,
  Port: 3000
)
