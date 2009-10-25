module CAP
  class Point
    include Validation

    LATTITUDE = :lattitude
    LONGITUDE = :longitude
    ATOMIC_ATTRIBUTES = [ LATTITUDE, LONGITUDE ]

    MAX_LONGITUDE = 180
    MIN_LONGITUDE = -180
    MAX_LATTITUDE = 90
    MIN_LATTITUDE= -90

    attr_accessor( *ATOMIC_ATTRIBUTES )

    validates_numericality_of( *ATOMIC_ATTRIBUTES )
    validates_inclusion_of( LATTITUDE, :in => MIN_LATTITUDE..MAX_LATTITUDE )
    validates_inclusion_of( LONGITUDE, :in => MIN_LONGITUDE..MAX_LONGITUDE)

    def initialize( attributes = {} )
      @lattitude = attributes[ LATTITUDE ]
      @longitude = attributes[ LONGITUDE ]
    end

    def to_s
      "#{ self.lattitude },#{ self.longitude }"
    end

    def inspect
      '('+self.to_s+')'
    end

		def ==( other )
			self.lattitude == other.lattitude &&
				self.longitude == other.longitude
		end
  end
end
