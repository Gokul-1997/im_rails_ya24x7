class AlertMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.alert_mailer.send_mail.subject
  #
  def send_mail(tenant_id,last_update,subject,body)
    tenant = Tenant.find tenant_id
  	@body = body
    mail from: "sales@yantra24x7.com"
    #mail from: "manimiranda5@gmail.com"
    mail to: "saravanan.senniyappan@adcltech.com"
    mail cc:  "manisankar.gnanasekaran@adcltech.com, rani.loganathan@adcltech.com"
    mail subject: subject 
  end

  def hour_report_mailer(path)
    @path = path
    attachments[@path] = File.read(@path)
    mail from: "sales@yantra24x7.com"
    mail to:  "manisankar.gnanasekaran@adcltech.com"
    mail cc:  "sarath.selvaraj@adcltech.com, prabhu.kittusamy@altiussolution.com"
    mail subject:  "yantra24x7 Report"
  end
  
  def wrong_hour_report_mailer(tenant, shift, date)
    @tenant_name = tenant.tenant_name
    @shift = shift.shift_no
    @date = date
    mail from: "sales@yantra24x7.com"
    mail to:  "manisankar.gnanasekaran@adcltech.com"
    #mail cc:  "sarath.selvaraj@adcltech.com"
    mail subject:  "yantra24x7 Report Wrong"
  end  
end
