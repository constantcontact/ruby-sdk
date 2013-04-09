#
# contact_list_spec.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

require 'spec_helper'

describe ConstantContact::Components::ContactList do
  describe "#from_list" do
    it "should return a list" do
      json = load_json('list.json')
      list = ConstantContact::Components::ContactList.create(JSON.parse(json))

      list.name.should eq('Fake List')
    end
  end
end