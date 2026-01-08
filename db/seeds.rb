puts "-" * 50

puts "Cleaning database..."
Message.destroy_all
ChannelUser.destroy_all
Channel.destroy_all
User.destroy_all

puts "Creating Users..."
dev = User.create!(
  email: 'dev@technova.com',
  username: 'alex_dev',
  password: 'password123',
  password_confirmation: 'password123'
)

designer = User.create!(
  email: 'designer@technova.com',
  username: 'sarah_design',
  password: 'password123',
  password_confirmation: 'password123'
)

manager = User.create!(
  email: 'boss@technova.com',
  username: 'mike_manager',
  password: 'password123',
  password_confirmation: 'password123'
)

puts "Creating Channels..."
general = Channel.create!(name: 'general', is_private: false)
development = Channel.create!(name: 'development', is_private: false)
design = Channel.create!(name: 'design', is_private: false)

puts "Subscribing users to channels..."
[dev, designer, manager].each do |user|
  ChannelUser.create!(user: user, channel: general)
end

[dev, manager].each do |user|
  ChannelUser.create!(user: user, channel: development)
end

[designer, manager].each do |user|
  ChannelUser.create!(user: user, channel: design)
end

puts "Creating Messages..."

Message.create!(
  content: 'Welcome to Xlack! Please remember to read the company policies 📄',
  user: manager,
  channel: general
)

# CASE 1: Thread in Development
sprint_msg = Message.create!(
  content: 'Team, how are we doing with the production bug?',
  user: manager,
  channel: development
)

# 2. Responses (Children / Thread)
Message.create!(
  content: 'I found the error, it was a typo in the User model.',
  user: dev,
  channel: development,
  parent: sprint_msg
)

Message.create!(
  content: 'Excellent, let me know when you do the deploy.',
  user: manager,
  channel: development,
  parent: sprint_msg
)

puts "DM between Alex and Sarah..."
dm_channel = Channel.create!(name: "dm-alex-sarah", is_private: true)

ChannelUser.create!(user: dev, channel: dm_channel)
ChannelUser.create!(user: designer, channel: dm_channel)

Message.create!(
  content: "Hi Sarah, can you share the latest design mockups for the project?",
  user: dev,
  channel: dm_channel
)

puts "Seeds planted successfully!"
puts "-" * 50
puts "You can log in with: dev@technova.com / password123"
