# frozen_string_literal: true

module RCAP
  module CAP_1_0
    # A Circle object is valid if
    # * it has a valid lattitude and longitude
    # * it has a radius with a value greater than zero
    class Circle < RCAP::Base::Circle
    end
  end
end
