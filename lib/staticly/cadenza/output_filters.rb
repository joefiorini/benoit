define_filter :format_like do |date,params|
  date_obj = Date.parse(date)
  date_obj.stamp_like params[0]
end
