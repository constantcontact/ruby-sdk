#
# api_spec.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

require 'spec_helper'

describe ConstantContact::Api do
	before(:each) do
		@api = ConstantContact::Api.new('api key')
	end

	describe "#get_contacts" do
		it "returns an array of contacts" do
			json = load_json('contacts.json')
			net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

			response = RestClient::Response.create(json, net_http_resp, {})
			RestClient.stub(:get).and_return(response)
			contacts = @api.get_contacts('token')
			contact = contacts.results[0]

			contacts.should be_kind_of(ConstantContact::Components::ResultSet)
			contact.should be_kind_of(ConstantContact::Components::Contact)
		end
	end

	describe "#get_contact" do
		it "returns a contact" do
			json = load_json('contact.json')
			net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

			response = RestClient::Response.create(json, net_http_resp, {})
			RestClient.stub(:get).and_return(response)
			contact = @api.get_contact('token', 1)

			contact.should be_kind_of(ConstantContact::Components::Contact)
		end
	end

	describe "#get_contact_by_email" do
		it "returns a contact" do
			json = load_json('contacts.json')
			net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

			response = RestClient::Response.create(json, net_http_resp, {})
			RestClient.stub(:get).and_return(response)
			contacts = @api.get_contact_by_email('token', 'john.smith@gmail.com')
			contact = contacts.results[0]

			contact.should be_kind_of(ConstantContact::Components::Contact)
		end
	end

	describe "#add_contact" do
		it "adds a contact" do
			json = load_json('contact.json')
			net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

			response = RestClient::Response.create(json, net_http_resp, {})
			RestClient.stub(:post).and_return(response)
			contact = ConstantContact::Components::Contact.create(JSON.parse(json))
			added = @api.add_contact('token', contact)

			added.should respond_to(:status)
			added.status.should eq('REMOVED')
		end
	end

	describe "#delete_contact" do
		it "deletes a contact" do
			json = load_json('contact.json')
			net_http_resp = Net::HTTPResponse.new(1.0, 204, 'No Content')

			response = RestClient::Response.create('', net_http_resp, {})
			RestClient.stub(:delete).and_return(response)
			contact = ConstantContact::Components::Contact.create(JSON.parse(json))
			@api.delete_contact('token', contact).should be_true
		end
	end

	describe "#delete_contact_from_lists" do
		it "deletes a contact" do
			json = load_json('contact.json')
			net_http_resp = Net::HTTPResponse.new(1.0, 204, 'No Content')

			response = RestClient::Response.create('', net_http_resp, {})
			RestClient.stub(:delete).and_return(response)
			contact = ConstantContact::Components::Contact.create(JSON.parse(json))
			@api.delete_contact_from_lists('token', contact).should be_true
		end
	end

	describe "#delete_contact_from_list" do
		it "deletes a contact" do
			contact_json = load_json('contact.json')
			list_json = load_json('list.json')
			net_http_resp = Net::HTTPResponse.new(1.0, 204, 'No Content')

			response = RestClient::Response.create('', net_http_resp, {})
			RestClient.stub(:delete).and_return(response)
			contact = ConstantContact::Components::Contact.create(JSON.parse(contact_json))
			list = ConstantContact::Components::ContactList.create(JSON.parse(list_json))
			@api.delete_contact_from_list('token', contact, list).should be_true
		end
	end

	describe "#update_contact" do
		it "updates a contact" do
			json = load_json('contact.json')
			net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

			response = RestClient::Response.create(json, net_http_resp, {})
			RestClient.stub(:put).and_return(response)
			contact = ConstantContact::Components::Contact.create(JSON.parse(json))
			added = @api.update_contact('token', contact)

			added.should respond_to(:status)
			added.status.should eq('REMOVED')
		end
	end

	describe "#get_lists" do
		it "returns an array of lists" do
			json = load_json('lists.json')
			net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

			response = RestClient::Response.create(json, net_http_resp, {})
			RestClient.stub(:get).and_return(response)
			lists = @api.get_lists('token')
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
			contact = @api.get_list('token', 1)

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
			added = @api.add_list('token', list)

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
			contacts = @api.get_contacts_from_list('token', list)
			contact = contacts.results[0]

			contacts.should be_kind_of(ConstantContact::Components::ResultSet)
			contact.should be_kind_of(ConstantContact::Components::Contact)
		end
	end
end