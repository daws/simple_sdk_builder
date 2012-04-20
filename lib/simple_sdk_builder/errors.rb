require 'typhoeus'

module SimpleSDKBuilder

  # An abstract super-class of all other SimpleSDKBuilder Error classes
  class Error < StandardError
    attr_reader :code

    def initialize(response)
      if response.is_a?(Typhoeus::Response)
        @code = response.code
        super(response.body)
      else
        super(response.to_s)
      end
    end
  end
  
  # Indicates an error establishing a connection to the API, or a timeout that occurs while
  # making an API call. Is relatively common and transient- worth retrying in important cases.
  class ConnectionError < Error; end

  # Indicates that the requested object was not found.
  class NotFoundError < Error; end

  # Indicates that something was wrong with the request. See the message for details.
  class RequestError < Error; end
  
  # Indicates any other API error (generally should be non-transient and not worth retrying). The
  # error code and string will be present in this error's message if one was provided in the
  # response.
  class UnknownError < Error; end

end
