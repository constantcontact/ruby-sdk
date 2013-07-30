#
# custom_field_spec.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

require 'spec_helper'

describe ConstantContact::Components::CustomField do
  describe "#from_list" do
    it "should return a custom field" do
      json = '{"name":"Property", "value":"Private"}'
      field = ConstantContact::Components::CustomField.create(JSON.parse(json))

      field.name.should eq('Property')
    end
  end
end