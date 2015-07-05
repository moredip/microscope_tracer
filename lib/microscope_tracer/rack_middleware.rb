require 'rack/body_proxy'
require 'request_store'

require 'microscope_tracer/headers'
require 'microscope_tracer/trace_logger'

module MicroscopeTracer

class RackMiddleware
  def initialize(app,service_name)
    @app = app
    @trace_logger = TraceLogger.new(service_name)
  end

  def call(env)
    span = (env["SPAN"] ||= Headers.span_from_server_request_headers(env))
    span.store_for_this_request

    started_at = Time.now

    @trace_logger.log_server_start(span)

    status, header, body = @app.call(env)

    body = Rack::BodyProxy.new(body) do
      duration = Time.now - started_at
      @trace_logger.log_server_end(span,duration) 
    end

    [status, header, body]
  ensure
    RequestStore.clear! # make certain that any span info is cleared out before the next request comes in
  end
end

end
