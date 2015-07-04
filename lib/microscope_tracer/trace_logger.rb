module MicroscopeTracer
class TraceLogger
  def initialize(logger)
    @logger = logger
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
    fields = {type:type,traceId:span.trace_id,spanId:span.span_id,pspanId:span.parent_span_id}.merge(extras)
    line = fields.map{ |k,v| "#{k}=\"#{v}\"" }.join(" ")
    @logger.info(line)
  end
end
end
