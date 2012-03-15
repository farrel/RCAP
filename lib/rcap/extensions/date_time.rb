class DateTime
  RCAP_TIME_FORMAT = "%Y-%m-%dT%H:%M:%S"
  RCAP_ZONE_FORMAT = "%+03i:00"

  alias inspect to_s

  # Returns a string representaion of the time suitable for CAP.
  # @return [String]
  # @example 
  #   DateTime.now.to_s_for_cap # => "2011-10-26T21:45:00+02:00"
  def to_s_for_cap
    t = self.strftime( RCAP_TIME_FORMAT ) + format( RCAP_ZONE_FORMAT , utc_hours_offset )
    t.sub(/\+(00:\d\d)$/, '-\1')
  end

  private
  def utc_hours_offset
    self.offset * 24
  end
end
