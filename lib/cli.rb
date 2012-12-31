require 'json'

begin
  $: << File.expand_path("../../bundle", __FILE__)
  require 'bundler/setup'
rescue LoadError => ex
  output = { message: ex.message, trace: ex.backtrace, load_path: $:.to_json }
  $stderr.puts output
end

$: << File.expand_path(File.dirname(__FILE__))

begin
  require 'psych'
  require 'rake'
  require 'rake-pipeline'
  require 'staticly'
rescue LoadError => ex
  output = { message: ex.message, trace: ex.backtrace, load_path: $:.to_json }
  $stderr.puts output
  raise
end

require 'staticly/filters'

require_relative "./build_notifiers/file_built_notifier"
require_relative "./build_notifiers/phase_notifier"
require_relative "./build_notifiers/summary_notifier"

class RakePipelineInvoke
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

begin
  assetfile_path = File.join(File.expand_path("../../", __FILE__), "Assetfile")
  pipeline = RakePipelineInvoke.new(assetfile_path, ARGV[0], ARGV[1])
  pipeline.invoke
rescue Staticly::CompilerError => ex
  output = { message: ex.message, path: ex.file_path, line_no: ex.line, original_error: ex.output }
  Staticly::Logger.report_error(ex.output)
  $stderr.puts output.to_json
rescue StandardError => ex
  Staticly::Logger.report_error(ex)
rescue StandardError => ex
  output = { message: ex.message, trace: ex.backtrace, load_path: $:.to_json }
  $stderr.puts output
end
