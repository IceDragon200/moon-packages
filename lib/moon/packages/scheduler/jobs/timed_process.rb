module Moon
  class Scheduler
    module Jobs
      # TimedProcess jobs are similar to Processes, they will run over their
      # provided duration, however, once complete they will execute their
      # on_done callback.
      class TimedProcess < TimeBase
        attr_accessor :on_done

        def on_timeout
          @on_done.call if @on_done
        end

        # @param [Float] delta
        def update_frame(delta)
          trigger(delta, self)
          super
        end
      end
    end
  end
end