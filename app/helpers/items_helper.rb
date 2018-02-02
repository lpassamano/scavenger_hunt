# Helpers for displaying items in erb
module ItemsHelper
  def display_items_for(hunt)
    # creates ol of all items in the hunt passed as an argument
    if hunt.active? || hunt.completed? || (hunt.pending? && current_user == hunt.owner)
      # only shows list of items when hunt is pending if user is hunt owner
      # shows list of items to all users when hunt is active or completed
      html = capture do
        li_for_item_list(hunt.items)
      end
      content_tag(:h3, 'Items:') + content_tag(:ol, html)
    end
  end

  def li_for_item_list(items)
    # creates an li for each item in list passed
    items.each do |item|
      concat content_tag(:li, item.name)
    end
  end
end
