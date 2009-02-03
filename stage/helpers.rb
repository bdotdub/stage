class Dir
  def Dir.files_and_directories(directory, remove_dotfiles = true)
    entries = Dir.entries(directory)

    # Get rid of dotfiles
    entries.reject!{ |entry| entry =~ /^\./ } if remove_dotfiles
  
    # Separate out the files and dirs
    files = entries.reject{ |entry| File.directory? "#{directory}/#{entry}" }
    directories = entries.select{ |entry| File.directory? "#{directory}/#{entry}" }

    return files, directories
  end

  def Dir.files(directory)
    files, directories = Dir.files_and_directories(directory)
    return files
  end

  def Dir.directories(directory)
    files, directories = Dir.files_and_directories(directory)
    return directories
  end
end


