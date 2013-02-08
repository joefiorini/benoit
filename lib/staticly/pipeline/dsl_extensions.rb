class Rake::Pipeline::DSL::PipelineDSL
  def needs_pagination(pattern, &block)
    matcher = pipeline.copy Staticly::Pipeline::PaginationMatcher, &block
    matcher.glob = pattern
    matcher.add_filter Staticly::Filters::PaginationFilter.new
    pipeline.add_filter matcher
  end
end
