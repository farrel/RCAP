# frozen_string_literal: true

module RCAP
  module Base
    class Polygon
      include Validation

      # @return [Array<Point>] Collection of {Point} objects
      attr_reader(:points)

      validates_collection_of(:points)
      validates_length_of(:points, minimum: 3, allow_blank: true)
      validates_equality_of_first_and_last(:points, allow_empty: true)

      XML_ELEMENT_NAME = 'polygon'
      XPATH            = "cap:#{XML_ELEMENT_NAME}"

      # @param [Hash] attributes
      # @option attributes [Array<Point>] :points Collection of {Point} objects
      def initialize
        @points = []
        yield(self) if block_given?
      end

      def add_point
        point = point_class.new
        yield(point) if block_given?
        points << point
        point
      end

      # Returns GeoJSON representation of the polygon
      def to_geojson
        coordinates = @points.map { |point| [point.longitude, point.lattitude] }
        { 'type' => 'Polygon', 'coordinates' => [coordinates] }.to_json
      end

      # Returns a string representation of the polygon of the form
      #  points[0] points[1] points[2] ...
      # where each point is formatted with Point#to_s
      def to_s
        @points.join(' ')
      end

      # @return [String]
      def inspect
        "(#{@points.map(&:inspect).join(', ')})"
      end

      # @return [REXML::Element]
      def to_xml_element
        xml_element = REXML::Element.new(XML_ELEMENT_NAME)
        xml_element.add_text(to_s)
        xml_element
      end

      # @return [Polygon]
      def self.from_xml_element(polygon_xml_element)
        if !polygon_xml_element.text.nil? && !polygon_xml_element.text.empty?
          coordinates = parse_polygon_string(polygon_xml_element.text)
          new do |polygon|
            coordinates.each do |lattitude, longitude|
              polygon.add_point do |point|
                point.lattitude = lattitude.to_f
                point.longitude = longitude.to_f
              end
            end
          end
        else
          new
        end
      end

      # @return [String]
      def to_xml
        to_xml_element.to_s
      end

      # Two polygons are equivalent if their collection of points is equivalent.
      #
      # @return [true,false]
      def ==(other)
        @points == other.points
      end

      # @return [Array<Array(Numeric,Numeric)>]
      def self.parse_polygon_string(polygon_string)
        polygon_string.split(' ').map { |coordinate_string| coordinate_string.split(',').map(&:to_f) }
      end

      # @return [Polygon]
      def self.from_yaml_data(polygon_yaml_data)
        new do |polygon|
          Array(polygon_yaml_data).each do |lattitude, longitude|
            polygon.add_point do |point|
              point.lattitude = lattitude.to_f
              point.longitude = longitude.to_f
            end
          end
        end
      end

      # @return [Hash]
      def to_yaml_data
        @points.map { |point| [point.lattitude, point.longitude] }
      end

      # @return [String]
      def to_yaml(options = {})
        to_yaml_data.to_yaml(options)
      end

      POINTS_KEY = 'points'

      # @return [Polygon]
      def self.from_h(polygon_hash)
        new do |polygon|
          Array(polygon_hash[POINTS_KEY]).each do |point_array|
            polygon.add_point do |point|
              point.lattitude = point_array[Point::LATTITUDE_INDEX].to_f
              point.longitude = point_array[Point::LONGITUDE_INDEX].to_f
            end
          end
        end
      end

      # @return [Hash]
      def to_h
        { POINTS_KEY => @points.map(&:to_a) }
      end
    end
  end
end
