module CAP
  class Point
    include Validation

    MAX_LONGITUDE = 180
    MIN_LONGITUDE = -180
    MAX_LATTITUDE = 90
    MIN_LATTITUDE= -90

    attr_accessor( :lattitude, :longitude )

    validates_numericality_of( :lattitude, :longitude )
    validates_inclusion_of( :lattitude, :in => MIN_LATTITUDE..MAX_LATTITUDE )
    validates_inclusion_of( :longitude, :in => MIN_LONGITUDE..MAX_LONGITUDE)

    def initialize( attributes = {} )
      @lattitude = attributes[ :lattitude ]
      @longitude = attributes[ :longitude ]
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
