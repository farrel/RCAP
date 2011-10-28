module RCAP
  module CAP_1_0
    # Subclass of {Parameter}
    class Geocode < Parameter
      XML_ELEMENT_NAME = 'geocode' 
      XPATH = "cap:#{ XML_ELEMENT_NAME }" 
    end
  end
end
