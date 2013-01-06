require 'rake-pipeline'

module Staticly
  class PipelineProject
    attr_reader :assetfile_path, :output_dir, :tmp_cache_dir, :project

    def initialize(assetfile_path, output_dir, tmp_cache_dir)
        @assetfile_path = assetfile_path
        @output_dir = output_dir
        @tmp_cache_dir = tmp_cache_dir
        @project = build_project!
    end

    def invoke
        project.pipelines.each do |pipeline|
          pipeline.register_invocation_hook :before_pipline, BuildNotifiers::SummaryNotifier
          pipeline.register_invocation_hook :after_task, BuildNotifiers::FileBuiltNotifier
          pipeline.register_invocation_hook :before_filter, BuildNotifiers::PhaseNotifier
        end
        project.invoke
    end

    private

    def build_project!
        output, tmp = [output_dir, tmp_cache_dir]
        Rake::Pipeline::Project.new(@assetfile_path) do
            output output
            tmpdir tmp
        end
    end

  end
end