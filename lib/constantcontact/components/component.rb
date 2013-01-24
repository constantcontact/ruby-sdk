#
# session_data_store.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
	module Components
		class Component
			protected

			# Return the value or the default value of the given Hash key
			# @param [Hash] array
			# @param [String] item
			# @param [String] default
			# @return [String, nil]
			def self.get_value(array, item, default = nil)
				array.has_key?(item) and array[item] ? array[item] : default
			end

		end
	end
end