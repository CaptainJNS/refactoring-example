module Validation
  def check_name(name)
    /^[A-Z]/.match?(name)
  end

  def check_login(login, existing_logins)
    /^\w{4,20}$/.match?(login) && !existing_logins.include?(login)
  end

  def check_password(password)
    /^\w{6,30}$/.match?(password)
  end

  def check_age(age)
    age.to_i.between?(23, 90)
  end

  # def check_card_type(type)
  #   %w[usual capitalist virtual].include?(type)
  # end
end
