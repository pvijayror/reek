require_relative 'smell_detector'
require_relative 'smell_warning'

module Reek
  module Smells
    #
    # TODO: Description
    # TODO: See {file:docs/Unused-Private-Method.md} for details.
    class UnusedPrivateMethod < SmellDetector
      def self.contexts
        [:class]
      end

      #
      # @return [Array<SmellWarning>]
      #
      def examine_context(ctx)
        unused_private_methods.map do |name|
          smell_warning(
            context: ctx,
            lines: [ctx.exp.line],
            message: "has the unused private method #{name}",
            parameters: { name: name })
        end
      end

      private

      def unused_private_methods
        # Difference between "private_methods_defined" and "method_calls_on_self".
        {} # TODO
      end

      def private_methods_defined(_ctx)
        {} # TODO
      end

      def method_calls_on_self(_ctx)
        # We need to:
        # * count method calls with "self" being the implicit receiver (so receiver is nil)
        # * count method calls with explicit receiver
        # * not count / ignore method calls on other objects.
        {} # TODO
      end
    end
  end
end
