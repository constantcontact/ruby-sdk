#
# api_spec.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

require 'spec_helper'

describe ConstantContact::Api do
  
  before(:all) {
    ConstantContact::Util::Config.configure do |config|
      config[:auth].delete :api_key
      config[:auth].delete :api_secret
      config[:auth].delete :redirect_uri
    end
  }
  
  it "without api_key defined" do
    lambda { 
      ConstantContact::Api.new
    }.should raise_error(ArgumentError)
  end
  
  context "with middle-ware configuration" do
    before(:all) do
      ConstantContact::Services::BaseService.api_key = nil
      ConstantContact::Util::Config.configure do |config|
        config[:auth][:api_key] = "config_api_key"
        config[:auth][:api_secret] = "config_api_secret"
        config[:auth][:redirect_uri] = "config_redirect_uri"
      end
    end
    let(:proc) { lambda { ConstantContact::Api.new } }
    it "use implicit config" do
      proc.should_not raise_error
    end
    it "has the correct client_id" do
      ConstantContact::Services::BaseService.api_key.should == "config_api_key"
    end
  end
    
  context "with middle-ware configuration" do
    before(:all) do
      ConstantContact::Services::BaseService.api_key = nil
      ConstantContact::Util::Config.configure do |config|
        config[:auth][:api_key] = "config_api_key"
        config[:auth][:api_secret] = "config_api_secret"
        config[:auth][:redirect_uri] = "config_redirect_uri"
      end
      ConstantContact::Api.new 'explicit_api_key'
    end
    it "has the correct explicit api key" do
      ConstantContact::Services::BaseService.api_key.should == "explicit_api_key"
    end
  end
  
  describe "test methods" do
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

  	describe "#get_events" do
  		it "returns an array of events" do
  			json = load_json('events.json')
  			
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')
  			response = RestClient::Response.create(json, net_http_resp, {})
  			RestClient.stub(:get).and_return(response)
  			
        events = @api.get_events('token')
  			events.should be_kind_of(ConstantContact::Components::ResultSet)
  			events.results.collect{|e| e.should be_kind_of(ConstantContact::Components::Event) }
  		end
  	end

  	describe "#get_event" do
  		it "returns an event" do
  			json = load_json('event.json')
  			net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

  			response = RestClient::Response.create(json, net_http_resp, {})
  			RestClient.stub(:get).and_return(response)
  			event = @api.get_event('token', 1)

  			event.should be_kind_of(ConstantContact::Components::Event)
  		end
  	end

  	describe "#add_event" do
  		it "adds an event" do
  			json = load_json('event.json')
  			
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')
  			response = RestClient::Response.create(json, net_http_resp, {})
  			RestClient.stub(:post).and_return(response)

  			event = ConstantContact::Components::Event.create(JSON.parse(json))
  			added = @api.add_event('token', event)

  			added.should respond_to(:id)
  			added.id.should_not be_empty
  		end
  	end

  	describe "#delete_event" do
  		it "deletes an event" do
  			json = load_json('event.json')

  			net_http_resp = Net::HTTPResponse.new(1.0, 204, 'No Content')
  			response = RestClient::Response.create('', net_http_resp, {})
  			RestClient.stub(:delete).and_return(response)

  			event = ConstantContact::Components::Event.create(JSON.parse(json))
  			@api.delete_event('token', event).should be_true
  		end
  	end

  	describe "#publish_event" do
  		it "updates an event with status of ACTIVE" do
  			json = load_json('event.json')
        hash = JSON.parse json
        hash["status"] = "ACTIVE"
      
  			net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')
        response = RestClient::Response.create(hash.to_json, net_http_resp, {})
  			RestClient.stub(:patch).and_return(response)
			
        event = ConstantContact::Components::Event.create(JSON.parse(json))
  			updated = @api.publish_event('token', event)
        updated.should be_kind_of(ConstantContact::Components::Event)
        updated.should respond_to(:status)
        updated.status.should eq("ACTIVE")
  		end
    end
    
  	describe "#cancel_event" do
  		it "updates an event's status to CANCELLED" do
  			json = load_json('event.json')
        hash =  JSON.parse json
        hash["status"] = "CANCELLED"
      
  			net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')
  			response = RestClient::Response.create(hash.to_json, net_http_resp, {})
  			RestClient.stub(:patch).and_return(response)

  			event = ConstantContact::Components::Event.create(JSON.parse(json))
  			updated = @api.cancel_event('token', event)
        updated.should be_kind_of(ConstantContact::Components::Event)
        updated.should respond_to(:status)
        updated.status.should eq("CANCELLED")
  		end
    end
      
  	describe "#get_fees" do
  		it "returns an array of fees for an event" do
  			event_json = load_json('event.json')
        fees_json = load_json('fees.json')
  			net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

  			response = RestClient::Response.create(fees_json, net_http_resp, {})
  			RestClient.stub(:get).and_return(response)
  			event = ConstantContact::Components::Event.create(JSON.parse(event_json))
  			fees = @api.get_event_fees('token', event)
  			#fees.should be_kind_of(ConstantContact::Components::ResultSet)
        #fees.results.collect{|f| f.should be_kind_of(ConstantContact::Components::Fee) }
      
        fees.should be_kind_of(Array) # inconsistent with oether APIs.
  			fees.collect{|f| f.should be_kind_of(ConstantContact::Components::Fee) }
      
  		end
    end

  	describe "#get_fee" do
  		it "return an event fee" do
  			event_json = load_json('event.json')
        fee_json = load_json('fees.json')
			
        net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')
  			response = RestClient::Response.create(fee_json, net_http_resp, {})
  			RestClient.stub(:get).and_return(response)

  			event = ConstantContact::Components::Event.create(JSON.parse(event_json))
        fee   = ConstantContact::Components::Fee.create(JSON.parse(fee_json))
  			retrieved = @api.get_event_fee('token', event, fee)
  			retrieved.should be_kind_of(ConstantContact::Components::Fee)
  		end
    end
  
  	describe "#add_fee" do
  		it "adds an event fee" do
  			event_json = load_json('event.json')
        fee_json = load_json('fee.json')
			
        net_http_resp = Net::HTTPResponse.new(1.0, 201, 'Created')
  			response = RestClient::Response.create(fee_json, net_http_resp, {})
  			RestClient.stub(:post).and_return(response)

  			event = ConstantContact::Components::Event.create(JSON.parse(event_json))
        fee   = ConstantContact::Components::Fee.create(JSON.parse(fee_json))
  			added = @api.add_event_fee('token', event, fee)
  			added.should be_kind_of(ConstantContact::Components::Fee)
        added.id.should_not be_empty
  		end
    end
  
  	describe "#update_fee" do
  		it "updates an event fee" do
  			event_json = load_json('event.json')
        fee_json = load_json('fee.json')
  			hash = JSON.parse fee_json
        hash['fee'] += 1
      
        net_http_resp = Net::HTTPResponse.new(1.0, 201, 'Created')
  			response = RestClient::Response.create(hash.to_json, net_http_resp, {})
  			RestClient.stub(:put).and_return(response)

  			event = ConstantContact::Components::Event.create(JSON.parse(event_json))
        fee   = ConstantContact::Components::Fee.create(JSON.parse(fee_json))
  			updated = @api.update_event_fee('token', event, fee)
  			updated.should be_kind_of(ConstantContact::Components::Fee)
        updated.fee.should_not eq(fee.fee)
        updated.fee.should eq(fee.fee + 1)
  		end
    end
  
  	describe "#delete_fee" do
  		it "deletes an event fee" do
  			event_json = load_json('event.json')
        fee_json = load_json('fees.json')
			
        net_http_resp = Net::HTTPResponse.new(1.0, 204, 'No Content')
  			response = RestClient::Response.create('', net_http_resp, {})
  			RestClient.stub(:delete).and_return(response)

  			event = ConstantContact::Components::Event.create(JSON.parse(event_json))
        fee   = ConstantContact::Components::Fee.create(JSON.parse(fee_json))
  			@api.delete_event_fee('token', event, fee).should be_true
  		end
    end
  
  	describe "#get_registrants" do
  		it "returns an array of event registrants" do
  			event_json = load_json('event.json')
        registrants_json = load_json('registrants.json')
      
        net_http_resp = Net::HTTPResponse.new(1.0, 201, 'Created')
  			response = RestClient::Response.create(registrants_json, net_http_resp, {})
  			RestClient.stub(:get).and_return(response)

  			event = ConstantContact::Components::Event.create(JSON.parse(event_json))
        registrants = @api.get_event_registrants('token', event)
        registrants.should be_kind_of(ConstantContact::Components::ResultSet)
  			registrants.results.collect{|r| r .should be_kind_of(ConstantContact::Components::Registrant) }
  		end
    end
  
  	describe "#get_registrant" do
  		it "returns an event registrant" do
  			event_json = load_json('event.json')
        registrant_json = load_json('registrant.json')
			
        net_http_resp = Net::HTTPResponse.new(1.0, 201, 'Created')
  			response = RestClient::Response.create(registrant_json, net_http_resp, {})
  			RestClient.stub(:get).and_return(response)

  			event = ConstantContact::Components::Event.create(JSON.parse(event_json))
        registrant = ConstantContact::Components::Registrant.create(JSON.parse(registrant_json))
        retrieved = @api.get_event_registrant('token', event, registrant)
  			retrieved.should be_kind_of(ConstantContact::Components::Registrant)
  		  retrieved.id.should_not be_empty
  		end
    end
  end
end