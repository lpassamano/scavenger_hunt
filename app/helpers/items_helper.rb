module ItemsHelper
  def display_items_for(hunt)
    html = []
    hunt.items.each do |item|
      html << li_for_item(item)
    end
    content_tag(:h3, "Items:") + content_tag(:ol, html.join.html_safe)
  end

  def li_for_item(item)
    if item.hunt.pending? && current_user == item.hunt.owner
      text = "#{item.name}" + tag(:br) + link_to("Edit Item", edit_hunt_item_path(item.hunt, item)) + button_to("Remove Item", hunt_item_path(@hunt, item), :method => "delete", :class => "destroy")
    else
      text = "#{item.name}"
    end
    content_tag(:li, text)
  end
end
