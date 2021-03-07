# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  class << self
    attr_reader :application_form

    def form(form)
      raise ArgumentError, 'Not an ApplicationForm' unless form.new.is_a?(ApplicationForm)

      @application_form = form
    end
  end

  def initialize(attributes = nil)
    if attributes.is_a?(ApplicationForm)
      @form = attributes
      super(@form.attributes)
    else
      app_form = self.class.application_form
      @form    = app_form.new(attributes) if app_form.present?

      super(attributes)
    end
  end

  def valid?(context = nil)
    if @form.present?
      @form.update_attributes(attributes)
      return false if @form.invalid?(context)
    end

    super
  end

  def errors
    errors = super
    errors.merge!(@form.errors) if @form&.errors.present?

    errors
  end

  def delete!
    raise ActiveRecord::RecordNotDestroyed.new("#{self.class.name} cannot be soft deleted", self) unless self.class.column_names.include?('deleted_at')

    update!(deleted_at: Time.now)
  end

  def restore!
    raise ActiveRecord::RecordNotDestroyed.new("#{self.class.name} cannot be restored", self) unless self.class.column_names.include?('deleted_at')

    update!(deleted_at: nil)
  end

  def delete
    delete!
  rescue StandardError
    false
  end

  def restore
    restore!
  rescue StandardError
    false
  end
end
