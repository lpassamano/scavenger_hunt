module ItemsHelper
  def display_items_for(hunt)
    if hunt.active? || hunt.completed? || (hunt.pending? && current_user == hunt.owner)
      html = []
      hunt.items.each do |item|
        html << content_tag(:li, "#{item.name}")
      end
      content_tag(:h3, "Items:") + content_tag(:ol, html.join.html_safe)
    end
  end
end
