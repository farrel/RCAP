module RCAP
  module CAP_1_1
    # A Polygon object is valid if
    # * if points are given it has a minimum of three points
    # * each Point object in the points collection is valid
    class Polygon < RCAP::Base::Polygon
      # @return [Class]
      def point_class
        Point
      end
    end
  end
end
