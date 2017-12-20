module MailerHelper
  def inbox
     ActionMailer::Base.deliveries
  end

  def clear_inbox
    ActionMailer::Base.deliveries.clear
  end
end