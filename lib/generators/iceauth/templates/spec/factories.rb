# By using the symbol ':user', we get Factory Girl to simulate the User model.
Factory.define :user do |user|
  user.name                   "Leah Dillon"
  user.username               "leahdillon"
  user.email                  "leahdillon@gmail.com"
  user.password               "foobar"
  user.password_confirmation  "foobar"
end

Factory.sequence :username do |n|
  "username#{n}"
end

Factory.sequence :email do |n|
  "user#{n}@example.com"
end
