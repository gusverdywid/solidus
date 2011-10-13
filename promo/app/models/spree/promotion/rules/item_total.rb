# A rule to limit a promotion to a specific user.
class Spree::Promotion::Rules::ItemTotal < Spree::PromotionRule
  preference :amount, :decimal, :default => 100.00
  preference :operator, :string, :default => '>'

  OPERATORS = ['gt', 'gte']

  def eligible?(order, options = {})
    item_total = order.line_items.map(&:amount).sum
    item_total.send(preferred_operator == 'gte' ? :>= : :>, preferred_amount)
  end
end
