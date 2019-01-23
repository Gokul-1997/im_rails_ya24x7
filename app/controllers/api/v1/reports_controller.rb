module Api
	module V1
		class ReportsController < ApplicationController

			def machine_job_report
				machine_job_reports = Machine.machine_job_report(params)
				render json: machine_job_reports
			end
		end
	end
end
