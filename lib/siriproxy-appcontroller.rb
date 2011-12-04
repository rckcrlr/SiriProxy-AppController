require 'cora'
require 'siri_objects'
require 'app_controller'

#######
# This is a "hello world" style plugin. It simply intercepts the phrase "text siri proxy" and responds
# with a message about the proxy being up and running (along with a couple other core features). This 
# is good base code for other plugins.
# 
# Remember to add other plugins to the "config.yml" file if you create them!
######

class SiriProxy::Plugin::Example < SiriProxy::Plugin
  def initialize(config)
     @app_ctl = AppController.new()
  end
# Spoken name to real application name translation
  def spoketoreal(spoken)
    case
     when (spoken =~ /i[Tt]unes/)
       realapp = "iTunes"
     when (spoken =~ /[Pp]lex/)
       realapp = "Plex"
     when (spoken =~ /[Ww]eb[Cc]am/)
       realapp = "iCamSource"
     else 
       realapp = "unknown"
    end
    return realapp
  end


  listen_for /test siri proxy/i do
    say "Siri Proxy is up and running right now!" #say something to the user!
    
    request_completed #always complete your request! Otherwise the phone will "spin" at the user!
  end
## App Controller high level
  listen_for /applications .* control/i do
     say "I can start, stop and give you status on itunes, plex and your webcam"
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

  listen_for /stop (.*)/i do |spokenapp|
    app = spoketoreal(spokenapp)
    if (app == "unknown")
       say "I'm sorry, I don't know how to stop #{spokenapp}."
    else
       if (@app_ctl.appstatus?(app))
          @app_ctl.stopapp?(app)
          sleep 5
          unless (@app_ctl.appstatus?(app))
            say "#{spokenapp} has been stopped"
            request_completed
          else
            say "I'm sorry, I was not able to stop #{spokenapp}"
          end
       else
          say "#{spokenapp} is not running"
       end
    end
    request_completed
   end
  
  #Demonstrate that you can have Siri say one thing and write another"!
  listen_for /you don't say/i do
    say "Sometimes I don't write what I say", spoken: "Sometimes I don't say what I write"
  end 

  #demonstrate state change
  listen_for /siri proxy test state/i do
    set_state :some_state #set a state... this is useful when you want to change how you respond after certain conditions are met!
    say "I set the state, try saying 'confirm state change'"
    
    request_completed #always complete your request! Otherwise the phone will "spin" at the user!
  end
  
  listen_for /confirm state change/i, within_state: :some_state do #this only gets processed if you're within the :some_state state!
    say "State change works fine!"
    set_state nil #clear out the state!
    
    request_completed #always complete your request! Otherwise the phone will "spin" at the user!
  end
  
  #demonstrate asking a question
  listen_for /siri proxy test question/i do
    response = ask "Is this thing working?" #ask the user for something
    
    if(response =~ /yes/i) #process their response
      say "Great!" 
    else
      say "You could have just said 'yes'!"
    end
    
    request_completed #always complete your request! Otherwise the phone will "spin" at the user!
  end
  
  #demonstrate capturing data from the user (e.x. "Siri proxy number 15")
  listen_for /siri proxy number ([0-9,]*[0-9])/i do |number|
    say "Detected number: #{number}"
    
    request_completed #always complete your request! Otherwise the phone will "spin" at the user!
  end
  
  #demonstrate injection of more complex objects without shortcut methods.
  listen_for /test map/i do
    add_views = SiriAddViews.new
    add_views.make_root(last_ref_id)
    map_snippet = SiriMapItemSnippet.new
    map_snippet.items << SiriMapItem.new
    utterance = SiriAssistantUtteranceView.new("Testing map injection!")
    add_views.views << utterance
    add_views.views << map_snippet
    
    #you can also do "send_object object, target: :guzzoni" in order to send an object to guzzoni
    send_object add_views #send_object takes a hash or a SiriObject object
    
    request_completed #always complete your request! Otherwise the phone will "spin" at the user!
  end
end
