class Item
  attr_accessor :name
  attr_accessor :status
  attr_accessor :index

  def initialize (name, status = "undone", index = nil)
    @name = name
    @status = status
    @index = index
  end

  def status?
    @status
  end

  def mark_done
    @status = "done"
  end

  def mark_undone
    @status = "undone"
  end

  def self.new_from_line(line, index)
    name = line[6..-1]
    status = line[3] == "x" ? "done" : "undone"
    index = index
    Item.new(name, status, index)
  end
  
end