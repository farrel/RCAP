module RCAP
  module CAP_1_0

    # A Polygon object is valid if
    # * it has a minimum of three points
    # * each Point object in the points collection is valid
    class Polygon < RCAP::Base::Polygon

      # Creates a new Point object and adds it to the points array.
      #
      # @see Point#initialize
      def add_point( point_attributes = {})
        point = Point.new( point_attributes )
        @points << point
        point
      end

      # @return [Polygon]
      def self.from_xml_element( polygon_xml_element ) 
        if !polygon_xml_element.text.nil? && !polygon_xml_element.text.empty?
          coordinates = self.parse_polygon_string( polygon_xml_element.text )
          points = coordinates.map{ |lattitude, longitude| Point.new( :lattitude => lattitude, :longitude => longitude )}
          polygon = self.new( :points => points )
        else
          self.new
        end
      end

      # @return [Polygon]
      def self.from_h( polygon_hash ) 
        self.new( :points => polygon_hash[ POINTS_KEY ].map{ |point_hash| Point.from_h( point_hash )})
      end
    end
  end
end
