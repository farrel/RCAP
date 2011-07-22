class String # :nodoc:
  CAP_LIST_REGEX = Regexp.new( '"([\w\s]+)"|(\S+)' )
  WHITESPACE_REGEX = Regexp.new('^\s+$')

  def for_cap_list
    if self =~ /\s/
      '"'+self+'"'
    else
      self
    end
  end

  def unpack_cap_list
    self.split( CAP_LIST_REGEX ).reject{ |match| match == "" || match =~ WHITESPACE_REGEX }
  end
end
