#
# campaign_schedule_service.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
	module Services
		class CampaignScheduleService < BaseService
			class << self

				# Create a new schedule for a campaign
				# @param [String] access_token - Constant Contact OAuth2 access token
				# @param [Integer] campaign_id - Campaign id to be scheduled
				# @param [Schedule] schedule - Schedule to be created
				# @return [Schedule]
				def add_schedule(access_token, campaign_id, schedule)
					url = Util::Config.get('endpoints.base_url') + 
								sprintf(Util::Config.get('endpoints.campaign_schedules'), campaign_id)
					payload = schedule.to_json
					response = RestClient.post(url, payload, get_headers(access_token))
					Components::Schedule.create(JSON.parse(response.body))
				end


				# Get a list of schedules for a campaign
				# @param [String] access_token - Constant Contact OAuth2 access token
				# @param [Integer] campaign_id - Campaign id to be scheduled
				# @return [Array<Schedule>]
				def get_schedules(access_token, campaign_id)
					url = Util::Config.get('endpoints.base_url') + 
								sprintf(Util::Config.get('endpoints.campaign_schedules'), campaign_id)

					response = RestClient.get(url, get_headers(access_token))
					body = JSON.parse(response.body)

					schedules = []
					body.each do |schedule|
						schedules << Components::Schedule.create(schedule)
					end

					schedules
				end


				# Get a specific schedule for a campaign
				# @param [String] access_token - Constant Contact OAuth2 access token
				# @param [Integer] campaign_id - Campaign id to get a schedule for
				# @param [Integer] schedule_id - Schedule id to retrieve
				# @return [Schedule]
				def get_schedule(access_token, campaign_id, schedule_id)
					url = Util::Config.get('endpoints.base_url') + 
								sprintf(Util::Config.get('endpoints.campaign_schedule'), campaign_id, schedule_id)
					response = RestClient.get(url, get_headers(access_token))
					Components::Schedule.create(JSON.parse(response.body))
				end


				# Delete a specific schedule for a campaign
				# @param [String] access_token - Constant Contact OAuth2 access token
				# @param [Integer] campaign_id - Campaign id to delete a schedule for
				# @param [Integer] schedule_id - Schedule id to delete
				# @return [Boolean]
				def delete_schedule(access_token, campaign_id, schedule_id)
					url = Util::Config.get('endpoints.base_url') + 
								sprintf(Util::Config.get('endpoints.campaign_schedule'), campaign_id, schedule_id)
					response = RestClient.delete(url, get_headers(access_token))
					response.code == 204
				end


				# Update a specific schedule for a campaign
				# @param [String] access_token - Constant Contact OAuth2 access token
				# @param [Integer] campaign_id - Campaign id to be scheduled
				# @param [Schedule] schedule - Schedule to retrieve 
				# @return [Schedule]
				def update_schedule(access_token, campaign_id, schedule)
					url = Util::Config.get('endpoints.base_url') + 
								sprintf(Util::Config.get('endpoints.campaign_schedule'), campaign_id, schedule.id)
					payload = schedule.to_json
					response = RestClient.put(url, payload, get_headers(access_token))
					Components::Schedule.create(JSON.parse(response.body))
				end


				# Send a test send of a campaign
				# @param [String] access_token - Constant Contact OAuth2 access token
				# @param [Integer] campaign_id - Id of campaign to send test of
				# @param [TestSend] test_send - Test send details
				# @return [TestSend]
				def send_test(access_token, campaign_id, test_send)
					url = Util::Config.get('endpoints.base_url') + 
								sprintf(Util::Config.get('endpoints.campaign_test_sends'), campaign_id)
					payload = test_send.to_json
					response = RestClient.post(url, payload, get_headers(access_token))
					Components::TestSend.create(JSON.parse(response.body))
				end

			end
		end
	end
end