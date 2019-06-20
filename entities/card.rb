class Card
  CARDS_HASH = {
    'usual' => 50,
    'capitalist' => 100,
    'virtual' => 150
  }.freeze

  attr_accessor :type, :number, :balance

  def initialize(type, number, balance = CARDS_HASH[type])
    @type = type
    @number = number
    @balance = balance
  end
end
