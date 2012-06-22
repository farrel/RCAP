module RCAP
  module CAP_1_0
    # A Circle object is valid if
    # * it has a valid lattitude and longitude
    # * it has a radius with a value greater than zero
    class Circle < Point
      include Validation

      # @return [Numeric] Expresed in kilometers 
      attr_accessor( :radius )

      validates_presence_of( :radius )
      validates_numericality_of( :radius , greater_than_or_equal: 0 )

      XML_ELEMENT_NAME = 'circle' 

      XPATH = 'cap:circle' 

      # @param [Hash] attributes
      # @option attributes [Numeric] :lattitude
      # @option attributes [Numeric] :longitude
      # @option attributes [Numeric] :radius
      def initialize( attributes = {} )
        super( attributes )
        @radius = attributes[ :radius ]
      end

      # Returns a string representation of the circle of the form
      #  lattitude,longitude radius
      #
      # @return [String]
      def to_s  
        "#{ @lattitude },#{ @longitude } #{ @radius }"
      end

      # @return [String]
      def inspect 
        "(#{ self.to_s })"
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

      # Parses a circle string of the form
      #   lattitude,longitude radius
      #
      # @param [String] circle_string
      # @return [Array(Float,Float,Float)]
      def self.parse_circle_string( circle_string ) 
        coordinates, radius = circle_string.split( ' ' )
        lattitude, longitude = coordinates.split( ',' )
        [ lattitude, longitude, radius ].map{ |e| e.to_f }
      end

      # @param [REXML::Element] circle_xml_element
      # @return [Circle]
      def self.from_xml_element( circle_xml_element ) 
        lattitude, longitude, radius = self.parse_circle_string( circle_xml_element.text )
        circle = self.new( :lattitude => lattitude,
                           :longitude => longitude,
                           :radius    => radius )
      end

      # Two circles are equivalent if their lattitude, longitude and radius are equal.
      #
      # @param [Circle] other
      # @return [true,false]
      def ==( other )
        [ @lattitude, @longitude, @radius ] == [ other.lattitude, other.longitude, other.radius ]
      end

      # @param [Array(Numeric, Numeric, Numeric)] circle_yaml_data lattitude, longitude, radius 
      # @return [Circle]
      def self.from_yaml_data( circle_yaml_data ) 
        lattitude, longitude, radius = circle_yaml_data
        self.new( :lattitude => lattitude, :longitude => longitude, :radius => radius )
      end

      RADIUS_KEY    = 'radius'    
      LATTITUDE_KEY = 'lattitude' 
      LONGITUDE_KEY = 'longitude' 

      # @return [Hash]
      def to_h 
        RCAP.attribute_values_to_hash( [ RADIUS_KEY,    @radius ],
                                       [ LATTITUDE_KEY, @lattitude ],
                                       [ LONGITUDE_KEY, @longitude ])
      end

      # @param [Hash] circle_hash
      # @return [Circle]
      def self.from_h( circle_hash ) 
        self.new( :radius    => circle_hash[ RADIUS_KEY ],
                  :lattitude => circle_hash[ LATTITUDE_KEY ],
                  :longitude => circle_hash[ LONGITUDE_KEY ])
      end
    end
  end
end
