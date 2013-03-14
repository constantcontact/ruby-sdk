#
# contact_tracking_service.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
	module Services
		class ContactTrackingService < BaseService
			class << self

				# Get a result set of bounces for a given contact
				# @param [String] access_token - Constant Contact OAuth2 access token
				# @param [String] contact_id - Contact id
				# @param [String] param - query param to be appended to request
				# @return [ResultSet<BounceActivity>] - Containing a results array of BounceActivity
				def get_bounces(access_token, contact_id, param = nil)
					url = Util::Config.get('endpoints.base_url') +
								sprintf(Util::Config.get('endpoints.contact_tracking_bounces'), contact_id)
					url += param if param

					response = RestClient.get(url, get_headers(access_token))
					body = JSON.parse(response.body)

					bounces = []
					body['results'].each do |bounce_activity|
						bounces << Components::BounceActivity.create(bounce_activity)
					end

					Components::ResultSet.new(bounces, body['meta'])
				end


				# Get clicks for a given contact
				# @param [String] access_token - Constant Contact OAuth2 access token
				# @param [String] contact_id - Contact id
				# @param [String] param - query param to be appended to request
				# @return [ResultSet<ClickActivity>] - Containing a results array of ClickActivity
				def get_clicks(access_token, contact_id, param = nil)
					url = Util::Config.get('endpoints.base_url') +
								sprintf(Util::Config.get('endpoints.contact_tracking_clicks'), contact_id)
					url += param if param

					response = RestClient.get(url, get_headers(access_token))
					body = JSON.parse(response.body)

					clicks = []
					body['results'].each do |click_activity|
						clicks << Components::ClickActivity.create(click_activity)
					end

					Components::ResultSet.new(clicks, body['meta'])
				end


				# Get forwards for a given contact
				# @param [String] access_token - Constant Contact OAuth2 access token
				# @param [String] contact_id - Contact id
				# @param [String] param - query param to be appended to request
				# @return [ResultSet<ForwardActivity>] - Containing a results array of ForwardActivity
				def get_forwards(access_token, contact_id, param = nil)
					url = Util::Config.get('endpoints.base_url') +
								sprintf(Util::Config.get('endpoints.contact_tracking_forwards'), contact_id)
					url += param if param

					response = RestClient.get(url, get_headers(access_token))
					body = JSON.parse(response.body)

					forwards = []
					body['results'].each do |forward_activity|
						forwards << Components::ForwardActivity.create(forward_activity)
					end

					Components::ResultSet.new(forwards, body['meta'])
				end


				# Get opens for a given contact
				# @param [String] access_token - Constant Contact OAuth2 access token
				# @param [String] contact_id - Contact id
				# @param [String] param - query param to be appended to request
				# @return [ResultSet<OpenActivity>] - Containing a results array of OpenActivity
				def get_opens(access_token, contact_id, param = nil)
					url = Util::Config.get('endpoints.base_url') +
								sprintf(Util::Config.get('endpoints.contact_tracking_opens'), contact_id)
					url += param if param

					response = RestClient.get(url, get_headers(access_token))
					body = JSON.parse(response.body)

					opens = []
					body['results'].each do |open_activity|
						opens << Components::OpenActivity.create(open_activity)
					end

					Components::ResultSet.new(opens, body['meta'])
				end


				# Get sends for a given contact
				# @param [String] access_token - Constant Contact OAuth2 access token
				# @param [String] contact_id - Contact id
				# @param [String] param - query param to be appended to request
				# @return [ResultSet<SendActivity>] - Containing a results array of SendActivity
				def get_sends(access_token, contact_id, param = nil)
					url = Util::Config.get('endpoints.base_url') +
								sprintf(Util::Config.get('endpoints.contact_tracking_sends'), contact_id)
					url += param if param

					response = RestClient.get(url, get_headers(access_token))
					body = JSON.parse(response.body)

					sends = []
					body['results'].each do |send_activity|
						sends << Components::SendActivity.create(send_activity)
					end

					Components::ResultSet.new(sends, body['meta'])
				end


				# Get opt outs for a given contact
				# @param [String] access_token - Constant Contact OAuth2 access token
				# @param [String] contact_id - Contact id
				# @param [String] param - query param to be appended to request
				# @return [ResultSet<OptOutActivity>] - Containing a results array of OptOutActivity
				def get_opt_outs(access_token, contact_id, param = nil)
					url = Util::Config.get('endpoints.base_url') +
								sprintf(Util::Config.get('endpoints.contact_tracking_unsubscribes'), contact_id)
					url += param if param

					response = RestClient.get(url, get_headers(access_token))
					body = JSON.parse(response.body)

					opt_outs = []
					body['results'].each do |opt_out_activity|
						opt_outs << Components::OptOutActivity.create(opt_out_activity)
					end

					Components::ResultSet.new(opt_outs, body['meta'])
				end


				# Get a summary of reporting data for a given contact
				# @param [String] access_token - Constant Contact OAuth2 access token
				# @param [Integer] contact_id - Contact id
				# @return [TrackingSummary]
				def get_summary(access_token, contact_id)
					url = Util::Config.get('endpoints.base_url') +
								sprintf(Util::Config.get('endpoints.contact_tracking_summary'), contact_id)
					response = RestClient.get(url, get_headers(access_token))
					Components::TrackingSummary.create(JSON.parse(response.body))
				end

			end
		end
	end
end