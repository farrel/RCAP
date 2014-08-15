module RCAP
  module CAP_1_0
    # A Point object is valid if
    # * it has a lattitude within the minimum and maximum lattitude values
    # * it has a longitude within the minimum and maximum longitude values
    class Point < RCAP::Base::Point
    end
  end
end
