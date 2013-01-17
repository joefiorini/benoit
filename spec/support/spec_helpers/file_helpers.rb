module FileHelpers
  def write_file(path, content)
    File.open(path, "w+") do |f|
      f << content
      f.path
    end
  end
end
