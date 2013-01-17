module BuildNotifiers
  module FileBuiltNotifier

    def self.call(_,task)
      puts "<FILE BUILT> #{task.name}"
    end

  end
end
