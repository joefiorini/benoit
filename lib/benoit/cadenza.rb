require 'stamp'
require 'cadenza'

module Benoit
  module Cadenza

    def self.load_output_filters!
      ::Cadenza::BaseContext.instance_eval File.read(File.join(File.dirname(__FILE__), 'cadenza', 'output_filters.rb'))
      ::Cadenza::BaseContext.instance_eval File.read(File.join(File.dirname(__FILE__), 'cadenza', 'blocks.rb'))
    end

  end
end
