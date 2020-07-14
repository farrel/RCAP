# frozen_string_literal: true

class Date
  alias inspect to_s

  # Returns a string representaion of the time suitable for CAP.
  # @return [String]
  # @example
  #   Date.today.to_s_for_cap # => "2011-10-26T00:00:00+00:00"
  def to_s_for_cap
    to_datetime.to_s_for_cap
  end
end
