module Console
  include Validation

  def start
    puts 'Hello, we are RubyG bank!'
    puts '- If you want to create account - press `create`'
    puts '- If you want to load account - press `load`'
    puts '- If you want to exit - press `exit`'

    gets.chomp
  end

  def name_input
    loop do
      puts 'Enter your name'
      name = gets.chomp
      next puts('Your name must not be empty and starts with first upcase letter') unless check_name(name)

      break name
    end
  end

  def login_input(existing_logins = nil)
    loop do
      puts 'Enter your login'
      login = gets.chomp
      next puts('Login must present', 'Login must be longer then 4 symbols', 'Login must be shorter then 20 symbols') unless check_login(login)

      next puts 'Such account is already exists' if existing_logins && !check_login_unique(login, existing_logins)

      break login
    end
  end

  def password_input
    loop do
      puts 'Enter your password'
      password = gets.chomp
      next puts('Password must present', 'Password must be longer then 6 symbols', 'Password must be shorter then 30 symbols') unless check_password(password)

      break password
    end
  end

  def age_input
    loop do
      puts 'Enter your age'
      age = gets.chomp
      next puts('Your Age must be greeter then 23 and lower then 90') unless check_age(age)

      break age
    end
  end

  def sign_in
    [login_input, password_input]
  end

  def first_account
    puts 'There is no active accounts, do you want to be the first?[y/n]'
    gets.chomp == 'y'
  end

  def main_choices(name)
    puts "\nWelcome, #{name}"
    puts 'If you want to:'
    puts '- show all cards - press SC'
    puts '- create card - press CC'
    puts '- destroy card - press DC'
    puts '- put money on card - press PM'
    puts '- withdraw money on card - press WM'
    puts '- send money to another card  - press SM'
    puts '- destroy account - press `DA`'
    puts '- exit from account - press `exit`'

    gets.chomp
  end

  def money_amount(operation)
    operation_hash = {
      withdraw_money: 'Input the amount of money you want to withdraw',
      put_money: 'Input the amount of money you want to put on your card'
    }
    loop do
      puts operation_hash[operation]
      user_input = gets.chomp.to_i
      next puts 'You must input correct amount of money' unless user_input.positive?

      break user_input
    end
  end

  def account_destroy
    puts 'Are you sure you want to destroy account?[y/n]'
    gets.chomp == 'y'
  end

  def card_destroy(cards)
    puts 'If you want to delete:'
    card = choose_card(cards)
    return unless card

    puts "Are you sure you want to delete #{cards[card - 1].number}?[y/n]"
    gets.chomp == 'y' && card
  end

  def create_card_choices
    loop do
      puts 'You could create one of 3 card types'
      puts '- Usual card. 2% tax on card INCOME. 20$ tax on SENDING money from this card. 5% tax on WITHDRAWING money. For creation this card - press `usual`'
      puts '- Capitalist card. 10$ tax on card INCOME. 10% tax on SENDING money from this card. 4$ tax on WITHDRAWING money. For creation this card - press `capitalist`'
      puts '- Virtual card. 1$ tax on card INCOME. 1$ tax on SENDING money from this card. 12% tax on WITHDRAWING money. For creation this card - press `virtual`'
      puts '- For exit - press `exit`'

      input = gets.chomp

      next puts "Wrong card type. Try again!\n" unless check_card_type(input)

      break input
    end
  end

  def cards_show(cards)
    return puts "There is no active cards!\n" unless cards.any?

    cards.each { |card| puts "- #{card.number}, #{card.type}" }
  end

  def choose_card(cards)
    loop do
      cards.each_with_index { |card, index| puts "- #{card.number}, #{card.type}, press #{index + 1}" }
      puts "press `exit` to exit\n"

      user_input = gets.chomp
      break false if user_input == 'exit'

      card = user_input.to_i
      next puts "You entered wrong number!\n" unless card.between?(1, cards.length)

      break card
    end
  end
end
