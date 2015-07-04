require 'microscope_tracer/span'

module MicroscopeTracer
  module Headers
    def self.add_client_request_headers(headers,span,child_span_id)
      headers["Microscope-Trace-Id"] = span.trace_id if span.trace_id
      headers["Microscope-Parent-Span-Id"] = span.span_id if span.span_id
      headers["Microscope-Span-Id"] = child_span_id if child_span_id
    end

    def self.span_from_server_request_headers(env)
      trace_id = env["HTTP_MICROSCOPE_TRACE_ID"]
      parent_span_id = env["HTTP_MICROSCOPE_PARENT_SPAN_ID"]
      span_id = env.fetch("HTTP_MICROSCOPE_SPAN_ID",false)
      Span.new(trace_id,parent_span_id,span_id)
    end
  end
end
