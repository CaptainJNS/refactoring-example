require 'yaml'
require 'pry'

class Account
  include Taxes
  include Validation
  include Console

  attr_accessor :login, :name, :card, :password, :file_path, :age

  def initialize(name:, age:, login:, password:)
    @name = name
    @age = age
    @login = login
    @password = password
    @card = []
  end

  # def console
  #   case start
  #   when 'create' then create
  #   when 'load' then load
  #   else exit
  #   end
  # end

  # def create
  #   @name = name_input
  #   @age = age_input
  #   @login = login_input(accounts.map { |a| a.login })
  #   @password = password_input

  #   @card = []
  #   new_accounts = accounts << self
  #   @current_account = self
  #   save(new_accounts) #Storing
  #   main_menu
  # end

  # def load
  #   loop do
  #     return create_the_first_account unless accounts.any?

  #     login, password = sign_in

  #     if accounts.map { |a| { login: a.login, password: a.password } }.include?({ login: login, password: password })
  #       a = accounts.detect { |a| login == a.login }
  #       @current_account = a
  #       break
  #     end

  #     break puts 'There is no account with given credentials'
  #   end
  #   main_menu
  # end

  # def create_the_first_account
  #   return create if first_account

  #   console
  # end

  # def main_menu
  #   loop do
  #     case main_choices(@current_account.name)
  #     when 'SC' then show_cards
  #     when 'CC' then create_card
  #     when 'DC' then destroy_card
  #     when 'PM' then put_money
  #     when 'WM' then withdraw_money
  #     when 'SM' then send_money
  #     when 'DA'
  #       destroy_account
  #       exit
  #     when 'exit' then break exit
  #     else puts "Wrong command. Try again!\n"
  #     end
  #   end
  # end

  # def create_card
  #     user_input = create_card_choices
  #     exit if user_input == 'exit'

  #     card = Card.new(user_input, 16.times.map{rand(10)}.join)

  #     cards = @current_account.card << card
  #     @current_account.card = cards #important!!!

  #     save([@current_account])
  # end

  # def destroy_card #MINE
  #   if @current_account.card.any? then loop do
  #     puts 'If you want to delete:'
  #     show_cards_for_choose(@current_account.card)

  #     user_input = gets.chomp
  #     break if user_input == 'exit'

  #     user_input = user_input.to_i
  #     next puts "You entered wrong number!\n" unless user_input.between?(1, @current_account.card.length)

  #     puts "Are you sure you want to delete #{@current_account.card[user_input - 1].number}?[y/n]"
  #         if gets.chomp == 'y'
  #           @current_account.card.delete_at(user_input - 1)
  #           break save([@current_account])
  #         end
  #   end
  #   else puts "There is no active cards!\n"
  #   end
  # end

  # def show_cards
  #   if @current_account.card.any?
  #     @current_account.card.each do |card|
  #       puts "- #{card.number}, #{card.type}"
  #     end
  #   else
  #     puts "There is no active cards!\n"
  #   end
  # end

  # def withdraw_money #MINE
  #   if @current_account.card.any? then loop do
  #     puts 'Choose the card for withdrawing:'
  #     show_cards_for_choose(@current_account.card)

  #     card_choice = gets.chomp
  #     break if card_choice == 'exit'

  #     card_choice = card_choice.to_i
  #     next puts "You entered wrong number!\n" unless card_choice.between?(1, @current_account.card.length)

  #     current_card = @current_account.card[card_choice - 1]
  #     puts 'Input the amount of money you want to withdraw'
  #     user_input = gets.chomp.to_i
  #     if user_input > 0
  #       money_left = current_card.balance - user_input - withdraw_tax(current_card.type, user_input)
  #       if money_left > 0
  #         current_card.balance = money_left
  #         @current_account.card[card_choice - 1] = current_card
  #         save
  #         puts "Money #{user_input} withdrawed from #{current_card.number}$. Money left: #{current_card.balance}$. Tax: #{withdraw_tax(current_card.type, user_input)}$"
  #       else
  #         puts "You don't have enough money on card for such operation"
  #         return
  #       end
  #     end
  #   else
  #     puts 'You must input correct amount of $'
  #     return
  #   end
  #   else puts "There is no active cards!\n"
  #   end
  # else
  #   puts "There is no active cards!\n"
  # end

  # def put_money
  #   puts 'Choose the card for putting:'

  #   if @current_account.card.any?
  #     @current_account.card.each_with_index do |c, i|
  #       puts "- #{c.number}, #{c.type}, press #{i + 1}"
  #     end
  #     puts "press `exit` to exit\n"
  #     loop do
  #       answer = gets.chomp
  #       break if answer == 'exit'
  #       if answer&.to_i.to_i <= @current_account.card.length && answer&.to_i.to_i > 0
  #         current_card = @current_account.card[answer&.to_i.to_i - 1]
  #         loop do
  #           puts 'Input the amount of money you want to put on your card'
  #           a2 = gets.chomp
  #           if a2&.to_i.to_i > 0
  #             if put_tax(current_card.type, a2&.to_i.to_i) >= a2&.to_i.to_i
  #               puts 'Your tax is higher than input amount'
  #               return
  #             else
  #               new_money_amount = current_card.balance + a2&.to_i.to_i - put_tax(current_card.type, a2&.to_i.to_i)
  #               current_card.balance = new_money_amount
  #               @current_account.card[answer&.to_i.to_i - 1] = current_card
  #               new_accounts = []
  #               accounts.each do |ac|
  #                 if ac.login == @current_account.login
  #                   new_accounts.push(@current_account)
  #                 else
  #                   new_accounts.push(ac)
  #                 end
  #               end
  #               save([@current_account]) #Storing
  #               puts "Money #{a2&.to_i.to_i} was put on #{current_card.number}. Balance: #{current_card.balance}. Tax: #{put_tax(current_card.type, a2&.to_i.to_i)}"
  #               return
  #             end
  #           else
  #             puts 'You must input correct amount of money'
  #             return
  #           end
  #         end
  #       else
  #         puts "You entered wrong number!\n"
  #         return
  #       end
  #     end
  #   else
  #     puts "There is no active cards!\n"
  #   end
  # end

  # def send_money
  #   puts 'Choose the card for sending:'

  #   if @current_account.card.any?
  #     @current_account.card.each_with_index do |c, i|
  #       puts "- #{c.number}, #{c.type}, press #{i + 1}"
  #     end
  #     puts "press `exit` to exit\n"
  #     answer = gets.chomp
  #     exit if answer == 'exit'
  #     if answer&.to_i.to_i <= @current_account.card.length && answer&.to_i.to_i > 0
  #       sender_card = @current_account.card[answer&.to_i.to_i - 1]
  #     else
  #       puts 'Choose correct card'
  #       return
  #     end
  #   else
  #     puts "There is no active cards!\n"
  #     return
  #   end

  #   puts 'Enter the recipient card:'
  #   a2 = gets.chomp
  #   if a2.length > 15 && a2.length < 17
  #     all_cards = accounts.map(&:card).flatten
  #     if all_cards.select { |card| card.number == a2 }.any?
  #       recipient_card = all_cards.detect { |card| card.number == a2 }
  #     else
  #       puts "There is no card with number #{a2}\n"
  #       return
  #     end
  #   else
  #     puts 'Please, input correct number of card'
  #     return
  #   end

  #   loop do
  #     puts 'Input the amount of money you want to withdraw'
  #     a3 = gets.chomp
  #     if a3&.to_i.to_i > 0
  #       sender_balance = sender_card.balance - a3&.to_i.to_i - sender_tax(sender_card.type, a3&.to_i.to_i)
  #       recipient_balance = recipient_card.balance + a3&.to_i.to_i - put_tax(recipient_card.type, a3&.to_i.to_i)

  #       if sender_balance < 0
  #         puts "You don't have enough money on card for such operation"
  #       elsif put_tax(recipient_card.type, recipient_card.balance, recipient_card.number, a3&.to_i.to_i) >= a3&.to_i.to_i
  #         puts 'There is no enough money on sender card'
  #       else
  #         sender_card.balance = sender_balance
  #         @current_account.card[answer&.to_i.to_i - 1] = sender_card
  #         new_accounts = []
  #         accounts.each do |ac|
  #           if ac.login == @current_account.login
  #             new_accounts.push(@current_account)
  #           elsif ac.card.map { |card| card.number }.include? a2
  #             recipient = ac
  #             new_recipient_cards = []
  #             recipient.card.each do |card|
  #               if card.number == a2
  #                 card.balance = recipient_balance
  #               end
  #               new_recipient_cards.push(card)
  #             end
  #             recipient.card = new_recipient_cards
  #             new_accounts.push(recipient)
  #           end
  #         end
  #         File.open('accounts.yml', 'w') { |f| f.write new_accounts.to_yaml } #Storing
  #         puts "Money #{a3&.to_i.to_i}$ was put on #{sender_card.number}. Balance: #{recipient_balance}. Tax: #{put_tax(sender_card.type, a3&.to_i.to_i)}$\n"
  #         puts "Money #{a3&.to_i.to_i}$ was put on #{a2}. Balance: #{sender_balance}. Tax: #{sender_tax(sender_card.type, a3&.to_i.to_i)}$\n"
  #         break
  #       end
  #     else
  #       puts 'You entered wrong number!\n'
  #     end
  #   end
  # end

  # def destroy_account
  #   puts 'Are you sure you want to destroy account?[y/n]'
  #   a = gets.chomp
  #   if a == 'y'
  #     new_accounts = []
  #     accounts.each do |ac|
  #       if ac.login == @current_account.login
  #       else
  #         new_accounts.push(ac)
  #       end
  #     end
  #     File.open(@file_path, 'w') { |f| f.write new_accounts.to_yaml } #Storing
  #   end
  # end

  private

  # def accounts
  #   if File.exists?('accounts.yml')
  #     YAML.load_file('accounts.yml')
  #   else
  #     []
  #   end
  # end

  # def save(accounts)
  #   File.open(@file_path, 'w') { |file| file.write accounts.to_yaml }
  # end
end
