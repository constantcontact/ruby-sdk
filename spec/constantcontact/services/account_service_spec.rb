#
# account_service_spec.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

require 'spec_helper'

describe ConstantContact::Services::AccountService do
  before(:each) do
    @request = double('http request', :user => nil, :password => nil, :url => 'http://example.com', :redirection_history => nil)
    @client = ConstantContact::Api.new('explicit_api_key', "access_token")
  end

  describe "#get_account_info" do
    it "gets a summary of account information" do
      json_response = load_file('account_info_response.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response =RestClient::Response.create(json_response, net_http_resp, @request)
      RestClient.stub(:get).and_return(response)

      result = ConstantContact::Services::AccountService.new(@client).get_account_info()
      result.should be_kind_of(ConstantContact::Components::AccountInfo)
      result.website.should eq('http://www.example.com')
      result.organization_addresses.first.should be_kind_of(ConstantContact::Components::AccountAddress)
      result.organization_addresses.first.city.should eq('Anytown')
    end
  end

  describe "#get_verified_email_addresses" do
    it "gets all verified email addresses associated with an account" do
      json_response = load_file('verified_email_addresses_response.json')
      net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

      response =RestClient::Response.create(json_response, net_http_resp, @request)
      RestClient.stub(:get).and_return(response)

      params = {}
      email_addresses = ConstantContact::Services::AccountService.new(@client).get_verified_email_addresses(params)

      email_addresses.should be_kind_of(Array)
      email_addresses.first.should be_kind_of(ConstantContact::Components::VerifiedEmailAddress)
      email_addresses.first.email_address.should eq('abc@def.com')
    end
  end
end