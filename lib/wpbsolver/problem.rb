module WPBSolver
  class Problem
    def initialize(ball_number, measure_number)
      @ball_number = ball_number
      @measure_number = measure_number
    end

    def solve_simple(number_of_solutions=1)
      @count = 0
      @results = []
      find_solution_simple([Balls.new(@ball_number)], @measure_number, [], number_of_solutions)
      (0...@results.count).each do |number|
        puts " -- Solution #{number+1} --"
        display(number)
      end
    end

    def find_solution_simple(state_set, max_measures, all_measures, number_of_solutions)
      if state_set.map(&:case_number).max > (Scale.number_of_outcomes ** max_measures)
        return
      end
      puts "Measures: #{max_measures}, states: #{state_set.count}"
      n = state_set.first.size
      ids = state_set.first.ids
      (1..(n/2)).each do |level|
        puts "Get #{2*level} balls"
        ids.combination(level*2).each do |subset|
          reverse = []
          subset.combination(level).each do |left|
            next if reverse.include?(left)
            right = subset - left
            reverse << right
            new_state_set = state_set.map do |bs|
              Scale.measure(bs, left, right)
            end.flatten
            if new_state_set.all? {|bs| bs.success? }
              @results << all_measures+[{left: left, right: right, set: new_state_set}]
              return if @results.count >= number_of_solutions
            elsif max_measures > 1
              find_solution_simple(new_state_set, max_measures-1, all_measures+[{left: left, right: right}], number_of_solutions)
              return if @results.count >= number_of_solutions
            end
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

    def solve_all
      @results = []
      @count = 0
      [1, 2, 0].                       # 1: left, 2: right, 0: no
      repeated_permutation(@measure_number). # possible measures of a ball
      select{|series| series != [0,0,0]}. # every ball should be measures at once
      combination(@ball_number).       # choosing 12 different measures: 9657700
      select do |mt|                   # keep only where put 4 balls onto both arms
        mt.reduce([0]*3*@measure_number) do |r,s|
          s.each_with_index{|v,idx| r[v+3*idx] += 1}
          r
        end.all? {|v| v == (@ball_number/3)}
      end.each do |mt|
        mt = mt.transpose
        @count += 1
        states = [Balls.new(@ball_number)]
        measures = []
        @measure_number.times do |level|
          left = []
          right = []
          mt[level].each_with_index do |pos,ball|
            if pos == 1
              left << ball+1
            elsif pos == 2
              right << ball+1
            end
          end
          measures << {left: left, right: right}
          states = states.map do |balls|
            Scale.measure(balls, left, right)
          end.flatten
          if states.all? {|balls| balls.success?}
            measures.last[:set] = states
            @results << measures
          end
        end
      end
      @results
    end
  end
end
