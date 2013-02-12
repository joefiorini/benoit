define_filter :format_like do |date,params|
  date = Date.parse(date) unless date.respond_to? :stamp_like
  date.stamp_like params[0]
end

define_filter :sort do |input,params|
  field = params.first.to_sym
  input.sort_by do |item|
    ::Cadenza::Context.lookup_on_object(field, item)
  end
end
