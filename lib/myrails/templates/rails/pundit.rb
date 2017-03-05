# @author Lovell McIlwain
#
# Authorization for <%= options[:name] %> objects
class <%= options[:name].camelize %>Policy < ApplicationPolicy
  # Allow all users to access new <%= options[:name] %>
  def new?
    true
  end

  # Allows owner to edit <%= options[:name].camelize %>
  def edit?
    user == record.user
  end

  # Allows all users to create <%= options[:name].camelize %>
  alias_method :create?, :new?

  # Allows all users to view <%= options[:name].camelize %>
  alias_method :show?, :new?

  # Allows owner to update an <%= options[:name].camelize %>
  alias_method :update?, :edit?

  # Allows owner to remove an <%= options[:name].camelize %>
  alias_method :destroy?, :edit?
end
