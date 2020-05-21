require 'yaml'


# Set a logger so that you can view the SQL actually performed by ActiveRecord
logger = Logger.new(STDOUT)
logger.formatter = proc do |_severity, _datetime, _progname, msg|
  "#{msg}\n"
end
ActiveRecord::Base.logger = logger

# Load models
Dir["#{__dir__}/../app/models/*.rb"].each { |file| require file }


# Discard warning message for i18n errors
I18n.enforce_available_locales = false
