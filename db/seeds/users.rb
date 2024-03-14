USERS = [
  {
    username: 'admin',
    password: 'password'
  },
  {
    username: 'user123',
    password: 'userpassword'
  }
]

ActiveRecord::Base.transaction do
  USERS.each do |user|
    User.find_or_initialize_by(username: user[:username]).tap do |user_data|
      user_data.password = user[:password]
      user_data.save!
    end
  end
end
