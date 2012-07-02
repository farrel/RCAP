module RCAP
  module CAP_1_2

    # A Polygon object is valid if
    # * it has a minimum of three points
    # * each Point object in the points collection is valid
    class Polygon < RCAP::Base::Polygon

      validates_length_of( :points, :minimum => 4 )

      # Creates a new Point object and adds it to the points array.
      #
      # @see Point#initialize
      def add_point( point_attributes = {})
        Point.new( point_attributes ).tap do |point|
          @points << point
        end
      end
    end
  end
end
