module ItemsHelper
  def display_items_for(hunt)
    if hunt.active? || hunt.completed? || (hunt.pending? && current_user == hunt.owner)
      html = capture do
        hunt.items.each do |item|
          concat content_tag(:li, "#{item.name}")
        end
      end
      content_tag(:h3, "Items:") + content_tag(:ol, html)
    end
  end
end
