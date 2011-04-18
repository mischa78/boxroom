class Clipboard
  def initialize
    @items = []
  end

  def items
    @items.each { |item| item.reload unless item.changed? }
  end

  def add(item)
    @items << item unless @items.find { |i| i.id == item.id && i.class == item.class }
  end

  def remove(item)
    @items.delete(item)
  end

  def reset
    @items = []
  end
end