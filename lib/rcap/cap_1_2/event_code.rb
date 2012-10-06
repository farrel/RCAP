module RCAP
  module CAP_1_2
    # Subclass of {Parameter}
    class EventCode < Parameter
      XML_ELEMENT_NAME = 'eventCode'
      XPATH = "cap:#{ XML_ELEMENT_NAME }"

      def xmlns
        Alert::XMLNS
      end
    end
  end
end
