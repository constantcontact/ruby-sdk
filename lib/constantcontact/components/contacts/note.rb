#
# note.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Components
    class Note < Component
      attr_accessor :id, :note, :created_date, :modified_date

      # Factory method to create a Note object from a json string
      # @param [String] props - properties to create object from
      # @return Note
      def self.create(props)
        note = Note.new
        if props
          props.each do |key, value|
            note.send("#{key}=", value)
          end
        end
        note
      end
    end
  end
end
