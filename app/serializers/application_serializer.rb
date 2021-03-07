# frozen_string_literal: true

class ApplicationSerializer
  def initialize(resource, options = {})
    @resource = resource
    @options  = options || {}
  end

  def self.serialize(resource, meta = {}, options = {})
    new(resource, meta).serializable_hash(options)
  end

  def self.serialized_attributes
    @serialized_attributes ||= []
  end

  def self.attribute(*attribute_list)
    attr_accessor(*attribute_list)

    @serialized_attributes ||= []
    @serialized_attributes += attribute_list
  end

  def self.serialize_resource(resource, options = {})
    return resource.map { |r| serialize_resource(r, options) } if resource.is_a?(Array)

    attributes = nil
    attributes ||= resource                            if resource.is_a?(Hash)
    attributes ||= resource.serializable_hash(options) if resource.respond_to?(:serializable_hash)
    attributes ||= resource.attributes                 if resource.respond_to?(:attributes)

    return resource   if attributes.nil? || !attributes.is_a?(Hash)
    return attributes unless serialized_attributes.present?

    attributes.symbolize_key.select { |k, _| k.include?(serialized_attributes) }
  end

  def serializable_hash(options = {})
    return { errors: [{ message: @resource.message }] } if @resource.is_a? StandardError

    result = { data: self.class.serialize_resource(@resource, options) }
    meta   = build_meta

    result[:meta] = meta if meta.present?
    result
  end

  private

  def build_meta
    return @options unless @resource.is_a? Array

    @options.reverse_merge({
      offset: @options[:offset].to_i,
      limit:  @options[:limit]&.to_i || @options[:total].to_i,
      total:  @options[:total].to_i
    })
  end
end
