module Staticly
  module Filters
      require_relative './filters/sass_filter'
      require_relative './filters/cadenza_filter'
      require_relative './filters/pass_thru_filter'
      require_relative './filters/blacklist_filter'
      require_relative './filters/markdown_filter'
      require_relative './filters/pagination_filter'
      require_relative './filters/metadata_cleaner'
      require_relative './filters/content_page_filter'
      require_relative './filters/move_to_root_filter'
  end
end

