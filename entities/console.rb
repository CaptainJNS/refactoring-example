module Console
  include Validation

  OPERATION_HASH = {
    'withdraw' => I18n.t(:withdraw_money),
    'put' => I18n.t(:put_money)
  }.freeze

  def input(*messages)
    messages.each { |message| puts message }

    gets.chomp
  end

  def start
    input(I18n.t(:greeting), I18n.t(:exit))
  end

  def name_input
    loop do
      name = input(I18n.t(:enter_name))
      next puts I18n.t(:wrong_name) if wrong_name?(name)

      break name
    end
  end

  def login_input(existing_logins = nil)
    loop do
      login = input(I18n.t(:enter_login))
      next puts(I18n.t(:login_present), I18n.t(:login_longer), I18n.t(:login_shorter)) if wrong_login?(login)

      next puts I18n.t(:login_exist) if existing_logins && login_exist?(login, existing_logins)

      break login
    end
  end

  def password_input
    loop do
      password = input(I18n.t(:enter_password))
      next puts(I18n.t(:password_present), I18n.t(:password_longer), I18n.t(:password_shorter)) if wrong_password?(password)

      break password
    end
  end

  def age_input
    loop do
      age = input(I18n.t(:enter_age))
      next puts(I18n.t(:wrong_age)) if wrong_age?(age)

      break age
    end
  end

  def sign_in
    [login_input, password_input]
  end

  def main_choices(name)
    input(I18n.t(:welcome, name: name), I18n.t(:main_choices), I18n.t(:exit))
  end

  def money_amount(operation)
    loop do
      user_input = input(OPERATION_HASH[operation]).to_i
      next puts I18n.t(:correct_amount) unless user_input.positive?

      break user_input
    end
  end

  def choice_is_yes?(message)
    input(message) == 'y'
  end

  def card_destroy?(cards)
    puts I18n.t(:delete)
    card = choose_card(cards)
    return unless card

    choice_is_yes?(I18n.t(:sure_delete, card: cards[card.pred].number)) && card
    # puts I18n.t(:sure_delete, card: cards[card - 1].number)
    # gets.chomp == 'y' && card
  end

  def create_card_choices
    loop do
      choice = input(I18n.t(:create_card), I18n.t(:exit))

      next puts I18n.t(:wrong_card_type) unless check_card_type(choice)

      break choice
    end
  end

  def cards_show(cards)
    return puts I18n.t(:no_cards) if cards.none?

    cards.each { |card| puts "- #{card.number}, #{card.type}" }
  end

  def choose_card(cards)
    loop do
      cards_list(cards)

      user_input = input(I18n.t(:exit))
      break false if user_input == 'exit'

      card = user_input.to_i
      next puts I18n.t(:wrong_card) unless card.between?(1, cards.length)

      break card
    end
  end

  def cards_list(cards)
    cards.each_with_index { |card, index| puts "- #{card.number}, #{card.type}, press #{index.next}" }
  end
end
