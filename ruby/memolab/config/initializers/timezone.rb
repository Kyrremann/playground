# Run 'rake time:zones:all' to see all timezones
Rails.application.config.time_zone = 'Europe/Oslo'
Rails.application.config.active_record.default_timezone = :utc # or :local
