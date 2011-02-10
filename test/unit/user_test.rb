require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: users
#
#  id                              :integer         not null, primary key
#  name                            :string(255)
#  email                           :string(255)
#  hashed_password                 :string(255)
#  password_salt                   :string(255)
#  is_admin                        :string(255)
#  access_key                      :string(255)
#  remember_token                  :string(255)
#  reset_password_token            :string(255)
#  reset_password_token_expires_at :datetime
#  created_at                      :datetime
#  updated_at                      :datetime
#

