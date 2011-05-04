module Resque
  def self.enqueue_with_priority(priority, klass, *args)
    queue = klass.instance_variable_get(:@queue) || (klass.respond_to?(:queue) and klass.queue)

    if [:high, :low].include?(priority.to_sym)
      queue = "#{queue}_#{priority}".to_sym
    end

    klass.priority = priority
    Resque::Job.create(queue, klass, *args)
    Resque.redis.setnx(klass.priority_key(*args), priority)
  end

  module Plugins
    module Priority
      def priority=(p)
        @priority = p.to_sym
      end

      def priority_identifier(*args)
        args.join('-')
      end

      def priority_key(*args)
        ['priority', 'name', priority_identifier(*args)].compact.join(':')
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

