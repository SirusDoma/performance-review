# frozen_string_literal: true

class PerformanceReview
  module Test
    module Methods
      def app
        described_class
      end

      def stub_env(environments)
        stub_const 'ENV', ENV.to_h.merge(environments.stringify_keys!)
      end
    end
  end
end
