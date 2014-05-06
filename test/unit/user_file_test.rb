require 'test_helper'

class UserFileTest < ActiveSupport::TestCase
  def setup
    clear_root_folder
  end

  test 'dependent share links get deleted' do
    file1 = create(:user_file)
    assert_equal UserFile.all.count, 1

    3.times { create(:share_link, :user_file => file1) }
    assert_equal file1.share_links.count, 3

    file2 = create(:user_file)
    assert_equal UserFile.all.count, 2

    5.times { create(:share_link, :user_file => file2) }
    assert_equal file2.share_links.count, 5
    assert_equal ShareLink.all.count, 8

    file1.destroy
    assert_equal ShareLink.all.count, 5

    file2.destroy
    assert_equal ShareLink.all.count, 0
  end

  test 'attachment is not empty' do
    folder = create(:folder)
    file = folder.user_files.build
    assert !file.save

    file.attachment = fixture_file
    assert file.save
  end

  test 'folder is not empty' do
    file = UserFile.new(:attachment => fixture_file)
    assert !file.save

    folder = create(:folder)
    file.folder = folder
    assert file.save
  end

  test 'attachment file name is unique' do
    file = create(:user_file)
    file.update_attributes(:attachment_file_name => 'Test.txt')
    assert UserFile.exists?(:attachment_file_name => 'Test.txt')

    folder = create(:folder)
    file2 = folder.user_files.build(:attachment => fixture_file)
    file2.attachment_file_name = 'Test.txt'
    assert file2.save

    file3 = Folder.root.user_files.build(:attachment => fixture_file)
    file3.attachment_file_name = 'Test.txt'
    assert !file3.save
  end

  test 'attachment file name cannot contain invalid characters' do
    file = create(:user_file)

    %w{< > : " / \ | ? *}.each do |invalid_character|
      file.attachment_file_name = "Test#{invalid_character}.txt"
      assert !file.save
    end

    file.attachment_file_name = 'Test.txt'
    assert file.save
  end

  test 'cannot copy a file to anything other than a folder' do
    file1 = create(:user_file)
    file2 = create(:user_file)
    folder = create(:folder)

    assert_raise(ActiveRecord::RecordInvalid) { file1.copy(nil) }
    assert_raise(ActiveRecord::AssociationTypeMismatch) { file1.copy('A string...') }
    assert_raise(ActiveRecord::AssociationTypeMismatch) { file1.copy(file2) }
    assert file1.copy(folder)
  end

  test 'copy a file' do
    folder = create(:folder)
    file = create(:user_file)

    assert_raise(ActiveRecord::RecordInvalid) { file.copy(Folder.root) }
    assert_equal UserFile.all.count, 1
    assert_equal folder.user_files.count, 0

    file.copy(folder)
    assert_equal UserFile.all.count, 2
    assert_equal folder.user_files.count, 1

    new_file = UserFile.find_by_attachment_file_name_and_folder_id(file.attachment_file_name, folder.id)
    assert File.exists?(new_file.attachment.path)
  end

  test 'cannot move a file to anything other than a folder' do
    file1 = create(:user_file)
    file2 = create(:user_file)
    folder = create(:folder)

    assert_raise(ActiveRecord::RecordInvalid) { file1.move(nil) }
    assert_raise(ActiveRecord::AssociationTypeMismatch) { file1.move('A string...') }
    assert_raise(ActiveRecord::AssociationTypeMismatch) { file1.move(file2) }
    assert file1.move(folder)
  end

  test 'move a file' do
    folder = create(:folder)
    folder2 = create(:folder)
    file = create(:user_file)

    assert file.copy(folder)
    assert_equal UserFile.all.count, 2
    assert_not_equal file.folder, folder
    assert_raise(ActiveRecord::RecordInvalid) { file.move(folder) }

    assert file.move(folder2)
    assert_equal UserFile.all.count, 2
    assert_equal file.folder, folder2
  end

  test 'file has correct extension' do
    file = create(:user_file)
    assert_equal file.extension, 'txt'

    file.update_attributes(:attachment_file_name => 'test.pdf')
    assert_equal file.extension, 'pdf'

    file.update_attributes(:attachment_file_name => 'test')
    assert file.extension.blank?
  end
end
