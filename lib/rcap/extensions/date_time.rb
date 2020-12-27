# frozen_string_literal: true

class DateTime
  alias inspect to_s

  # Returns a string representaion of the time suitable for CAP.
  # @return [String]
  # @example
  #   DateTime.now.to_s_for_cap # => "2011-10-26T21:45:00+02:00"
  def to_s_for_cap
    t = strftime(RCAP::RCAP_TIME_FORMAT) + format(RCAP::RCAP_ZONE_FORMAT, utc_hours_offset)
    t.sub(/\+(00:\d\d)$/, '-\1')
  end

  def blank?
    false
  end

  private

  def utc_hours_offset
    offset * 24
  end
end
