class ShiftCheckingMailer < ApplicationMailer
	def check_time(data)
	@timing = data
	mail from: "sales@yantra24x7.com"
    mail(to: 'manisankar.gnanasekaran@adcltech.com, sarath.selvaraj@adcltech.com', subject: "Tenant's shift timming" )
	end
end
