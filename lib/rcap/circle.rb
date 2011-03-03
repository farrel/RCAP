module RCAP
	# A Circle object is valid if
	# * it has a point which is a valid Point object
	# * it has a radius with a value greater than zero
  class Circle
    include Validation

		# Instance of Point class
    attr_accessor( :point )
		# Expresed in kilometers 
		attr_accessor( :radius )

    validates_presence_of( :point, :radius )
    validates_numericality_of( :radius , :greater_than => 0 )
    validates_validity_of( :point )

    XML_ELEMENT_NAME = 'circle' # :nodoc:

    XPATH = 'cap:circle' # :nodoc:

    def initialize( attributes = {} )
      @point = attributes[ :point ]
      @radius = attributes[ :radius ]
    end

		# Returns a string representation of the circle of the form
		#  point radius
    def to_s  # :nodoc:
      "#{ self.point.to_s } #{ self.radius }"
    end

    def inspect # :nodoc:
      "(#{ self.point.lattitude},#{ self.point.longitude } #{ self.radius })"
    end

    def to_xml_element # :nodoc:
      xml_element = REXML::Element.new( XML_ELEMENT_NAME )
      xml_element.add_text( self.to_s )
      xml_element
    end

    def to_xml # :nodoc:
      self.to_xml_element.to_s
    end

    def self.parse_circle_string( circle_string ) # :nodoc:
      coordinates, radius = circle_string.split( ' ' )
      lattitude, longitude = coordinates.split( ',' )
      [ lattitude, longitude, radius ].map{ |e| e.to_f }
    end

    def self.from_xml_element( circle_xml_element ) # :nodoc:
      lattitude, longitude, radius = self.parse_circle_string( circle_xml_element.text )
      point = RCAP::Point.new( :lattitude => lattitude, :longitude => longitude )
      circle = self.new( :point  => point,
                         :radius => radius )
    end

		# Two circles are equivalent if their point and radius are equal.
    def ==( other )
      self.point == other.point && self.radius == other.radius
    end

    def self.from_yaml_data( circle_yaml_data ) # :nodoc:
      point_yaml_data, radius = circle_yaml_data
      self.new( :point => RCAP::Point.new( :lattitude => point_yaml_data[ 0 ], :longitude => point_yaml_data[ 1 ]),
                :radius => radius )
    end

    def to_h # :nodoc:
      { 'radius' => self.radius, 'lattitude' => self.point.lattitude, 'longitude' => self.point.longitude }
    end

    def self.from_h( circle_hash ) # :nodoc:
      self.new( :radius => circle_hash[ 'radius' ], :point => RCAP::Point.new( :lattitude => circle_hash[ 'lattitude' ], :longitude => circle_hash[ 'longitude' ]))
    end
  end
end
