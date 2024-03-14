USERS = [
  {
    username: 'admin',
    password: 'password',
    role: 1
  },
  {
    username: 'client',
    password: 'password',
    role: 0
  }
]

ActiveRecord::Base.transaction do
  USERS.each do |user|
    User.find_or_initialize_by(username: user[:username]).tap do |user_data|
      user_data.password = user[:password]
      user_data.role = user[:role]
      user_data.save!
    end
  end
end
