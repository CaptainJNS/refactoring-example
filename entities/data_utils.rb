module DataUtils
  PATH = 'accounts.yml'.freeze

  def load_accounts(path = PATH)
    return [] unless File.exist?(path)

    YAML.load_file(path)
  end

  def save_account(account, path = PATH)
    accounts = load_accounts(path)
    accounts.delete_if { |acc| acc.login == account.login }
    accounts << account
    File.open(path, 'w') { |file| file.write accounts.to_yaml }
  end

  def save_accounts(accounts, path = PATH)
    File.open(path, 'w') { |file| file.write accounts.to_yaml }
  end
end
