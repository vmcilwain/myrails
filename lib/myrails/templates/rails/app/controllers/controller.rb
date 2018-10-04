class <%= @name.pluralize.camelize %>Controller < <% if @name.include?("/")%><%= @name.split("/").first.camelize %>::<%= @name.split("/").first.camelize %><% else %>Application<% end %>Controller
  # before_action :<%= @name.split("/").last.singularize %>, only: []
  private

  def <%= @name.split("/").last.singularize %>
    @<%= @name.split("/").last.singularize %> = <%= @name.camelize.singularize %>.find(params[:id])
  end

  def <%= @name.split("/").last.singularize %>_params
    params.require(:<%= @name.split("/").last.singularize %>).permit()
  end
end
