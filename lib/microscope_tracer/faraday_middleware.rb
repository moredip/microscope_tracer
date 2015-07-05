require 'faraday'

require 'microscope_tracer/trace_logger'

module MicroscopeTracer
class FaradayMiddleware < Faraday::Middleware
  def initialize(app,service_name)
    @trace_logger = TraceLogger.new(service_name)
    super(app)
  end

  def call(env)
    span = Span.lookup_for_this_request
    child_span_id = Span.generate_unique_id

    Headers.add_client_request_headers(env.request_headers,span,child_span_id)

    started_at = Time.now

    @trace_logger.log_client_start(span)


    @app.call(env).on_complete do |response_env|
      duration = Time.now - started_at
      @trace_logger.log_client_end(span,duration) 
    end
  end
end
end
