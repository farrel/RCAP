module RCAP
  module CAP_1_0
    # A Polygon object is valid if
    # * it has a minimum of three points
    # * each Point object in the points collection is valid
    class Polygon
      include Validation

      # Collection of Point objects.
      attr_reader( :points )

      validates_collection_of( :points )
      validates_length_of( :points, :minimum => 3 )
      validates_equality_of_first_and_last( :points )

      XML_ELEMENT_NAME = 'polygon'                   
      XPATH            = "cap:#{ XML_ELEMENT_NAME }" 

      def initialize( attributes = {})
        @points = Array( attributes[ :points ])
      end

      # Creates a new Point object and adds it to the points array. The
      # poitn_attributes are passed as a parameter to Point.new.
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

      def inspect 
        "(#{ @points.map{|point| point.inspect}.join(', ')})"
      end

      def to_xml_element 
        xml_element = REXML::Element.new( XML_ELEMENT_NAME )
        xml_element.add_text( self.to_s )
        xml_element
      end

      # Two polygons are equivalent if their collection of points is equivalent.
      def ==( other )
        @points == other.points
      end

      def self.parse_polygon_string( polygon_string ) 
        polygon_string.split( ' ' ).map{ |coordinate_string| coordinate_string.split( ',' ).map{|coordinate| coordinate.to_f }}
      end

      def self.from_xml_element( polygon_xml_element ) 
        if !polygon_xml_element.text.nil? && !polygon_xml_element.text.empty?
          coordinates = self.parse_polygon_string( polygon_xml_element.text )
          points = coordinates.map{ |lattitude, longitude| Point.new( :lattitude => lattitude, :longitude => longitude )}
          polygon = self.new( :points => points )
        else
          self.new
        end
      end


      def to_yaml( options = {} ) 
        @points.map{ |point| [ point.lattitude, point.longitude ]}.to_yaml( options )
      end

      def self.from_yaml_data( polygon_yaml_data ) 
        self.new( :points => Array( polygon_yaml_data ).map{ |lattitude, longitude| Point.new( :lattitude => lattitude, :longitude => longitude )})
      end

      POINTS_KEY  = 'points' 

      def to_h 
        { POINTS_KEY => @points.map{ |point| point.to_h }}
      end

      def self.from_h( polygon_hash ) 
        self.new( :points => polygon_hash[ POINTS_KEY ].map{ |point_hash| Point.from_h( point_hash )})
      end
    end
  end
end
