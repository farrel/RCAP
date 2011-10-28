module RCAP
  module CAP_1_0
    # Subclass of {Paramter}
    class EventCode < Parameter
      XML_ELEMENT_NAME = 'eventCode' 
      XPATH = "cap:#{ XML_ELEMENT_NAME }" 
    end
  end
end
