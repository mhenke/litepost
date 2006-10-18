<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE circuit>
<circuit access="internal">

	<fuseaction name="main">
		<do action="entry.recent" />
	</fuseaction>
	
	<fuseaction name="output">
		<include template="../layout/lay_main.cfm" />
	</fuseaction>
	
	<fuseaction name="message">
		<set name="title" value="System Message" overwrite="false" />
		<set name="message" value="" overwrite="false" />
		<set name="forward" value="entry.recent" overwrite="false" />
		<include template="dsp_message.cfm" contentvariable="REQUEST.content.body" />
	</fuseaction>
	
	<fuseaction name="globalXFA">
		<xfa name="home" value="entry.recent" />
		<xfa name="view" value="entry.display" />
		<xfa name="addPost" value="entry.addForm" />
		<xfa name="login" value="login.form" />
		<xfa name="logout" value="login.logout" />
	</fuseaction>
	
</circuit>
