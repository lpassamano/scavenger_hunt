module CommentsHelper
  def display_comments_for(hunt)
    if hunt.comments != []
      html = capture do
        hunt.comments.each do |comment|
          concat content_tag(:li, "#{comment.user.name} said: \"#{comment.text}\"")
        end
      end
      content_tag(:ul, html)
    end
  end
end
