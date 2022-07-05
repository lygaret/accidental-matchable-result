require 'dry/monads/result'

module Accidental
  module MatchableResult

    def self.included(mod)
      mod.include ResultMixin
      mod.extend  ResultMixin
    end

    class Success < Dry::Monads::Result::Success
      def deconstruct         = [value!]
      def deconstruct_keys(_) = { success: value! }
    end

    class Failure < Dry::Monads::Result::Failure
      def initialize(key, exception = nil, ...)
        super(key, ...)

        @key       = key
        @exception = exception
      end

      attr_reader :key, :exception

      def deconstruct = [key]
      def deconstruct_keys(_) = { failure: key, exception: exception }
    end

    module ResultMixin
      def success(result)        = Success.new(result)
      def failure(key, ex = nil) = Failure.new(key, ex, Dry::Monads::RightBiased::Left.trace_caller)
    end

  end
end
