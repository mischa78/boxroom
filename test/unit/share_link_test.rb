require 'test_helper'

class ShareLinkTest < ActiveSupport::TestCase
  test 'emails is not empty' do
    assert_raise(ActiveRecord::RecordInvalid) { create(:share_link, :emails => '') }
  end

  test 'link expires at is not empty' do
    assert_raise(ActiveRecord::RecordInvalid) { create(:share_link, :link_expires_at => '') }
  end

  test 'emails is not longer than 256 characters' do
    share_link = create(:share_link)

    # 256 chars
    share_link.emails = 'email@domain.com, another-email@domain.com, email@domain.com, another-email@domain.com, email@domain.com, another-email@domain.com, email@domain.com, another-email@domain.com, email@domain.com, another-email@domain.com, email@domain.com, another@domain.com'
    assert share_link.save

    # 257 chars
    share_link.emails = 'email@domain.com, another-email@domain.com, email@domain.com, another-email@domain.com, email@domain.com, another-email@domain.com, email@domain.com, another-email@domain.com, email@domain.com, another-email@domain.com, email@domain.com, anothere@domain.com'
    assert !share_link.save
  end

  test 'the format of emails is valid' do
    assert_raise(ActiveRecord::RecordInvalid) { create(:share_link, :emails => 'mail@domain.com, @.com') }
    assert_raise(ActiveRecord::RecordInvalid) { create(:share_link, :emails => 'mail@domain.com, @test.com') }
    assert_raise(ActiveRecord::RecordInvalid) { create(:share_link, :emails => 'mail@domain.com, test@.com, another-email@domain.com') }
    assert_raise(ActiveRecord::RecordInvalid) { create(:share_link, :emails => 'mail@domain.com, test@test.') }
    assert_raise(ActiveRecord::RecordInvalid) { create(:share_link, :emails => 'mail@domain.com, test@$%^.com') }
    assert_raise(ActiveRecord::RecordInvalid) { create(:share_link, :emails => 'mail@domain.com, test@test.c') }
    assert_raise(ActiveRecord::RecordInvalid) { create(:share_link, :emails => 'mail@domain.com, test@test.$$$') }
  end

  test 'a link token gets generated' do
    share_link1 = create(:share_link)
    assert !share_link1.link_token.blank?

    share_link2 = ShareLink.new
    share_link2.user_file = create(:user_file)
    share_link2.emails = 'mail@domain.com'
    share_link2.link_expires_at = 2.weeks.from_now.end_of_day
    assert share_link2.link_token.blank?

    share_link2.save
    assert !share_link2.link_token.blank?
  end

  test 'active share links' do
    last_week = 1.week.ago
    next_week = 1.week.from_now
    in_two_weeks = 2.weeks.from_now
    in_three_weeks = 3.weeks.from_now
    next_month = 1.month.from_now

    create(:share_link, :link_expires_at => in_two_weeks)
    create(:share_link, :link_expires_at => next_month)
    create(:share_link, :link_expires_at => next_week)
    create(:share_link, :link_expires_at => in_three_weeks)
    create(:share_link, :link_expires_at => last_week)

    assert_equal ShareLink.active_share_links.count, 4

    ShareLink.active_share_links.each_with_index do |share_link, i|
      case i
      when 0
        assert_equal share_link.link_expires_at, next_week
      when 1
        assert_equal share_link.link_expires_at, in_two_weeks
      when 2
        assert_equal share_link.link_expires_at, in_three_weeks
      when 3
        assert_equal share_link.link_expires_at, next_month
      end
    end
  end

  test 'the correct file is returned for a given link token' do
    user_file = create(:user_file)

    share_link1 = create(:share_link)
    share_link1.user_file = user_file
    share_link1.save

    share_link2 = create(:share_link, :link_expires_at => 1.week.ago.end_of_day)
    share_link2.user_file = user_file
    share_link2.save

    random_token = SecureRandom.hex(10)
    assert_raise(NoMethodError) { ShareLink.file_for_token(random_token) }

    old_link_token = share_link2.link_token
    assert_raise(RuntimeError) { ShareLink.file_for_token(old_link_token) }

    valid_link_token = share_link1.link_token
    assert_equal ShareLink.file_for_token(valid_link_token), user_file
  end
end
