module RCAP
  module CAP_1_1
    class Geocode < Parameter
      XML_ELEMENT_NAME = 'geocode' 
      XPATH = "cap:#{ XML_ELEMENT_NAME }" 
    end
  end
end
