module BuildNotifiers
  module FileBuiltNotifier

    def self.call(pipeline,task)
      if ProgressNotifier.finalizing?
        path = task.name.sub(pipeline.output_root + "/", "")
        notify_built(path, "success")
      end
    end

    def self.notify_built(path, status="built")
      if Staticly.output_mode == :app
        puts({ type: status, path: path }.to_json)
      else
        puts "Built: #{path}"
      end
    end

  end
end
