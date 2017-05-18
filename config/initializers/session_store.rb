# Be sure to restart your server when you modify this file.

#Rails.application.config.session_store :cookie_store, key: '_sms_application_session', domain: :all
# SmsApplication::Application.config.session_store :cookie_store,
# 							:key => "_sms_application_session",
#                                              :domain=> :all,
#                                              :expire_after => 30.minutes
                                             

SmsApplication::Application.config.session_store :active_record_store,
					:key => "_sms_application_session",
                                             :domain=> :all,
                                             :expire_after => 30.minutes