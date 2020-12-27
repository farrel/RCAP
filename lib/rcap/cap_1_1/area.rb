# frozen_string_literal: true

module RCAP
  module CAP_1_1
    # An Area object is valid if
    # * it has an area description
    # * all Circle objects contained in circles are valid
    # * all Geocode objects contained in geocodes are valid
    # * all Polygon objects contained in polygons are valid
    # * altitude has a value if ceiling is set
    class Area < RCAP::Base::Area
      # @return [String]
      def xmlns
        Alert::XMLNS
      end

      # @return [Class]
      def polygon_class
        Polygon
      end

      # @return [Class]
      def circle_class
        Circle
      end

      # @return [Class]
      def geocode_class
        Geocode
      end
    end
  end
end
