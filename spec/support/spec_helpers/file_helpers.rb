module FileHelpers
  def write_file(path, content)
    File.open(input.path, "w+") do |f|
      f << input.read
      f.path
    end
  end
end
