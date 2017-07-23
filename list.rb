require_relative "item"

class List
  attr_accessor :items

  def initialize(name, items = [])
    @name = name
    @items = items
  end

  def add(item)
    @items << item
  end

  def read_file
    @lines = File.read("todo.md").split("\n")
    @lines.each_with_index do |line, index|
      add(Item.new_from_line(line, index))
    end
  end

  def write_file
    File.open("todo.md", "w") do |f|
    @items.each do |item|
      if item.status == "done"
        f.puts "- [x] " + item.name
      else
        f.puts "- [ ] " + item.name
      end
    end
    end
  end

  def append_file(new_item)
    File.open("todo.md", "a") do |f|
    f << "- [ ] "+ new_item.name
    f << "\n"
    end
  end

  def mark_done_at!(index)
    item = @items[index]
    item.status = "done"
  end

  def mark_undone_at!(index)
    item = @items[index]
    item.status = "undone"
  end

  def toggle(index)
    if items[index].status == "done"
      items[index].status = "undone"
    else
      items[index].status = "done"
    end
  end

  def hash_to_object(hash)
    hash.each do |item|
      add(Item.new(item[:name], item[:status]))
    end
  end
end
