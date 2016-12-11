require "solver/version"

module Solver
  def self.measure_number(ball_set)
    n = ball_set.balls.size
    (1..(n/2)).inject(0) do |s,k|
      s += nCr(n,k*2)*nCr(k*2,k)/2
    end
  end

  def self.nCr(n,r)
    return 1 if n == r
    return n if r == 1
    return 1 if n == 0
    nCr(n-1,r) + nCr(n-1,r-1)
  end
end

require "solver/ball"
require "solver/ball_set"
require "solver/balance"
require "solver/problem"
