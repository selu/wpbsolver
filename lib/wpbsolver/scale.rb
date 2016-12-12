module WPBSolver
  class Scale
    def self.number_of_outcomes
      3
    end

    def self.measure(ball_set, left_arm, right_arm)
      [
        equal(ball_set, left_arm, right_arm),
        heavy(ball_set, left_arm, right_arm),
        heavy(ball_set, right_arm, left_arm)
      ]
    end

    def self.equal(ball_set, left_arm, right_arm)
      result = ball_set.dup
      [:heavy, :light].each do |state|
        result.unset(left_arm+right_arm, state)
      end
      result
    end

    def self.heavy(ball_set, heavy_arm, light_arm)
      result = ball_set.dup
      result.unsetexcept(light_arm, :light)
      result.unsetexcept(heavy_arm, :heavy)
    end
  end
end
