require 'rake-pipeline'

module Rake
  class Pipeline
    class FileWrapper
      include Staticly::FileWrapperExtensions

    end
  end
end

module Staticly
  class PipelineProject
    attr_reader :assetfile_path, :output_dir, :tmp_cache_dir, :project, :site_name

    def initialize(assetfile_path, output_dir=nil, tmp_cache_dir=nil)
        @assetfile_path = assetfile_path
        @output_dir = output_dir || default_output_dir
        @site_name = File.basename(Dir.pwd)
        @tmp_cache_dir = tmp_cache_dir || default_cache_dir
        @project = build_project!
    end

    def invoke
        project.pipelines.each do |pipeline|
          pipeline.register_invocation_hook :before_pipline, BuildNotifiers::SummaryNotifier
          pipeline.register_invocation_hook :after_task, BuildNotifiers::FileBuiltNotifier
          pipeline.register_invocation_hook :before_filter, BuildNotifiers::PhaseNotifier
          pipeline.register_invocation_hook :filters_ready, ->(pipeline){
            require 'ostruct'
            pipeline.output_files.each do |output|
              input = output.original_inputs.first

              wrapper = OpenStruct.new(path: output.path, read: input.read, fullpath: input.fullpath)

              input.final_output = output

              PageMetadata::Store.current[wrapper]

            end

            current_site = CurrentSite.load

            # Load ALL filters (including filters within filters)
            filters = recursively_load_filters_from_pipeline(pipeline)
            filters.each do |filter|
              if filter.respond_to? :current_site=
                filter.current_site = current_site
              end
            end
          }
        end
        project.invoke
    end

    private

    def recursively_load_filters_from_pipeline(pipeline)
      pipeline.filters.map do |filter|
        if filter.respond_to? :filters
          recursively_load_filters_from_pipeline(filter)
        else
          filter
        end
      end.flatten
    end

    def default_output_dir
      File.expand_path(File.join(Dir.pwd, "_build"))
    end

    def default_cache_dir
      File.expand_path("~/.staticly/tmpcache/#{site_name}")
    end

    def build_project!
        output, tmp = [output_dir, tmp_cache_dir]
        Rake::Pipeline::Project.new(@assetfile_path) do
            output output
            tmpdir tmp if tmp
        end
    end

  end
end
