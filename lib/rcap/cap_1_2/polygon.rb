# frozen_string_literal: true

module RCAP
  module CAP_1_2
    # A Polygon object is valid if
    # * if points are given it has a minimum of three points
    # * each Point object in the points collection is valid
    class Polygon < RCAP::Base::Polygon
      validates_length_of(:points, minimum: 4, allow_blank: true)

      # @return [Class]
      def point_class
        Point
      end
    end
  end
end
