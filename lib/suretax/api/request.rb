require 'suretax/api/request_validator'

module Suretax
  module Api
    class Request

      attr_accessor :business_unit,
                    :client_number,
                    :client_tracking,
                    :data_month,
                    :data_year,
                    :industry_exemption,
                    :response_group,
                    :response_type,
                    :return_file_code,
                    :total_revenue,
                    :validation_key,
                    :items

      def initialize(args = {})
        @return_file_code = '0'
        args.each_pair do |key,value|
          self.send("#{key.to_s}=",value)
        end
        @items = []
        if args[:items].respond_to?(:each)
          args[:items].each do |item_args|
            @items << RequestItem.new(item_args)
          end
        end
      end

      def valid?
        RequestValidator.valid?(self)
      end

      def params
        {
          "BusinessUnit"             => business_unit,
          "ClientNumber"             => client_number,
          "ClientTracking"           => client_tracking,
          "DataMonth"                => data_month,
          "DataYear"                 => data_year,
          "IndustryExemption"        => industry_exemption,
          "ItemList"                 => items.map { |item| item.params },
          "ResponseGroup"            => response_group,
          "ResponseType"             => response_type,
          "ReturnFileCode"           => return_file_code,
          "TotalRevenue"             => total_revenue,
          "ValidationKey"            => validation_key
        }
      end

    end
  end
end
