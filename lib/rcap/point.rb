module CAP
  class Point
    include Validation

    LATTITUDE = :lattitude
    LONGITUDE = :longitude
    ATOMIC_ATTRIBUTES = [ LATTITUDE, LONGITUDE ]

    attr_accessor( *ATOMIC_ATTRIBUTES )

    validates_numericality_of( *ATOMIC_ATTRIBUTES )
    validates_inclusion_of( LATTITUDE, :in => -90..90 )
    validates_inclusion_of( LONGITUDE, :in => -180..180 )

    def initialize( lattitude, longitude )
      @lattitude = lattitude
      @longitude = longitude
    end

    def to_s
      "#{ @lattitude },#{ @longitude }"
    end
  end
end
