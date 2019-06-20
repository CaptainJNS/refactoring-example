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

  def login_input(existing_logins)
    loop do
      puts 'Enter your login'
      login = gets.chomp
      next puts('Login must present', 'Login must be longer then 4 symbols', 'Login must be shorter then 20 symbols', 'Such account is already exists') unless check_login(login, existing_logins)

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
end
