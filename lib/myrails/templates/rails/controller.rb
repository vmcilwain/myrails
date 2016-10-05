class <%= options[:name].pluralize.camelize %>Controller < ApplicationController
  # before_action :<%= options[:name].singularize %>, only: []
  private

  def <%= options[:name].singularize %>
    @<%= options[:name].singularize %> = <%= options[:name].capitalize%>.find(params[:id])
  end

  def <%= options[:name].singularize %>_params
    params.require(:<%= options[:name] %>).permit()
  end
end
