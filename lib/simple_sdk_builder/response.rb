require 'json'

module SimpleSDKBuilder
class Response

  def initialize(typhoeus_response)
    @typhoeus_response = typhoeus_response
  end

  def code
    @typhoeus_response.code
  end

  def time
    @typhoeus_response.time
  end

  def headers
    @typhoeus_response.headers
  end

  def body
    @typhoeus_response.body
  end

  def parsed_body
    @parsed_body ||= JSON.parse(body)
  end

  def build(type)
    if parsed_body.is_a?(Array)
      parsed_body.collect { |value| type.new.from_json(value.to_json) }
    else
      type.new.from_json(body)
    end
  end

end
end

