require "yaml"

module WPBSolver
  class Problem
    attr_reader :ball_number, :measure_number, :results

    def initialize(measure_number,ball_number=nil)
      @measure_number = measure_number
      @ball_number = ball_number||max_ball_number
      @third = @ball_number/3
      raise ArgumentError, "Ball number is too high" if @ball_number > max_ball_number
    end

    def max_ball_number
      3**@measure_number/6*3   # 2 -> 3, 3 -> 12, 4 -> 39, 5 -> 120
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
      measures = result[:measures].size
      puts "Measures:"
      result[:measures].each_with_index do |m,idx|
        puts "  #{idx+1}. left: #{m[:left].join(",")}, right: #{m[:right].join(",")}"
      end
      if result[:good]
        puts "Solution:"
        result[:states].each_with_index do |s,idx|
          mresults = (1..measures).map{|level| ["EQUAL", "HEAVY", "LIGHT"][(idx/(3 ** (measures-level)))%3]}.join(",")
          puts "#{s.result} (#{mresults})"
        end
      else
        puts "Not a solution!"
      end
      nil
    end

    def solve_all
      @results = []
      @count = 0
      [1, 2, 0].                       # 1: left, 2: right, 0: no
      repeated_permutation(@measure_number). # possible measures of a ball
      select{|series| series != [0]*@measure_number}. # every ball should be measures at once
      combination(@ball_number).each do |mt|
        # keep only where put 4 balls onto both arms
        next unless mt.reduce([0]*3*@measure_number) do |r,s|
          s.each_with_index{|v,idx| r[v+3*idx] += 1}
          r
        end.all? {|v| v == @third}
        # non of the balls can be measured in mirror of any other
        next if mt.combination(2).any? do |pair|
          pair.transpose.map{|l| l.reduce(&:+)%3}.reduce(&:+) == 0
        end
        @count += 1
        states = [Balls.new(@ball_number)]
        measures = []
        @measure_number.times do |level|
          left = []
          right = []
          mt.transpose[level].each_with_index do |pos,ball|
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
        end
        @results << Result.new(
          measures: measures,
          mcomb: mt,
          states: states,
          good: states.all? {|balls| balls.success?}
        )
      end
      @results
    end

    def solve_all_fast(max_result=nil)
      @results = []
      generate_combinations.each do |mt|
        states = [Balls.new(@ball_number)]
        measures = []
        @measure_number.times do |level|
          left = []
          right = []
          mt.transpose[level].each_with_index do |pos,ball|
            if pos > 0
              left << ball+1
            elsif pos < 0
              right << ball+1
            end
          end
          measures << {left: left, right: right}
          states = states.map do |balls|
            Scale.measure(balls, left, right)
          end.flatten
        end
        @results << Result.new(
          measures: measures,
          mcomb: mt,
          states: states,
          good: states.all? {|balls| balls.success?}
        )
        break if !max_result.nil? && @results.count >= max_result
      end
      @results
    end

    def generate_combinations
      return enum_for(:generate_combinations) unless block_given?

      series = [1,-1,0].repeated_permutation(@measure_number).to_a-[[0]*@measure_number]
      counts = series.map{|i| i.map{|v| [1,0,0].rotate(v)}.flatten}
      len = series.size
      mirrors = series.map do |i|
        series.find_index do |m|
          [i,m].transpose.map{|v| v.reduce(&:+)}.all? {|s| s==0}
        end
      end
      stack = [0]*@ball_number
      aggr = []
      lev = 0
      ball_limit = @third
      finish = false
      begin
        if lev > 0
          aggr[lev] = counts[stack[lev]].zip(aggr[lev-1]).map{|v| v.reduce(:+)}
        else
          aggr[0] = counts[stack[0]]
        end
        lev += 1
        while lev < @ball_number && !finish do
          stack[lev] = stack[lev-1]+1
          aggr[lev] = counts[stack[lev]].zip(aggr[lev-1]).map{|v| v.reduce(:+)}
          while (stack[0...lev].include?(mirrors[stack[lev]]) ||
                 aggr[lev].any? {|s| s>ball_limit}) && !finish
            lev += 1
            begin
              if lev == 0
                finish = true
                break
              end
              lev -= 1
              stack[lev] += 1
            end while stack[lev]+@ball_number == len+lev+1
            if lev > 0
              aggr[lev] = counts[stack[lev]].zip(aggr[lev-1]).map{|v| v.reduce(:+)}
            else
              aggr[0] = counts[stack[0]]
            end
          end
          lev += 1
        end
        yield stack.map{|idx| series[idx]} unless finish
        lev -= 1
        begin
          lev += 1
          begin
            if lev == 0
              finish = true
              break
            end
            lev -= 1
            stack[lev] += 1
          end while (stack[lev]+@ball_number == len+lev+1)
          if lev > 0
            aggr[lev] = counts[stack[lev]].zip(aggr[lev-1]).map{|v| v.reduce(:+)}
          else
            aggr[0] = counts[stack[0]]
          end
        end while (stack[0...lev].include?(mirrors[stack[lev]]) ||
                  aggr[lev].any? {|s| s>ball_limit}) && !finish
      end until finish
    end

    def measure_series
      # all working measure series
      series = [1,-1,0].repeated_permutation(@measure_number).to_a-[[0]*@measure_number]
      # remove mirrored series
      (0...@measure_number).each do |level|
        series.delete_if do |s|
          (0..level).all? {|idx| s[idx] == (idx == level ? -1 : 0)}
        end
      end
      series
    end

    def generate_good_combinations
      return enum_for(:generate_good_combinations) unless block_given?

      spart = measure_series.group_by do |s|
        case
        when s.all?{|v| v!=0}
          :variable
        else
          :fix
        end
      end

      spart[:variable].combination(spart[:variable].count-1).each do |variable|
        base = variable + spart[:fix]
        [1,-1].repeated_permutation(base.count-1).each do |mirror|
          chosen = base.map.with_index do |s,i|
            s.map{|v| v*([1]+mirror)[i]}
          end
          yield chosen if chosen.reduce([0]*3*@measure_number) do |r,s|
            s.each_with_index{|v,idx| r[v+3*idx] += 1}
            r
          end.all? {|v| v == @third}
        end
      end
    end

    def generate_uniq_good_combinations
      return enum_for(:generate_uniq_good_combinations) unless block_given?

      base = measure_series.delete_if do |s|
        s == [1] + [-1]*(s.count-1)
      end

      ones_start = Array.new(measure_number)
      ones_end = Array.new(measure_number)
      j = 1
      level = 0
      ones_start[level] = j
      while j<ball_number do
        if base[j][level] == 1
          j += 1
        else
          ones_end[level] = j
          level += 1
          ones_start[level] = j
        end
      end
      ones_end[level] = j

      result = base.map {|col| col.dup}
      comb = Array.new(measure_number,false)
      mirror = Array.new(ball_number,1)
      counts = Array.new(measure_number) {Array.new(3)}

      count = 0
      result_count = 0
      prev_time = Time.now

      level = 0
      while level>=0 do
        count += 1
        if count % 1000000 == 0
          next_time = Time.now
          puts "count: #{count}, results: #{result_count}, duration: #{(next_time-prev_time).round(2)}s"
          prev_time = next_time
        end
        counts[0].map!{0}
        result[0...ones_start[level]].each{|e| counts[0][e[level]+1] += 1}
        if counts[0].any?{|c| c>@third}
          level -= 1
          next
        end

        wrong = false
        unless comb[level]
          (ones_start[level]...@ball_number).each do |idx|
            mirror[idx] = ((ones_end[level]-@third+counts[0][0]...ones_end[level]).include?(idx) ? -1 : 1)
          end
          comb[level] = true
        else
          wrong = !mirror.prev_permutation(ones_start[level], ones_end[level])
        end
        while !wrong do
          (ones_start[level]...ones_end[level]).each do |pos|
            measure_number.times.each{|i| result[pos][i] = base[pos][i] * mirror[pos]}
          end
          (level+1...measure_number).each do |i|
            counts[i].map!{0}
            ones_end[level].times.each do |pos|
              counts[i][result[pos][i]+1] += 1
            end
          end
          break if counts[level+1..-1].all?{|a| a.all?{|c| c<=@third}}
          wrong = !mirror.prev_permutation(ones_start[level], ones_end[level])
        end
        if wrong
          comb[level] = false
          level -= 1
        else
          level += 1
          if level == @measure_number
            yield result
            result_count += 1
            level -= 1
            next
          end
        end
      end
      puts "final count: #{count}"
    end

    def save_results
      File.open("results_#{@ball_number}_#{@measure_number}.yml","w") do |f|
        f.write(@results.to_yaml)
      end
    end

    def equiv
      grps = []
      @results.each do |r|
        rcomb = r.mcomb
        group = grps.find do |g|
          gcomb = g[0].mcomb
          [1,-1].repeated_permutation(@measure_number).any? do |p|
            rcomb.all? do |l|
              gcomb.include?(l.map.with_index {|v,idx| v*p[idx]})
            end
          end
        end
        if group
          group << r
        else
          grps << [r]
        end
      end
      grps
    end

    # e.map{|g| g.sort.first.mcomb.transpose}.each{|m| puts "---"*12; m.each{|l| l.each{|v| print "%2d " % v}; puts}};
  end
end
