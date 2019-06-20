class Manager
  include Taxes
  include Console
  include DataUtils

  attr_accessor :current_account

  def initialize
    @file_path = PATH
    @current_account = nil
  end

  def console
    case start
    when 'create' then create
    when 'load' then load
    else exit
    end
  end

  def create
    name = name_input
    age = age_input
    login = login_input(load_accounts.map(&:login))
    password = password_input
    @current_account = Account.new(name: name, age: age, login: login, password: password)
    save_account(@current_account, @file_path)
    main_menu
  end

  def show_cards
    cards_show(@current_account.card)
  end

  def withdraw_money
    if @current_account.card.any?
      puts 'Choose the card for withdrawing:'
      card = choose_card(@current_account.card)
      return unless card

      current_card = @current_account.card[card - 1]
      money = money_amount(__method__)

      calculate_withdraw_money(current_card, card, money, withdraw_tax(current_card.type, money))
    else puts "There is no active cards!\n"
    end
  end

  def put_money
    if @current_account.card.any?
      puts 'Choose the card for putting:'
      card = choose_card(@current_account.card)
      return unless card

      current_card = @current_account.card[card - 1]
      money = money_amount(__method__)
      calculate_put_money(current_card, card, money, put_tax(current_card.type, money))
    else
      puts "There is no active cards!\n"
    end
  end

  def destroy_account
    return unless account_destroy

    new_accounts = load_accounts.delete_if { |account| account.login == @current_account.login }
    save_accounts(new_accounts, @file_path)
  end

  def load
    accounts = load_accounts
    return create_the_first_account unless accounts.any?

    login, password = sign_in
    @current_account = accounts.detect { |account| account.login == login && account.password == password }
    puts 'There is no account with given credentials' unless @current_account
    main_menu
  end

  def create_the_first_account
    return create if first_account

    console
  end

  def main_menu
    loop do
      case main_choices(@current_account.name)
      when 'SC' then show_cards
      when 'CC' then create_card
      when 'DC' then destroy_card
      when 'PM' then put_money
      when 'WM' then withdraw_money
      when 'SM' then send_money
      when 'DA'
        destroy_account
        exit
      when 'exit' then break exit
      else puts "Wrong command. Try again!\n"
      end
    end
  end

  def create_card
    user_input = create_card_choices
    exit if user_input == 'exit'

    @current_account.card << Card.new(user_input, 16.times.map { rand(10) }.join)
    save_account(@current_account, @file_path)
  end

  def destroy_card
    return puts "There is no active cards!\n" unless @current_account.card.any?

    return unless (card = card_destroy(@current_account.card))

    @current_account.card.delete_at(card - 1)
    save_account(@current_account, @file_path)
  end

  private

  def calculate_withdraw_money(card, card_number, money, tax)
    money_left = card.balance - money - tax

    if money_left.positive?
      @current_account.card[card_number - 1].balance = money_left
      save_account(@current_account, @file_path)
      puts "Money #{money} withdrawed from #{card.number}$. Money left: #{card.balance}$. Tax: #{tax}$"
    else
      puts "You don't have enough money on card for such operation"
    end
  end

  def calculate_put_money(card, card_number, money, tax)
    return puts 'Your tax is higher than input amount' if tax >= money

    new_balance = card.balance + money - tax
    @current_account.card[card_number - 1].balance = new_balance
    save_account(@current_account, @file_path)
    puts "Money #{money} was put on #{card.number}. Balance: #{card.balance}. Tax: #{tax}"
  end
end
