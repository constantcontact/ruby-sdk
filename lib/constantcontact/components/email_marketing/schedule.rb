#
# schedule.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Components
    class Schedule < Component
      attr_accessor :id, :scheduled_date


			# Factory method to create a Schedule object from an array
			# @param [Hash] props - hash of properties to create object from
			# @return [Schedule]
			def self.create(props)
				obj = Schedule.new
				if props
					props = props.first if props.is_a?(Array)
					props.each do |key, value|
						obj.send("#{key}=", value) if obj.respond_to? key
					end
				end
				obj
			end
		end
	end
end