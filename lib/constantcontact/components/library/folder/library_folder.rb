#
# library_folder.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Components
    class LibraryFolder < Component
      attr_accessor :created_date, :id, :item_count, :level, :modified_date, :name, :parent_id, :children

      # Factory method to create a LibraryFolder object from a json string
      # @param [Hash] props - properties to create object from
      # @return [LibraryFolder]
      def self.create(props)
        obj = LibraryFolder.new
        if props
          props.each do |key, value|
            obj.send("#{key}=", value) if obj.respond_to?(key)
          end
        end
        obj
      end
    end
  end
end