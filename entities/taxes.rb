module Taxes
  CARDS_HASH = {
    'usual' => [0.05, 0.02, 20],
    'capitalist' => [0.04, 10, 0.1],
    'virtual' => [0.88, 1, 1]
  }.freeze

  def withdraw_tax(type, amount)
    amount * CARDS_HASH[type][0]
  end

  def put_tax(type, amount)
    CARDS_HASH[type][1] * (type == 'usual' ? amount : 1)
  end

  def sender_tax(type, amount)
    CARDS_HASH[type][2] * (type == 'capitalist' ? amount : 1)
  end
end
