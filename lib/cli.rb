begin
  require 'rake'
  require 'rake-pipeline'
  require 'SiteContext'
  require 'PageContext'
  require 'FrontMatterParser'
  require 'FrontMatterStore'
  require 'Logging'
  require 'Compilers'
  require 'FindsLayoutsForTemplate'
  require 'NormalizesPathToTemplate'
  require 'staticly-pipeline-filters'
rescue LoadError
  $stderr.puts $:
  raise
end

class RakePipelineInvoke
    attr_reader :assetfile_path, :output_dir, :tmp_cache_dir, :project

    def initialize(assetfile_path, output_dir, tmp_cache_dir)
        @assetfile_path = assetfile_path
        @output_dir = output_dir
        @tmp_cache_dir = tmp_cache_dir
        @project = build_project!
    end

    def filter_phases
      {
        preparing: [
          Staticly::Pipeline::Filters::MoveToRootFilter,
          Staticly::Pipeline::Filters::FrontMatterFilter
        ],
        compiling: [
          Staticly::Pipeline::Filters::MarkdownFilter,
          Staticly::Pipeline::Filters::ContentPageFilter,
          Staticly::Pipeline::Filters::SassFilter,
          Staticly::Pipeline::Filters::CadenzaFilter
        ],
        finishing: [
          Rake::Pipeline::ConcatFilter,
          Rake::Pipeline::PipelineFinalizingFilter
        ]
      }
    end

    def invoke
      current_phase = nil
        project.pipelines.each do |pipeline|
          pipeline.register_hook :after_task_invocation do |task|
            puts task.name
          end
          pipeline.register_hook :before_filter_invocation do |filter|
            if filter_phases[:preparing].include? filter.class
              puts "preparing"
            elsif filter_phases[:compiling].include? filter.class
              puts "compiling"
            elsif filter_phases[:finishing].include? filter.class
              puts "finishing"
            end
          end
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
  pipeline = RakePipelineInvoke.new(ARGV[0], ARGV[1], ARGV[2])
  pipeline.invoke
rescue Staticly::CompilerError => ex
  puts $!.message
  puts "error: #{ex.output}"
end
