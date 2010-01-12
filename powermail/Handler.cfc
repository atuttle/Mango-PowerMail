<!---
LICENSE INFORMATION:

Copyright 2010, Adam Tuttle

Licensed under the Apache License, Version 2.0 (the "License"); you may not
use this file except in compliance with the License.

You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
CONDITIONS OF ANY KIND, either express or implied. See the License for the
specific language governing permissions and limitations under the License.

VERSION INFORMATION:

This file is part of PowerMail.
--->
<cfcomponent displayname="Handler" extends="BasePlugin">

	<cffunction name="init" access="public" output="false" returntype="any">
		<cfargument name="mainManager" type="any" required="true" />
		<cfargument name="preferences" type="any" required="true" />

		<cfset setManager(arguments.mainManager) />
		<cfset setPreferencesManager(arguments.preferences) />
		<cfset setPackage("com/fusiongrokker/plugins/PowerMail") />

		<!--- monkeypatch custom mailer instantiation code into API --->
		<cfset getManager().getMailer = this.getMailer />

		<!--- 
			Here we're creating an interface to update Mango's core config. This is the best way I've figured out how to accomplish this so far. Got a better idea? Email me!
		 --->
		<!--- this logic is based on the way Application.cfc finds config.cfm --->
		<cfset variables.configFile = replaceNoCase(getDirectoryFromPath(getCurrentTemplatePath()),'components/plugins/user/powermail/','','all') & "config.cfm" />
		<!--- this logic is absed on how Mango.cfc instantiates PreferencesFile in its init method --->
		<cfset variables.preferences = createObject("component", "org.mangoblog.utilities.PreferencesFile").init(variables.configFile) />
		<!--- this logic is based on the above logic, and just finds the api directory --->
		<cfset variables.api = replacenocase(variables.configFile, "config.cfm", "api/") />
		
		<cfreturn this/>
	</cffunction>
	
	<!--- custom mailer instantiation code --->
	<cffunction name="getMailer" access="public" output="false" returntype="any">
		<cfreturn createObject("component", "components.plugins.user.PowerMail.CustomMailer").init(argumentCollection=variables.settings["mailServer"]) />	
	</cffunction>
	
	<!--- routine stuff --->
	<cffunction name="setup" hint="This is run when a plugin is activated" access="public" output="false" returntype="any">
		<cfreturn "PowerMail is activated.<br/>Would you like to <a href='generic_settings.cfm?event=PowerMail-settings&amp;owner=PowerMail&amp;selected=PowerMail-settings'>change its settings</a>?" />
	</cffunction>
	<cffunction name="unsetup" hint="This is run when a plugin is de-activated" access="public" output="false" returntype="any">
		<cfreturn "Plugin De-activated" />
	</cffunction>
	<cffunction name="upgrade" hint="This is run when upgrading from a previous version with auto-install" output="false" returntype="any">
		<cfreturn "Upgrade complete." />
	</cffunction>
	<cffunction name="handleEvent" hint="Asynchronous event handling" access="public" output="false" returntype="any">
		<cfargument name="event" type="any" required="true" />
		<!--- this plugin doesn't respond to any asynch events --->
		<cfreturn />
	</cffunction>
	<!--- main work of the plugin --->
	<cffunction name="processEvent" hint="Synchronous event handling" access="public" output="false" returntype="any">
		<cfargument name="event" type="any" required="true" />
		<cfset var eventName = arguments.event.getName()/>
		<cfset var local = structNew()/>

		<cfif eventName eq "settingsNav">
			<!--- add our settings link --->
			<cfset local.link = structnew() />
			<cfset local.link.owner = "PowerMail">
			<cfset local.link.page = "settings" />
			<cfset local.link.title = "PowerMail" />
			<cfset local.link.eventName = "PowerMail-settings" />
			<cfset arguments.event.addLink(local.link)>

		<cfelseif eventName EQ "PowerMail-settings">
			<!--- render settings page --->
			<cfsavecontent variable="local.content">
				<cfoutput>
					<cfinclude template="settings.cfm">
				</cfoutput>
			</cfsavecontent>
			<cfset local.data = arguments.event.data />
			<cfset local.data.message.setTitle("PowerMail settings") />
			<cfset local.data.message.setData(local.content) />
		</cfif>
		<cfreturn arguments.event />
	</cffunction>
</cfcomponent>