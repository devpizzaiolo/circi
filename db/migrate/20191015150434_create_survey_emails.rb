class CreateSurveyEmails < ActiveRecord::Migration
  def change
    create_table :survey_emails do |t|
      t.string :email
      t.datetime :customer_survey_email_exported_at
      t.string :week_and_year

      t.timestamps
    end
  end
end
