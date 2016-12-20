require "wpbsolver/version"

module WPBSolver
  def self.measure_number(ball_set)
    n = ball_set.size
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

  def self.all_measures(ball_number)
    m = Measure.new(ball_number)
    result = []
    begin
      result << [m.left, m.right]
    end while m.next
    result
  end
end

require "wpbsolver/balls"
require "wpbsolver/measure"
require "wpbsolver/scale"
require "wpbsolver/result"
require "wpbsolver/problem"
