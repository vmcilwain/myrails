module JavascriptHelper
  # Basecamp trix uses hidden input to populate its editor
  def fill_in_trix_editor(id, value)
    find(:css, id).set(value)
  end

  def click_ok
    page.accept_alert
  end
end

# Example of use in feature test: fill_in_trix_editor("#blog_comment_body_trix_input_blog_comment_#{blog_comment.id}", "some text")
