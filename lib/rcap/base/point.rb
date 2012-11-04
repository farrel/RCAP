module RCAP
  module Base
    class Point
      include Validation

      MAX_LONGITUDE = 180
      MIN_LONGITUDE = -180
      MAX_LATTITUDE = 90
      MIN_LATTITUDE= -90

      # @return [Numeric]
      attr_accessor( :lattitude )
      # @return [Numeric]
      attr_accessor( :longitude )

      validates_numericality_of( :lattitude, :longitude )
      validates_inclusion_of( :lattitude, :in => MIN_LATTITUDE..MAX_LATTITUDE )
      validates_inclusion_of( :longitude, :in => MIN_LONGITUDE..MAX_LONGITUDE)

      # @param [Hash] attributes
      # @option attributes [Numeric] :lattitude
      # @option attributes [Numeric] :longitude
      def initialize
        yield( self ) if block_given?
      end

      # Returns a string representation of the point of the form
      #  lattitude,longitude
      #
      # @return [String]
      def to_s
        "#{ self.lattitude },#{ self.longitude }"
      end

      # @return [String]
      def inspect
        '('+self.to_s+')'
      end

      # Two points are equivalent if they have the same lattitude and longitude
      #
      # @param [Point] other
      # @return [true, false]
      def ==( other )
        [ self.lattitude, self.longitude ] == [ other.lattitude, other.longitude ]
      end

      LATTITUDE_KEY = 'lattitude'
      LONGITUDE_KEY = 'longitude'

      # @return [Hash]
      def to_h
        RCAP.attribute_values_to_hash( [ LATTITUDE_KEY, self.lattitude ],
                                       [ LONGITUDE_KEY, self.longitude ])
      end

      # @param [Hash] point_hash
      # @return [Point]
      def self.from_h( point_hash )
        self.new do |point|
          point.lattitude = point_hash[ LATTITUDE_KEY ]
          point.longitude = point_hash[ LONGITUDE_KEY ]
        end
      end

      LONGITUDE_INDEX = 0
      LATTITUDE_INDEX = 1

      # @return [Array(Numeric, Numeric)]
      def to_a
        Array.new.tap do |array|
          array[ LONGITUDE_INDEX ] = self.longitude
          array[ LATTITUDE_INDEX ] = self.lattitude
        end
      end

      # @param [Array(Numeric, Numeric)]
      # @return [Point]
      def self.from_a( point_array )
        self.new do |point|
          point.longitude = point_array[ LONGITUDE_INDEX ]
          point.lattitude = point_array[ LATTITUDE_INDEX ]
        end
      end
    end
  end
end
