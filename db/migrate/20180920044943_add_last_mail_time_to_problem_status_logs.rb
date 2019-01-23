class AddLastMailTimeToProblemStatusLogs < ActiveRecord::Migration[5.0]
  def change
    add_column :problem_status_logs, :last_mail_time, :datetime
  end
end
