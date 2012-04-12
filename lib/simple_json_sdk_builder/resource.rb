require 'active_support/core_ext/hash'

module SimpleJsonSDKBuilder
module Resource

  def self.included(klass)
    klass.class_eval do
      include ActiveModel::Serializers::JSON
      self.include_root_in_json = false
    end

    klass.extend ClassMethods
  end

  def initialize(attrs = {})
    @attributes = (attrs || {}).with_indifferent_access
  end

  def attributes
    @attributes
  end

  def attributes=(attributes)
    self.class.simple_json_attributes.each do |attr|
      self.send("#{attr}=", attributes[attr])
    end
  end

  private

  module ClassMethods

    def simple_json_attribute(*attrs)
      attrs.each do |attr|
        attr = attr.to_s
        simple_json_attributes.push(attr)
        define_method attr do
          @attributes[attr]
        end
        define_method "#{attr}=" do |value|
          @attributes[attr] = value
        end
      end
    end

    def simple_json_attributes
      @simple_json_attributes ||= []
    end

  end

end
end
