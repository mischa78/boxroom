Factory.define :folder do |f|
  f.sequence(:name) { |i| "test#{i}" }
  f.parent { Folder.find_or_create_by_name('Root folder') }
end

Factory.define :group do |f|
  f.sequence(:name) { |i| "test#{i}" }
end

Factory.define :share_link do |f|
  f.emails 'email1@domain.com, email2@domain.com'
  f.link_expires_at { 2.weeks.from_now.end_of_day }
end

Factory.define :user_file do |f|
  f.attachment { fixture_file }
  f.sequence(:attachment_file_name) { |i| "test#{i}.txt" }
  f.folder { Folder.find_or_create_by_name('Root folder') }
end

Factory.define :user do |f|
  f.sequence(:name) { |i| "test#{i}" }
  f.sequence(:email) { |i| "test#{i}@test.com" }
  f.password 'secret123'
  f.password_confirmation { |u| u.password }
  f.password_required true
  f.reset_password_token ''
  f.dont_clear_reset_password_token false
  f.remember_token ''
  f.is_admin false
end

def fixture_file
  File.open("#{Rails.root}/test/fixtures/textfile.txt")
end
