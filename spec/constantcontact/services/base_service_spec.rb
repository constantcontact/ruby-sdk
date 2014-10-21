#
# base_service_spec.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

require 'spec_helper'

describe ConstantContact::Services::BaseService do
  describe "#get_headers" do
    it "gets a hash of headers" do
      token = 'foo'
      headers = ConstantContact::Services::BaseService.send(:get_headers, token)

      expect(headers).to be_a Hash
      expect(headers[:content_type]).to be_a String
      expect(headers[:content_type]).to eq('application/json')
      expect(headers[:accept]).to be_a String
      expect(headers[:accept]).to eq('application/json')
      expect(headers[:authorization]).to be_a String
      expect(headers[:authorization]).to eq("Bearer #{token}")
      expect(headers[:user_agent]).to be_a String
      expect(headers[:user_agent].include?("Ruby SDK v#{ConstantContact::SDK::VERSION}")).to be_true
      expect(headers[:user_agent].include?(RUBY_DESCRIPTION)).to be_true
      expect(headers[:x_ctct_request_source]).to be_a String
      expect(headers[:x_ctct_request_source].include?(ConstantContact::SDK::VERSION)).to be_true
   end
 end
end