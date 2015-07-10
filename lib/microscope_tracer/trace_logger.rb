module MicroscopeTracer
class TraceLogger
  def initialize(service_name)
    @service_name = service_name

    # hardcoded for now
    @log_prefix = "MICROSCOPE: "
    @io = $stdout
  end

  def log_server_start(span)
    log(:server_start,span)
  end

  def log_server_end(span,duration_in_seconds)
    millis = duration_in_seconds * 1000
    log(:server_end,span,{elapsedMillis:millis})
  end

  def log_client_start(span)
    log(:client_start,span)
  end

  def log_client_end(span,duration_in_seconds)
    millis = duration_in_seconds * 1000
    log(:client_end,span,{elapsedMillis:millis})
  end

  def log(type,span,extras={})
    fields = {service:@service_name,type:type,traceId:span.trace_id,spanId:span.span_id,pSpanId:span.parent_span_id}.merge(extras)
    line = fields.map{ |k,v| if v then "#{k}=\"#{v}\"" else nil end }.compact.join(" ")

    @io.puts(@log_prefix + line)
  end
end
end
