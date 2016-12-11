module Solver
  class Problem
    def initialize(ball_number, measure_number)
      @ball_number = ball_number
      @measure_number = measure_number
    end

    def solve
      @count = 0
      @results = []
      find_solution([BallSet.new(@ball_number)], @measure_number, [])
      @results.count
    end

    def counter
      @count += 1
      if (@count % 100000) == 0
        puts "Count: #{@count}, results: #{@results.count}"
      end
    end

    def find_solution(state_set, max_measures, all_measures)
      if state_set.map(&:case_number).max > (3 ** max_measures)
        #puts "too many cases for remaining measures"
        #puts "available: #{3 ** max_measures}"
        #state_set.each do |bs|
        #  print "N: #{bs.case_number} - "
        #  p bs
        #end
        return nil
      end
      puts "Measures: #{max_measures}, states: #{state_set.count}"
      n = state_set.first.balls.size
      ids = state_set.first.balls.map(&:id)
      (1..(n/2)).each do |level|
        puts "Get #{2*level} balls"
        ids.combination(level*2).each do |subset|
          reverse = []
          subset.combination(level).each do |left|
            next if reverse.include?(left)
            right = subset - left
            reverse << right
            new_state_set = state_set.map do |bs|
              Balance.measure(bs, left, right)
            end.flatten
            if new_state_set.all? {|bs| bs.success? }
              @results << all_measures+[{left: left, right: right, set: new_state_set}]
            elsif max_measures > 1
              find_solution(new_state_set, max_measures-1, all_measures+[{left: left, right: right}])
            end
            counter if max_measures == 1
          end
        end
      end
      nil
    end

    def display(number)
      result = @results[number]
      if result.nil?
        puts "no solution"
        return
      end
      measures = result.size
      puts "Measures:"
      result.each_with_index do |m,idx|
        puts "  #{idx+1}. left: #{m[:left].join(",")}, right: #{m[:right].join(",")}"
      end
      puts "Solution:"
      result.last[:set].each_with_index do |s,idx|
        mresults = (1..measures).map{|level| ["EQUAL", "HEAVY", "LIGHT"][(idx/(3 ** (measures-level)))%3]}.join(",")
        puts "#{s.result} (#{mresults})"
      end
      nil
    end
  end
end
