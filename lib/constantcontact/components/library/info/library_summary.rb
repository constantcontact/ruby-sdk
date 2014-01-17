#
# library_summary.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Components
    class LibrarySummary < Component
      attr_accessor :max_free_file_num, :max_premium_space_limit, :max_upload_size_limit, :image_root, :usage_summary

      # Factory method to create a LibrarySummary object from a json string
      # @param [Hash] props - properties to create object from
      # @return [LibrarySummary]
      def self.create(props)
        obj = LibrarySummary.new
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