class Account
  attr_accessor :login, :name, :card, :password, :file_path, :age

  def initialize(options)
    @name, @age, @login, @password = options.values_at(:name, :age, :login, :password)
    @card = []
  end
end
