class Account
  attr_accessor :login, :name, :card, :password, :file_path, :age

  def initialize(name:, age:, login:, password:)
    @name = name
    @age = age
    @login = login
    @password = password
    @card = []
  end
end
