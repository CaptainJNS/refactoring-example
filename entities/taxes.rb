module Taxes
  CARDS_HASH = {
    I18n.t(:usual) => [0.05, 0.02, 20],
    I18n.t(:capitalist) => [0.04, 10, 0.1],
    I18n.t(:virtual) => [0.88, 1, 1]
  }.freeze

  def withdraw_put_tax(operation, type, amount)
    return amount * CARDS_HASH[type][0] if operation == 'withdraw'

    CARDS_HASH[type][1] * (type == I18n.t(:usual) ? amount : 1)
  end

  def sender_tax(type, amount)
    CARDS_HASH[type][2] * (type == I18n.t(:capitalist) ? amount : 1)
  end
end
