module RCAP
  module CAP_1_2
    # Subclass of {Parameter}
    class EventCode < RCAP::Base::EventCode
      XML_ELEMENT_NAME = 'eventCode'
      XPATH = "cap:#{ XML_ELEMENT_NAME }"

      def xmlns
        Alert::XMLNS
      end
    end
  end
end
