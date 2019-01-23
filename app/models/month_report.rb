class MonthReport < ApplicationRecord
mount_uploader :file_path, FileUploader
  belongs_to :tenant
end
