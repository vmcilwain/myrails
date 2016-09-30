# @author Lovell McIlwain
#
# Presenter class for object views
class <%= options[:name].camelize %>Presenter < BasePresenter
  # Reference initialized object_presenter as object
  presents :<%= options[:name]%>

  # delegate :attribute, to: :object, allow_nil: true

  # Return concatenated full name
  def name
    <%= options[:name]%>.attribute + " " + <%= options[:name]%>.attribute
  end

  # Return edit path
  def edit_link
    link_to :Edit, edit_<%= options[:name]%>_path(<%= options[:name]%>)
  end
end
