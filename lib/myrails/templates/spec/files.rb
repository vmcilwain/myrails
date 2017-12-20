def delete_files
  `rm -rf \#{Rails.root}/tmp/uploads`
end