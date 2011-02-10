class Permission < ActiveRecord::Base
  belongs_to :group
  belongs_to :folder
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

