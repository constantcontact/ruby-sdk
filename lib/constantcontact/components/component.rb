#
# component.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Components
    class Component

      def to_hash
        hash = Hash.new
        self.instance_variables.collect do |var|
          hash[var.to_s[1..-1]] = self.class.to_hash_value(self.instance_variable_get(var))
        end
        hash
      end

      def self.to_hash_value(val)
        if val.is_a? ConstantContact::Components::Component
          return val.to_hash
        elsif val.is_a? Array
          return val.collect{|subval| Component.to_hash_value(subval) }
        elsif val.is_a? DateTime
          return val.to_s
        else
          return val
        end
      end

      def to_json(val = nil)
        self.to_hash.to_json
      end

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