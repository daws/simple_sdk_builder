require 'spec_helper'

include SimpleJsonSDKBuilder

class MockResponse
  attr_accessor :timed_out, :code, :body

  def initialize(options = {})
    self.timed_out = false
    self.code = 200
    self.body = %{{"value":"it worked!"}}

    options.each do |key, value|
      self.send("#{key}=", value)
    end
  end

  def timed_out?
    @timed_out
  end
end

describe Base do

  before(:each) do
    @base_class = Class.new do
      include SimpleJsonSDKBuilder::Base
    end
  end

  subject { @base_class }

  it 'can be configured with a :service_url' do
    url = 'https://api.davidmdawson.com'
    @base_class.config :service_url => url
    @base_class.config[:service_url].should == url
  end

  context 'with error handlers defined' do

    before(:each) do
      @timeout_error = Class.new(StandardError)
      @not_found_error = Class.new(StandardError)
      @server_error = Class.new(StandardError)
      @unknown_error = Class.new(StandardError)

      @base_class.config :error_handlers => {
        nil => @timeout_error,
        '404' => @not_found_error,
        /^5/ => @server_error,
        '*' => @unknown_error
      }
    end

    subject { @base_class }

    context 'the check_response method' do

      it 'should return successfully with a 200 status code' do
        lambda { subject.check_response(MockResponse.new) }.should_not raise_error
      end

      it 'should raise a not_found_error with a 404 status code' do
        lambda { subject.check_response(MockResponse.new(:code => 404)) }.should raise_error(@not_found_error)
      end

      it 'should raise a server_error with a 503 status code' do
        lambda { subject.check_response(MockResponse.new(:code => 503)) }.should raise_error(@server_error)
      end

      it 'should raise an unknown_error with a 301 status code' do
        lambda { subject.check_response(MockResponse.new(:code => 301)) }.should raise_error(@unknown_error)
      end

      it 'should raise a timeout_error upon a timeout' do
        lambda { subject.check_response(MockResponse.new(:timed_out => true, :code => nil)) }.should raise_error(@timeout_error)
      end

    end

    context 'a subclass' do

      subject { Class.new(@base_class) }

      it %q{should use parent's not_found_error} do
        lambda { subject.check_response(MockResponse.new(:code => 404)) }.should raise_error(@not_found_error)
      end

    end

  end

  context 'with a service url and stubbed hydra instance configured' do

    before(:each) do
      hydra = Typhoeus::Hydra.new

      response = Typhoeus::Response.new(:code => 200, :headers => '', :body => %{{"foo":"bar"}}, :time => 0.3)
      hydra.stub(:get, 'https://api.davidmdawson.com/').and_return(response)

      @base_class.config :service_url => 'https://api.davidmdawson.com'
      @base_class.config :hydra => hydra
    end

    it 'should default to a GET /' do
      subject.simple_json_request.parsed_body.should == { 'foo' => 'bar' }
    end

    context 'with a serializable foo class' do

      before(:each) do
        @foo_class = Class.new do
          include ActiveModel::Serializers::JSON
          attr_accessor :attributes
        end
      end

      it 'should build a foo class when requested' do
        response = subject.simple_json_request
        result = response.build(@foo_class)
        result.should be_a(@foo_class)
        result.attributes.should == 'bar'
      end

    end

  end

end
