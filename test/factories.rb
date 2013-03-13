FactoryGirl.define do
  factory :folder do
    sequence(:name) { |i| "test#{i}" }
    parent { Folder.where(:name => 'Root folder').first_or_create }
  end
end

FactoryGirl.define do
  factory :group do
    sequence(:name) { |i| "test#{i}" }
  end
end

FactoryGirl.define do
  factory :share_link do
    emails 'email1@domain.com, email2@domain.com'
    link_expires_at { 2.weeks.from_now.end_of_day }
  end
end

FactoryGirl.define do
  factory :user_file do
    attachment { fixture_file }
    sequence(:attachment_file_name) { |i| "test#{i}.txt" }
    folder { Folder.where(:name => 'Root folder').first_or_create }
  end
end

FactoryGirl.define do
  factory :user do
    sequence(:name) { |i| "test#{i}" }
    sequence(:email) { |i| "test#{i}@test.com" }
    password 'secret123'
    password_confirmation { |u| u.password }
    password_required true
    reset_password_token ''
    dont_clear_reset_password_token false
    remember_token ''
    is_admin false
  end
end

def fixture_file
  File.open("#{Rails.root}/test/fixtures/textfile.txt")
end
