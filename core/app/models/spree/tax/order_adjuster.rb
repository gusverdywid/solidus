module Spree
  module Tax
    # Add tax adjustments to all line items and shipments in an order
    class OrderAdjuster
      attr_reader :order

      include TaxHelpers

      # @param [Spree::Order] order to be adjusted
      def initialize(order)
        @order = order
      end

      # Creates tax adjustments for all taxable items (shipments and line items)
      # in the given order.
      def adjust!
        return unless order_tax_zone(order)

        [order, *order.line_items, *order.shipments].each do |item|
          item.adjustments.tax.destroy_all
        end

        (order.line_items + order.shipments).each do |item|
          ItemAdjuster.new(item, order_wide_options).adjust!
        end
      end

      private

      def order_wide_options
        {
          rates_for_order_zone: rates_for_order_zone(order),
          rates_for_default_zone: rates_for_default_zone,
          order_tax_zone: order_tax_zone(order),
          skip_destroy_adjustments: true
        }
      end
    end
  end
end
