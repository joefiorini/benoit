class Staticly::Filters::MoveToRootFilter < Rake::Pipeline::Filter

  def initialize
      block = proc { |input|
          components = input.split('/')
          if components.length == 1 # Already at root
              components.first
          elsif components.first.start_with? '_'
              components.shift
          end
          components.join('/')
      }
      super &block
  end

  def generate_output(inputs, output)
      inputs.each do |input|
          output.write input.read
      end
  end

end
