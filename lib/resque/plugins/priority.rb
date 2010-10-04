module Resque
  def self.enqueue_with_priority(priority, klass, *args)
    queue = klass.instance_variable_get(:@queue) || (klass.respond_to?(:queue) and klass.queue)

    if [:high, :low].include?(priority.to_sym)
      queue = "#{queue}_#{priority}".to_sym
    end
    klass.priority = priority
    Resque::Job.create(queue, klass, *args)
  end

  module Plugin
    module Priority
      def priority=(p)
        if [:high, :low].include?(p.to_sym)
          @queue = "#{@queue}_#{p}".to_sym
        end
        @priority = p.to_sym
      end

      def priority_key(*args)
        "priority:#{name}-#{args.to_s}"
      end
      
      def after_enqueue_set_priority(*args)
        Resque.redis.setnx(priority_key(*args), @priority)
      end

      def around_perform_retrieve_priority(*args)
        key = priority_key(*args)
        priority = Resque.redis.get(key)
        self.priority = priority && priority.empty? ? :normal : priority

        begin
          yield
        ensure
          Resque.redis.del(key)
        end
      end
    end
  end
end

