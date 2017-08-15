#
# api_spec.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

require 'spec_helper'

describe ConstantContact::SDK do
  
  let(:dummy_class) { Class.new { include ConstantContact::SDK } }
  
  it "should respond to VERSION" do
    expect((dummy_class.const_get("VERSION") rescue nil)).to be_truthy
  end
  
  it "should have a VERSION of type string" do
    expect(dummy_class::VERSION).to be_a String
  end
  
  it "should have a VERSION of the format x.y.z" do
    expect(dummy_class::VERSION.match(/[1-9]+\.\d+\.\d+/)).to_not be_nil
  end
end