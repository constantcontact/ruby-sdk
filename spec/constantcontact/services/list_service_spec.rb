#
# list_service_spec.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

require 'spec_helper'

describe ConstantContact::Services::ListService do
	describe "#get_lists" do
		it "returns an array of lists" do
			json = load_json('lists.json')
			net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

			response = RestClient::Response.create(json, net_http_resp, {})
			RestClient.stub(:get).and_return(response)
			lists = ConstantContact::Services::ListService.get_lists('token')
			list = lists[0]

			lists.should be_kind_of(Array)
			list.should be_kind_of(ConstantContact::Components::ContactList)
		end
	end

	describe "#get_list" do
		it "returns a list" do
			json = load_json('list.json')
			net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

			response = RestClient::Response.create(json, net_http_resp, {})
			RestClient.stub(:get).and_return(response)
			contact = ConstantContact::Services::ListService.get_list('token', 1)

			contact.should be_kind_of(ConstantContact::Components::ContactList)
		end
	end

	describe "#add_list" do
		it "adds a list" do
			json = load_json('list.json')
			net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

			response = RestClient::Response.create(json, net_http_resp, {})
			RestClient.stub(:post).and_return(response)
			list = ConstantContact::Components::ContactList.create(JSON.parse(json))
			added = ConstantContact::Services::ListService.add_list('token', list)

			added.should respond_to(:status)
			added.status.should eq('ACTIVE')
		end
	end

	describe "#get_contacts_from_list" do
		it "returns an array of contacts" do
			json_list = load_json('list.json')
			json_contacts = load_json('contacts.json')
			net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

			response = RestClient::Response.create(json_contacts, net_http_resp, {})
			RestClient.stub(:get).and_return(response)
			list = ConstantContact::Components::ContactList.create(JSON.parse(json_list))
			contacts = ConstantContact::Services::ListService.get_contacts_from_list('token', list)
			contact = contacts.results[0]

			contacts.should be_kind_of(ConstantContact::Components::ResultSet)
			contact.should be_kind_of(ConstantContact::Components::Contact)
		end
	end
end