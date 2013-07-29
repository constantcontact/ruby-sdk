#
# activity.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
	module Components
		class Activity < Component
			attr_accessor :id, :type, :status, :start_date, :finish_date, :file_name, :created_date,
										:error_count, :errors, :warnings, :contact_count

			# Factory method to create an Activity object from a json string
			# @param [Hash] props - hash of properties to create object from
			# @return [Activity]
			def self.create(props)
				obj = Activity.new
				if props
					props.each do |key, value|
						if key == 'errors'
							if value
								obj.errors = []
								value.each do |error|
									obj.errors << Components::ActivityError.create(error)
								end
							end
						elsif key == 'warnings'
							if value
								obj.warnings = []
								value.each do |error|
									obj.warnings << Components::ActivityError.create(error)
								end
							end
						else
							obj.send("#{key}=", value) if obj.respond_to? key
						end
					end
				end
				obj
			end
		end
	end
end