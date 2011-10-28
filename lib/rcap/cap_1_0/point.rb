module RCAP
  module CAP_1_0
    # A Point object is valid if
    # * it has a lattitude within the minimum and maximum lattitude values
    # * it has a longitude within the minimum and maximum longitude values
    class Point
      include Validation

      MAX_LONGITUDE = 180
      MIN_LONGITUDE = -180
      MAX_LATTITUDE = 90
      MIN_LATTITUDE = -90

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
      def initialize( attributes = {} )
        @lattitude = attributes[ :lattitude ]
        @longitude = attributes[ :longitude ]
      end

      # Returns a string representation of the point of the form
      #  lattitude,longitude
      #
      # @return [String]
      def to_s
        "#{ @lattitude },#{ @longitude }"
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
        [ @lattitude, @longitude ] == [ other.lattitude, other.longitude ]
      end

      LATTITUDE_KEY = 'lattitude'  
      LONGITUDE_KEY = 'longitude'  

      # @return [Hash]
      def to_h 
        RCAP.attribute_values_to_hash(
          [ LATTITUDE_KEY, @lattitude ],
          [ LONGITUDE_KEY, @longitude ])
      end

      # @param [Hash] point_hash
      # @return [Point]
      def self.from_h( point_hash ) 
        self.new( :lattitude => point_hash[ LATTITUDE_KEY ], :longitude => point_hash[ LONGITUDE_KEY ])
      end
    end
  end
end
