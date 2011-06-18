module RCAP
  module CAP_1_1
    class EventCode < Parameter
      XML_ELEMENT_NAME = 'eventCode' # :nodoc:
      XPATH = "cap:#{ XML_ELEMENT_NAME }" # :nodoc:
    end
  end
end
