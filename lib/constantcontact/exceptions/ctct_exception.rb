#
# ctct_exception.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Exceptions
    class CtctException < Exception
      attr_accessor :errors

      # Setter
      # @param [Array<String>] errors
      def set_errors(errors)
        @errors = errors
      end

      # Getter
      # @return [Array<String>]
      def get_errors
        @errors
      end
    end
  end
end
