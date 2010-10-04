Resque Priority
================

Provides Resque with three levels of (named) priority for a single queue.

For example:
    
    require 'resque/plugins/priority'
    
    class Job
      extend Resque::Plugins::Priority

      @queue = :primary

      def self.perform(record)
        puts @queue #=> :primary_low
        puts @priority #=> :low
        other_stuff_and_junk
      end
    end
    
    # Enqueuing the job
    Resque.enqueue_with_priority(:low, Job, params)

The above code creates a new Job in the `:primary_low` queue. There are three variations on the queues:

* `:high`
* `:normal`
* `:low`

These three priorities produce queue names like, assuming `@queue` is set to "queuename", like:

* `:queuename_high`
* `:queuename`
* `:queuename_low`

A Resque worker would then use a `QUEUE` variable like: `QUEUE=queuename_high,queuename,queuename_low`

Your Job `self.perform` methods have have two instance variables available to them: `@queue` and `@priority`. `@queue` is nothing new, it's provided by Resque by default, but Priority has appended the current priority to the existing value; resulting in the actual queue the job originated from (e.g. ":queuename_high"). `@priority` provides you with the priority (e.g. ":high") of the current job execution.
