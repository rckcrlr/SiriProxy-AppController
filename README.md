<h1>About</h1>

<p>SiriProxy-AppController plugin to start, shutdown and get status of Mac OSX applications using Siri.</p>

<p>Any application that can be started using "open -a" can be configured.</p>

<p>The plugin by default will control iTunes, Plex and iCamSource.</p>

<p>Spoken commands are:</p>

<p>Start "app"
Shutdown "app"
Status of "app"</p>

<p>Siri knows Plex as "media" and iCamSource as "WebCam".  This was done as Siri has a problem understanding the word Plex and icamsource.  </p>

<h1>Installation</h1>

<p>1) Install siriproxy using the instructions here: https://github.com/plamoni/SiriProxy</p>

<p>2) Add AppConroller config lines from config-info.yml to your siriproxy config.yml file</p>

<p>3) From the top level of your siriproxy installation run './bin/siriproxy bundle'</p>

<p>To add apps or change the word that Siri uses for an app you can edit the 'case' statement at the top of siriproxy-appcontroller.rb.</p>

<p>That's it</p>

<h1>ToDo</h1>

<p>Remove case statement in siriproxy-appcontroller.rb and do the application configuration information to config.yml</p>
