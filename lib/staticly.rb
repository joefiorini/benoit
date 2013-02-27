module Staticly

  require "rake-pipeline-web-filters"

  require_relative "./staticly/file_wrapper_extensions"

  require_relative './staticly/configuration'
  require_relative './staticly/logger'
  require_relative './staticly/version'
  require_relative "./staticly/site_context"
  require_relative "./staticly/page"
  require_relative "./staticly/pipeline_project"
  require_relative "./staticly/compiler_error"
  require_relative "./staticly/current_site"
  require_relative "./staticly/cleaner"


  require_relative "./staticly/cadenza"

  require_relative "./staticly/filters"
  require_relative "./staticly/pipeline"


  require_relative "./staticly/page_metadata"

  require_relative "./build_notifiers/file_built_notifier"
  require_relative "./build_notifiers/progress_notifier"


  require_relative "./staticly/utils/finds_layouts_for_template"
  require_relative "./staticly/utils/normalizes_path_to_template"
  require_relative "./staticly/utils/paginated_list"

  extend Configuration

end
