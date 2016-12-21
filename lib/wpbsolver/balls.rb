module WPBSolver
  class Balls
    include Comparable

    attr_reader :heavy, :light

    def initialize(count)
      @heavy = [1]*count
      @light = [1]*count
      @count = count
    end

    def initialize_copy(orig)
      super
      @heavy = @heavy.dup
      @light = @light.dup
    end

    def case_number
      (@heavy+@light).inject(&:+)
    end

    def success?
      case_number <= 1
    end

    def size
      @count
    end

    def ids
      (1..(@count)).to_a
    end

    def unset(ball_ids, state)
      ball_ids.each do |id|
        (state == :heavy ? @heavy : @light)[id-1] = 0
      end
      self
    end

    def unsetexcept(ball_ids, state)
      (ids-ball_ids).each do |id|
        (state == :heavy ? @heavy : @light)[id-1] = 0
      end
      self
    end

    def result
      if case_number == 0
        return "impossible"
      elsif case_number == 1
        if idx = @heavy.find_index {|b| b == 1}
          return "#{idx+1} is HEAVY"
        elsif idx = @light.find_index {|b| b == 1}
          return "#{idx+1} is LIGHT"
        end
      else
        return "no solution #{inspect}"
      end
    end

    def <=>(other)
      if self.size == other.size
        if self.case_number == other.case_number
          (self.heavy+self.light) <=> (other.heavy+other.light)
        else
          self.case_number <=> other.case_number
        end
      else
        self.size <=> other.size
      end
    end
  end
end
