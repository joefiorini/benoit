module BuildNotifiers
  include Rake::Pipeline::Web::Filters
  include Staticly::Filters

  FILTER_PHASES = {
    preparing: [MetadataCleaner],
    compiling: [MarkdownFilter, MinispadeFilter, HandlebarsFilter, ContentPageFilter, SassFilter, CadenzaFilter],
    finishing: [Rake::Pipeline::ConcatFilter, Rake::Pipeline::PipelineFinalizingFilter]
  }

  module PhaseNotifier
    def self.call(_,filter)
      if TrackPhase.last_phase?(filter)
        $stdout.puts "<COMPLETED PHASE> #{TrackPhase.lookup_phase(filter)}"
        $stdout.flush
      end
    end

    module TrackPhase

      def self.lookup_phase(filter)
        FILTER_PHASES.keys.detect do |phase|
          puts filter.class.name.inspect
          FILTER_PHASES[phase].include? filter.class
        end
      end

      def self.last_phase?(filter)
        FILTER_PHASES[lookup_phase(filter)].first == filter.class
      end

    end

  end

end
