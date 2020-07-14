# frozen_string_literal: true

module RCAP
  XML_PRETTY_PRINTER = REXML::Formatters::Pretty.new(2)
  XML_PRETTY_PRINTER.compact = true

  RCAP_TIME_FORMAT = '%Y-%m-%dT%H:%M:%S'
  RCAP_ZONE_FORMAT = '%+03i:00'
end
