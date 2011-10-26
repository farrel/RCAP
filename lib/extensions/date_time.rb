class DateTime # :nodoc:
  RCAP_TIME_FORMAT = "%Y-%m-%dT%H:%M:%S"
  RCAP_ZONE_FORMAT = "%+03i:00"

  alias inspect to_s

  def to_s_for_cap
    t = self.strftime( RCAP_TIME_FORMAT ) + format( RCAP_ZONE_FORMAT , utc_hours_offset )
    t.sub(/\+(00:\d\d)$/, '-\1')
  end

  private
  def utc_hours_offset
    self.offset * 24
  end
end
