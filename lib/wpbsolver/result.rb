module WPBSolver
  class Result
    attr_reader :mcomb, :measures, :states, :good

    def initialize(params)
      raise ArgumentError, "both :mcomb & :measures should not be empty" if (params.keys & [:mcomb, :measures]).empty?
      @mcomb = params[:mcomb]
      @measures = params[:measures] || generate_measures
      @mcomb ||= generate_mcomb
      @states = params[:states] || generate_states
      @good = params[:good] || @states.all? {|balls| balls.success?}
    end

    def generate_measures
      @mcomb[0].size.times.map do |level|
        left = []
        right = []
        @mcomb.transpose[level].each_with_index do |pos,ball|
          if pos > 0
            left << ball+1
          elsif pos < 0
            right << ball+1
          end
        end
        {left: left, right: right}
      end
    end

    def generate_mcomb
      (1..@measures.map{|m| m[:left]+m[:right]}.reduce(:+).max).map do |ball|
        @measures.map do |measure|
          case
          when measure[:left].include?(ball)
            1
          when measure[:right].include?(ball)
            -1
          else
            0
          end
        end
      end
    end

    def generate_states
      @measures.inject([Balls.new(@mcomb.size)]) do |states,measure|
        states.map do |state|
          Scale.measure(state, measure[:left], measure[:right])
        end.flatten
      end
    end

    def to_s
    end
  end
end
