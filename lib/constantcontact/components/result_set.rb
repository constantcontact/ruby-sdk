#
# result_set.rb
# ConstantContact
#
# Copyright (c) 2013 Constant Contact. All rights reserved.

module ConstantContact
  module Components
    class ResultSet
      attr_accessor :results, :next


      # Constructor to create a ResultSet from the results/meta response when performing a get on a collection
      # @param [Array<Hash>] results - results array from request
      # @param [Hash] meta - meta hash from request
      def initialize(results, meta)
        @results = results

        if meta.has_key?('pagination') and meta['pagination'].has_key?('next_link')
          next_link = meta['pagination']['next_link']
          @next = next_link[next_link.index('?'), next_link.length]
        end
      end

    end
  end
end