module RCAP
  module CAP_1_1
    # Subclass of {Parameter}
    class EventCode < Parameter
      XML_ELEMENT_NAME = 'eventCode'
      XPATH = "cap:#{ XML_ELEMENT_NAME }"
    end
  end
end
