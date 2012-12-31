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
