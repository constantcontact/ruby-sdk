#
# bounce_activity.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
	module Components
		class BounceActivity < Component
			attr_accessor :activity_type, :bounce_code, :bounce_description, :bounce_message, :bounce_date,
										:contact_id, :email_address, :campaign_id


			# Factory method to create a BounceActivity object from an array
			# @param [Hash] props - hash of properties to create object from
			# @return [BounceActivity]
			def self.create(props)
				obj = BounceActivity.new
				if props
					props.each do |key, value|
						obj.send("#{key}=", value) if obj.respond_to? key
					end
				end
				obj
			end
		end
	end
end