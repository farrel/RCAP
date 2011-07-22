class Array # :nodoc:
  def to_s_for_cap
    self.map{ |element| element.to_s.for_cap_list }.join( ' ' )
  end
end
