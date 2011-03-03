module RCAP
	# A Point object is valid if
	# * it has a lattitude within the minimum and maximum lattitude values
	# * it has a longitude within the minimum and maximum longitude values
  class Point
    include Validation

    MAX_LONGITUDE = 180
    MIN_LONGITUDE = -180
    MAX_LATTITUDE = 90
    MIN_LATTITUDE= -90

    attr_accessor( :lattitude )
		attr_accessor( :longitude )

    validates_numericality_of( :lattitude, :longitude )
    validates_inclusion_of( :lattitude, :in => MIN_LATTITUDE..MAX_LATTITUDE )
    validates_inclusion_of( :longitude, :in => MIN_LONGITUDE..MAX_LONGITUDE)

    def initialize( attributes = {} )
      @lattitude = attributes[ :lattitude ]
      @longitude = attributes[ :longitude ]
    end

		# Returns a string representation of the point of the form
		#  lattitude,longitude
    def to_s
      "#{ self.lattitude },#{ self.longitude }"
    end

    def inspect # :nodoc:
      '('+self.to_s+')'
    end

		# Two points are equivalent if they have the same lattitude and longitude
		def ==( other )
			[ self.lattitude, self.longitude ] == [ other.lattitude, other.longitude ]
		end

    def to_h # :nodoc:
      { 'lattitude' => self.lattitude, 'longitude' => self.longitude }
    end

    def self.from_h( point_hash ) # :nodoc:
      self.new( :lattitude => point_hash[ 'lattitude' ], :longitude => point_hash[ 'longitude' ])
    end
  end
end
