require 'test_helper'

class FolderTest < ActiveSupport::TestCase
  def setup
    clear_root_folder
  end

  test 'dependent files get deleted' do
    folder1 = create(:folder)
    assert_equal Folder.all.count, 2 # Root folder gets created automatically

    3.times { create(:user_file, :folder => folder1) }
    assert_equal folder1.user_files.count, 3

    folder2 = create(:folder)
    assert_equal Folder.all.count, 3

    5.times { create(:user_file, :folder => folder2) }
    assert_equal folder2.user_files.count, 5
    assert_equal UserFile.all.count, 8

    folder1.destroy
    assert_equal UserFile.all.count, 5

    folder2.destroy
    assert_equal UserFile.all.count, 0
  end

  test 'dependent permissions get deleted' do
    root = create(:folder, :name => 'Root folder', :parent => nil) # Root folder
    assert_equal Folder.all.count, 1

    3.times { create(:group) }
    assert Group.all.count > 0
    assert_equal root.permissions.count, Group.all.count

    folder1 = create(:folder)
    folder2 = create(:folder)
    assert_equal folder1.permissions.count, 3
    assert_equal folder2.permissions.count, 3
    assert_equal Permission.all.count, 9

    folder1.destroy
    assert_equal Permission.all.count, 6

    folder2.destroy
    assert_equal Permission.all.count, 3
  end

  test 'name is unique' do
    folder = create(:folder, :name => 'Test')
    assert Folder.exists?(:name => 'Test')

    folder2 = Folder.new(:name => 'Test')
    folder2.parent = folder
    assert folder2.save

    folder3 = Folder.new(:name => 'Test')
    folder3.parent = folder
    assert !folder3.save
  end

  test 'name is not empty' do
    folder = Folder.new
    assert !folder.save
  end

  test 'cannot create a folder without a parent' do
    folder = Folder.new(:name => 'Test')
    assert_nil folder.parent
    assert_raise(RuntimeError) { folder.save }
  end

  test 'permissions get created' do
    root = create(:folder, :name => 'Root folder', :parent => nil) # Root folder
    assert_equal Folder.all.count, 1

    create(:group)
    assert Group.all.count > 0
    assert_equal root.permissions.count, Group.all.count

    root.permissions.each do |permission|
      assert !permission.can_create
      assert permission.can_read
      assert !permission.can_update
      assert !permission.can_delete

      # Change the permissions
      permission.update_attributes(:can_create => true, :can_update => true)
    end

    folder = create(:folder)
    assert_equal Folder.all.count, 2
    assert_equal folder.permissions.count, Group.all.count

    # Test if updated permissions get copied correctly
    folder.permissions.each do |permission|
      assert permission.can_create
      assert permission.can_read
      assert permission.can_update
      assert !permission.can_delete
    end
  end

  test 'cannot delete root folder' do
    folder = create(:folder)
    root = Folder.root

    assert_raise(RuntimeError) { root.destroy }
    assert folder.destroy
  end

  test 'cannot copy a folder to anything other than a folder' do
    file = create(:user_file)
    folder1 = create(:folder)
    folder2 = create(:folder)

    assert_raise(RuntimeError) { folder1.copy(nil) }
    assert_raise(ActiveRecord::AssociationTypeMismatch) { folder1.copy('A string...') }
    assert_raise(ActiveRecord::AssociationTypeMismatch) { folder1.copy(file) }
    assert folder1.copy(folder2)
  end

  test 'copy a folder' do
    folder1 = create(:folder)
    5.times { create(:user_file, :folder => folder1) }

    folder2 = create(:folder)
    3.times { create(:user_file, :folder => folder2) }

    assert_raise(ActiveRecord::RecordInvalid) { folder1.copy(Folder.root) }
    assert_equal UserFile.all.count, 8
    assert_equal folder2.children.count, 0
    assert folder1.copy(folder2)
    assert_equal UserFile.all.count, 13
    assert_equal folder2.children.count, 1
  end

  test 'cannot move a folder to anything other than a folder' do
    file = create(:user_file)
    folder1 = create(:folder)
    folder2 = create(:folder)

    assert_raise(RuntimeError) { folder1.move(nil) }
    assert_raise(ActiveRecord::AssociationTypeMismatch) { folder1.move('A string...') }
    assert_raise(ActiveRecord::AssociationTypeMismatch) { folder1.move(file) }
    assert folder1.move(folder2)
  end

  test 'move a folder' do
    folder1 = create(:folder)
    folder2 = create(:folder, :parent => folder1)
    folder3 = create(:folder)

    assert folder1.parent_of?(folder2)
    assert !folder1.parent_of?(folder3)

    # Should not be able to move a folder to its own sub-folder
    assert_raise(RuntimeError) { folder1.move(folder2) }

    assert_equal Folder.all.count, 4
    assert_equal folder1.parent, Folder.root

    folder1.move(folder3)
    assert_equal folder1.parent, folder3
    assert_equal Folder.all.count, 4

    assert folder3.parent_of?(folder1)
    assert folder3.parent_of?(folder2)
  end

  test 'whether a folder is root or not' do
    folder1 = create(:folder)
    assert !folder1.is_root?

    folder2 = Folder.new
    assert !folder2.is_root?

    root = Folder.root
    assert root.is_root?
  end

  test 'whether a folder has children or not' do
    folder = create(:folder)
    assert !folder.has_children?

    root = Folder.root
    assert_equal folder.parent, root
    assert root.has_children?

    folder2 = create(:folder, :parent => folder)
    assert folder.has_children?

    folder.destroy
    assert !root.has_children?
  end

  test 'that the root folder is really the root folder' do
    folder = create(:folder)
    assert !folder.is_root?

    root = Folder.root
    assert root.is_root?
    assert_equal root.name, 'Root folder'
    assert_nil root.parent
  end
end
