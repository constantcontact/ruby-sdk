#
# constantcontact.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

require 'rubygems'
require 'rest_client'
require 'json'
require 'cgi'
require 'cgi/session'
require 'cgi/session/pstore'


module ConstantContact
	autoload :Api, "constantcontact/api"

	module Auth
		autoload :OAuth2, "constantcontact/auth/oauth2"
		autoload :Session, "constantcontact/auth/session_data_store"
	end

	module Components
		autoload :Component, "constantcontact/components/component"
		autoload :ResultSet, "constantcontact/components/result_set"
		autoload :Activity, "constantcontact/components/activities/activity"
		autoload :ActivityError, "constantcontact/components/activities/activity_error"
		autoload :AddContacts, "constantcontact/components/activities/add_contacts"
		autoload :AddContactsImportData, "constantcontact/components/activities/add_contacts_import_data"
		autoload :ExportContacts, "constantcontact/components/activities/export_contacts"
		autoload :Address, "constantcontact/components/contacts/address"
		autoload :Contact, "constantcontact/components/contacts/contact"
		autoload :ContactList, "constantcontact/components/contacts/contact_list"
		autoload :CustomField, "constantcontact/components/contacts/custom_field"
		autoload :EmailAddress, "constantcontact/components/contacts/email_address"
		autoload :Note, "constantcontact/components/contacts/note"
		autoload :ClickThroughDetails, "constantcontact/components/email_campaigns/click_through_details"
		autoload :EmailCampaign, "constantcontact/components/email_campaigns/email_campaign"
		autoload :MessageFooter, "constantcontact/components/email_campaigns/message_footer"
		autoload :Schedule, "constantcontact/components/email_campaigns/schedule"
		autoload :TestSend, "constantcontact/components/email_campaigns/test_send"
		autoload :BounceActivity, "constantcontact/components/tracking/bounce_activity"
		autoload :ClickActivity, "constantcontact/components/tracking/click_activity"
		autoload :ForwardActivity, "constantcontact/components/tracking/forward_activity"
		autoload :OpenActivity, "constantcontact/components/tracking/open_activity"
		autoload :OptOutActivity, "constantcontact/components/tracking/opt_out_activity"
		autoload :SendActivity, "constantcontact/components/tracking/send_activity"
		autoload :TrackingActivity, "constantcontact/components/tracking/tracking_activity"
		autoload :TrackingSummary, "constantcontact/components/tracking/tracking_summary"
	end

	module Exceptions
		autoload :CtctException, "constantcontact/exceptions/ctct_exception"
		autoload :IllegalArgumentException, "constantcontact/exceptions/illegal_argument_exception"
		autoload :OAuth2Exception, "constantcontact/exceptions/oauth2_exception"
	end

	module Services
		autoload :BaseService, "constantcontact/services/base_service"
		autoload :ActivityService, "constantcontact/services/activity_service"
		autoload :CampaignScheduleService, "constantcontact/services/campaign_schedule_service"
		autoload :CampaignTrackingService, "constantcontact/services/campaign_tracking_service"
		autoload :ContactService, "constantcontact/services/contact_service"
		autoload :ContactTrackingService, "constantcontact/services/contact_tracking_service"
		autoload :EmailCampaignService, "constantcontact/services/email_campaign_service"
		autoload :ListService, "constantcontact/services/list_service"
		autoload :EmailAddressService, "constantcontact/services/email_address_service"
	end

	module Util
		autoload :Config, "constantcontact/util/config"
		autoload :Helpers, "constantcontact/util/helpers"
	end
end