module Solver
  class Balance
    def self.measure(ball_set, left_arm, right_arm)
      [
        equal(ball_set, left_arm, right_arm),
        heavy(ball_set, left_arm, right_arm),
        heavy(ball_set, right_arm, left_arm)
      ]
    end

    def self.equal(ball_set, left_arm, right_arm)
      result = ball_set.dup
      result.balls.select {|b| (left_arm+right_arm).include?(b.id)}.each do |ball|
        ball.unset(Ball::HEAVY|Ball::LIGHT)
      end
      result
    end

    def self.heavy(ball_set, heavy_arm, light_arm)
      result = ball_set.dup
      result.balls.each do |ball|
        case
        when heavy_arm.include?(ball.id)
          ball.unset(Ball::LIGHT)
        when light_arm.include?(ball.id)
          ball.unset(Ball::HEAVY)
        else
          ball.unset(Ball::HEAVY|Ball::LIGHT)
        end
      end
      result
    end
  end
end
