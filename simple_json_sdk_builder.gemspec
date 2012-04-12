require File.expand_path(File.join(File.dirname(__FILE__), 'lib', 'simple_json_sdk_builder', 'version'))

Gem::Specification.new do |s|

  # definition
  s.name = %q{simple_json_sdk_builder}
  s.version = SimpleJsonSDKBuilder::VERSION

  # details
  s.date = %q{2012-04-12}
  s.summary = %q{Makes building SDKs for RESTful JSON services easy.}
  s.description = %q{A set of libraries that supports building an object-oriented ruby SDK on top of a RESTful JSON web service.}
  s.authors = [ 'David Dawson' ]
  s.email = %q{david@stashrewards.com}
  s.homepage = %q{https://github.com/daws/simple_json_sdk_builder}
  s.require_paths = [ 'lib' ]
  
  # documentation
  s.has_rdoc = true
  s.extra_rdoc_files = %w( README.rdoc CHANGELOG.rdoc LICENSE.txt )
  s.rdoc_options = %w( --main README.rdoc )

  # files to include
  s.files = Dir[ 'lib/**/*.rb', 'README.rdoc', 'CHANGELOG.rdoc', 'LICENSE.txt' ]

  # dependencies
  # s.add_dependency 'activemodel', '~> 3.0'

  # if binaries
  # s.bindir = 'bin'
  # s.executables = [ 'executable' ]

end
