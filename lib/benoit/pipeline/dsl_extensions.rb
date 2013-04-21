class Rake::Pipeline::DSL::PipelineDSL
  def needs_pagination(pattern, &block)
    matcher = pipeline.copy Benoit::Pipeline::PaginationMatcher, &block
    matcher.glob = pattern
    matcher.add_filter Benoit::Filters::PaginationFilter.new
    pipeline.add_filter matcher
  end
end
