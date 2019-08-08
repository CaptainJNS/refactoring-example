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
    name = input(I18n.t(:enter_name))
    return name if valid_name?(name)

    puts I18n.t(:wrong_name)
    name_input
  end

  def login_input(existing_logins = [])
    login = input(I18n.t(:enter_login))
    return login if valid_login?(login) && !login_exist?(login, existing_logins)

    puts(I18n.t(:login_present), I18n.t(:login_longer), I18n.t(:login_shorter))
    puts I18n.t(:login_exist)
    login_input(existing_logins)
  end

  def password_input
    password = input(I18n.t(:enter_password))
    return password if valid_password?(password)

    puts(I18n.t(:password_present), I18n.t(:password_longer), I18n.t(:password_shorter))
    password_input
  end

  def age_input
    age = input(I18n.t(:enter_age))
    return age if valid_age?(age)

    puts(I18n.t(:wrong_age))
    age_input
  end

  def sign_in
    [login_input, password_input]
  end

  def main_choices(name)
    input(I18n.t(:welcome, name: name), I18n.t(:main_choices), I18n.t(:exit))
  end

  # def money_amount(operation)
  #   user_input = input(OPERATION_HASH[operation]).to_i
  #   return user_input if user_input.positive?

  #   puts I18n.t(:correct_amount)
  #   money_amount(operation)
  # end

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
  end

  def create_card_choices
    choice = input(I18n.t(:create_card), I18n.t(:exit))
    return choice if valid_card_type?(choice)

    puts I18n.t(:wrong_card_type)
    create_card_choices
  end

  def cards_show(cards)
    return puts I18n.t(:no_cards) if cards.none?

    cards.each { |card| puts "- #{card.number}, #{card.type}" }
  end

  def choose_card(cards)
    cards_list(cards)

    user_input = input(I18n.t(:exit))
    return if user_input == 'exit'

    card = user_input.to_i
    return card if card.between?(1, cards.length)

    puts I18n.t(:wrong_card) unless card.between?(1, cards.length)
    choose_card(cards)
  end

  def cards_list(cards)
    cards.each_with_index { |card, index| puts "- #{card.number}, #{card.type}, press #{index.next}" }
  end
end
