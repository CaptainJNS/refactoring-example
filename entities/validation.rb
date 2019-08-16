module Validation
  def valid_name?(name)
    /^[A-Z]/.match?(name)
  end

  def valid_login?(login, existing_logins)
    /^\w{4,20}$/.match?(login) && !existing_logins.include?(login)
  end

  def valid_password?(password)
    /^\w{6,30}$/.match?(password)
  end

  def valid_age?(age)
    age.to_i.between?(23, 90)
  end

  def valid_card_type?(type)
    [I18n.t(:usual), I18n.t(:capitalist), I18n.t(:virtual), 'exit'].include?(type)
  end

  def choice_is_yes?(choice)
    choice == 'y'
  end
end
