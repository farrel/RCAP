# frozen_string_literal: true

module RCAP
  module Base
    class Point
      include Validation

      MAX_LONGITUDE = 180
      MIN_LONGITUDE = -180
      MAX_LATTITUDE = 90
      MIN_LATTITUDE = -90

      # @return [Numeric]
      attr_accessor(:lattitude)
      # @return [Numeric]
      attr_accessor(:longitude)

      validates_numericality_of(:lattitude, :longitude)
      validates_inclusion_of(:lattitude, in: MIN_LATTITUDE..MAX_LATTITUDE)
      validates_inclusion_of(:longitude, in: MIN_LONGITUDE..MAX_LONGITUDE)

      # @param [Hash] attributes
      # @option attributes [Numeric] :lattitude
      # @option attributes [Numeric] :longitude
      def initialize
        yield(self) if block_given?
      end

      # Returns a string representation of the point of the form
      #  lattitude,longitude
      #
      # @return [String]
      def to_s
        "#{lattitude},#{longitude}"
      end

      # @return [String]
      def inspect
        '(' + to_s + ')'
      end

      # Two points are equivalent if they have the same lattitude and longitude
      #
      # @param [Point] other
      # @return [true, false]
      def ==(other)
        [lattitude, longitude] == [other.lattitude, other.longitude]
      end

      LATTITUDE_KEY = 'lattitude'
      LONGITUDE_KEY = 'longitude'

      # @return [Hash]
      def to_h
        RCAP.attribute_values_to_hash([LATTITUDE_KEY, lattitude],
                                      [LONGITUDE_KEY, longitude])
      end

      # @param [Hash] point_hash
      # @return [Point]
      def self.from_h(point_hash)
        new do |point|
          point.lattitude = point_hash[LATTITUDE_KEY].to_f
          point.longitude = point_hash[LONGITUDE_KEY].to_f
        end
      end

      LATTITUDE_INDEX = 0
      LONGITUDE_INDEX = 1

      # @return [Array(Numeric, Numeric)]
      def to_a
        [].tap do |array|
          array[LATTITUDE_INDEX] = lattitude
          array[LONGITUDE_INDEX] = longitude
        end
      end

      # @param [Array(Numeric, Numeric)] point_array
      # @return [Point]
      def self.from_a(point_array)
        new do |point|
          point.lattitude = point_array[LATTITUDE_INDEX].to_f
          point.longitude = point_array[LONGITUDE_INDEX].to_f
        end
      end
    end
  end
end
