require 'test_helper'

class PermissionTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: permissions
#
#  id         :integer         not null, primary key
#  folder_id  :integer
#  group_id   :integer
#  can_create :boolean
#  can_read   :boolean
#  can_update :boolean
#  can_delete :boolean
#

