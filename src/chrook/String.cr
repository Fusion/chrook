class String
  def tail_line
    s = strip
    idx = s.rindex("\n")
    idx = -1 if idx.nil?
    s[idx+1..-1]
  end
end
