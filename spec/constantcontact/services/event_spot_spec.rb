#
# event_spot_service_spec.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

require 'spec_helper'

describe ConstantContact::Services::EventSpotService do
	describe "#get_events" do
		it "returns an array of events" do
			json = load_json('events.json')
			net_http_resp = Net::HTTPResponse.new(1.0, 200, 'OK')

			response = RestClient::Response.create(json, net_http_resp, {})
			RestClient.stub(:get).and_return(response)
			events = ConstantContact::Services::EventSpotService.get_events('token')
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
			event = ConstantContact::Services::EventSpotService.get_event('token', 1)

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
			added = ConstantContact::Services::EventSpotService.add_event('token', event)

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
			ConstantContact::Services::EventSpotService.delete_event('token', event).should be_true
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
			updated = ConstantContact::Services::EventSpotService.publish_event('token', event)
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
			updated = ConstantContact::Services::EventSpotService.cancel_event('token', event)
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
			fees = ConstantContact::Services::EventSpotService.get_fees('token', event)
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
			retrieved = ConstantContact::Services::EventSpotService.get_fee('token', event, fee)
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
			added = ConstantContact::Services::EventSpotService.add_fee('token', event, fee)
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
			updated = ConstantContact::Services::EventSpotService.update_fee('token', event, fee)
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
			ConstantContact::Services::EventSpotService.delete_fee('token', event, fee).should be_true
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
      registrants = ConstantContact::Services::EventSpotService.get_registrants('token', event)
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
      retrieved = ConstantContact::Services::EventSpotService.get_registrant('token', event, registrant)
			retrieved.should be_kind_of(ConstantContact::Components::Registrant)
		  retrieved.id.should_not be_empty
		end
  end
end