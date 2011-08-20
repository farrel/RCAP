module RCAP
  module CAP_1_2
    # A Circle object is valid if
    # * it has a valid lattitude and longitude
    # * it has a radius with a value greater than zero
    class Circle < Point
      include Validation

      # Expresed in kilometers
      attr_accessor( :radius )

      validates_presence_of( :radius )
      validates_numericality_of( :radius , greater_than_or_equal: 0 )

      XML_ELEMENT_NAME = 'circle' 

      XPATH = 'cap:circle' 

      def initialize( attributes = {} )
        super( attributes )
        @radius = attributes[ :radius ]
      end

      # Returns a string representation of the circle of the form
      #  lattitude,longitude,radius
      def to_s  
        "#{ @lattitude },#{ @longitude } #{ @radius }"
      end

      def inspect 
        "(#{ self.to_s })"
      end

      def to_xml_element 
        xml_element = REXML::Element.new( XML_ELEMENT_NAME )
        xml_element.add_text( self.to_s )
        xml_element
      end

      def to_xml 
        self.to_xml_element.to_s
      end

      def self.parse_circle_string( circle_string ) 
        coordinates, radius = circle_string.split( ' ' )
        lattitude, longitude = coordinates.split( ',' )
        [ lattitude, longitude, radius ].map{ |e| e.to_f }
      end

      def self.from_xml_element( circle_xml_element ) 
        lattitude, longitude, radius = self.parse_circle_string( circle_xml_element.text )
        circle = self.new( :lattitude => lattitude,
                          :longitude => longitude,
                          :radius => radius )
      end

      # Two circles are equivalent if their lattitude, longitude and radius are equal.
      def ==( other )
        [ @lattitude, @longitude, @radius ] == [ other.lattitude, other.longitude, other.radius ]
      end

      def self.from_yaml_data( circle_yaml_data ) 
        lattitude, longitude,radius = circle_yaml_data
        self.new( :lattitude => lattitude, :longitude => longitude, :radius => radius )
      end

      RADIUS_KEY    = 'radius' 
      LATTITUDE_KEY = 'lattitude' 
      LONGITUDE_KEY = 'longitude' 
      def to_h 
        RCAP.attribute_values_to_hash( [ RADIUS_KEY, @radius ],
                                       [ LATTITUDE_KEY, @lattitude ],
                                       [ LONGITUDE_KEY, @longitude ])
      end

      def self.from_h( circle_hash ) 
        self.new( :radius => circle_hash[ RADIUS_KEY ],
                  :lattitude => circle_hash[ LATTITUDE_KEY ],
                  :longitude => circle_hash[ LONGITUDE_KEY ])
      end
    end
  end
end
