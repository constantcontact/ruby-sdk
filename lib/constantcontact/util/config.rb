#
# config.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
	module Util
		class Config

			class << self

				# Return a hash of configuration strings
				# @return [Hash] - hash of configuration properties
				def props
					{
						# REST endpoints
						:endpoints => {
							:base_url      => 'https://api.constantcontact.com/v2/',
							:contact       => 'contacts/%s',
							:contacts      => 'contacts',
							:lists         => 'lists',
							:list          => 'lists/%s',
							:list_contacts => 'lists/%s/contacts',
							:contact_lists => 'contacts/%s/lists',
							:contact_list  => 'contacts/%s/lists/%s',
							:campaigns     => 'campaigns',
							:campaign_id   => 'campaigns/%s'
						},

						# OAuth2 Authorization related configuration options
						:auth => {
							:base_url                      => 'https://oauth2.constantcontact.com/oauth2/',
							:response_type_code            => 'code',
							:response_type_token           => 'token',
							:authorization_code_grant_type => 'authorization_code',
							:authorization_endpoint        => 'oauth/siteowner/authorize',
							:token_endpoint                => 'oauth/token'
						},

						# Errors to be returned for various exceptions
						:errors => {
							:contact_or_id => 'Only an interger or Contact are allowed for this method.',
							:list_or_id    => 'Only an interger or ContactList are allowed for this method.'
						}
					}
				end

				# Get a configuration property given a specified location, example usage: Config::get('auth.token_endpoint')
				# @param [String] index - location of the property to obtain
				# @return [String]
				def get(index)
					properties = index.split('.')
					get_value(properties, props)
				end

				private

				# Navigate through a config array looking for a particular index
				# @param [Array] index The index sequence we are navigating down
				# @param [Hash, String] value The portion of the config array to process
				# @return [String]
				def get_value(index, value)
					index = index.is_a?(Array) ? index : [index]
					key = index.shift.to_sym
					value.is_a?(Hash) and value[key] and value[key].is_a?(Hash) ?
					get_value(index, value[key]) :
					value[key]
				end
			end

		end
	end
end