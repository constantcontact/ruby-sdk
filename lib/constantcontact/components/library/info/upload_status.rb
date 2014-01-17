#
# upload_status.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Components
    class UploadStatus < Component
      attr_accessor :status, :description, :file_id

      # Factory method to create an UploadStatus object from a json string
      # @param [Hash] props - properties to create object from
      # @return [UploadStatus]
      def self.create(props)
        obj = UploadStatus.new
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