#
# export_contacts.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
	module Components
		class ExportContacts < Component
			attr_accessor :file_type, :sort_by, :export_date_added,
										:export_added_by, :lists, :column_names


			# Constructor to create an ExportContacts object
			# @param [Array] lists - array of lists ids
			# @return [ExportContacts]
			def initialize(lists = nil)
				if !lists.nil?
					@lists = lists
				end
				@file_type = 'CSV'
				@sort_by = 'EMAIL_ADDRESS'
				@export_date_added = true
				@export_added_by = true
				@column_names = ['Email Address', 'First Name', 'Last Name']
			end

		end
	end
end