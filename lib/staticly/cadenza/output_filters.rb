define_filter :format_like do |date,params|
  date_obj = Date.parse(date)
  date_obj.stamp_like params[0]
end

define_filter :paginated do |collection|
  per_page = 10
  @paginated ||= collection.each_slice(10)
  begin
  @paginated.next
  rescue
    @paginated = nil
    collection
  end
end
