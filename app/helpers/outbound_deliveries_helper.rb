module OutboundDeliveriesHelper
  def encode_string(untrusted_string)
    return '.' if untrusted_string.nil?

    ic = Iconv.new('UTF-8//IGNORE', 'UTF-8')
    ic.iconv(untrusted_string + ' ')[0..-2]
  end  
end