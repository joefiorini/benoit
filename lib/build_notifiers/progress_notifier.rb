module BuildNotifiers
  include Rake::Pipeline::Web::Filters
  include Benoit::Filters

  FILTER_PHASES = {
    none: [],
    preparing: [MetadataCleaner],
    compiling: [MarkdownFilter, MinispadeFilter, HandlebarsFilter, SassFilter, PaginationFilter, ContentPageFilter, CadenzaFilter],
    finishing: [Rake::Pipeline::PipelineFinalizingFilter]
  }


  module ProgressNotifier

    def self.finalizing?
      @finalizing
    end

    def self.finalizing=(value)
      @finalizing = true
    end

    def self.call(_,filter)
      if TrackPhase.last_phase?(filter)
        notify(TrackPhase.lookup_phase(filter))
      end
      if filter.class == Rake::Pipeline::PipelineFinalizingFilter
        ProgressNotifier.finalizing = true
      end
    end

    def self.notify(phase)
      if Benoit.config.output_mode == :app
        $stdout.puts({ type: "progress", name: phase}.to_json)
      else
        puts "Phase complete: #{phase}"
      end
      $stdout.flush
    end

    module TrackPhase

      def self.lookup_phase(filter)
        FILTER_PHASES.keys.detect do |phase|
          FILTER_PHASES[phase].include? filter.class
        end || :none
      end

      def self.last_phase?(filter)
        FILTER_PHASES[lookup_phase(filter)].first == filter.class
      end

    end

  end

end
