require 'spec_helper'

$counter = 0

class TestJob

  extend Resque::Plugins::Priority

  @queue = :test

  def perform  
    $counter = $counter + 1
  end

end

describe Resque::Plugins::Priority do
  before(:each) do
    Resque.redis.flushdb
  end

  describe :enqueue_with_priority do

    context "when normal" do
      before(:each) do
        Resque.enqueue_with_priority(:normal, TestJob)
      end

      it 'should enqueue to normal queue' do
        Resque.size(:test).should==1
      end
    end

    [:high, :low].each do |priority| 
      context "when #{priority}" do
        before(:each) do
          Resque.enqueue_with_priority(priority, TestJob)
        end

        it 'should enqueue high queue' do
          Resque.size("test_#{priority.to_s}").should==1
        end
      end
    end

    describe 'enqueue multiple jobs at high' do
      before(:each) do
        3.times { Resque.enqueue_with_priority(:high, TestJob) }
      end

      it 'should have 3 jobs enqueued' do 
        Resque.size(:test_high).should==3
      end

    end


  end

end
