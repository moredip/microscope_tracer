require 'microscope_tracer/span'

module MicroscopeTracer
  module Headers
    def self.add_client_request_headers(headers,span,child_span_id)
      headers["Microscope-Trace-Id"] = span.trace_id if span.trace_id
      headers["Microscope-Parent-Span-Id"] = span.span_id if span.span_id
      headers["Microscope-Span-Id"] = child_span_id if child_span_id
    end

    def self.span_from_server_request_headers(env)
      trace_id = env.fetch("HTTP_MICROSCOPE_TRACE_ID",false)
      parent_span_id = env.fetch("HTTP_MICROSCOPE_PARENT_SPAN_ID",false)
      span_id = env.fetch("HTTP_MICROSCOPE_SPAN_ID",false)

      sanity_checks(!!trace_id,!!span_id,!!parent_span_id)

      if trace_id && !parent_span_id 
        return false
      end

      Span.new(trace_id,parent_span_id,span_id)
    end

    def self.sanity_checks(trace_id_provided, span_id_provided, parent_span_id_provided)
      if !trace_id_provided && span_id_provided 
        puts "WARNING: no TraceId provided but a SpanId *was* provided"
      end

      if !trace_id_provided && parent_span_id_provided 
        puts "WARNING: no TraceId provided but a ParentSpanId *was* provided"
      end
    end
  end
end
