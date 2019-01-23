class SettingSerializer < ActiveModel::Serializer
  attributes :id, :date_wise, :month_wise, :shift_wise, :operator_wise, :hour_wise, :program_wise, :email_notification, :sms, :notification, :ethernet, :rs232, :ct, :simans
  #has_one :tenant
end
