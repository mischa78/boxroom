class Clipboard
  def initialize
    setup
  end

  def folders
    Folder.where(:id => @folders)
  end

  def files
    UserFile.where(:id => @files)
  end

  def add(item)
    if item.class == Folder
      @folders << item.id unless @folders.include?(item.id)
    else
      @files << item.id unless @files.include?(item.id)
    end
  end

  def remove(item)
    if item.class == Folder
      @folders.delete(item.id)
    else
      @files.delete(item.id)
    end
  end

  def empty?
    (@folders.empty? || folders.empty?) && (@files.empty? || files.empty?)
  end

  def reset
    setup
  end

  private

  def setup
    @folders, @files = [], []
  end
end
