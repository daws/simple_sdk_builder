# This file should require or autoload the implementation of this gem
#
# Example:
#
#  require 'my_gem/my_extension'
#
#  module MyGem
#    autoload :MyClass, 'my_gem/my_class'
#  end

require 'simple_sdk_builder/errors'

module SimpleSDKBuilder

  autoload :Base, 'simple_sdk_builder/base'
  autoload :Resource, 'simple_sdk_builder/resource'
  autoload :Response, 'simple_sdk_builder/response'
  autoload :SearchResults, 'simple_sdk_builder/search_results'

end
