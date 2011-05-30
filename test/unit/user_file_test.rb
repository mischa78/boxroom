require 'test_helper'

class UserFileTest < ActiveSupport::TestCase
  test 'attachment is not empty' do
    folder = Factory(:folder)
    file = UserFile.new(:folder => folder)
    assert !file.save

    file.attachment = fixture_file
    assert file.save
  end

  test 'folder is not empty' do
    file = UserFile.new(:attachment => fixture_file)
    assert !file.save

    folder = Factory(:folder)
    file.folder = folder
    assert file.save
  end

  test 'attachment file name is unique' do
    file = Factory(:user_file)
    file.update_attributes(:attachment_file_name => 'Test')
    assert UserFile.exists?(:attachment_file_name => 'Test')

    folder = Factory(:folder)
    file2 = UserFile.new(:attachment => fixture_file, :folder => folder)
    file2.attachment_file_name = 'Test'
    assert file2.save

    file3 = UserFile.new(:attachment => fixture_file, :folder => Folder.root)
    file3.attachment_file_name = 'Test'
    assert !file3.save
  end

  test 'attachment file name cannot contain invalid characters' do
    file = Factory(:user_file)

    %w{< > : " / \ | ? *}.each do |invalid_character|
      file.attachment_file_name = "Test#{invalid_character}"
      assert !file.save
    end

    file.attachment_file_name = 'Test'
    assert file.save
  end

  test 'cannot copy a file to anything other than a folder' do
    file1 = Factory(:user_file)
    file2 = Factory(:user_file)
    folder = Factory(:folder)

    assert_raise(ActiveRecord::RecordInvalid) { file1.copy(nil) }
    assert_raise(ActiveRecord::AssociationTypeMismatch) { file1.copy('A string...') }
    assert_raise(ActiveRecord::AssociationTypeMismatch) { file1.copy(file2) }
    assert file1.copy(folder)
  end

  test 'copy a file' do
    folder = Factory(:folder)
    file = Factory(:user_file)

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
    file1 = Factory(:user_file)
    file2 = Factory(:user_file)
    folder = Factory(:folder)

    assert_raise(ActiveRecord::RecordInvalid) { file1.move(nil) }
    assert_raise(ActiveRecord::AssociationTypeMismatch) { file1.move('A string...') }
    assert_raise(ActiveRecord::AssociationTypeMismatch) { file1.move(file2) }
    assert file1.move(folder)
  end

  test 'move a file' do
    folder = Factory(:folder)
    folder2 = Factory(:folder)
    file = Factory(:user_file)

    assert file.copy(folder)
    assert_equal UserFile.all.count, 2
    assert_not_equal file.folder, folder
    assert_raise(ActiveRecord::RecordInvalid) { file.move(folder) }

    assert file.move(folder2)
    assert_equal UserFile.all.count, 2
    assert_equal file.folder, folder2
  end

  test 'file has correct extension' do
    file = Factory(:user_file)
    assert_equal file.extension, 'txt'

    file.update_attributes(:attachment_file_name => 'test.pdf')
    assert_equal file.extension, 'pdf'

    file.update_attributes(:attachment_file_name => 'test')
    assert file.extension.blank?
  end
end
