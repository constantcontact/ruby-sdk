#
# component.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Components
    class Component
      protected

      # Get the requested value from a hash, or return the default
      # @param [Hash] hsh - the hash to search for the provided hash key
      # @param [String] key - hash key to look for
      # @param [String] default - value to return if the key is not found, default is null
      # @return [String]
      def self.get_value(hsh, key, default = nil)
        hsh.has_key?(key) and hsh[key] ? hsh[key] : default
      end

    end
  end
end