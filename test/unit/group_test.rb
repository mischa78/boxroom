require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  test 'dependent permissions get deleted' do
    3.times { Factory(:folder) }
    assert_equal Folder.all.count, 4 # Root folder gets created automatically

    group1 = Factory(:group)
    group2 = Factory(:group)
    assert_equal group1.permissions.count, 4
    assert_equal group2.permissions.count, 4
    assert_equal Permission.all.count, 8

    group1.destroy
    assert_equal Permission.all.count, 4

    group2.destroy
    assert_equal Permission.all.count, 0
  end

  test 'name is unique' do
    Factory(:group, :name => 'Users')
    assert Group.exists?(:name => 'Users')

    group = Group.new(:name => 'Users')
    assert !group.save
  end

  test 'name is not empty' do
    group = Group.new
    assert !group.save
  end

  test 'admin permissions get created' do
    Factory(:folder)
    assert Folder.all.count > 0

    group = Factory(:group, :name => 'Admins')
    assert_equal group.permissions.count, Folder.all.count

    group.permissions.each do |permission|
      assert permission.can_create
      assert permission.can_read
      assert permission.can_update
      assert permission.can_delete
    end
  end

  test 'permissions get created' do
    Factory(:folder)
    assert Folder.all.count > 0

    group = Factory(:group)
    assert_equal group.permissions.count, Folder.all.count

    group.permissions.each do |permission|
      assert !permission.can_create
      assert_equal permission.can_read, permission.folder.is_root?
      assert !permission.can_update
      assert !permission.can_delete
    end
  end

  test 'cannot delete admins group' do
    admins = Factory(:group, :name => 'Admins')
    normal_group = Factory(:group)

    assert admins.admins_group?
    assert_raise(RuntimeError) { admins.destroy }
    assert normal_group.destroy
  end
end
