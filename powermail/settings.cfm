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

<cfif structKeyExists(form, 'powermail-settings-apply')>
<!--- set defaults from form post --->
	<cfparam name="form.server" default="" />
	<cfparam name="form.port" default="" />
	<cfparam name="form.username" default="" />
	<cfparam name="form.password" default="" />
	<cfparam name="form.defaultFromAddress" default="" />
	<cfparam name="form.defaultToAddress" default="" />
	<cfparam name="form.useSSL" default="false" />
	<cfparam name="form.useTLS" default="false" />
	<cfset variables.preferences.put('/generalSettings/mailServer', 'server', form.server, false) />
	<cfset variables.preferences.put('/generalSettings/mailServer', 'port', form.port, false) />
	<cfset variables.preferences.put('/generalSettings/mailServer', 'username', form.username, false) />
	<cfset variables.preferences.put('/generalSettings/mailServer', 'password', form.password, false) />
	<cfset variables.preferences.put('/generalSettings/mailServer', 'defaultFromAddress', form.defaultFromAddress, false) />
	<cfset variables.preferences.put('/generalSettings/mailServer', 'defaultToAddress', form.defaultToAddress, false) />
	<cfset variables.preferences.put('/generalSettings/mailServer', 'useSSL', form.useSSL, false) />
	<!--- set the "reload" argument of the final setting to "true" to force the settings to be persisted and
	the cached config to be reloaded --->
	<cfset variables.preferences.put('/generalSettings/mailServer', 'useTLS', form.useTLS, true) />

	<!--- display message --->
	<cfset event.data.message.setstatus("success") />
	<cfset event.data.message.setType("settings") />
	<cfset event.data.message.settext("Mail Server Updated") />

	<!--- update local plugin cache of file config values --->
	<cfset variables.preferences.init(variables.configFile) />
</cfif>

<!---
	Get values to display in the form. Since Mango doesn't provide an API to read settings from its main config file
	we need to use a local instance of the preferences file reader component that Mango uses.
--->
<cfset local.preferences = variables.preferences />
<cfparam name="form.server" default="#local.preferences.get(pathName='/generalSettings/mailServer',key='server')#" />
<cfparam name="form.port" default="#local.preferences.get(pathName='/generalSettings/mailServer',key='port')#" />
<cfparam name="form.username" default="#local.preferences.get(pathName='/generalSettings/mailServer',key='username')#" />
<cfparam name="form.password" default="#local.preferences.get(pathName='/generalSettings/mailServer',key='password')#" />
<cfparam name="form.defaultFromAddress" default="#local.preferences.get(pathName='/generalSettings/mailServer',key='defaultFromAddress')#" />
<cfparam name="form.defaultToAddress" default="#local.preferences.get(pathName='/generalSettings/mailServer',key='defaultToAddress')#" />
<cfparam name="form.useSSL" default="#local.preferences.get(pathName='/generalSettings/mailServer',key='useSSL')#" />
<cfparam name="form.useTLS" default="#local.preferences.get(pathName='/generalSettings/mailServer',key='useTLS')#" />

<cfoutput>
<form method="post" action="">
	<input type="hidden" name="powermail-settings-apply" value="true"/>
	<fieldset>
		<legend>Mail Server Settings</legend>
		<p>
			<label for="server">Server IP / DNS Name:</label>
			<span class="hint">
				e.g. 127.0.0.1 or smtp.example.com
			</span>
			<span class="field">
				<input type="text" id="server" name="server" value="#form.server#" size="30" />
			</span>
		</p>
		<p>
			<label for="port">Server Port:</label>
			<span class="hint">
				<strong>Numeric.</strong> Usually leave this blank unless directed to enter a specific port.
			</span>
			<span class="field">
				<input type="text" id="port" name="port" value="#form.port#" size="30" />
			</span>
		</p>
		<p>
			<label for="username">Server Username:</label>
			<span class="hint">
				Username required to authenticate with the server.
			</span>
			<span class="field">
				<input type="text" id="username" name="username" value="#form.username#" size="30" />
			</span>
		</p>
		<p>
			<label for="password">Server Password:</label>
			<span class="hint">
				Password for Username specified above.
			</span>
			<span class="field">
				<input type="password" id="password" name="password" value="#form.password#" size="30" />
			</span>
		</p>
		<p>
			<span class="field">
				<input type="checkbox" id="useSSL" name="useSSL" value="true" <cfif form.useSSL eq "true">checked="checked"</cfif> />
				<label for="useSSL">Use SSL</label>
				<span class="hint">
					Whether or not to connect to the server with SSL. Requires CF8 or later.
				</span>
			</span>
		</p>
		<p>
			<span class="field">
				<input type="checkbox" id="useTLS" name="useTLS" value="true" <cfif form.useTLS eq "true">checked="checked"</cfif> />
				<label for="useTLS">Use TLS</label>
				<span class="hint">
					Whether or not to connect to the server with TLS. Requires CF8 or later.
				</span>
			</span>
		</p>
		<p>
			<label for="username">Default From Address:</label>
			<span class="hint">
				Used when one is not passed as an argument.
			</span>
			<span class="field">
				<input type="text" id="defaultFromAddress" name="defaultFromAddress" value="#form.defaultFromAddress#" size="30" />
			</span>
		</p>
		<p>
			<label for="username">Default To Address:</label>
			<span class="hint">
				Used when one is not passed as an argument.
			</span>
			<span class="field">
				<input type="text" id="defaultToAddress" name="defaultToAddress" value="#form.defaultToAddress#" size="30" />
			</span>
		</p>
		<input type="submit" value="Save Changes" />
	</fieldset>
</form>
</cfoutput>
