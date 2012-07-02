module RCAP
  module Base
    class Polygon
      include Validation

      # @return [Array<Point>] Collection of {Point} objects 
      attr_reader( :points )

      validates_collection_of( :points )
      validates_length_of( :points, :minimum => 3 )
      validates_equality_of_first_and_last( :points )

      XML_ELEMENT_NAME = 'polygon'                   
      XPATH            = "cap:#{ XML_ELEMENT_NAME }" 
      
      # @param [Hash] attributes
      # @option attributes [Array<Point>] :points Collection of {Point} objects
      def initialize( attributes = {})
        @points = attributes[ :points ] || []
      end

      # Creates a new Point object and adds it to the points array.
      #
      # @see Point#initialize
      def add_point( point_attributes = {})
        point = Point.new( point_attributes )
        @points << point
        point
      end

      # Returns a string representation of the polygon of the form
      #  points[0] points[1] points[2] ...
      # where each point is formatted with Point#to_s
      def to_s
        @points.join( ' ' )
      end

      # @return [String]
      def inspect 
        "(#{ @points.map{|point| point.inspect}.join(', ')})"
      end

      # @return [REXML::Element]
      def to_xml_element 
        xml_element = REXML::Element.new( XML_ELEMENT_NAME )
        xml_element.add_text( self.to_s )
        xml_element
      end

      # @return [String]
      def to_xml
        self.to_xml_element.to_s
      end

      # Two polygons are equivalent if their collection of points is equivalent.
      # 
      # @return [true,false]
      def ==( other )
        @points == other.points
      end

      # @return [Array<Array(Numeric,Numeric)>]
      def self.parse_polygon_string( polygon_string ) 
        polygon_string.split( ' ' ).map{ |coordinate_string| coordinate_string.split( ',' ).map{|coordinate| coordinate.to_f }}
      end

      # @return [String]
      def to_yaml( options = {} ) 
        @points.map{ |point| [ point.lattitude, point.longitude ]}.to_yaml( options )
      end

      POINTS_KEY  = 'points' 

      # @return [Hash]
      def to_h 
        { POINTS_KEY => @points.map{ |point| point.to_a }}
      end
    end
  end
end
