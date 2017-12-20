module <%= options[:name].split("/").first.camelize %>
  def self.table_name_prefix
    '<%= options[:name].split("/").first.downcase %>_'
  end
end
