# frozen_string_literal: true

module RCAP
  module CAP_1_0
    # Subclass of {Parameter}
    class EventCode < RCAP::Base::EventCode
      XML_ELEMENT_NAME = 'eventCode'
      XPATH = "cap:#{XML_ELEMENT_NAME}"

      # @return [String]
      def xmlns
        Alert::XMLNS
      end
    end
  end
end
