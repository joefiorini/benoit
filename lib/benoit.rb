module Benoit

  require "rake-pipeline-web-filters"

  require_relative "./benoit/file_wrapper_extensions"

  require_relative './benoit/configuration'
  require_relative './benoit/logger'
  require_relative './benoit/version'
  require_relative "./benoit/site_context"
  require_relative "./benoit/page"
  require_relative "./benoit/pipeline_project"
  require_relative "./benoit/compiler_error"
  require_relative "./benoit/current_site"
  require_relative "./benoit/cleaner"


  require_relative "./benoit/cadenza"

  require_relative "./benoit/filters"
  require_relative "./benoit/pipeline"


  require_relative "./benoit/page_metadata"

  require_relative "./build_notifiers/file_built_notifier"
  require_relative "./build_notifiers/progress_notifier"


  require_relative "./benoit/utils/finds_layouts_for_template"
  require_relative "./benoit/utils/normalizes_path_to_template"
  require_relative "./benoit/utils/paginated_list"

  extend Configuration

end
