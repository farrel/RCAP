# frozen_string_literal: true

module RCAP
  module CAP_1_0
    # In Info object is valid if
    # * it has an event
    # * it has an urgency with a valid value
    # * it has a severity with a valid value
    # * it has a certainty with a valid value
    # * all categories are valid and categories has at minimum 1 entry
    # * all Resource objects in the resources collection are valid
    # * all Area objects in the areas collection are valid
    class Info < RCAP::Base::Info
      validates_inclusion_of(:certainty, allow_nil: true, in: VALID_CERTAINTIES, message: "can only be assigned the following values: #{VALID_CERTAINTIES.join(', ')}")

      # @return [String]
      def xmlns
        Alert::XMLNS
      end

      # @return [Class]
      def event_code_class
        EventCode
      end

      # @return [Class]
      def parameter_class
        Parameter
      end

      # @return [Class]
      def resource_class
        Resource
      end

      # @return [Class]
      def area_class
        Area
      end
    end
  end
end
