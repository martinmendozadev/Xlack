puts "-" * 50
puts "STARTING SEED PROCESS"
puts "-" * 50

puts "1. Cleaning database..."
# Order matters due to foreign keys
Notification.destroy_all
Reaction.destroy_all
Message.destroy_all
ChannelUser.destroy_all
Channel.destroy_all
User.destroy_all

puts "2. Creating Users..."
# Tech Team
dev = User.create!(
  email: 'dev@technova.com',
  username: 'alex_dev',
  password: 'password123',
  password_confirmation: 'password123'
)

# Design Team
designer = User.create!(
  email: 'designer@technova.com',
  username: 'sarah_design',
  password: 'password123',
  password_confirmation: 'password123'
)

# Management
manager = User.create!(
  email: 'boss@technova.com',
  username: 'mike_manager',
  password: 'password123',
  password_confirmation: 'password123'
)

# HR & Admin (New)
hr = User.create!(
  email: 'hr@technova.com',
  username: 'lisa_hr',
  password: 'password123',
  password_confirmation: 'password123'
)

# QA (New)
qa = User.create!(
  email: 'qa@technova.com',
  username: 'dave_qa',
  password: 'password123',
  password_confirmation: 'password123'
)

all_users = [dev, designer, manager, hr, qa]

puts "3. Creating Channels..."
general = Channel.create!(name: 'general', is_private: false)
development = Channel.create!(name: 'development', is_private: false)
design = Channel.create!(name: 'design', is_private: false)
marketing = Channel.create!(name: 'marketing', is_private: false)
random = Channel.create!(name: 'random', is_private: false)

puts "4. Subscribing users to channels..."

# Everyone is in General and Random
all_users.each do |user|
  ChannelUser.create!(user: user, channel: general)
  ChannelUser.create!(user: user, channel: random)
end

# Dev Team (Dev, Manager, QA, Designer)
[dev, manager, qa, designer].each do |user|
  ChannelUser.create!(user: user, channel: development)
end

# Design Team (Designer, Manager, Dev - for feedback)
[designer, manager, dev].each do |user|
  ChannelUser.create!(user: user, channel: design)
end

# Marketing (Manager, HR, Designer)
[manager, hr, designer].each do |user|
  ChannelUser.create!(user: user, channel: marketing)
end

puts "5. Creating Messages and History..."

# --- CHANNEL: GENERAL (History: 5 days ago to Today) ---
msg_welcome = Message.create!(
  content: 'Welcome everyone to the new Xlack platform! 🚀',
  user: manager,
  channel: general,
  created_at: 5.days.ago
)

# Reactions to welcome message
Reaction.create!(user: dev, message: msg_welcome, emoji: '🔥')
Reaction.create!(user: designer, message: msg_welcome, emoji: '🔥')
Reaction.create!(user: qa, message: msg_welcome, emoji: '🔥')
Reaction.create!(user: hr, message: msg_welcome, emoji: '🎉')

Message.create!(
  content: 'Please review the updated holiday policy in the shared drive.',
  user: hr,
  channel: general,
  created_at: 3.days.ago
)

Message.create!(
  content: 'Donuts in the kitchen! 🍩',
  user: hr,
  channel: general,
  created_at: Date.today.beginning_of_day + 9.hours
)

# --- CHANNEL: DEVELOPMENT (Technical discussions) ---

# A Thread from yesterday
bug_report = Message.create!(
  content: 'CRITICAL: Production is throwing 500 errors on the checkout page.',
  user: qa,
  channel: development,
  created_at: 1.day.ago
)
Reaction.create!(user: manager, message: bug_report, emoji: '👀')

# Thread replies
Message.create!(content: 'Looking into it now.', user: dev, channel: development, parent: bug_report, created_at: 1.day.ago + 5.minutes)
Message.create!(content: 'I think it is the payment gateway API.', user: dev, channel: development, parent: bug_report, created_at: 1.day.ago + 20.minutes)
Message.create!(content: 'Fixed. It was an expired API key.', user: dev, channel: development, parent: bug_report, created_at: 1.day.ago + 1.hour)
Message.create!(content: 'Great job @alex_dev!', user: manager, channel: development, parent: bug_report, created_at: 1.day.ago + 1.hour + 5.minutes)

# Today's messages (Mentions)
Message.create!(
  content: 'Guys, are we ready for the deployment today?',
  user: manager,
  channel: development,
  created_at: Time.current - 2.hours
)

Message.create!(
  content: 'Yes, @alex_dev double-checked the migrations.',
  user: qa,
  channel: development,
  created_at: Time.current - 1.hour
)

Message.create!(
  content: 'Deploying in 10 minutes. Hold on tight.',
  user: dev,
  channel: development,
  created_at: Time.current - 10.minutes
)

# --- CHANNEL: RANDOM (Jokes and social) ---
joke = Message.create!(
  content: 'Why do Java developers wear glasses? Because they don\'t C# 🥁',
  user: dev,
  channel: random,
  created_at: 2.days.ago
)
Reaction.create!(user: designer, message: joke, emoji: '😂')
Reaction.create!(user: qa, message: joke, emoji: '😂')
Reaction.create!(user: manager, message: joke, emoji: '🚪') # Manager telling him to leave

Message.create!(
  content: 'Has anyone seen my stapler?',
  user: hr,
  channel: random,
  created_at: Time.current
)

# --- CHANNEL: DESIGN ---
mockup = Message.create!(
  content: 'Here are the v2 mockups for the landing page.',
  user: designer,
  channel: design,
  created_at: 1.day.ago
)
Reaction.create!(user: manager, message: mockup, emoji: '❤️')
Reaction.create!(user: dev, message: mockup, emoji: '👍')

# --- DIRECT MESSAGES ---

puts "6. Creating Direct Messages..."

# DM: Alex (Dev) & Sarah (Designer)
dm_alex_sarah = Channel.create!(name: "dm-alex-sarah", is_private: true)
ChannelUser.create!(user: dev, channel: dm_alex_sarah)
ChannelUser.create!(user: designer, channel: dm_alex_sarah)

Message.create!(
  content: "Hi Sarah, do you have the SVG for the logo?",
  user: dev,
  channel: dm_alex_sarah,
  created_at: 4.hours.ago
)
Message.create!(
  content: "Sure, sending it right now.",
  user: designer,
  channel: dm_alex_sarah,
  created_at: 3.hours.ago
)

# DM: Alex (Dev) & Mike (Manager)
dm_alex_mike = Channel.create!(name: "dm-alex-mike", is_private: true)
ChannelUser.create!(user: dev, channel: dm_alex_mike)
ChannelUser.create!(user: manager, channel: dm_alex_mike)

Message.create!(
  content: "Hey Alex, do you have a minute for a quick sync?",
  user: manager,
  channel: dm_alex_mike,
  created_at: 30.minutes.ago
)

puts "7. Simulating Unread Status..."
# Logic: We update 'last_read_at' for 'alex_dev'.
# 1. GENERAL: Read everything (no bold).
alex_membership_general = ChannelUser.find_by(user: dev, channel: general)
alex_membership_general.update(last_read_at: Time.current)

# 2. RANDOM: Last read 3 days ago (Should be BOLD with unread messages).
alex_membership_random = ChannelUser.find_by(user: dev, channel: random)
alex_membership_random.update(last_read_at: 3.days.ago)

# 3. DM with Mike: Unread (Should be BOLD).
alex_membership_dm = ChannelUser.find_by(user: dev, channel: dm_alex_mike)
alex_membership_dm.update(last_read_at: 1.day.ago)

puts "-" * 50
puts "SEED COMPLETE"
puts "Users created:"
puts " - dev@technova.com (Alex) - Pass: password123"
puts " - designer@technova.com (Sarah)"
puts " - boss@technova.com (Mike)"
puts " - hr@technova.com (Lisa)"
puts " - qa@technova.com (Dave)"
puts "-" * 50
