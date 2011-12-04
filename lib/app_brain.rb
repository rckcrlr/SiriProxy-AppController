class AppBrain
   def initialize()
	# Put init stuff here.
   end

   def appstatus?(app)
     isrunning = `/usr/bin/killall -s "#{app}"`
     if (isrunning =~ /kill/)
       return true
     else
       return false
     end
   end
   
   def startapp?(app)
     if (appstatus?(app))
       return true
     else
       `/usr/bin/open -a "#{app}"`
     return appstatus?(app)
     end
   end
   
   def stopapp?(app)
     if (appstatus?(app))
       status = `/usr/bin/killall "#{app}"`
     end
     return appstatus?(app)
   end
end
