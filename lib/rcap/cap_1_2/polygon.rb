module RCAP
  module CAP_1_2

    # A Polygon object is valid if
    # * it has a minimum of three points
    # * each Point object in the points collection is valid
    class Polygon < RCAP::Base::Polygon

      validates_length_of( :points, :minimum => 4 )

      def point_class
        Point
      end
    end
  end
end
