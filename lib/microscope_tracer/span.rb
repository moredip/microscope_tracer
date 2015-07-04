require 'securerandom'
require 'request_store'

module MicroscopeTracer
class Span
  attr_reader :trace_id, :span_id, :parent_span_id

  def self.generate_unique_id
    SecureRandom.uuid
  end

  def self.lookup_for_this_request
    RequestStore.store[:microscope_span]
  end

  def store_for_this_request
    RequestStore.store[:microscope_span] = self
  end

  def initialize(trace_id,parent_span_id,span_id = false)
    span_id ||= Span.generate_unique_id
    @trace_id, @parent_span_id, @span_id = trace_id, parent_span_id, span_id
  end
end
end
