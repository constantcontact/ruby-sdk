#
# email_address_spec.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

require 'spec_helper'

describe ConstantContact::Components::EmailAddress do
	describe "#from_list" do
		it "should return an email address" do
			json = load_json('email_address.json')
			email = ConstantContact::Components::EmailAddress.from_array(JSON.parse(json))

			email.email_address.should eq('wm2q7rwtp77m@roving.com')
		end
	end
end
