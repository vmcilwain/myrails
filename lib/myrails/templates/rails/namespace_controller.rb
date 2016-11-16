module <%= options[:namespace].camelize %>
  class <%= options[:name].pluralize.camelize %>Controller < <%= options[:namespace].camelize %>::<%= options[:namespace].camelize %>Controller
    # before_action :<%= options[:name].singularize %>, only: []
    private

    def <%= options[:name].singularize.downcase %>
      @<%= options[:name].singularize %> = <%= options[:name].camelize.singularize %>.find(params[:id]) %>
    end

    def <%= options[:name].singularize.downcase %>_params
      params.require(:<%= options[:name.downcase].singularize %>).permit()
    end
  end
end
