module BuildNotifiers
  module FileBuiltNotifier

    def self.call(task)
      puts "<FILE BUILT> #{task.name}"
    end

  end
end
