class Time

  # Returns a string representaion of the time suitable for CAP.
  # @return [String]
  # @example
  #   Time.now.to_s_for_cap # => "2011-10-26T21:45:00+02:00"
  def to_s_for_cap
    t = self.strftime( RCAP::RCAP_TIME_FORMAT ) + format( RCAP::RCAP_ZONE_FORMAT , utc_hours_offset )
    t.sub(/\+(00:\d\d)$/, '-\1')
  end

  private
  def utc_hours_offset
    self.localtime.utc_offset/3600
  end
end
