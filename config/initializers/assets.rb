# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'


Rails.application.config.assets.precompile += %w( cloud_admins.js )
Rails.application.config.assets.precompile += %w( cloud_admins.css )
Rails.application.config.assets.precompile += %w( dashboards.css )
Rails.application.config.assets.precompile += %w( bootstrap.css )
Rails.application.config.assets.precompile += %w( dynamic_loaders.css )
Rails.application.config.assets.precompile += %w( footerStyle.css )
Rails.application.config.assets.precompile += %w( headerStyle.css )
Rails.application.config.assets.precompile += %w( homeStyle.css )
Rails.application.config.assets.precompile += %w( logoStyle.css )  
Rails.application.config.assets.precompile += %w( attendanceStyle.css )


# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
