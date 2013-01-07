module FrontMatter

  REGEX    = /^(?<metadata>---\s*\n.*?\n?)^(---\s*$\n?)/m
  INSPECT  = 13
  PARSER   = Psych
  REQUIRED = [:title, :date, :content]
  OPTIONAL = [:author, :categories, :tags, :id, :layout, :template, :permalink, :published, :publish_path]

  # Quick check to discover if a file might have frontmatter in it.
  # Only checks if the first line starts with "---"
  #
  # path_to_file - the canonical path the the file
  #
  # Returns boolean
  def self.file_might_have_frontmatter?(path_to_file)
    File.open(path_to_file){|f| f.readline}[0..2] == '---'
  end

  # A more definitive check to find if a file has frontmatter in it.
  # Since we are reading the file, we want to be prudent with with
  # memory and only check LINES_TO_INSPECT
  #
  # path_to_file - the canonical path to the file
  #
  # Returns boolean
  def self.file_has_frontmatter?(path_to_file)
    IO.readlines(path_to_file,INSPECT).join =~ REGEX ? true : false
  end


  # Checks a string to find if it has valid frontmatter
  #
  # text - string containing frontmatter
  #
  # Returns boolean
  def self.has_valid_frontmatter?(text)
    front_matter = self.parse(text)
    self.valid_frontmatter?(front_matter)
  end

  # Checks a hash to find if it has valid frontmatter
  #
  # front_matter - the frontmatter hash
  #
  # Returns boolean
  def self.valid_frontmatter?(front_matter)
    allkeys = REQUIRED
    allkeys.concat(OPTIONAL)
    REQUIRED.each {|key| front_matter.has_key?(key) }.all? &&
      front_matter.keys.each{|key| allkeys.include?(key) }.all?
  end

  # Check if the text has front matter
  #
  # text - the string to check
  #
  # Returns boolean
  def self.has_frontmatter?(text)
    text =~ REGEX ? true : false
  end

  # Load a file and parse the frontmatter
  #
  # path_to_file
  #
  # Returns a hash.
  def self.file_parse(path_to_file)
    text = File.open(path_to_file){|f| f.read}
    front_matter = self.parse(text)
  end

  # Parse the YAML frontmatter.
  #
  # text - The String path to the frontmatter and the content.
  #
  # Returns a hash containing the parsed frontmatter data and the content.
  def self.parse(text)

    front_matter = Hash.new 

    if md = text.match(REGEX)
      front_matter['content'] = md.post_match
      begin
        front_matter.merge!(PARSER.load(md[:metadata]))
      rescue => e
        puts "YAML Exception reading #{name}: #{e.message}"
      end
    end

    front_matter

  end

end
