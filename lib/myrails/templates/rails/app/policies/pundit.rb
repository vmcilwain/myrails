class <%= @name.camelize %>Policy < ApplicationPolicy
  
  def new?
    true
  end

  def edit?
    user == record.user
  end

  alias_method :create?, :new?

  alias_method :show?, :new?

  alias_method :update?, :edit?

  alias_method :destroy?, :edit?
end
