#
# move_results.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Components
    class MoveResults < Component
      attr_accessor :id, :uri

      # Factory method to create a MoveResults object from a json string
      # @param [Hash] props - properties to create object from
      # @return [MoveResults]
      def self.create(props)
        obj = MoveResults.new
        if props
          props.each do |key, value|
            obj.send("#{key}=", value) if obj.respond_to?("#{key}=")
          end
        end
        obj
      end
    end
  end
end