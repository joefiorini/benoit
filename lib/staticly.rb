module Staticly

  require_relative './staticly/logger'
  require_relative "./staticly/site_context"
  require_relative "./staticly/page_context"
  require_relative "./staticly/compiler_error"
  require_relative "./staticly/front_matter_parser"
  require_relative "./staticly/front_matter_store"

  require_relative "./staticly/utils/finds_layouts_for_template"
  require_relative "./staticly/utils/normalizes_path_to_template"

end
