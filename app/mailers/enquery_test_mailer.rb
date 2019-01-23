class EnqueryTestMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.enquery_test_mailer.enquery_from.subject
  #
  def enquery_from(params)
    @name = params[:name]
    @query = params[:query]
    
    mail to: "sales@yantra24x7.com"
   
    mail subject: @name + " was registered...."
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.enquery_test_mailer.enquiry_to.subject
  #
  def enquiry_to(params)
    to = params[:to_mail]
    @name = params[:name]

    mail to: to.to_s
  
    mail subject: "Welcome To Yantra24x7.."
  end
end
