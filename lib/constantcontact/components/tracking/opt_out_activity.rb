#
# opt_out_activity.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
	module Components
		class OptOutActivity < Component
			attr_accessor :activity_type, :campaign_id, :email_address, :contact_id, :unsubscribe_date,
										:unsubscribe_source, :unsubscribe_reason


			# Factory method to create an OptOutActivity object from an array
			# @param [Hash] props - hash of properties to create object from
			# @return [OptOutActivity]
			def self.create(props)
				opt_out_activity = OptOutActivity.new
				if props
					props.each do |key, value|
						opt_out_activity.send("#{key}=", value)
					end
				end
				opt_out_activity
			end

		end
	end
end