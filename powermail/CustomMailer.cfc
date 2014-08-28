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
<cfcomponent name="CustomMailer" hint="Sends email">

	<cfset variables.server = "" />
	<cfset variables.username = "" />
	<cfset variables.password = "" />
	<cfset variables.useTLS = "" />
	<cfset variables.useSSL = "" />
	<cfset variables.port = "" />
	<cfset variables.defaultFromAddress = "" />
	<cfset variables.defaultToAddress = "" />

	<cffunction name="init" access="public" output="false" returntype="any">
		<cfargument name="server" required="false" default="">  
		<cfargument name="username" required="false" default="">  
		<cfargument name="password" required="false" default="">
		<cfargument name="defaultFromAddress" required="false" default="">
		<cfargument name="defaultToAddress" required="false" default="">
		<cfargument name="useTLS" required="false" default="">
		<cfargument name="useSSL" required="false" default="">
		<cfargument name="port" required="false" default="">
		
		<cfset variables.server = arguments.server />
		<cfset variables.username = arguments.username />
		<cfset variables.password = arguments.password />
		<cfset variables.defaultFromAddress = arguments.defaultFromAddress />
		<cfset variables.defaultToAddress = arguments.defaultToAddress />
		<cfset variables.useTLS = arguments.useTLS />
		<cfset variables.useSSL = arguments.useSSL />
		<cfset variables.port = arguments.port />
		<cfreturn this />
	</cffunction>

	<!--- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: --->
	<cffunction name="sendEmail" output="false" returnType="void" description="sends an email to the specified address"  access="public">
		<cfargument name="to" required="false" default="#variables.defaultToAddress#">
		<cfargument name="from" required="false" default="#variables.defaultFromAddress#">
		<cfargument name="subject" required="false" default="">
		<cfargument name="body" required="false" default="">
		<cfargument name="bcc" required="false" default="">
		<cfargument name="type" required="false" default="plain text">
	 
		<cfset var plaintext = "">
		<cfset var args = StructNew() />
		<cfif arguments.type EQ "html">
			<cfset plaintext = ReReplaceNoCase(arguments.body, "<[^>]*>", "", "ALL")>
		</cfif>
		
		<!--- build cfmail attribute collection --->
		<cfset args.to = arguments.to />
		<cfset args.from = arguments.from />
		<cfset args.subject = arguments.subject />
		<cfset args.type = arguments.type />
		<cfif len(arguments.bcc)>
			<cfset args.bcc = arguments.bcc />
		</cfif>
		<cfif len(variables.server)>
			<cfset args.server = variables.server />
		</cfif>
		<cfif len(variables.username)>
			<cfset args.username = variables.username />
		</cfif>
		<cfif len(variables.password)>
			<cfset args.password = variables.password />
		</cfif>
		<cfif len(variables.useTLS)>
			<cfset args.useTLS = variables.useTLS />
		</cfif>
		<cfif len(variables.useSSL)>
			<cfset args.useSSL = variables.useSSL />
		</cfif>
		<cfif len(variables.port)>
			<cfset args.port = variables.port />
		</cfif>
		
		<cfmail attributecollection="#args#"><cfif arguments.type neq "html">#arguments.body#<cfelse>
			<cfmailpart type="text">#plaintext#</cfmailpart>
			<cfmailpart type="html">#arguments.body#</cfmailpart>
			</cfif>
		</cfmail>
	</cffunction> 

	<!--- some custom functions that will allow plugin developers to check on whether or not this plugin is installed, via checking for feature support --->	
	<cffunction name="supportsBCC" access="public" output="false" returntype="boolean">
		<cfreturn true />
	</cffunction>
	<cffunction name="supportsSSL" access="public" output="false" returntype="boolean">
		<cfreturn true />
	</cffunction>
	<cffunction name="supportsTLS" access="public" output="false" returntype="boolean">
		<cfreturn true />
	</cffunction>

</cfcomponent>