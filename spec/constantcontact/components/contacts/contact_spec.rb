#
# contact_spec.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

require 'spec_helper'

describe ConstantContact::Components::Contact do
  describe "#from_list" do
    it "should return a contact" do
      json = load_file('contact.json')
      contact = ConstantContact::Components::Contact.create(JSON.parse(json))

      contact.last_name.should eq('Smith')
    end
  end
end