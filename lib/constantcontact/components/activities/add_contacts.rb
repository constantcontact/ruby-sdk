#
# add_contacts.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Components
    class AddContacts < Component
      attr_accessor :import_data, :lists, :column_names

      # Constructor to create an AddContacts object from the given contacts and contact lists
      # @param [Array<Contact>] contacts - contacts array
      # @param [Array<ContactList>] lists - contact lists array]
      # @param [Array<String>] column_names - array of column names
      # @return [AddContacts]
      def initialize(contacts, lists, column_names = [])
        if !contacts.empty?
          if contacts[0].instance_of?(Components::AddContactsImportData)
            @import_data = contacts
          else
            raise Exceptions::IllegalArgumentException, sprintf(Util::Config.get('errors.id_or_object'), 'AddContactsImportData')
          end
        end

        @lists = lists
        @column_names = column_names

        # attempt to determine the column names being used if they are not provided
        if column_names.empty?
          used_columns = [Util::Config.get('activities_columns.email')]

          contacts.each do |contact|

            if !contact.first_name.nil?
              used_columns << Util::Config.get('activities_columns.first_name')
            end

            if !contact.middle_name.nil?
              used_columns << Util::Config.get('activities_columns.middle_name')
            end

            if !contact.last_name.nil?
              used_columns << Util::Config.get('activities_columns.last_name')
            end

            if !contact.birthday_day.nil?
              used_columns << Util::Config.get('activities_columns.birthday_day')
            end

            if !contact.birthday_month.nil?
              used_columns << Util::Config.get('activities_columns.birthday_month')
            end

            if !contact.anniversary.nil?
              used_columns << Util::Config.get('activities_columns.anniversary')
            end

            if !contact.job_title.nil?
              used_columns << Util::Config.get('activities_columns.job_title')
            end

            if !contact.company_name.nil?
              used_columns << Util::Config.get('activities_columns.company_name')
            end

            if !contact.work_phone.nil?
              used_columns << Util::Config.get('activities_columns.work_phone')
            end

            if !contact.home_phone.nil?
              used_columns << Util::Config.get('activities_columns.home_phone')
            end

            contact.addresses.each do |address|

              if !address.line1.nil?
                used_columns << Util::Config.get('activities_columns.address1')
              end

              if !address.line2.nil?
                used_columns << Util::Config.get('activities_columns.address2')
              end

              if !address.line3.nil?
                used_columns << Util::Config.get('activities_columns.address3')
              end

              if !address.city.nil?
                used_columns << Util::Config.get('activities_columns.city')
              end

              if !address.state_code.nil? || !address.state.nil?
                used_columns << Util::Config.get('activities_columns.state')
              end

              if !address.country_code.nil?
                used_columns << Util::Config.get('activities_columns.country')
              end

              if !address.postal_code.nil?
                used_columns << Util::Config.get('activities_columns.postal_code')
              end

              if !address.sub_postal_code.nil?
                used_columns << Util::Config.get('activities_columns.sub_postal_code')
              end
            end

            # Custom Fields
            if !contact.custom_fields.nil?
              contact.custom_fields.each do |custom_field|
                if custom_field.name.match('custom_field_')
                  custom_field_number = custom_field.name[13, custom_field.name.length]
                  used_columns << Util::Config.get('activities_columns.custom_field_' + custom_field_number)
                end
              end
            end
          end

          @column_names = used_columns.uniq
        end
      end

    end
  end
end