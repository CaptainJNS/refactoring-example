module Console
  include Validation

  def start
    puts I18n.t(:greeting)
    puts I18n.t(:exit)

    gets.chomp
  end

  def name_input
    loop do
      puts puts I18n.t(:enter_name)
      name = gets.chomp
      next puts I18n.t(:wrong_name) unless check_name(name)

      break name
    end
  end

  def login_input(existing_logins = nil)
    loop do
      puts I18n.t(:enter_login)
      login = gets.chomp
      next puts(I18n.t(:login_present), I18n.t(:login_longer), I18n.t(:login_shorter)) unless check_login(login)

      next puts I18n.t(:login_exist) if existing_logins && !check_login_unique(login, existing_logins)

      break login
    end
  end

  def password_input
    loop do
      puts I18n.t(:enter_password)
      password = gets.chomp
      next puts(I18n.t(:password_present), I18n.t(:password_longer), I18n.t(:password_shorter)) unless check_password(password)

      break password
    end
  end

  def age_input
    loop do
      puts I18n.t(:enter_age)
      age = gets.chomp
      next puts(I18n.t(:wrong_age)) unless check_age(age)

      break age
    end
  end

  def sign_in
    [login_input, password_input]
  end

  def first_account
    puts I18n.t(:no_accounts)
    gets.chomp == 'y'
  end

  def main_choices(name)
    puts I18n.t(:welcome, name: name)
    puts I18n.t(:main_choices)
    puts I18n.t(:exit)

    gets.chomp
  end

  def money_amount(operation)
    operation_hash = {
      'withdraw' => I18n.t(:withdraw_money),
      'put' => I18n.t(:put_money)
    }
    loop do
      puts operation_hash[operation]
      user_input = gets.chomp.to_i
      next puts I18n.t(:correct_amount) unless user_input.positive?

      break user_input
    end
  end

  def account_destroy
    puts I18n.t(:destroy_account)
    gets.chomp == 'y'
  end

  def card_destroy(cards)
    puts I18n.t(:delete)
    card = choose_card(cards)
    return unless card

    puts I18n.t(:sure_delete, card: cards[card - 1].number)
    gets.chomp == 'y' && card
  end

  def create_card_choices
    loop do
      puts I18n.t(:create_card)
      puts I18n.t(:exit)

      input = gets.chomp

      next puts I18n.t(:wrong_card_type) unless check_card_type(input)

      break input
    end
  end

  def cards_show(cards)
    return puts I18n.t(:no_cards) unless cards.any?

    cards.each { |card| puts "- #{card.number}, #{card.type}" }
  end

  def choose_card(cards)
    loop do
      cards.each_with_index { |card, index| puts "- #{card.number}, #{card.type}, press #{index + 1}" }
      puts I18n.t(:exit)

      user_input = gets.chomp
      break false if user_input == 'exit'

      card = user_input.to_i
      next puts I18n.t(:wrong_card) unless card.between?(1, cards.length)

      break card
    end
  end
end
