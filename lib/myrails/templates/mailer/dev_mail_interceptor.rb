# Mail interceptor for development and test emails
require 'socket'
class DevMailInterceptor
  def self.delivering_email(message)
    dev_text = "\n\n\n------------\n"
    dev_text += "To address is: #{message.to.to_a.join(", ")}\n"
    dev_text += "CC address is: #{message.cc.to_a.join(", ")}\n"
    dev_text += "BCC address is: #{message.bcc.to_a.join(", ")}\n"

    message.subject = "[#{Socket.gethostname}] [#{Rails.env}] #{message.subject}"
    message.to = '<%= options[:email]%>'
    message.cc = ""
    message.bcc = ""
    append_address_info(message, dev_text)
  end

  def self.append_address_info(part, dev_text)
    case part.content_type
      when %r{^text/plain} then part.body = part.body.to_s + dev_text
      when %r{^text/html} then part.body = part.body.to_s + ("<pre>#{dev_text}</pre>").html_safe
    end
    part.parts.each { |p| append_address_info(p, dev_text)}
  end

end
