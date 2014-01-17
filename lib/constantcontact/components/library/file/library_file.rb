#
# library_file.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Components
    class LibraryFile < Component
      attr_accessor :created_date, :description, :file_type, :folder, :folder_id, :height, :id, :is_image,
                    :modified_date, :name, :size, :source, :status, :thumbnail, :url, :width, :type

      # Factory method to create a LibraryFile object from a json string
      # @param [Hash] props - properties to create object from
      # @return [LibraryFile]
      def self.create(props)
        obj = LibraryFile.new
        if props
          props.each do |key, value|
            obj.send("#{key}=", value) if obj.respond_to?("#{key}=")
          end
        end
        obj
      end
    end
  end
end