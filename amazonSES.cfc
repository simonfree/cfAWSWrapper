<cfcomponent output="false" extends="amazonAWS" >
	<cffunction name="init" access="public" returntype="amazonSES" >
		<cfargument name="awsAccessKeyId" type="string" required="true"/>
		<cfargument name="secretAccessKey" type="string" required="true"/>
		<cfargument name="endPoint" type="string" required="true" default="sns.us-east-1.amazonaws.com"/>
				
		<cfset variables.awsAccessKeyId = arguments.awsAccessKeyId />
		<cfset variables.secretAccesskey = arguments.secretAccessKey />
		<cfset variables.endPoint = arguments.endPoint />
		
		<cfset variables.requestMethod = '' />
		<cfreturn this />		
	</cffunction>	
	
	<cffunction name="ListVerifiedEmailAddresses" access="public" returntype="Struct" hint="Returns a list containing all of the email addresses that have been verified.">
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=ListVerifiedEmailAddresses" />
		
		<cfset var rawResult = makeRequestFull(
									endPoint = variables.endPoint,
									awsAccessKeyId = variables.awsAccessKeyId, 
									secretAccesskey = variables.secretAccesskey, 
									body=body,
									requestMethod=variables.requestMethod) />
									
		<cfif rawResult.statusCode neq 200>
			<cfset error = getResultNodes(xmlParse(rawResult.fileContent),'Error')[1] />
			<cfset stResponse.success=false />
			<cfset stResponse.statusCode=rawResult.statusCode />
			<cfset stResponse.error=error.Code.xmlText/>
			<cfset stResponse.errorType=error.Type.xmlText/>
			<cfset stResponse.errorMessage=error.Message.xmlText/>
		<cfelse>								
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'member') />
			<cfset stResponse.result = [] />
			
			<cfloop array="#dataResult#" index="member">
				<cfset arrayAppend(stResponse.result,member.xmlText) />
			</cfloop>	
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
		
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="verifyEmailAddress" access="public" returntype="String" hint="Verifies an email address. variables action causes a confirmation email message to be sent to the specified address.">
		<cfargument name="emailAddress" type="string" required="true" hint="The email address to be verified.">
		
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=VerifyEmailAddress&EmailAddress=" & trim(arguments.emailAddress) />
		
		<cfset var rawResult = makeRequestFull(
									endPoint = variables.endPoint,
									awsAccessKeyId = variables.awsAccessKeyId, 
									secretAccesskey = variables.secretAccesskey, 
									body=body,
									requestMethod = variables.requestMethod,
									version = variables.version  ) />
		
		<cfif rawResult.statusCode neq 200>
			<cfset error = getResultNodes(xmlParse(rawResult.fileContent),'Error')[1] />
			<cfset stResponse.success=false />
			<cfset stResponse.statusCode=rawResult.statusCode />
			<cfset stResponse.error=error.Code.xmlText/>
			<cfset stResponse.errorType=error.Type.xmlText/>
			<cfset stResponse.errorMessage=error.Message.xmlText/>
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
		
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="DeleteVerifiedEmailAddress" access="public" returntype="Struct" hint="Deletes the specified email address from the list of verified addresses.">
		<cfargument name="emailAddress" type="string" required="true" hint="An email address to be removed from the list of verified addreses.">
		
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=DeleteVerifiedEmailAddress&EmailAddress=" & trim(arguments.emailAddress) />
		
		<cfset var rawResult = makeRequestFull(
									endPoint = variables.endPoint,
									awsAccessKeyId = variables.awsAccessKeyId, 
									secretAccesskey = variables.secretAccesskey, 
									body=body ) />
		
		<cfif rawResult.statusCode neq 200>
			<cfset error = getResultNodes(xmlParse(rawResult.fileContent),'Error')[1] />
			<cfset stResponse.success=false />
			<cfset stResponse.statusCode=rawResult.statusCode />
			<cfset stResponse.error=error.Code.xmlText/>
			<cfset stResponse.errorType=error.Type.xmlText/>
			<cfset stResponse.errorMessage=error.Message.xmlText/>
		</cfif>	
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
		
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="GetSendQuota" access="public" returntype="Struct" hint="Returns the user's current sending limits.">
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=GetSendQuota" />
		
		<cfset var rawResult = makeRequestFull(
									endPoint = variables.endPoint,
									awsAccessKeyId = variables.awsAccessKeyId, 
									secretAccesskey = variables.secretAccesskey, 
									body=body ) />
		
		<cfif rawResult.statusCode neq 200>
			<cfset error = getResultNodes(xmlParse(rawResult.fileContent),'Error')[1] />
			<cfset stResponse.success=false />
			<cfset stResponse.statusCode=rawResult.statusCode />
			<cfset stResponse.error=error.Code.xmlText/>
			<cfset stResponse.errorType=error.Type.xmlText/>
			<cfset stResponse.errorMessage=error.Message.xmlText/>
		<cfelse>	
			<cfset dataResult = getResultNodes(xmlParse(rawResult.fileContent),'GetSendQuotaResult')[1] />
			<cfset stResponse.result = {} />
			<cfset stResponse.result['SentLast24Hours'] = getValue(dataResult,'SentLast24Hours') />
			<cfset stResponse.result['Max24HourSend'] = getValue(dataResult,'Max24HourSend') />
			<cfset stResponse.result['MaxSendRate'] = getValue(dataResult,'MaxSendRate') />
		</cfif>	

		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="GetSendStatistics" access="public" returntype="Struct" hint="Returns the user's sending statistics. The result is a list of data points, representing the last two weeks of sending activity. Each data point in the list contains statistics for a 15-minute interval.">
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=GetSendStatistics" />
		
		<cfset var rawResult = makeRequestFull(
									endPoint = variables.endPoint,
									awsAccessKeyId = variables.awsAccessKeyId, 
									secretAccesskey = variables.secretAccesskey, 
									body=body ) />
									
		<cfif rawResult.statusCode neq 200>
			<cfset error = getResultNodes(xmlParse(rawResult.fileContent),'Error')[1] />
			<cfset stResponse.success=false />
			<cfset stResponse.statusCode=rawResult.statusCode />
			<cfset stResponse.error=error.Code.xmlText/>
			<cfset stResponse.errorType=error.Type.xmlText/>
			<cfset stResponse.errorMessage=error.Message.xmlText/>
		<cfelse>								
			<cfset dataResult = getResultNodes(xmlParse(rawResult.fileContent),'SendDataPoints')[1].xmlChildren />
			<cfset stResponse.result = [] />
			
			<cfloop array="#dataResult#" index="sendDataPoint">
				<cfset arrayAppend(stResponse.result,createSendDataPoint(sendDataPoint)) />
			</cfloop>	
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
		
		<cfreturn stResponse />
	</cffunction>	
	
	<cffunction name="SendEmail" access="public" returntype="Struct" hint="Composes an email message based on input data, and then immediately queues the message for sending.">
		<cfargument name="to" type="String" required="true" >
		<cfargument name="from" type="String" required="true" >
		<cfargument name="subject" type="String" required="true" >
		<cfargument name="textbody" type="String" required="false" default="">
		<cfargument name="htmlbody" type="String" required="false" default="">
		<cfargument name="cc" type="String" required="false" default="">
		<cfargument name="bcc" type="String" required="false" default="" >
		<cfargument name="replyTo" type="String" required="false" default="" >
		<cfargument name="bounceback" type="String" required="false" default="" >
		
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=SendEmail" />

		<cfif listLen(arguments.to,',' )>
			<cfset var count = 1/>
			<cfloop list="#arguments.to#" index="listItem">
				<cfset body &= '&Destination.ToAddresses.member.' & count & '=' & trim(listItem)/>
				<cfset count++ />
			</cfloop>	
		<cfelse>	
			<cfset body &= '&Destination.ToAddresses.member.1=' & trim(arguments.to)/>
		</cfif>
		
		<cfif listLen(arguments.cc,',' )>
			<cfset var count = 1/>
			<cfloop list="#arguments.cc#" index="listItem">
				<cfset body &= '&Destination.CcAddresses.member.' & count & '=' & trim(listItem)/>
				<cfset count++ />
			</cfloop>	
		<cfelseif len(trim(arguments.cc))>	
			<cfset body &= '&Destination.CcAddresses.member.1=' & trim(arguments.cc)/>
		</cfif>
		
		<cfif listLen(arguments.bcc,',' )>
			<cfset var count = 1/>
			<cfloop list="#arguments.bcc#" index="listItem">
				<cfset body &= '&Destination.BccAddresses.member.' & count & '=' & trim(listItem)/>
				<cfset count++ />
			</cfloop>	
		<cfelseif len(trim(arguments.bcc))>	
			<cfset body &= '&Destination.BccAddresses.member.1=' & trim(arguments.bcc)/>
		</cfif>
		
		<cfif listLen(arguments.replyTo,',' )>
			<cfset var count = 1/>
			<cfloop list="#arguments.replyTo#" index="listItem">
				<cfset body &= '&ReplyToAddresses.member.' & count & '=' & trim(listItem)/>
				<cfset count++ />
			</cfloop>	
		<cfelseif len(trim(arguments.replyTo))>	
			<cfset body &= '&ReplyToAddresses.member.1=' & trim(arguments.replyTo)/>
		</cfif>					
		
		<cfif len(trim(arguments.bounceback))>
			<cfset body &= '&ReturnPath=' & trim(arguments.bounceback )/>
		</cfif>
		
		<cfif len(trim(arguments.textBody))>
			<cfset body &= '&Message.Body.Text.Data=' & trim(arguments.textBody )/>
		</cfif>	
		
		<cfif len(trim(arguments.htmlbody))>
			<cfset body &= '&Message.Body.Html.Data=' & trim(arguments.htmlBody )/>
		</cfif>	
		
		<cfset body &= "&Message.Subject.Data=#trim(arguments.subject)#&Source=#trim(arguments.from)#" />
		
		<cfset var rawResult = makeRequestFull(
									endPoint = variables.endPoint,
									awsAccessKeyId = variables.awsAccessKeyId, 
									secretAccesskey = variables.secretAccesskey, 
									body=body ) />
		
		<cfif rawResult.statusCode neq 200>
			<cfset error = getResultNodes(xmlParse(rawResult.fileContent),'Error')[1] />
			<cfset stResponse.success=false />
			<cfset stResponse.statusCode=rawResult.statusCode />
			<cfset stResponse.error=error.Code.xmlText/>
			<cfset stResponse.errorType=error.Type.xmlText/>
			<cfset stResponse.errorMessage=error.Message.xmlText/>
		<cfelse>								
			<cfset stResponse.result = getResultNodes(xmlParse(rawResult.filecontent),'MessageId')[1].xmlText />
		</cfif>	
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />

		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="SendRawEmail" access="public" returntype="String" hint="Sends an email message, with header and content specified by the client. The SendRawEmail action is useful for sending multipart MIME emails. The raw text of the message must comply with Internet email standards; otherwise, the message cannot be sent.">
		<cfargument name="RawMessage" type="String" required="true">
		<cfargument name="to" type="String" required="false" default="">
		<cfargument name="from" type="String" required="false" default="">
		
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=SendRawEmail" />

		<cfif listLen(arguments.to,',' )>
			<cfset var count = 1/>
			<cfloop list="#arguments.to#" index="listItem">
				<cfset body &= '&Destination.member.' & count & '=' & trim(listItem)/>
				<cfset count++ />
			</cfloop>	
		<cfelse>	
			<cfset body &= '&Destination.member.1=' & trim(arguments.to)/>
		</cfif>
		
		<cfif len(trim(arguments.from))>
			<cfset body &= '&Source=' & trim(arguments.from )/>
		</cfif>	
		
		<cfset body &= "&RawMessage.Data=#trim(arguments.RawMessage)#" />
		
		<cfset var rawResult = makeRequestFull(
									endPoint = variables.endPoint,
									awsAccessKeyId = variables.awsAccessKeyId, 
									secretAccesskey = variables.secretAccesskey, 
									body=body ) />
									
		<cfif rawResult.statusCode neq 200>
			<cfset error = getResultNodes(xmlParse(rawResult.fileContent),'Error')[1] />
			<cfset stResponse.success=false />
			<cfset stResponse.statusCode=rawResult.statusCode />
			<cfset stResponse.error=error.Code.xmlText/>
			<cfset stResponse.errorType=error.Type.xmlText/>
			<cfset stResponse.errorMessage=error.Message.xmlText/>
		<cfelse>	
			<cfset stResponse.result = getResultNodes(xmlParse(rawResult.filecontent),'MessageId')[1].xmlText />
		</cfif>	
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />

		<cfreturn stResponse />
	</cffunction>
</cfcomponent>