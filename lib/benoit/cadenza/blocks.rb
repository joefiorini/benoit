define_block :times do |context, nodes, parameters|
  from, to, *rest = parameters.map(&:value).map(&:to_i)

  from, to = 1, from unless to

  result = ""

  from.upto(to) do |idx|
    context.push(:counter => idx)
    context.push(:counter0 => idx - from)
    context.push(:first => idx == from)
    context.push(:last => idx == to)
    nodes.each {|child| result << ::Cadenza::TextRenderer.render(child, context) }
    context.pop
  end

  result
end
