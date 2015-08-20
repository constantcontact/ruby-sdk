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
require 'openssl'
require 'base64'

module ConstantContact
  autoload :Api, 'constantcontact/api'
  autoload :WebhooksUtil, 'constantcontact/webhooks/webhooks_util'
  autoload :SDK, 'constantcontact/version'

  module Auth
    autoload :OAuth2, 'constantcontact/auth/oauth2'
    autoload :Session, 'constantcontact/auth/session_data_store'
  end

  module Components
    autoload :Component, 'constantcontact/components/component'
    autoload :ResultSet, 'constantcontact/components/result_set'
    autoload :Activity, 'constantcontact/components/activities/activity'
    autoload :ActivityError, 'constantcontact/components/activities/activity_error'
    autoload :AddContacts, 'constantcontact/components/activities/add_contacts'
    autoload :AddContactsImportData, 'constantcontact/components/activities/add_contacts_import_data'
    autoload :ExportContacts, 'constantcontact/components/activities/export_contacts'
    autoload :Address, 'constantcontact/components/contacts/address'
    autoload :Contact, 'constantcontact/components/contacts/contact'
    autoload :ContactList, 'constantcontact/components/contacts/contact_list'
    autoload :CustomField, 'constantcontact/components/contacts/custom_field'
    autoload :EmailAddress, 'constantcontact/components/contacts/email_address'
    autoload :Note, 'constantcontact/components/contacts/note'
    autoload :ClickThroughDetails, 'constantcontact/components/email_marketing/click_through_details'
    autoload :Campaign, 'constantcontact/components/email_marketing/campaign'
    autoload :CampaignPreview, 'constantcontact/components/email_marketing/campaign_preview'
    autoload :MessageFooter, 'constantcontact/components/email_marketing/message_footer'
    autoload :Schedule, 'constantcontact/components/email_marketing/schedule'
    autoload :TestSend, 'constantcontact/components/email_marketing/test_send'
    autoload :BounceActivity, 'constantcontact/components/tracking/bounce_activity'
    autoload :ClickActivity, 'constantcontact/components/tracking/click_activity'
    autoload :ForwardActivity, 'constantcontact/components/tracking/forward_activity'
    autoload :OpenActivity, 'constantcontact/components/tracking/open_activity'
    autoload :UnsubscribeActivity, 'constantcontact/components/tracking/unsubscribe_activity'
    autoload :SendActivity, 'constantcontact/components/tracking/send_activity'
    autoload :TrackingActivity, 'constantcontact/components/tracking/tracking_activity'
    autoload :TrackingSummary, 'constantcontact/components/tracking/tracking_summary'
    autoload :VerifiedEmailAddress, 'constantcontact/components/account/verified_email_address'
    autoload :AccountInfo, 'constantcontact/components/account/account_info'
    autoload :AccountAddress, 'constantcontact/components/account/account_address'
    autoload :Event, 'constantcontact/components/event_spot/event'
    autoload :EventFee, 'constantcontact/components/event_spot/event_fee'
    autoload :Registrant, 'constantcontact/components/event_spot/registrant'
    autoload :EventItem, 'constantcontact/components/event_spot/event_item'
    autoload :EventItemAttribute, 'constantcontact/components/event_spot/event_item_attribute'
    autoload :Promocode, 'constantcontact/components/event_spot/promocode'
    autoload :LibrarySummary, 'constantcontact/components/library/info/library_summary'
    autoload :UploadStatus, 'constantcontact/components/library/info/upload_status'
    autoload :MoveResults, 'constantcontact/components/library/info/move_results'
    autoload :LibraryFolder, 'constantcontact/components/library/folder/library_folder'
    autoload :LibraryFile, 'constantcontact/components/library/file/library_file'

    module EventSpot
      autoload :EventAddress, 'constantcontact/components/event_spot/event_address'
      autoload :Contact, 'constantcontact/components/event_spot/contact'
      autoload :NotificationOption, 'constantcontact/components/event_spot/notification_option'
      autoload :OnlineMeeting, 'constantcontact/components/event_spot/online_meeting'
      autoload :PaymentAddress, 'constantcontact/components/event_spot/payment_address'
      autoload :PaymentSummary, 'constantcontact/components/event_spot/payment_summary'
      autoload :Guest, 'constantcontact/components/event_spot/guest'
      autoload :GuestSection, 'constantcontact/components/event_spot/guest_section'
      autoload :EventTrack, 'constantcontact/components/event_spot/event_track'
      autoload :RegistrantFee, 'constantcontact/components/event_spot/registrant_fee'
      autoload :RegistrantField, 'constantcontact/components/event_spot/registrant_field'
      autoload :RegistrantOrder, 'constantcontact/components/event_spot/registrant_order'
      autoload :RegistrantPromoCode, 'constantcontact/components/event_spot/registrant_promo_code'
      autoload :RegistrantPromoCodeInfo, 'constantcontact/components/event_spot/registrant_promo_code_info'
      autoload :RegistrantSection, 'constantcontact/components/event_spot/registrant_section'
      autoload :SaleItem, 'constantcontact/components/event_spot/sale_item'
    end
  end

  module Exceptions
    autoload :CtctException, 'constantcontact/exceptions/ctct_exception'
    autoload :IllegalArgumentException, 'constantcontact/exceptions/illegal_argument_exception'
    autoload :OAuth2Exception, 'constantcontact/exceptions/oauth2_exception'
    autoload :WebhooksException, 'constantcontact/exceptions/webhooks_exception'
  end

  module Services
    autoload :BaseService, 'constantcontact/services/base_service'
    autoload :ActivityService, 'constantcontact/services/activity_service'
    autoload :CampaignScheduleService, 'constantcontact/services/campaign_schedule_service'
    autoload :CampaignTrackingService, 'constantcontact/services/campaign_tracking_service'
    autoload :ContactService, 'constantcontact/services/contact_service'
    autoload :ContactTrackingService, 'constantcontact/services/contact_tracking_service'
    autoload :EmailMarketingService, 'constantcontact/services/email_marketing_service'
    autoload :ListService, 'constantcontact/services/list_service'
    autoload :AccountService, 'constantcontact/services/account_service'
    autoload :EventSpotService, 'constantcontact/services/event_spot_service'
    autoload :LibraryService, 'constantcontact/services/library_service'
  end

  module Util
    autoload :Config, 'constantcontact/util/config'
    autoload :Helpers, 'constantcontact/util/helpers'
  end

  module Webhooks
    module Helpers
      autoload :Validator, 'constantcontact/webhooks/helpers/validator'
    end

    module Models
      autoload :BillingChangeNotification, 'constantcontact/webhooks/models/billing_change_notification'
    end
  end
end
