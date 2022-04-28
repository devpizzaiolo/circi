class SurveyEmail < ActiveRecord::Base
  attr_accessible :customer_survey_email_exported_at, :email, :week_and_year
end
