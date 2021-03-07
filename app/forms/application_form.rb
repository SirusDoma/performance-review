# frozen_string_literal: true

class ApplicationForm
  include ActiveModel::Validations

  def initialize(params = {})
    update_attributes(params, normalize: true)
  end
  
  def self.form_attributes
    @form_attributes ||= []
  end

  def self.attribute(*attribute_list)
    attr_accessor(*attribute_list)

    @form_attributes ||= []
    @form_attributes += attribute_list
  end

  def update_attributes(params = {}, options = {})
    params  ||= {}
    options ||= {}
    return unless params.is_a?(Hash)

    params.each do |key, value|
      value = value.to_s.strip if options[:normalize].present? && value.is_a?(String)
      instance_variable_set("@#{key}", value) if respond_to?(key)
    end
  end

  def attributes
    instance_values.symbolize_keys.select { |key, _| self.class.form_attributes.include?(key) }
  end
end
