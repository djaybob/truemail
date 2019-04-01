# frozen_string_literal: true

module Truemail
  module Validate
    class ResolverExecutionWrapper
      attr_accessor :attempts

      def self.call(&block)
        new.call(&block)
      end

      def initialize
        @attempts = Truemail.configuration.retry_count
      end

      def call(&block)
        Timeout.timeout(Truemail.configuration.connection_timeout, &block)
      rescue Resolv::ResolvError
        false
      rescue Timeout::Error
        retry unless (self.attempts -= 1).zero?
        false
      end
    end
  end
end
