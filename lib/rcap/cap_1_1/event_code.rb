module RCAP
  module CAP_1_1
    # Subclass of {Parameter}
    class EventCode < RCAP::Base::EventCode
      XML_ELEMENT_NAME = 'eventCode'
      XPATH = "cap:#{ XML_ELEMENT_NAME }"

      # @return [String]
      def xmlns
        Alert::XMLNS
      end
    end
  end
end
