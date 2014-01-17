#
# address_spec.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

require 'spec_helper'

describe ConstantContact::Components::Address do
  describe "#from_list" do
    it "should return an address" do
      json = load_file('address.json')
      address = ConstantContact::Components::Address.create(JSON.parse(json))

      address.line1.should eq('6 Main Street')
    end
  end
end