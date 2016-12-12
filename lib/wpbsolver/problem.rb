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
  end
end
