module WPBSolver
  class Measure
    attr_reader :left, :right

    def initialize(ball_number)
      @ball_number = ball_number
      @arm_size = @ball_number/3
      @comb_pick = (1..@ball_number).to_a.combination(@arm_size*2)
      next_pick
      next_sort
    end

    def next
      begin
        next_sort
      rescue StopIteration
        begin
          next_pick
        rescue StopIteration
          return false
        end
        retry
      end
      true
    end

    def next_sort
      begin
        @left = @comb_sort.next
      end while @reversed.include?(@left)
      @right = @selected - @left
      @reversed << @right
    end

    def next_pick
      @selected = @comb_pick.next
      @comb_sort = @selected.combination(@arm_size)
      @reversed = []
    end
  end
end
