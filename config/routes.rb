Rails.application.routes.draw do
  
  
  resources :common_settings
  # resources :ct_machine_logs
  #resources :alarm_histories
 # resources :set_alarm_settings
 # resources :alarm_types
 # resources :data_loss_entries
 # resources :delivery_lists
 # resources :job_lists
 # resources :mac_id_configs
 # resources :one_signals
 # resources :machine_series_nos
 # resources :alarm_codes
 # resources :break_times
 # resources :alarms
 #resources :error_masters
   namespace :api, defaults: {format: 'json'} do
      namespace :v1 do
        post 'authenticate', to: 'authentication#authenticate'
        get 'operator_allocations/operator_machines'
        post 'hmi_reasons/hmi_job_program'
        post 'hmi_reasons/hmi_machine_reason_create'
        get  'hmi_reasons/operator_machine'
        get 'machines/api'
        get 'machines/alarm_api'
        get 'machines/consolidate_data_export'
        get 'reports/machine_job_report'
        get 'machines/client_dashboard'
        post 'tenants/tenant_user_creation'
        get 'machines/dashboard_test'
        get 'machines/dashboard_status_1'
        get 'machines/machine_process'
        get 'machines/machine_counts'
        post 'machines/dashboard_test'
        post 'shifts/shift_validation'
        post 'shifts/shift_detail'
        get 'machines/dashboard'
        post 'cncjobs/job_list'
        get 'cncjobs/all_jobs'
        get 'shifts/all_shifts'
        
        get 'users/pending_approvals'
        post 'machines/machinelog_entry'
        get 'machines/machine_details'
        get 'users/email_validation'
        get 'cncjobs/job_detail'
        get 'cncoperations/cncoperation_list'
        get 'machineallocations/machine_allocations_list'
        get 'users/password_recovery'
        get 'machines/machine_log_status'
        get 'machines/machine_log_status_portal'
        get 'menuconfigurations/page_detail'
        get 'notifications/insert_notification'
        get 'roles/role_detail'
        get 'cncjobs/job_page_details'
        get 'cncjobs/job_page_operation'
        get 'shifttransactions/get_all_shift'
        get 'cncjobs/job_filter'
        get 'cncjobs/opration_details'
        get 'tenants/get_all_notification'
        get 'machines/oee_calculation'
        post 'tenants/send_enquery_mail'
        get 'alarms/alarm_history'
        get 'machines/reports_page'
        get 'machines/month_reports'
        get 'machines/machine_log_insert'
        get 'machines/hour_status'
        get 'alarms/alarm_dashboard'
        get 'shifttransactions/find_shift'
        get 'sessions/change_pwd'
        get 'sessions/change_pwd_web'
        get 'sessions/forgot_pwd'
        post 'sessions/api'
        post 'sessions/alarm'
        get 'job_lists/pending_customer_dc_list'
        get 'job_lists/job_list_detail'
        get 'machines/part_change_summery'
        get 'machines/hour_wise_detail'
        get 'machines/target_parts'
        get 'machines/status'
        get 'machines/month'
        get 'machines/dashboard_live'
        
        get 'machines/machine_process12'
        get 'new_board' => 'machines#new_board'
        post 'data_loss_entries/update_data'
        get '/alerts', to: 'notifications#alert_all'
        get '/pending_approvals', to: 'users#approval_list'
        get '/alarm_reports', to: 'alarms#report'
        get '/alarm_histories_reports', to: 'alarm_histories#report' 
        put '/set_status', to: 'set_alarm_settings#set_status'
        get '/hour_reports', to: 'machines#hour_reports'
        get '/utilization_reports',to: 'machines#date_reports'
        get '/month_reports_wise',to: 'machines#month_reports_wise'


        get "active_tenant" => "device_mappings#active_tenant"
        get "avialable_device" => "device_mappings#avialable_device"
        get 'setting_detail' => 'settings#setting_detail'
        get 'users/admin_user'
        get 'operators/restore_operator'
        
        get 'report_value' => 'settings#report_value'
        get 'resport_split_value' => 'settings#resport_split_value'
       
        get '/date_reports',to: 'machines#date_reports'
        get 'active_device', to: 'device_mappings#active_device'

        post 'rsmachine_data' => 'machines#rsmachine_data'
        get 'rsmachine_data' => 'machines#rsmachine_data'
        post 'current_trans' => 'machines#current_trans'
        

        get 'all_cycle_time_chart' => 'machines#all_cycle_time_chart'
        get 'hour_parts_count_chart' => 'machines#hour_parts_count_chart'
        get 'hour_machine_status_chart' => 'machines#hour_machine_status_chart'
        get 'hour_machine_utliz_chart' => 'machines#hour_machine_utliz_chart'
        get 'cycle_start_to_start' => 'machines#cycle_start_to_start'
        
        
        get 'hourtest' => 'machines#hourtest'
        post 'alarm_last_history' => 'alarm_histories#alarm_last_history'
        post 'ct_machine_logs1' => 'ct_machine_logs#ct_machine_logs1'
        get 'ct_dashboard' => 'ct_machine_logs#ct_dashboard'
        post 'machine_log_history' => 'machines#machine_log_history'

        get 'current_shift'  => 'shifts#current_shift'
        get 'machine_page_status'=>'machine_monthly_logs#machine_page_status'

        get 'shift_machine_status_chart' => 'machines#shift_machine_status_chart'
        get 'shift_machine_utilization_chart' => 'machines#shift_machine_utilization_chart'
        get 'all_cycle_time_chart_new' => 'machines#all_cycle_time_chart_new'
        get 'weekly_machine_chart' => 'machines#weekly_chart'
        get 'cycle_stop_to_start' => 'machines#cycle_stop_to_start'       

        get 'alarm_automatic' => 'alarm_histories#alarm_automatic'
        get 'alarm_manual' => 'alarm_histories#alarm_manual'
        get 'rs_dashboard' => 'machines#rs_dashboard'
        get 'rs232_machine_process' => 'machines#rs232_machine_process'

        post 'login' => 'sessions#login'
        get 'test' => 'sessions#test'

        get 'current_shift_hour_wise' => 'settings#current_shift_hour_wise'
        get 'current_shift_parts' => 'settings#current_shift_parts'
        get 'machine_current_shit' => 'settings#current_shit1'

        get 'pre_setting_dasboard' => 'set_alarm_settings#pre_setting_dasboard'
        get 'pre_setting_dasboard_full_data' => 'set_alarm_settings#pre_setting_dasboard_full_data'
        get 'single_machine_pre_data' => 'set_alarm_settings#single_machine_pre_data'

        post 'toradax_test' => 'roles#toradax_test'
        get 'latest_dashboard' => 'machines#latest_dashboard'
        get 'single_machine_live_status' => 'machines#single_machine_live_status'
        get 'rs232_shift_hour_wise' => 'settings#rs232_shift_hour_wise'
        
        get 'hmi_reason' => 'set_alarm_settings#hmi_reson'
        get 'hmi_reason_chart' => 'hmi_reasons#hmi_reason_chart'
        get 'shift_part_count' => 'machines#shift_part_count'
        post 'shift_part_update' => 'machines#shift_part_update'
       
        get 'calculate_time' => 'oee_calculations#calculate_time'
        post 'oee_create' => "oee_calculations#oee_create"        
        get 'shift_part_cal' => "oee_calculations#shift_part_cal"
        post 'shift_part_creation' => "oee_calculations#shift_part_creation"
        get 'delete_shift_part' => "oee_calculations#delete_shift_part"
        get 'shift_part_update' => "oee_calculations#shift_part_update"


 
        resources :oee_calculations
        resources :ct_machine_logs
        resources :device_types
        resources :alarm_histories
        resources :settings
        resources :device_mappings
        resources :devices
        resources :ethernet_logs
        resources :connection_logs
        resources :month_reports
        resources :operator_mapping_allocations
        resources :nodetests
        resources :set_alarm_settings
        resources :alarm_types
        resources :data_loss_entries
        resources :delivery_lists
        resources :job_lists
        resources :operator_allocations
        resources :operators
        resources :reports
        resources :notifications
        resources :sessions
        resources :operatorproductiondetails
        resources :operatorworkingdetails
        resources :consummablemaintanances
        resources :maintananceentries
        resources :plannedmaintanances
        resources :cnctools
        resources :machineallocations
        resources :cncvendors
        resources :materials
        resources :machines
        resources :deliveries
        resources :deliverytypes
        resources :planstatuses
        resources :cncoperations
        resources :cncjobs
        resources :cncclients
        resources :menuconfigurations
        resources :pageauthorizations
        resources :pages
        resources :userslogs
        resources :roles
        resources :users
        resources :approvals
        resources :usertypes
        resources :shifttransactions
        resources :shifts
        resources :tenants
        resources :companytypes
        resources :alarms
        resources :break_times
        resources :one_signals
        resources :hmi_reasons
      end
    end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
