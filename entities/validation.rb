module Validation
  def check_name(name)
    /^[A-Z]/.match?(name)
  end

  def check_login(login)
    /^\w{4,20}$/.match?(login)
  end

  def check_login_unique(login, existing_logins)
    !existing_logins.include?(login)
  end

  def check_password(password)
    /^\w{6,30}$/.match?(password)
  end

  def check_age(age)
    age.to_i.between?(23, 90)
  end

  def check_card_type(type)
    [I18n.t(:usual), I18n.t(:capitalist), I18n.t(:virtual), 'exit'].include?(type)
  end
end
