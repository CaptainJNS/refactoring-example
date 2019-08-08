module Taxes
  WITHDRAW_TAX = {
    I18n.t(:usual) => 0.05,
    I18n.t(:capitalist) => 0.04,
    I18n.t(:virtual) => 0.88
  }.freeze

  PUT_TAX = {
    I18n.t(:usual) => 0.02,
    I18n.t(:capitalist) => 10,
    I18n.t(:virtual) => 1
  }.freeze

  def withdraw_put_tax(operation, type, amount)
    return amount * WITHDRAW_TAX[type] if operation == 'withdraw'

    return PUT_TAX[type] * amount if type == I18n.t(:usual)

    PUT_TAX[type]
  end
end
