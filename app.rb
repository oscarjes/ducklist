require 'bundler/setup'
Bundler.require

require_relative "item"
require_relative "list"

get "/" do
  @list = List.new("Today")
  @list.read_file
  if params["sort"] == "asc"
    @list.items = @list.items.sort_by {|obj| obj.name}
  elsif params["sort"] == "desc"
    @list.items = @list.items.sort_by {|obj| obj.name}.reverse
  elsif params["sort"] == "done"
    @list.items = @list.items.sort_by {|obj| obj.status}
  elsif params["sort"] == "undone"
    @list.items = @list.items.sort_by {|obj| obj.status}.reverse
  else
    @list.items
  end
  if params["q"]
    @list.items = @list.items.select{|s| s.name.include?(params["q"])}
  end
  erb :"index.html", layout: :"layout.html", locals: {items: @list.items}
end

post "/submit" do
  @list = List.new("Today")
  @list.read_file
  @list.append_file(Item.new(params["item_name"], "undone"))
  redirect to("/")
end

get "/undone" do
  @list = List.new("Today")
  @list.read_file
  items = @list.items.select {|item| item.status == "undone"}
  erb :"index.html", layout: :"layout.html", locals: {items: items}
end

get "/onlydone" do
  @list = List.new("Today")
  @list.read_file
  items = @list.items.select {|item| item.status == "done"}
  erb :"index.html", layout: :"layout.html", locals: {items: items}
end

post "/update-all" do
  @list = List.new("Today")
  @list.hash_to_object(params["items"])
  if params["toggle"]
    @list.toggle(params["toggle"].to_i)
  end
  if params["trash"]
    @list.items.delete_at(params["trash"].to_i)
  end
  @list.write_file
  redirect back
end