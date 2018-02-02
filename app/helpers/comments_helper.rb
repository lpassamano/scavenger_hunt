# helpers to display comments in erb
module CommentsHelper
  def display_comments_for(hunt)
    # displays all comments for a hunt
    return false unless hunt.comments != []
    html = capture do
      hunt.comments.each do |c|
        concat content_tag(:li, "#{c.user.name} said: \"#{c.text}\"")
      end
      content_tag(:ul, html)
    end
  end
end
