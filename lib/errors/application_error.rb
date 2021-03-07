# frozen_string_literal: true

class ApplicationError < StandardError
  attr_reader :http_code, :error_code

  def initialize(params = {})
    params = { message: params } if params.is_a?(String)
    params ||= {}

    err_name = self.class.name.underscore.delete_suffix('_error')
    params[:message] ||= I18n.t("errors.#{err_name}.message", params)

    super(params[:message])
    @http_code  = params[:http_code]  || I18n.t("errors.#{err_name}.http_code")
    @error_code = params[:error_code] || I18n.t("errors.#{err_name}.error_code")
  end
end
