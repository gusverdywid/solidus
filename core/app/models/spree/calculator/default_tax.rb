require_dependency 'spree/calculator'

module Spree
  class Calculator::DefaultTax < Calculator
    def self.description
      Spree.t(:default_tax)
    end

    def compute(computable)
      case computable
        when Spree::Shipment
          compute_shipment(computable)
        when Spree::LineItem
          compute_line_item(computable)
      end
    end


    private

      def rate
        self.calculable
      end

      def compute_shipment(shipment)
        round_to_two_places(shipment.discounted_cost * rate.amount)
      end

      def compute_line_item(line_item)
        if line_item.tax_category == rate.tax_category
          if rate.included_in_price
            deduced_total_by_rate(line_item.discounted_amount, rate)
          else
            round_to_two_places(line_item.discounted_amount * rate.amount)
          end
        else
          0
        end
      end

      def round_to_two_places(amount)
        BigDecimal.new(amount.to_s).round(2, BigDecimal::ROUND_HALF_UP)
      end

      def deduced_total_by_rate(total, rate)
        round_to_two_places(total - ( total / (1 + rate.amount) ) )
      end

  end
end
