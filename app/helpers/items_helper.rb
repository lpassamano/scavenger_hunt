module ItemsHelper
  def display_items_for(hunt)
    if hunt.active? || hunt.completed? || (hunt.pending? && current_user == hunt.owner)
      html = []
      hunt.items.each do |item|
        html << li_for_item(item)
      end
      content_tag(:h3, "Items:") + content_tag(:ol, html.join.html_safe)
    end
  end

  def li_for_item(item)
    if item.hunt.pending? && current_user == item.hunt.owner
      text = capture do
        concat "#{item.name}"
        concat tag(:br)
        concat link_to("Edit Item", edit_hunt_item_path(item.hunt, item))
        concat button_to("Remove Item", hunt_item_path(item.hunt, item), :method => "delete", :class => "destroy")
      end

    else
      text = "#{item.name}"
    end
    content_tag(:li, text)
  end
end
