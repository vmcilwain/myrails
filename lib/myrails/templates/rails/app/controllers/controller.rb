class <%= options[:name].pluralize.camelize %>Controller < <% if options[:name].include?("/")%><%= options[:name].split("/").first.camelize %>::<%= options[:name].split("/").first.camelize %><% else %>Application<% end %>Controller
  # before_action :<%= options[:name].split("/").last.singularize %>, only: []
  private

  def <%= options[:name].split("/").last.singularize %>
    @<%= options[:name].split("/").last.singularize %> = <%= options[:name].camelize.singularize %>.find(params[:id])
  end

  def <%= options[:name].split("/").last.singularize %>_params
    params.require(:<%= options[:name].split("/").last.singularize %>).permit()
  end
end
