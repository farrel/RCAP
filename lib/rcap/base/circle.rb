module RCAP
  module Base
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
      def initialize
        yield( self ) if block_given?
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
        self.from_a( self.parse_circle_string( circle_xml_element.text ))
      end

      # Two circles are equivalent if their lattitude, longitude and radius are equal.
      #
      # @param [Circle] other
      # @return [true,false]
      def ==( other )
        self.to_a == other.to_a
      end

      # @param [Array(Numeric, Numeric, Numeric)] circle_yaml_data lattitude, longitude, radius
      # @return [Circle]
      def self.from_yaml_data( circle_yaml_data )
        lattitude, longitude, radius = circle_yaml_data
        self.new do |circle|
          circle.lattitude = lattitude
          circle.longitude = longitude
          circle.radius    = radius
        end
      end

      RADIUS_KEY    = 'radius'
      # @return [Hash]
      def to_h
        RCAP.attribute_values_to_hash( [ RADIUS_KEY,    @radius ],
                                       [ LATTITUDE_KEY, @lattitude ],
                                       [ LONGITUDE_KEY, @longitude ])
      end

      # @param [Hash] circle_hash
      # @return [Circle]
      def self.from_h( circle_hash )
        self.new do |circle|
          circle.radius    = circle_hash[ RADIUS_KEY ]
          circle.lattitude = circle_hash[ LATTITUDE_KEY ]
          circle.longitude = circle_hash[ LONGITUDE_KEY ]
        end
      end

      # @return [Array(Numeric,Numeric,Numeric)]
      def to_a
        [ @lattitude, @longitude, @radius ]
      end

      RADIUS_INDEX = 2

      # @param [Array] circle_array
      # @return [Circle]
      def self.from_a( circle_array )
        self.new do |circle|
          circle.longitude = circle_array[ LONGITUDE_INDEX ]
          circle.lattitude = circle_array[ LATTITUDE_INDEX ]
          circle.radius    = circle_array[ RADIUS_INDEX ]
        end
      end
    end
  end
end
