module RCAP
  module CAP_1_2
    class EventCode < Parameter
      XML_ELEMENT_NAME = 'eventCode' 
      XPATH = "cap:#{ XML_ELEMENT_NAME }" 
    end
  end
end
