# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20190118124719) do

  create_table "AlarmCodes_MachineSeriesNos", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "machine_series_no_id", null: false
    t.integer "alarm_code_id",        null: false
  end

  create_table "alarm_codes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "code"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "alarm_histories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "alarm_type"
    t.string   "alarm_no"
    t.string   "axis_no"
    t.datetime "time"
    t.string   "message"
    t.integer  "alarm_status"
    t.integer  "machine_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["machine_id"], name: "index_alarm_histories_on_machine_id", using: :btree
  end

  create_table "alarm_tests", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "alarm_type"
    t.string   "alarm_no"
    t.string   "axis_no"
    t.datetime "time"
    t.string   "message"
    t.integer  "alarm_status"
    t.integer  "machine_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["machine_id"], name: "index_alarm_tests_on_machine_id", using: :btree
  end

  create_table "alarm_types", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "alarm_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "alarms", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "alarm_type"
    t.integer  "alarm_number"
    t.string   "alarm_message"
    t.integer  "emergency"
    t.integer  "machine_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_alarms_on_deleted_at", using: :btree
    t.index ["machine_id"], name: "index_alarms_on_machine_id", using: :btree
  end

  create_table "approvals", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "approval_status_name"
    t.string   "description"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "break_times", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "reasion"
    t.string   "start_time"
    t.string   "end_time"
    t.string   "total_minutes"
    t.integer  "shifttransaction_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "start_time_dummy"
    t.string   "end_time_dumy"
    t.index ["shifttransaction_id"], name: "index_break_times_on_shifttransaction_id", using: :btree
  end

  create_table "cnc_hour_reports", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.date     "date"
    t.string   "hour"
    t.string   "time"
    t.integer  "shift_no"
    t.text     "job_description", limit: 65535
    t.string   "parts_produced"
    t.string   "run_time"
    t.string   "ideal_time"
    t.string   "stop_time"
    t.string   "time_diff"
    t.integer  "log_count"
    t.integer  "utilization"
    t.text     "all_cycle_time",  limit: 65535
    t.integer  "shift_id"
    t.integer  "operator_id"
    t.integer  "machine_id"
    t.integer  "tenant_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "feed_rate"
    t.string   "spendle_speed"
    t.string   "oee"
    t.text     "cutting_time",    limit: 65535
    t.string   "spindle_load"
    t.string   "spindle_m_temp"
    t.text     "servo_load",      limit: 65535
    t.text     "servo_m_temp",    limit: 65535
    t.text     "puls_code",       limit: 65535
    t.string   "test_code"
    t.index ["machine_id"], name: "index_cnc_hour_reports_on_machine_id", using: :btree
    t.index ["operator_id"], name: "index_cnc_hour_reports_on_operator_id", using: :btree
    t.index ["shift_id"], name: "index_cnc_hour_reports_on_shift_id", using: :btree
    t.index ["tenant_id"], name: "index_cnc_hour_reports_on_tenant_id", using: :btree
  end

  create_table "cnc_reports", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.date     "date"
    t.string   "hour"
    t.integer  "shift_no"
    t.string   "time"
    t.string   "program_no"
    t.text     "job_description",      limit: 65535
    t.string   "parts_produced"
    t.string   "run_time"
    t.string   "idle_time"
    t.string   "stop_time"
    t.string   "time_diff"
    t.integer  "utilization"
    t.text     "all_cycle_time",       limit: 65535
    t.text     "cycle_start_to_start", limit: 65535
    t.boolean  "is_sent"
    t.integer  "shift_id"
    t.integer  "operator_id"
    t.integer  "machine_id"
    t.integer  "tenant_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "data_part"
    t.integer  "target"
    t.integer  "approved"
    t.integer  "rework"
    t.integer  "reject"
    t.string   "feed_rate"
    t.string   "spendle_speed"
    t.string   "oee"
    t.text     "cutting_time",         limit: 65535
    t.text     "stop_to_start",        limit: 65535
    t.string   "availability"
    t.string   "perfomance"
    t.string   "quality"
    t.string   "spindle_load"
    t.string   "spindle_m_temp"
    t.text     "servo_load",           limit: 65535
    t.text     "servo_m_temp",         limit: 65535
    t.text     "puls_code",            limit: 65535
    t.string   "test_code"
    t.index ["machine_id"], name: "index_cnc_reports_on_machine_id", using: :btree
    t.index ["operator_id"], name: "index_cnc_reports_on_operator_id", using: :btree
    t.index ["shift_id"], name: "index_cnc_reports_on_shift_id", using: :btree
    t.index ["tenant_id"], name: "index_cnc_reports_on_tenant_id", using: :btree
  end

  create_table "cncclients", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "client_name"
    t.string   "email_id"
    t.string   "phone_number"
    t.integer  "tenant_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.boolean  "isactive"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_cncclients_on_deleted_at", using: :btree
    t.index ["tenant_id"], name: "index_cncclients_on_tenant_id", using: :btree
  end

  create_table "cncjobs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "description"
    t.date     "job_start_date"
    t.date     "job_due_date"
    t.integer  "order_quantity"
    t.integer  "cncclient_id"
    t.integer  "tenant_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "job_id"
    t.boolean  "isactive"
    t.datetime "deleted_at"
    t.string   "cycle_time"
    t.string   "idle_cycle_time"
    t.index ["cncclient_id"], name: "index_cncjobs_on_cncclient_id", using: :btree
    t.index ["deleted_at"], name: "index_cncjobs_on_deleted_at", using: :btree
    t.index ["tenant_id"], name: "index_cncjobs_on_tenant_id", using: :btree
  end

  create_table "cncoperations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "operation_name"
    t.string   "description"
    t.integer  "cncjob_id"
    t.integer  "tenant_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "planstatus_id"
    t.boolean  "isactive"
    t.datetime "deleted_at"
    t.string   "operation_no"
    t.string   "cycle_time"
    t.string   "idle_cycle_time"
    t.date     "start_date"
    t.date     "end_date"
    t.time     "cycle_time_dummy"
    t.time     "idle_cycle_time_dummy"
    t.string   "total_cycle_time"
    t.index ["cncjob_id"], name: "index_cncoperations_on_cncjob_id", using: :btree
    t.index ["deleted_at"], name: "index_cncoperations_on_deleted_at", using: :btree
    t.index ["planstatus_id"], name: "index_cncoperations_on_planstatus_id", using: :btree
    t.index ["tenant_id"], name: "index_cncoperations_on_tenant_id", using: :btree
  end

  create_table "cnctools", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "tool_name"
    t.integer  "no_of_parts"
    t.string   "material_string"
    t.integer  "produced_count"
    t.boolean  "status"
    t.integer  "tenant_id"
    t.integer  "machine_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["machine_id"], name: "index_cnctools_on_machine_id", using: :btree
    t.index ["tenant_id"], name: "index_cnctools_on_tenant_id", using: :btree
  end

  create_table "cncvendors", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "vendor_name"
    t.date     "start_date"
    t.date     "delivery_date"
    t.integer  "quantity"
    t.string   "phone_number"
    t.string   "email_id"
    t.integer  "cncoperation_id"
    t.integer  "tenant_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.boolean  "isactive"
    t.index ["cncoperation_id"], name: "index_cncvendors_on_cncoperation_id", using: :btree
    t.index ["tenant_id"], name: "index_cncvendors_on_tenant_id", using: :btree
  end

  create_table "common_settings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "setting_name"
    t.integer  "setting_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "companytypes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "companytype_name"
    t.string   "description"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "connection_logs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "date"
    t.string   "status"
    t.integer  "tenant_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tenant_id"], name: "index_connection_logs_on_tenant_id", using: :btree
  end

  create_table "consolidate_data", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "parts_count"
    t.integer  "cons_parts_count"
    t.integer  "programe_number"
    t.integer  "machine_status"
    t.integer  "day"
    t.integer  "month"
    t.integer  "year"
    t.integer  "shift"
    t.integer  "total_run_time"
    t.integer  "cons_total_run_time"
    t.integer  "total_run_second"
    t.integer  "cons_total_run_second"
    t.integer  "cutting_time"
    t.integer  "cons_cutting_time"
    t.integer  "cycle_time"
    t.integer  "run_time"
    t.integer  "cons_run_time"
    t.integer  "run_second"
    t.integer  "cons_run_second"
    t.integer  "cons_down_time"
    t.integer  "cons_load_unload_time"
    t.datetime "log_created_time"
    t.integer  "total_available_time"
    t.integer  "machine_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.index ["machine_id"], name: "index_consolidate_data_on_machine_id", using: :btree
  end

  create_table "consummablemaintanances", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "maintance_type"
    t.date     "change_date"
    t.date     "next_change_date"
    t.string   "reason_for_change"
    t.integer  "machine_id"
    t.integer  "tenant_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["machine_id"], name: "index_consummablemaintanances_on_machine_id", using: :btree
    t.index ["tenant_id"], name: "index_consummablemaintanances_on_tenant_id", using: :btree
  end

  create_table "cron_reports", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "report"
    t.string   "tenant"
    t.string   "shift"
    t.date     "date"
    t.string   "time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ct_machine_daily_logs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "status"
    t.integer  "heart_beat"
    t.datetime "from_date"
    t.datetime "to_date"
    t.datetime "uptime"
    t.string   "reason"
    t.integer  "machine_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["machine_id"], name: "index_ct_machine_daily_logs_on_machine_id", using: :btree
  end

  create_table "ct_machine_logs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "status"
    t.integer  "heart_beat"
    t.datetime "from_date"
    t.datetime "to_date"
    t.datetime "uptime"
    t.string   "reason"
    t.integer  "machine_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["machine_id"], name: "index_ct_machine_logs_on_machine_id", using: :btree
  end

  create_table "ct_reports", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.date     "date"
    t.string   "shift_no"
    t.string   "time"
    t.string   "run_time"
    t.string   "idle_time"
    t.string   "stop_time"
    t.string   "total_time"
    t.string   "actual_shifttime"
    t.string   "utilization"
    t.integer  "operator_id"
    t.integer  "machine_id"
    t.integer  "shift_id"
    t.integer  "tenant_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["machine_id"], name: "index_ct_reports_on_machine_id", using: :btree
    t.index ["operator_id"], name: "index_ct_reports_on_operator_id", using: :btree
    t.index ["shift_id"], name: "index_ct_reports_on_shift_id", using: :btree
    t.index ["tenant_id"], name: "index_ct_reports_on_tenant_id", using: :btree
  end

  create_table "dashboard_data", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.date     "date"
    t.string   "utilization"
    t.string   "shift_no"
    t.string   "machine_status"
    t.string   "job_id"
    t.string   "cycle_time"
    t.string   "run_time"
    t.string   "idle_time"
    t.string   "stop_time"
    t.text     "job_wise_part",       limit: 65535
    t.integer  "shifttransaction_id"
    t.integer  "tenant_id"
    t.integer  "machine_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.index ["machine_id"], name: "index_dashboard_data_on_machine_id", using: :btree
    t.index ["shifttransaction_id"], name: "index_dashboard_data_on_shifttransaction_id", using: :btree
    t.index ["tenant_id"], name: "index_dashboard_data_on_tenant_id", using: :btree
  end

  create_table "dashboards", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "machine_name"
    t.string   "job_name"
    t.string   "utilization"
    t.string   "parts_produced"
    t.string   "downtime"
    t.string   "machine_status"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "data_loss_entries", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "downtime"
    t.string   "parts_produced"
    t.integer  "total_second"
    t.integer  "program_no"
    t.integer  "run_time"
    t.boolean  "entry_status"
    t.integer  "machine_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["machine_id"], name: "index_data_loss_entries_on_machine_id", using: :btree
  end

  create_table "delayed_jobs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "priority",                 default: 0, null: false
    t.integer  "attempts",                 default: 0, null: false
    t.text     "handler",    limit: 65535,             null: false
    t.text     "last_error", limit: 65535
    t.datetime "run_at"
    t.integer  "tenant"
    t.integer  "shift"
    t.date     "date"
    t.string   "method"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree
  end

  create_table "deliveries", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.date     "start_date"
    t.date     "delivery_date"
    t.integer  "quantity"
    t.integer  "cncjob_id"
    t.integer  "deliverytype_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["cncjob_id"], name: "index_deliveries_on_cncjob_id", using: :btree
    t.index ["deliverytype_id"], name: "index_deliveries_on_deliverytype_id", using: :btree
  end

  create_table "delivery_lists", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "client_dc_no"
    t.string   "our_dc_no"
    t.string   "j_name"
    t.string   "j_id"
    t.integer  "fresh_pecs"
    t.integer  "rework_pecs"
    t.integer  "reject_pecs"
    t.string   "notes"
    t.integer  "cncclient_id"
    t.integer  "job_list_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["cncclient_id"], name: "index_delivery_lists_on_cncclient_id", using: :btree
    t.index ["job_list_id"], name: "index_delivery_lists_on_job_list_id", using: :btree
  end

  create_table "deliverytypes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "deliverytype_name"
    t.string   "description"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "device_mappings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "installing_date"
    t.string   "removing_date"
    t.integer  "number_of_machine"
    t.string   "reasons"
    t.string   "description"
    t.string   "created_by"
    t.string   "updated_by"
    t.boolean  "is_active",         default: true
    t.datetime "deleted_at"
    t.integer  "tenant_id"
    t.integer  "device_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.index ["device_id"], name: "index_device_mappings_on_device_id", using: :btree
    t.index ["tenant_id"], name: "index_device_mappings_on_tenant_id", using: :btree
  end

  create_table "device_types", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.integer  "count"
    t.decimal  "per_pic_price", precision: 10
    t.decimal  "total_price",   precision: 10
    t.datetime "purchase_date"
    t.string   "created_by"
    t.string   "updated_by"
    t.datetime "deleted_at"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "devices", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "device_name"
    t.string   "description"
    t.string   "purchase_date"
    t.string   "created_by"
    t.boolean  "is_active",      default: true
    t.datetime "deleted_at"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "device_type_id"
    t.string   "updated_by"
    t.index ["device_type_id"], name: "index_devices_on_device_type_id", using: :btree
  end

  create_table "error_masters", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "error_code"
    t.string   "message"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "ethernet_logs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "date"
    t.string   "status"
    t.integer  "machine_id"
    t.integer  "tenant_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["machine_id"], name: "index_ethernet_logs_on_machine_id", using: :btree
    t.index ["tenant_id"], name: "index_ethernet_logs_on_tenant_id", using: :btree
  end

  create_table "hmi_machine_details", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "job_id"
    t.string   "program_number"
    t.integer  "parts_count"
    t.integer  "operator_id"
    t.integer  "machine_id"
    t.integer  "tenant_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "shifttransaction_id"
    t.integer  "shift_no"
    t.integer  "duration"
    t.date     "date"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string   "description"
    t.index ["machine_id"], name: "index_hmi_machine_details_on_machine_id", using: :btree
    t.index ["operator_id"], name: "index_hmi_machine_details_on_operator_id", using: :btree
    t.index ["shifttransaction_id"], name: "index_hmi_machine_details_on_shifttransaction_id", using: :btree
    t.index ["tenant_id"], name: "index_hmi_machine_details_on_tenant_id", using: :btree
  end

  create_table "hmi_machine_reasons", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.time     "start_time"
    t.time     "end_time"
    t.string   "duration"
    t.integer  "hmi_reason_id"
    t.integer  "machine_id"
    t.integer  "tenant_id"
    t.boolean  "is_active"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "hmi_machine_detail_id"
    t.index ["hmi_machine_detail_id"], name: "index_hmi_machine_reasons_on_hmi_machine_detail_id", using: :btree
    t.index ["hmi_reason_id"], name: "index_hmi_machine_reasons_on_hmi_reason_id", using: :btree
    t.index ["machine_id"], name: "index_hmi_machine_reasons_on_machine_id", using: :btree
    t.index ["tenant_id"], name: "index_hmi_machine_reasons_on_tenant_id", using: :btree
  end

  create_table "hmi_reasons", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "image_path"
    t.boolean  "is_active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hour_detail_timeline_reports", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "start_time"
    t.string   "end_time"
    t.integer  "ideal_time"
    t.integer  "run_time"
    t.integer  "stop_time"
    t.integer  "hour_timeline_report_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["hour_timeline_report_id"], name: "index_hour_detail_timeline_reports_on_hour_timeline_report_id", using: :btree
  end

  create_table "hour_reports", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.date     "date"
    t.string   "hour"
    t.integer  "shift_id"
    t.integer  "shift_no"
    t.string   "time"
    t.integer  "operator_id"
    t.integer  "machine_id"
    t.string   "program_number"
    t.string   "job_description"
    t.integer  "parts_produced"
    t.string   "cycle_time"
    t.string   "loading_and_unloading_time"
    t.string   "idle_time"
    t.string   "total_downtime"
    t.string   "actual_running"
    t.string   "actual_working_hours"
    t.string   "utilization"
    t.integer  "tenant_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["machine_id"], name: "index_hour_reports_on_machine_id", using: :btree
    t.index ["operator_id"], name: "index_hour_reports_on_operator_id", using: :btree
    t.index ["shift_id"], name: "index_hour_reports_on_shift_id", using: :btree
    t.index ["tenant_id"], name: "index_hour_reports_on_tenant_id", using: :btree
  end

  create_table "hour_timeline_reports", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "start_time"
    t.string   "end_time"
    t.integer  "ideal_time"
    t.integer  "run_time"
    t.integer  "stop_time"
    t.integer  "shift_timeline_report_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["shift_timeline_report_id"], name: "index_hour_timeline_reports_on_shift_timeline_report_id", using: :btree
  end

  create_table "job_lists", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "client_dc_no"
    t.string   "j_name"
    t.string   "j_id"
    t.integer  "fresh_pecs"
    t.integer  "rework_pecs"
    t.integer  "reject_pecs"
    t.string   "notes"
    t.boolean  "completed_status"
    t.integer  "cncclient_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["cncclient_id"], name: "index_job_lists_on_cncclient_id", using: :btree
  end

  create_table "load_unloads", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "load_unload_time"
    t.string   "program_number"
    t.integer  "machine_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "cycle_time"
    t.index ["machine_id"], name: "index_load_unloads_on_machine_id", using: :btree
  end

  create_table "mac_id_configs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "mac_id"
    t.string   "player_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "machine_daily_logs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "parts_count"
    t.integer  "machine_status"
    t.string   "job_id"
    t.integer  "total_run_time"
    t.integer  "total_cutting_time"
    t.integer  "run_time"
    t.integer  "feed_rate"
    t.integer  "cutting_speed"
    t.integer  "axis_load"
    t.string   "axis_name"
    t.integer  "spindle_speed"
    t.integer  "spindle_load"
    t.integer  "total_run_second"
    t.string   "programe_number"
    t.string   "programe_description"
    t.integer  "run_second"
    t.integer  "machine_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.datetime "machine_time"
    t.string   "cycle_time_minutes"
    t.string   "machine_total_time"
    t.string   "cycle_time_per_part"
    t.string   "total_cutting_second"
    t.string   "x_axis"
    t.string   "y_axis"
    t.string   "z_axis"
    t.string   "reason"
    t.index ["machine_id"], name: "index_machine_daily_logs_on_machine_id", using: :btree
  end

  create_table "machine_log_histories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "parts_count"
    t.integer  "machine_status"
    t.string   "job_id"
    t.integer  "total_run_time"
    t.integer  "total_cutting_time"
    t.integer  "run_time"
    t.integer  "feed_rate"
    t.integer  "cutting_speed"
    t.integer  "axis_load"
    t.string   "axis_name"
    t.integer  "spindle_speed"
    t.integer  "spindle_load"
    t.integer  "total_run_second"
    t.string   "programe_number"
    t.string   "programe_description"
    t.integer  "run_second"
    t.datetime "machine_time"
    t.string   "cycle_time_minutes"
    t.string   "machine_total_time"
    t.string   "cycle_time_per_part"
    t.integer  "machine_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["machine_id"], name: "index_machine_log_histories_on_machine_id", using: :btree
  end

  create_table "machine_logs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "parts_count"
    t.integer  "machine_status"
    t.string   "job_id"
    t.integer  "total_run_time"
    t.integer  "total_cutting_time"
    t.integer  "run_time"
    t.integer  "feed_rate"
    t.integer  "cutting_speed"
    t.integer  "axis_load"
    t.string   "axis_name"
    t.integer  "spindle_speed"
    t.integer  "spindle_load"
    t.integer  "total_run_second"
    t.string   "programe_number"
    t.string   "programe_description"
    t.integer  "run_second"
    t.integer  "machine_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.datetime "machine_time"
    t.string   "cycle_time_minutes"
    t.string   "machine_total_time"
    t.string   "cycle_time_per_part"
    t.string   "total_cutting_second"
    t.string   "x_axis"
    t.string   "y_axis"
    t.string   "z_axis"
    t.string   "reason"
    t.index ["machine_id"], name: "index_machine_logs_on_machine_id", using: :btree
  end

  create_table "machine_monthly_logs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "parts_count"
    t.string   "machine_status"
    t.string   "job_id"
    t.integer  "total_run_time"
    t.integer  "total_cutting_time"
    t.integer  "run_time"
    t.integer  "feed_rate"
    t.integer  "cutting_speed"
    t.integer  "axis_load"
    t.string   "axis_name"
    t.integer  "spindle_speed"
    t.integer  "spindle_load"
    t.integer  "total_run_second"
    t.string   "programe_number"
    t.string   "programe_description"
    t.integer  "run_second"
    t.datetime "machine_time"
    t.integer  "machine_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "total_cutting_second"
    t.string   "x_axis"
    t.string   "y_axis"
    t.string   "z_axis"
    t.string   "reason"
    t.index ["machine_id"], name: "index_machine_monthly_logs_on_machine_id", using: :btree
  end

  create_table "machine_series_nos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "number"
    t.string   "controller_name"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "machine_setting_lists", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "setting_name"
    t.string   "manual"
    t.boolean  "is_active",          default: false
    t.integer  "machine_setting_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.index ["machine_setting_id"], name: "index_machine_setting_lists_on_machine_setting_id", using: :btree
  end

  create_table "machine_settings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.boolean  "is_active",  default: true
    t.string   "reason"
    t.string   "manual"
    t.integer  "machine_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["machine_id"], name: "index_machine_settings_on_machine_id", using: :btree
  end

  create_table "machine_shift_reports", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.date     "date"
    t.string   "shift"
    t.string   "operator_mfr"
    t.string   "operator_id"
    t.string   "machine_name"
    t.string   "machineid"
    t.string   "program_number"
    t.text     "job_description",  limit: 65535
    t.integer  "produced_item"
    t.string   "load_unload_time"
    t.string   "ideal_time"
    t.string   "total_down_time"
    t.string   "actual_Run_Time"
    t.integer  "utilization"
    t.string   "report_type"
    t.integer  "machine_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.index ["machine_id"], name: "index_machine_shift_reports_on_machine_id", using: :btree
  end

  create_table "machineallocations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.date     "from_date"
    t.date     "to_date"
    t.string   "start_time"
    t.string   "end_time"
    t.integer  "actual_quantity"
    t.time     "cycle_time"
    t.string   "idle_cycle_time"
    t.decimal  "total_down_time",  precision: 10
    t.integer  "produced_quantiy"
    t.integer  "tenant_id"
    t.integer  "machine_id"
    t.integer  "cncoperation_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.index ["cncoperation_id"], name: "index_machineallocations_on_cncoperation_id", using: :btree
    t.index ["machine_id"], name: "index_machineallocations_on_machine_id", using: :btree
    t.index ["tenant_id"], name: "index_machineallocations_on_tenant_id", using: :btree
  end

  create_table "machines", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "machine_name"
    t.string   "machine_model"
    t.string   "machine_serial_no"
    t.string   "machine_type"
    t.integer  "tenant_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.boolean  "isactive"
    t.datetime "deleted_at"
    t.string   "machine_ip"
    t.integer  "unit"
    t.string   "device_id"
    t.integer  "controller_type"
    t.index ["deleted_at"], name: "index_machines_on_deleted_at", using: :btree
    t.index ["tenant_id"], name: "index_machines_on_tenant_id", using: :btree
  end

  create_table "mail_logs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.date     "date"
    t.datetime "stop_time"
    t.datetime "start_time"
    t.boolean  "mail_status"
    t.datetime "last_mail_time"
    t.string   "log_id"
    t.integer  "tenant_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["tenant_id"], name: "index_mail_logs_on_tenant_id", using: :btree
  end

  create_table "maintananceentries", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "maintanance_type"
    t.date     "maintanance_date"
    t.string   "service_engineer_name"
    t.string   "maintanance_time"
    t.string   "remarks"
    t.integer  "machine_id"
    t.integer  "tenant_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "maintanance_time_dummy"
    t.index ["machine_id"], name: "index_maintananceentries_on_machine_id", using: :btree
    t.index ["tenant_id"], name: "index_maintananceentries_on_tenant_id", using: :btree
  end

  create_table "materials", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "suplier_name"
    t.string   "product_name"
    t.date     "purchase_date"
    t.time     "purchase_time"
    t.integer  "quantity"
    t.integer  "cncjob_id"
    t.integer  "tenant_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["cncjob_id"], name: "index_materials_on_cncjob_id", using: :btree
    t.index ["tenant_id"], name: "index_materials_on_tenant_id", using: :btree
  end

  create_table "menuconfigurations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "page_id"
    t.integer  "role_id"
    t.integer  "pageauthorization_id"
    t.integer  "tenant_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["page_id"], name: "index_menuconfigurations_on_page_id", using: :btree
    t.index ["pageauthorization_id"], name: "index_menuconfigurations_on_pageauthorization_id", using: :btree
    t.index ["role_id"], name: "index_menuconfigurations_on_role_id", using: :btree
    t.index ["tenant_id"], name: "index_menuconfigurations_on_tenant_id", using: :btree
  end

  create_table "month_reports", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.date     "date"
    t.string   "file_path"
    t.integer  "tenant_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tenant_id"], name: "index_month_reports_on_tenant_id", using: :btree
  end

  create_table "nodetests", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "m_no"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifications", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "machine_log_id"
    t.string   "message"
    t.boolean  "viewed_status"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "machine_id"
    t.index ["machine_id"], name: "index_notifications_on_machine_id", using: :btree
    t.index ["machine_log_id"], name: "index_notifications_on_machine_log_id", using: :btree
  end

  create_table "oee_calculate_lists", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "program_number"
    t.string   "run_rate"
    t.string   "parts_count"
    t.string   "time"
    t.integer  "oee_calculation_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["oee_calculation_id"], name: "index_oee_calculate_lists_on_oee_calculation_id", using: :btree
  end

  create_table "oee_calculations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "duration"
    t.string   "break_time"
    t.string   "balance"
    t.date     "date"
    t.string   "prod_time"
    t.text     "prog_count",          limit: 65535
    t.integer  "machine_id"
    t.integer  "shifttransaction_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.index ["machine_id"], name: "index_oee_calculations_on_machine_id", using: :btree
    t.index ["shifttransaction_id"], name: "index_oee_calculations_on_shifttransaction_id", using: :btree
  end

  create_table "one_signals", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "player_id"
    t.integer  "user_id"
    t.integer  "tenant_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tenant_id"], name: "index_one_signals_on_tenant_id", using: :btree
    t.index ["user_id"], name: "index_one_signals_on_user_id", using: :btree
  end

  create_table "operator_allocations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "operator_id"
    t.integer  "shifttransaction_id"
    t.integer  "machine_id"
    t.string   "description"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "tenant_id"
    t.date     "from_date"
    t.date     "to_date"
    t.index ["machine_id"], name: "index_operator_allocations_on_machine_id", using: :btree
    t.index ["operator_id"], name: "index_operator_allocations_on_operator_id", using: :btree
    t.index ["shifttransaction_id"], name: "index_operator_allocations_on_shifttransaction_id", using: :btree
    t.index ["tenant_id"], name: "index_operator_allocations_on_tenant_id", using: :btree
  end

  create_table "operator_entry_oees", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "total_part"
    t.string   "idle_run_rate"
    t.string   "reject_part"
    t.integer  "cncoperation_id"
    t.integer  "shifttransaction_id"
    t.integer  "machine_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "downtime"
    t.index ["cncoperation_id"], name: "index_operator_entry_oees_on_cncoperation_id", using: :btree
    t.index ["machine_id"], name: "index_operator_entry_oees_on_machine_id", using: :btree
    t.index ["shifttransaction_id"], name: "index_operator_entry_oees_on_shifttransaction_id", using: :btree
  end

  create_table "operator_mapping_allocations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.date     "date"
    t.integer  "operator_id"
    t.integer  "operator_allocation_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "target",                 default: 0
    t.integer  "pending",                default: 0
    t.integer  "rework",                 default: 0
    t.integer  "approved",               default: 0
    t.integer  "rejected",               default: 0
    t.string   "operator_name"
    t.string   "reason"
    t.string   "alert"
    t.index ["operator_allocation_id"], name: "index_operator_mapping_allocations_on_operator_allocation_id", using: :btree
    t.index ["operator_id"], name: "index_operator_mapping_allocations_on_operator_id", using: :btree
  end

  create_table "operatorproductiondetails", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "no_of_rejects"
    t.integer  "no_of_parts_produced"
    t.integer  "parts_moved_to_next_operation"
    t.time     "total_down_time"
    t.string   "reason_for_down_time"
    t.time     "last_machine_reset_time"
    t.string   "remarks"
    t.integer  "operatorworkingdetail_id"
    t.integer  "tenant_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["operatorworkingdetail_id"], name: "index_operatorproductiondetails_on_operatorworkingdetail_id", using: :btree
    t.index ["tenant_id"], name: "index_operatorproductiondetails_on_tenant_id", using: :btree
  end

  create_table "operators", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "operator_name"
    t.string   "operator_spec_id"
    t.string   "description"
    t.integer  "tenant_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.boolean  "isactive",         default: true
    t.datetime "deleted_at"
    t.index ["tenant_id"], name: "index_operators_on_tenant_id", using: :btree
  end

  create_table "operatorworkingdetails", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.date     "working_date"
    t.string   "from_time"
    t.string   "to_time"
    t.integer  "user_id"
    t.integer  "shifttransaction_id"
    t.integer  "machine_id"
    t.integer  "tenant_id"
    t.string   "no_of_rejects"
    t.string   "no_of_parts_produced"
    t.string   "parts_moved_to_next_operation"
    t.string   "total_down_time"
    t.string   "reason_for_down_time"
    t.string   "last_machine_reset_time"
    t.string   "remarks"
    t.integer  "cncoperation_id"
    t.integer  "cncjob_id"
    t.string   "no_of_reworks"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.boolean  "isactive"
    t.datetime "deleted_at"
    t.index ["cncjob_id"], name: "index_operatorworkingdetails_on_cncjob_id", using: :btree
    t.index ["cncoperation_id"], name: "index_operatorworkingdetails_on_cncoperation_id", using: :btree
    t.index ["machine_id"], name: "index_operatorworkingdetails_on_machine_id", using: :btree
    t.index ["shifttransaction_id"], name: "index_operatorworkingdetails_on_shifttransaction_id", using: :btree
    t.index ["tenant_id"], name: "index_operatorworkingdetails_on_tenant_id", using: :btree
    t.index ["user_id"], name: "index_operatorworkingdetails_on_user_id", using: :btree
  end

  create_table "pageauthorizations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "authorization_name"
    t.string   "description"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "pages", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "page_name"
    t.string   "icon"
    t.string   "url"
    t.integer  "parent_page_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "companytype_id"
    t.index ["companytype_id"], name: "index_pages_on_companytype_id", using: :btree
  end

  create_table "plannedmaintanances", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "maintanance_type"
    t.date     "duration_from"
    t.date     "duration_to"
    t.date     "expire_date"
    t.string   "supplier_name"
    t.string   "remarks"
    t.integer  "machine_id"
    t.integer  "tenant_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["machine_id"], name: "index_plannedmaintanances_on_machine_id", using: :btree
    t.index ["tenant_id"], name: "index_plannedmaintanances_on_tenant_id", using: :btree
  end

  create_table "planstatuses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "planstatus_name"
    t.string   "description"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "machine_id"
    t.datetime "last_mail_time"
    t.boolean  "mail_status"
    t.index ["machine_id"], name: "index_planstatuses_on_machine_id", using: :btree
  end

  create_table "plants", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "plant_name"
    t.string   "place"
    t.integer  "tenant_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tenant_id"], name: "index_plants_on_tenant_id", using: :btree
  end

  create_table "pre_monthly_logs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "parts_count"
    t.string   "machine_status"
    t.string   "job_id"
    t.integer  "total_run_time"
    t.integer  "total_cutting_time"
    t.integer  "run_time"
    t.integer  "feed_rate"
    t.integer  "cutting_speed"
    t.integer  "axis_load"
    t.string   "axis_name"
    t.integer  "spindle_speed"
    t.integer  "spindle_load"
    t.integer  "total_run_second"
    t.string   "programe_number"
    t.string   "programe_description"
    t.integer  "run_second"
    t.integer  "machine_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["machine_id"], name: "index_pre_monthly_logs_on_machine_id", using: :btree
  end

  create_table "problem_status_logs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.boolean  "mail_status"
    t.integer  "tenant_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.datetime "last_mail_time"
    t.index ["tenant_id"], name: "index_problem_status_logs_on_tenant_id", using: :btree
  end

  create_table "program_reports", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.date     "date"
    t.integer  "shift_id"
    t.integer  "shift_no"
    t.string   "time"
    t.integer  "operator_id"
    t.integer  "machine_id"
    t.string   "program_number"
    t.string   "job_description"
    t.integer  "parts_produced"
    t.string   "cycle_time"
    t.string   "loading_and_unloading_time"
    t.string   "idle_time"
    t.string   "total_downtime"
    t.string   "actual_running"
    t.string   "actual_working_hours"
    t.string   "utilization"
    t.integer  "tenant_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["machine_id"], name: "index_program_reports_on_machine_id", using: :btree
    t.index ["operator_id"], name: "index_program_reports_on_operator_id", using: :btree
    t.index ["shift_id"], name: "index_program_reports_on_shift_id", using: :btree
    t.index ["tenant_id"], name: "index_program_reports_on_tenant_id", using: :btree
  end

  create_table "reports", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.date     "date"
    t.integer  "shift_id"
    t.integer  "shift_no"
    t.string   "time"
    t.integer  "operator_id"
    t.integer  "machine_id"
    t.string   "program_number"
    t.string   "job_description"
    t.integer  "parts_produced"
    t.string   "cycle_time"
    t.string   "loading_and_unloading_time"
    t.string   "idle_time"
    t.string   "total_downtime"
    t.string   "actual_running"
    t.string   "actual_working_hours"
    t.string   "utilization"
    t.integer  "tenant_id"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.text     "all_cycle_time",             limit: 65535
    t.boolean  "is_sent"
    t.index ["date"], name: "index_reports_on_date", using: :btree
    t.index ["machine_id"], name: "index_reports_on_machine_id", using: :btree
    t.index ["operator_id"], name: "index_reports_on_operator_id", using: :btree
    t.index ["shift_id"], name: "index_reports_on_shift_id", using: :btree
    t.index ["shift_no"], name: "index_reports_on_shift_no", using: :btree
    t.index ["tenant_id"], name: "index_reports_on_tenant_id", using: :btree
  end

  create_table "roles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "role_name"
    t.integer  "tenant_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tenant_id"], name: "index_roles_on_tenant_id", using: :btree
  end

  create_table "sessions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean  "isactive"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_sessions_on_deleted_at", using: :btree
  end

  create_table "set_alarm_settings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "alarm_for"
    t.string   "time_interval"
    t.integer  "alarm_type"
    t.integer  "machine_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.boolean  "active"
    t.index ["machine_id"], name: "index_set_alarm_settings_on_machine_id", using: :btree
  end

  create_table "settings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.boolean  "date_wise",          default: false
    t.boolean  "month_wise",         default: false
    t.boolean  "shift_wise",         default: true
    t.boolean  "operator_wise",      default: true
    t.boolean  "email_notification", default: false
    t.boolean  "hour_wise"
    t.boolean  "program_wise",       default: false
    t.boolean  "sms",                default: false
    t.boolean  "notification",       default: false
    t.string   "created_by"
    t.integer  "tenant_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.boolean  "ethernet",           default: false
    t.boolean  "rs232",              default: false
    t.boolean  "ct",                 default: false
    t.boolean  "simans",             default: false
    t.boolean  "option1",            default: false
    t.boolean  "option2",            default: false
    t.index ["tenant_id"], name: "index_settings_on_tenant_id", using: :btree
  end

  create_table "shift_parts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.date     "date"
    t.string   "time"
    t.integer  "shift_no"
    t.string   "part"
    t.string   "program_number"
    t.boolean  "is_complete",         default: false
    t.integer  "status"
    t.string   "idle_status"
    t.integer  "machine_id"
    t.integer  "shifttransaction_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["machine_id"], name: "index_shift_parts_on_machine_id", using: :btree
    t.index ["shifttransaction_id"], name: "index_shift_parts_on_shifttransaction_id", using: :btree
  end

  create_table "shift_timeline_reports", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.date     "date"
    t.integer  "ideal_time"
    t.integer  "run_time"
    t.integer  "stop_time"
    t.integer  "machine_id"
    t.integer  "shifttransaction_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["machine_id"], name: "index_shift_timeline_reports_on_machine_id", using: :btree
    t.index ["shifttransaction_id"], name: "index_shift_timeline_reports_on_shifttransaction_id", using: :btree
  end

  create_table "shifts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "working_time"
    t.integer  "no_of_shift"
    t.string   "day_start_time"
    t.integer  "tenant_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.boolean  "isactive"
    t.datetime "deleted_at"
    t.time     "working_time_dummy"
    t.time     "day_start_time_dummy"
    t.index ["deleted_at"], name: "index_shifts_on_deleted_at", using: :btree
    t.index ["tenant_id"], name: "index_shifts_on_tenant_id", using: :btree
  end

  create_table "shifttransactions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "shift_start_time"
    t.string   "shift_end_time"
    t.string   "actual_working_hours"
    t.integer  "shift_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "shift_no"
    t.boolean  "isactive"
    t.datetime "deleted_at"
    t.time     "shift_start_time_dummy"
    t.time     "shift_end_time_dummy"
    t.time     "actual_working_hours_dummy"
    t.string   "actual_working_without_break"
    t.integer  "day"
    t.integer  "end_day"
    t.index ["deleted_at"], name: "index_shifttransactions_on_deleted_at", using: :btree
    t.index ["shift_id"], name: "index_shifttransactions_on_shift_id", using: :btree
  end

  create_table "tenant_setting_lists", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "setting_name"
    t.string   "manual"
    t.boolean  "is_active",          default: false
    t.integer  "machine_setting_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.index ["machine_setting_id"], name: "index_tenant_setting_lists_on_machine_setting_id", using: :btree
  end

  create_table "tenant_settings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.boolean  "is_active",  default: true
    t.string   "reason"
    t.string   "manual"
    t.integer  "tenant_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["tenant_id"], name: "index_tenant_settings_on_tenant_id", using: :btree
  end

  create_table "tenants", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "tenant_name"
    t.string   "address_line1"
    t.string   "address_line2"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "pincode"
    t.integer  "parent_tenant_id"
    t.integer  "companytype_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.boolean  "isactive"
    t.datetime "deleted_at"
    t.text     "machine_type",     limit: 65535
    t.index ["companytype_id"], name: "index_tenants_on_companytype_id", using: :btree
    t.index ["deleted_at"], name: "index_tenants_on_deleted_at", using: :btree
  end

  create_table "test_machine_logs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "parts_count"
    t.integer  "machine_status"
    t.text     "job_id",               limit: 65535
    t.integer  "total_run_time"
    t.integer  "total_cutting_time"
    t.integer  "run_time"
    t.integer  "feed_rate"
    t.integer  "cutting_speed"
    t.integer  "axis_load"
    t.string   "axis_name"
    t.integer  "spindle_speed"
    t.integer  "spindle_load"
    t.integer  "total_run_second"
    t.string   "programe_number"
    t.string   "programe_description"
    t.integer  "run_second"
    t.integer  "machine_id"
    t.datetime "machine_date"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.index ["machine_id"], name: "index_test_machine_logs_on_machine_id", using: :btree
  end

  create_table "user_setting_lists", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "setting_name"
    t.string   "manual"
    t.boolean  "is_active",       default: false
    t.integer  "user_setting_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.index ["user_setting_id"], name: "index_user_setting_lists_on_user_setting_id", using: :btree
  end

  create_table "user_settings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.boolean  "is_active",                default: true
    t.string   "reason"
    t.string   "manual"
    t.text     "machine",    limit: 65535
    t.integer  "user_id"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.index ["user_id"], name: "index_user_settings_on_user_id", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email_id"
    t.string   "password"
    t.string   "phone_number"
    t.string   "remarks"
    t.integer  "usertype_id"
    t.integer  "approval_id"
    t.integer  "tenant_id"
    t.integer  "role_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.boolean  "isactive"
    t.datetime "deleted_at"
    t.string   "password_digest"
    t.string   "default"
    t.index ["approval_id"], name: "index_users_on_approval_id", using: :btree
    t.index ["deleted_at"], name: "index_users_on_deleted_at", using: :btree
    t.index ["role_id"], name: "index_users_on_role_id", using: :btree
    t.index ["tenant_id"], name: "index_users_on_tenant_id", using: :btree
    t.index ["usertype_id"], name: "index_users_on_usertype_id", using: :btree
  end

  create_table "userslogs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email_id"
    t.string   "password"
    t.string   "phone_number"
    t.string   "remarks"
    t.integer  "usertype_id"
    t.integer  "approval_id"
    t.integer  "tenant_id"
    t.integer  "role_id"
    t.integer  "user_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.boolean  "isactive"
    t.datetime "deleted_at"
    t.index ["approval_id"], name: "index_userslogs_on_approval_id", using: :btree
    t.index ["deleted_at"], name: "index_userslogs_on_deleted_at", using: :btree
    t.index ["role_id"], name: "index_userslogs_on_role_id", using: :btree
    t.index ["tenant_id"], name: "index_userslogs_on_tenant_id", using: :btree
    t.index ["user_id"], name: "index_userslogs_on_user_id", using: :btree
    t.index ["usertype_id"], name: "index_userslogs_on_usertype_id", using: :btree
  end

  create_table "usertypes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "usertype_name"
    t.string   "description"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_foreign_key "alarm_histories", "machines"
  add_foreign_key "alarm_tests", "machines"
  add_foreign_key "alarms", "machines"
  add_foreign_key "break_times", "shifttransactions"
  add_foreign_key "cnc_hour_reports", "machines"
  add_foreign_key "cnc_hour_reports", "operators"
  add_foreign_key "cnc_hour_reports", "shifts"
  add_foreign_key "cnc_hour_reports", "tenants"
  add_foreign_key "cnc_reports", "machines"
  add_foreign_key "cnc_reports", "operators"
  add_foreign_key "cnc_reports", "shifts"
  add_foreign_key "cnc_reports", "tenants"
  add_foreign_key "cncclients", "tenants"
  add_foreign_key "cncjobs", "cncclients"
  add_foreign_key "cncjobs", "tenants"
  add_foreign_key "cncoperations", "cncjobs"
  add_foreign_key "cncoperations", "planstatuses"
  add_foreign_key "cncoperations", "tenants"
  add_foreign_key "cnctools", "machines"
  add_foreign_key "cnctools", "tenants"
  add_foreign_key "cncvendors", "cncoperations"
  add_foreign_key "cncvendors", "tenants"
  add_foreign_key "connection_logs", "tenants"
  add_foreign_key "consolidate_data", "machines"
  add_foreign_key "consummablemaintanances", "machines"
  add_foreign_key "consummablemaintanances", "tenants"
  add_foreign_key "ct_machine_daily_logs", "machines"
  add_foreign_key "ct_machine_logs", "machines"
  add_foreign_key "ct_reports", "machines"
  add_foreign_key "ct_reports", "operators"
  add_foreign_key "ct_reports", "shifts"
  add_foreign_key "ct_reports", "tenants"
  add_foreign_key "dashboard_data", "machines"
  add_foreign_key "dashboard_data", "shifttransactions"
  add_foreign_key "dashboard_data", "tenants"
  add_foreign_key "data_loss_entries", "machines"
  add_foreign_key "deliveries", "cncjobs"
  add_foreign_key "deliveries", "deliverytypes"
  add_foreign_key "delivery_lists", "cncclients"
  add_foreign_key "delivery_lists", "job_lists"
  add_foreign_key "device_mappings", "devices"
  add_foreign_key "device_mappings", "tenants"
  add_foreign_key "devices", "device_types"
  add_foreign_key "ethernet_logs", "machines"
  add_foreign_key "ethernet_logs", "tenants"
  add_foreign_key "hmi_machine_details", "machines"
  add_foreign_key "hmi_machine_details", "operators"
  add_foreign_key "hmi_machine_details", "shifttransactions"
  add_foreign_key "hmi_machine_details", "tenants"
  add_foreign_key "hmi_machine_reasons", "hmi_machine_details"
  add_foreign_key "hmi_machine_reasons", "hmi_reasons"
  add_foreign_key "hmi_machine_reasons", "machines"
  add_foreign_key "hmi_machine_reasons", "tenants"
  add_foreign_key "hour_detail_timeline_reports", "hour_timeline_reports"
  add_foreign_key "hour_reports", "machines"
  add_foreign_key "hour_reports", "operators"
  add_foreign_key "hour_reports", "shifts"
  add_foreign_key "hour_reports", "tenants"
  add_foreign_key "hour_timeline_reports", "shift_timeline_reports"
  add_foreign_key "job_lists", "cncclients"
  add_foreign_key "load_unloads", "machines"
  add_foreign_key "machine_daily_logs", "machines"
  add_foreign_key "machine_log_histories", "machines"
  add_foreign_key "machine_logs", "machines"
  add_foreign_key "machine_monthly_logs", "machines"
  add_foreign_key "machine_setting_lists", "machine_settings"
  add_foreign_key "machine_settings", "machines"
  add_foreign_key "machine_shift_reports", "machines"
  add_foreign_key "machineallocations", "cncoperations"
  add_foreign_key "machineallocations", "machines"
  add_foreign_key "machineallocations", "tenants"
  add_foreign_key "machines", "tenants"
  add_foreign_key "mail_logs", "tenants"
  add_foreign_key "maintananceentries", "machines"
  add_foreign_key "maintananceentries", "tenants"
  add_foreign_key "materials", "cncjobs"
  add_foreign_key "materials", "tenants"
  add_foreign_key "menuconfigurations", "pageauthorizations"
  add_foreign_key "menuconfigurations", "pages"
  add_foreign_key "menuconfigurations", "roles"
  add_foreign_key "menuconfigurations", "tenants"
  add_foreign_key "month_reports", "tenants"
  add_foreign_key "notifications", "machine_logs"
  add_foreign_key "notifications", "machines"
  add_foreign_key "oee_calculate_lists", "oee_calculations"
  add_foreign_key "oee_calculations", "machines"
  add_foreign_key "oee_calculations", "shifttransactions"
  add_foreign_key "one_signals", "tenants"
  add_foreign_key "one_signals", "users"
  add_foreign_key "operator_allocations", "machines"
  add_foreign_key "operator_allocations", "operators"
  add_foreign_key "operator_allocations", "shifttransactions"
  add_foreign_key "operator_allocations", "tenants"
  add_foreign_key "operator_entry_oees", "cncoperations"
  add_foreign_key "operator_entry_oees", "machines"
  add_foreign_key "operator_entry_oees", "shifttransactions"
  add_foreign_key "operator_mapping_allocations", "operator_allocations"
  add_foreign_key "operator_mapping_allocations", "operators"
  add_foreign_key "operatorproductiondetails", "operatorworkingdetails"
  add_foreign_key "operatorproductiondetails", "tenants"
  add_foreign_key "operators", "tenants"
  add_foreign_key "operatorworkingdetails", "cncjobs"
  add_foreign_key "operatorworkingdetails", "cncoperations"
  add_foreign_key "operatorworkingdetails", "machines"
  add_foreign_key "operatorworkingdetails", "shifttransactions"
  add_foreign_key "operatorworkingdetails", "tenants"
  add_foreign_key "operatorworkingdetails", "users"
  add_foreign_key "pages", "companytypes"
  add_foreign_key "plannedmaintanances", "machines"
  add_foreign_key "plannedmaintanances", "tenants"
  add_foreign_key "planstatuses", "machines"
  add_foreign_key "plants", "tenants"
  add_foreign_key "pre_monthly_logs", "machines"
  add_foreign_key "problem_status_logs", "tenants"
  add_foreign_key "program_reports", "machines"
  add_foreign_key "program_reports", "operators"
  add_foreign_key "program_reports", "shifts"
  add_foreign_key "program_reports", "tenants"
  add_foreign_key "reports", "machines"
  add_foreign_key "reports", "operators"
  add_foreign_key "reports", "shifts"
  add_foreign_key "reports", "tenants"
  add_foreign_key "roles", "tenants"
  add_foreign_key "set_alarm_settings", "machines"
  add_foreign_key "settings", "tenants"
  add_foreign_key "shift_parts", "machines"
  add_foreign_key "shift_parts", "shifttransactions"
  add_foreign_key "shift_timeline_reports", "machines"
  add_foreign_key "shift_timeline_reports", "shifttransactions"
  add_foreign_key "shifts", "tenants"
  add_foreign_key "shifttransactions", "shifts"
  add_foreign_key "tenant_setting_lists", "machine_settings"
  add_foreign_key "tenant_settings", "tenants"
  add_foreign_key "tenants", "companytypes"
  add_foreign_key "test_machine_logs", "machines"
  add_foreign_key "user_setting_lists", "user_settings"
  add_foreign_key "user_settings", "users"
  add_foreign_key "users", "approvals"
  add_foreign_key "users", "roles"
  add_foreign_key "users", "tenants"
  add_foreign_key "users", "usertypes"
  add_foreign_key "userslogs", "approvals"
  add_foreign_key "userslogs", "roles"
  add_foreign_key "userslogs", "tenants"
  add_foreign_key "userslogs", "users"
  add_foreign_key "userslogs", "usertypes"
end
