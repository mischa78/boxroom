require 'test_helper'

class ClipboardTest < ActiveSupport::TestCase
  test 'a folder can be added to the clipboard' do
    folder = create(:folder)
    clipboard = Clipboard.new
    assert clipboard.folders.empty?
    assert clipboard.empty?

    clipboard.add(folder)
    assert_equal clipboard.folders.count, 1
    assert !clipboard.empty?
  end

  test 'a file can be added to the clipboard' do
    file = create(:user_file)
    clipboard = Clipboard.new
    assert clipboard.files.empty?
    assert clipboard.empty?

    clipboard.add(file)
    assert_equal clipboard.files.count, 1
    assert !clipboard.empty?
  end

  test 'a folder can be removed from the clipboard' do
    folder = create(:folder)
    clipboard = Clipboard.new
    clipboard.add(folder)
    assert_equal clipboard.folders.count, 1
    assert !clipboard.empty?

    clipboard.remove(folder)
    assert clipboard.folders.empty?
    assert clipboard.empty?
  end

  test 'a file can be removed from the clipboard' do
    file = create(:user_file)
    clipboard = Clipboard.new
    clipboard.add(file)
    assert_equal clipboard.files.count, 1
    assert !clipboard.empty?

    clipboard.remove(file)
    assert clipboard.files.empty?
    assert clipboard.empty?
  end

  test 'the same folder cannot be added twice' do
    folder = create(:folder)
    clipboard = Clipboard.new
    clipboard.add(folder)
    assert_equal clipboard.folders.count, 1

    another_folder = create(:folder)
    clipboard.add(another_folder)
    assert_equal clipboard.folders.count, 2

    clipboard.add(folder)
    assert_equal clipboard.folders.count, 2
  end

  test 'the same file cannot be added twice' do
    file = create(:user_file)
    clipboard = Clipboard.new
    clipboard.add(file)
    assert_equal clipboard.files.count, 1

    another_file = create(:user_file)
    clipboard.add(another_file)
    assert_equal clipboard.files.count, 2

    clipboard.add(file)
    assert_equal clipboard.files.count, 2
  end

  test 'when a folder is updated the referenced folder on the clipboard must also change' do
    folder = create(:folder, :name => 'Test')
    clipboard = Clipboard.new
    clipboard.add(folder)
    assert_equal clipboard.folders.first.name, 'Test'

    folder.update_attributes(:name => 'Name changed')
    assert_equal clipboard.folders.first.name, 'Name changed'
  end

  test 'when a file is updated the referenced file on the clipboard must also change' do
    file = create(:user_file)
    clipboard = Clipboard.new
    clipboard.add(file)
    assert_not_equal clipboard.files.first.attachment_file_name, 'Name changed.txt'

    file.update_attributes(:attachment_file_name => 'Name changed.txt')
    assert_equal clipboard.files.first.attachment_file_name, 'Name changed.txt'
  end

  test 'a deleted folder must also be deleted from the clipboard' do
    folder = create(:folder)
    clipboard = Clipboard.new
    clipboard.add(folder)
    assert !clipboard.folders.empty?

    folder.destroy
    assert clipboard.empty?
    assert clipboard.folders.empty?
  end

  test 'a deleted file must also be deleted from the clipboard' do
    file = create(:user_file)
    clipboard = Clipboard.new
    clipboard.add(file)
    assert !clipboard.files.empty?

    file.destroy
    assert clipboard.empty?
    assert clipboard.files.empty?
  end

  test 'reset clears all the files and folders from the clipboard' do
    clipboard = Clipboard.new
    3.times { clipboard.add(create(:user_file)) }
    3.times { clipboard.add(create(:folder)) }

    assert_equal clipboard.files.size, 3
    assert_equal clipboard.folders.size, 3
    assert !clipboard.empty?

    clipboard.reset
    assert clipboard.files.empty?
    assert clipboard.folders.empty?
    assert clipboard.empty?
  end
end
