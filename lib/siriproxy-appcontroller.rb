require 'cora'
require 'siri_objects'
require 'app_brain'


class SiriProxy::Plugin::AppController < SiriProxy::Plugin
  def initialize(config)
     @app_ctl = AppBrain.new()
  end
# Spoken name to real application name translation
  def spoketoreal(spoken)
    case
     when (spoken =~ /i[Tt]unes/)
       realapp = "iTunes"
     when (spoken =~ /[Mm]edia/)
       realapp = "Plex"
     when (spoken =~ /[Ww]eb[Cc]am/)
       realapp = "iCamSource"
     else 
       realapp = "unknown"
    end
    return realapp
  end

## App Controller high level
  listen_for /applications .* control/i do
     say "I can start, shutdown and give you status on itunes, plex and your webcam"
     request_completed
  end

## iTunes status/up/down
  listen_for /status of (.*)/i do |spokenapp|
    app = spoketoreal(spokenapp)
    if (app == "unknown")
       say "I haven't been programmed to manage #{spokenapp}."
    else
       if (@app_ctl.appstatus?(app))
          say "#{spokenapp} is up"
       else
          say "#{spokenapp} is down"
       end
    end
    request_completed
  end


  listen_for /start (.*)/i do |spokenapp|
    app = spoketoreal(spokenapp)
    if (app == "unknown")
       say "I'm sorry, I don't know how to start #{spokenapp}."
    else
       if (@app_ctl.appstatus?(app))
          say "#{spokenapp} is already running"
          request_completed
       else
          @app_ctl.startapp?(app)
          sleep 5
       end
       if (@app_ctl.appstatus?(app))
          say "#{spokenapp} has been started"
       else
          say "I'm sorry, I was not able to start #{spokenapp}"
       end
    end
    request_completed
  end

  listen_for /shutdown (.*)/i do |spokenapp|
    app = spoketoreal(spokenapp)
    if (app == "unknown")
       say "I'm sorry, I don't know how to shutdown #{spokenapp}."
    else
       if (@app_ctl.appstatus?(app))
          @app_ctl.stopapp?(app)
          sleep 5
          unless (@app_ctl.appstatus?(app))
            say "#{spokenapp} has been stopped"
            request_completed
          else
            say "I'm sorry, I was not able to shutdown #{spokenapp}"
          end
       else
          say "#{spokenapp} is not running"
       end
    end
    request_completed
   end
end
