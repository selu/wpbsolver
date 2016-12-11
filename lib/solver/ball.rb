module Solver
  class Ball
    EQUAL = 1
    HEAVY = 2
    LIGHT = 4

    attr_reader :id

    def initialize(id, states=nil)
      @id = id
      @states = states || (EQUAL|HEAVY|LIGHT)
    end

    def error?
      @states == 0
    end

    def fixed?
      [EQUAL,HEAVY,LIGHT].include?(@states)
    end

    def state
      @states if fixed?
    end

    def count
      (@states & HEAVY)/HEAVY +
      (@states & LIGHT)/LIGHT
    end

    def unset(state)
      @states &= ~state
    end

    def set(state)
      @states |= state
    end

    def inspect
      "#<#{self.class}: #{id} - {#{self.to_a.join("|")}}"
    end

    def to_a
      ary = []
      ary << "EQUAL" if @states & EQUAL > 0
      ary << "HEAVY" if @states & HEAVY > 0
      ary << "LIGHT" if @states & LIGHT > 0
      ary
    end
  end
end
