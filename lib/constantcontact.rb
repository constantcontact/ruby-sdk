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
		autoload :Campaign, "constantcontact/components/campaigns/campaign"
		autoload :Address, "constantcontact/components/contacts/address"
		autoload :Contact, "constantcontact/components/contacts/contact"
		autoload :ContactList, "constantcontact/components/contacts/contact_list"
		autoload :CustomField, "constantcontact/components/contacts/custom_field"
		autoload :EmailAddress, "constantcontact/components/contacts/email_address"
	end

	module Exceptions
		autoload :CtctException, "constantcontact/exceptions/ctct_exception"
		autoload :IllegalArgumentException, "constantcontact/exceptions/illegal_argument_exception"
		autoload :OAuth2Exception, "constantcontact/exceptions/oauth2_exception"
	end

	module Services
		autoload :BaseService, "constantcontact/services/base_service"
		autoload :CampaignService, "constantcontact/services/campaign_service"
		autoload :ContactService, "constantcontact/services/contact_service"
		autoload :ListService, "constantcontact/services/list_service"
	end

	module Util
		autoload :Config, "constantcontact/util/config"
		autoload :Helpers, "constantcontact/util/helpers"
	end
end