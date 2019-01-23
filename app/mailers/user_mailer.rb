class UserMailer < ApplicationMailer


  def sample_email(user)
    mail from: "sales@yantra24x7.com"
    mail to: "manoj.rajendran@altiussolution.com,sarath.selvaraj@adcltech.com",:subject => 'Waiting For Apporval'
  end

end
