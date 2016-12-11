module Solver
  class BallSet
    attr_reader :balls
    def initialize(count)
      @balls = (1..count).map {|n| Ball.new(n)}
    end

    def initialize_copy(orig)
      super
      @balls = @balls.inject([]) {|a,b| a << b.dup}
    end

    def case_number
      @balls.inject(0) {|c,b| c += b.count}
    end

    def success?
      case_number <= 1
    end

    def result
      if case_number == 0
        return "impossible"
      elsif case_number == 1
        ball = @balls.find {|b| b.count > 0}
        ball.unset(Ball::EQUAL)
        return "#{ball.id} is #{ball.to_a.first}"
      else
        return "no solution #{inspect}"
      end
    end
  end
end
