#
# campaign_schedule_service.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Services
    class CampaignScheduleService < BaseService

      # Create a new schedule for a campaign
      # @param [Integer] campaign_id - Campaign id to be scheduled
      # @param [Schedule] schedule - Schedule to be created
      # @return [Schedule]
      def add_schedule(campaign_id, schedule)
        url = Util::Config.get('endpoints.base_url') +
              sprintf(Util::Config.get('endpoints.campaign_schedules'), campaign_id)
        url = build_url(url)
        payload = schedule.to_json
        response = RestClient.post(url, payload, get_headers())
        Components::Schedule.create(JSON.parse(response.body))
      end


      # Get a list of schedules for a campaign
      # @param [Integer] campaign_id - Campaign id to be scheduled
      # @return [Array<Schedule>]
      def get_schedules(campaign_id)
        url = Util::Config.get('endpoints.base_url') +
              sprintf(Util::Config.get('endpoints.campaign_schedules'), campaign_id)
        url = build_url(url)
        response = RestClient.get(url, get_headers())
        body = JSON.parse(response.body)

        schedules = []
        body.each do |schedule|
          schedules << Components::Schedule.create(schedule)
        end

        schedules
      end


      # Get a specific schedule for a campaign
      # @param [Integer] campaign_id - Campaign id to get a schedule for
      # @param [Integer] schedule_id - Schedule id to retrieve
      # @return [Schedule]
      def get_schedule(campaign_id, schedule_id)
        url = Util::Config.get('endpoints.base_url') +
              sprintf(Util::Config.get('endpoints.campaign_schedule'), campaign_id, schedule_id)
        url = build_url(url)
        response = RestClient.get(url, get_headers())
        Components::Schedule.create(JSON.parse(response.body))
      end


      # Delete a specific schedule for a campaign
      # @param [Integer] campaign_id - Campaign id to delete a schedule for
      # @param [Integer] schedule_id - Schedule id to delete
      # @return [Boolean]
      def delete_schedule(campaign_id, schedule_id)
        url = Util::Config.get('endpoints.base_url') +
              sprintf(Util::Config.get('endpoints.campaign_schedule'), campaign_id, schedule_id)
        url = build_url(url)
        response = RestClient.delete(url, get_headers())
        response.code == 204
      end


      # Update a specific schedule for a campaign
      # @param [Integer] campaign_id - Campaign id to be scheduled
      # @param [Schedule] schedule - Schedule to retrieve
      # @return [Schedule]
      def update_schedule(campaign_id, schedule)
        url = Util::Config.get('endpoints.base_url') +
              sprintf(Util::Config.get('endpoints.campaign_schedule'), campaign_id, schedule.id)
        url = build_url(url)
        payload = schedule.to_json
        response = RestClient.put(url, payload, get_headers())
        Components::Schedule.create(JSON.parse(response.body))
      end


      # Send a test send of a campaign
      # @param [Integer] campaign_id - Id of campaign to send test of
      # @param [TestSend] test_send - Test send details
      # @return [TestSend]
      def send_test(campaign_id, test_send)
        url = Util::Config.get('endpoints.base_url') +
              sprintf(Util::Config.get('endpoints.campaign_test_sends'), campaign_id)
        url = build_url(url)
        payload = test_send.to_json
        response = RestClient.post(url, payload, get_headers())
        Components::TestSend.create(JSON.parse(response.body))
      end

    end
  end
end