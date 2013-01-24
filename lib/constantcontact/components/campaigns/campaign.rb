#
# campaign.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
	module Components
		class Campaign < Component
			attr_accessor :id, :name, :subject, :from_name, :from_email, :reply_to_email, :campaign_type,
										:created_date, :last_send_date, :last_edit_date, :last_run_date, :next_run_date,
										:status, :share_page_url, :is_permission_reminder_enabled, :permission_reminder_text,
										:is_view_as_webpage_enabled, :view_as_web_page_text, :view_as_web_page_link_text,
										:greeting_salutations, :greeting_name, :greeting_string, :email_content, :text_content

			# Factory method to create a Campaign object from a json string
			# @param [Hash] props - array of properties to create object from
			# @return [Campaign]
			def self.from_array(props)
				campaign = Campaign.new
				campaign
			end

	end
end