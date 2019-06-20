module DataUtils
  def load_accounts(path = @file_path)
    return [] unless File.exist?(path)

    YAML.load_file(path)
  end

  def save_account(account, path = @file_path)
    accounts = load_accounts(path)
    accounts.delete_if {|acc| acc.login == account.login}
    accounts << account
    File.open(path, 'w') { |file| file.write accounts.to_yaml }
  end
end