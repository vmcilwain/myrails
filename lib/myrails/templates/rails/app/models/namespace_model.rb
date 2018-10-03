module <%= @name.split("/").first.camelize %>
  def self.table_name_prefix
    '<%= @name.split("/").first.downcase %>_'
  end
end
