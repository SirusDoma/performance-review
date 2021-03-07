# frozen_string_literal: true

module EmployeeService
  module_function

  def fetch(*args)
    EmployeeService::Fetcher.perform(*args)
  end

  def register(*args)
    EmployeeService::Registrar.perform(*args)
  end

  def update(*args)
    EmployeeService::Updater.perform(*args)
  end
end
