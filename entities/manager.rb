class Manager
  include Taxes
  include Console
  include DataUtils

  OPERATIONS = {
    show_cards: 'SC',
    create_card: 'CC',
    destroy_card: 'DC',
    put_money: 'PM',
    withdraw_money: 'WM',
    destroy_account: 'DA'
  }.freeze

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

  def operate_money(operation)
    return puts I18n.t(:no_cards) if @current_account.card.none?

    card = card_for_operation(operation)
    return unless card

    return calculate_withdraw_money(*items_for_operation(card, operation)) if operation == 'withdraw'

    calculate_put_money(*items_for_operation(card, operation))
  end

  def card_for_operation(operation)
    puts I18n.t(operation.to_sym)
    card = choose_card(@current_account.card)
    card || exit
  end

  def items_for_operation(card, operation)
    current_card = @current_account.card[card.pred]
    money = money_amount(operation)

    [current_card, card, money, withdraw_put_tax(operation, current_card.type, money)]
  end

  def destroy_account
    return unless choice_is_yes?(I18n.t(:destroy_account))

    new_accounts = load_accounts.delete_if { |account| account.login == @current_account.login }
    save_accounts(new_accounts, @file_path)
  end

  def load
    accounts = load_accounts
    return create_the_first_account unless accounts.any?

    login, password = sign_in
    @current_account = accounts.detect { |account| account.login == login && account.password == password }
    puts I18n.t(:no_account) unless @current_account
    main_menu
  end

  def create_the_first_account
    return create if choice_is_yes?(I18n.t(:no_accounts))

    console
  end

  def main_menu
    choice = main_choices(@current_account.name)
    return exit if choice == 'exit'

    unless OPERATIONS.value?(choice)
      puts I18n.t(:wrong_command)
      main_menu
    end

    main_menu_choices(choice)
  end

  def main_menu_choices(choice)
    case choice
    when OPERATIONS[:show_cards] then show_cards
    when OPERATIONS[:create_card] then create_card
    when OPERATIONS[:destroy_card] then destroy_card
    when OPERATIONS[:put_money] then operate_money('put')
    when OPERATIONS[:withdraw_money] then operate_money('withdraw')
    when OPERATIONS[:destroy_account]
      destroy_account
      exit
    end
  end

  def create_card
    user_input = create_card_choices

    @current_account.card << Card.new(user_input, 16.times.map { rand(10) }.join)
    save_account(@current_account, @file_path)
  end

  def destroy_card
    return puts I18n.t(:no_cards) unless @current_account.card.any?

    return unless (card = card_destroy?(@current_account.card))

    @current_account.card.delete_at(card.pred)
    save_account(@current_account, @file_path)
  end

  private

  def calculate_withdraw_money(card, card_number, money, tax)
    money_left = card.balance - money - tax

    return puts I18n.t(:not_enough_money) unless money_left.positive?

    current_balance(money_left, card_number)
    save_account(@current_account, @file_path)
    puts I18n.t(:money_withdrawed, money: money, card: card.number, balance: card.balance, tax: tax)
  end

  def calculate_put_money(card, card_number, money, tax)
    return puts I18n.t(:higher_tax) if tax >= money

    new_balance = card.balance + money - tax
    current_balance(new_balance, card_number)
    save_account(@current_account, @file_path)
    puts I18n.t(:money_putted, money: money, card: card.number, balance: card.balance, tax: tax)
  end

  def current_balance(money, card_number)
    @current_account.card[card_number.pred].balance = money
  end
end
