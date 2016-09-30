module JavascriptHelper
  # Basecamp trix uses hidden input to populate its editor
  def fill_in_trix_editor(id, value)
    find(:xpath, "//*[@id='#{id}']", visible: false).set(value)
  end
end

# Example of use in feature test: fill_in_trix_editor("blog_comment_body_trix_input_blog_comment_#{blog_comment.id}", "some text")
