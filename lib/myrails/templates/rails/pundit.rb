# @author Lovell McIlwain
#
# Authorization for article objects
class <%= options[:name].camelize %>Policy < ApplicationPolicy
  # Allow all users to access new article objects
  def new?
    true
  end

  # Allows owner of an article to edit the article
  def edit?
    user == record.user
  end

  # Allows all users to create article objects
  alias_method :create?, :new?

  # Allows all users to view article objects
  alias_method :show?, :new?

  # Allows owner of an article to update an article object
  alias_method :update?, :edit?

  # Allows owner of an object to remove an object
  alias_method :destroy?, :edit?
end
