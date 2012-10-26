<cfcomponent output="false" extends="amazonAWS" >
	<cffunction name="init" access="public" returntype="amazonSNS" >
		<cfargument name="awsAccessKeyId" type="string" required="true"/>
		<cfargument name="secretAccessKey" type="string" required="true"/>
		<cfargument name="endPoint" type="string" required="true" default="sns.us-east-1.amazonaws.com" />
				
		<cfset variables.awsAccessKeyId = arguments.awsAccessKeyId />
		<cfset variables.secretAccesskey = arguments.secretAccessKey />
		<cfset variables.endPoint = arguments.endPoint />
		<cfset variables.requestMethod = 'no-header' />
		<cfreturn this />		
	</cffunction>	
	
	<cffunction name="ListTopics" access="public" returntype="Struct" >
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=ListTopics">
		
		<cfset var rawResult = makeRequestFull(
									endPoint = variables.endPoint,
									awsAccessKeyId = variables.awsAccessKeyId, 
									secretAccesskey = variables.secretAccesskey, 
									body=body,
									requestMethod=variables.requestMethod ) />
									
		<cfif rawResult.statusCode neq 200>
			<cfset error = getResultNodes(xmlParse(rawResult.fileContent),'Error')[1] />
			<cfset stResponse.success=false />
			<cfset stResponse.statusCode=rawResult.statusCode />
			<cfset stResponse.error=error.Code.xmlText/>
			<cfset stResponse.errorType=error.Type.xmlText/>
			<cfset stResponse.errorMessage=error.Message.xmlText/>
		<cfelse>		
			<cfset stResponse.result=[] />						
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'TopicArn') />
			
			<cfloop array="#dataResult#" index="topic">
				<cfset arrayAppend(stResponse.result, topic.xmlText) />
			</cfloop>	
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="ListSubscriptions" access="public" returntype="Struct" >
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=ListSubscriptions">

		<cfset var rawResult = makeRequestFull(
									endPoint = variables.endPoint,
									awsAccessKeyId = variables.awsAccessKeyId, 
									secretAccesskey = variables.secretAccesskey, 
									body=body,
									requestMethod=variables.requestMethod ) />

		<cfif rawResult.statusCode neq 200>
			<cfset error = getResultNodes(xmlParse(rawResult.fileContent),'Error')[1] />
			<cfset stResponse.success=false />
			<cfset stResponse.statusCode=rawResult.statusCode />
			<cfset stResponse.error=error.Code.xmlText/>
			<cfset stResponse.errorType=error.Type.xmlText/>
			<cfset stResponse.errorMessage=error.Message.xmlText/>
		<cfelse>	
			<cfset stResponse.result=[] />
			
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'member') />
			<cfloop array="#dataResult#" index="member">
				<cfset stMember = {} />
				<cfset stMember.Protocol = getValue(member,'Protocol') />
				<cfset stMember.Owner = getValue(member,'Owner') />
				<cfset stMember.TopicArn = getValue(member,'TopicArn') />
				<cfset stMember.SubscriptionArn = getValue(member,'SubscriptionArn') />
				<cfset stMember.Endpoint = getValue(member,'Endpoint') />
				<cfset arrayAppend(stResponse.result, stMember) />
			</cfloop>	
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="ListSubscriptionsByTopic" access="public" returntype="Struct" >
		<cfargument name="TopicArn" type="string" required="true" >
		
		<cfset var stResponse = createResponse() />
		<cfset var body = 'Action=ListSubscriptionsByTopic&TopicArn=' & trim(arguments.TopicArn)>
		
		<cfset var rawResult = makeRequestFull(
									endPoint = variables.endPoint,
									awsAccessKeyId = variables.awsAccessKeyId, 
									secretAccesskey = variables.secretAccesskey, 
									body=body,
									requestMethod=variables.requestMethod ) />

		<cfif rawResult.statusCode neq 200>
			<cfset error = getResultNodes(xmlParse(rawResult.fileContent),'Error')[1] />
			<cfset stResponse.success=false />
			<cfset stResponse.statusCode=rawResult.statusCode />
			<cfset stResponse.error=error.Code.xmlText/>
			<cfset stResponse.errorType=error.Type.xmlText/>
			<cfset stResponse.errorMessage=error.Message.xmlText/>
		<cfelse>	
			<cfset stResponse.result=[] />
			
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'member') />
			
			<cfloop array="#dataResult#" index="member">
				<cfset stMember = {} />
				<cfset stMember.Protocol = getValue(member,'Protocol') />
				<cfset stMember.Owner = getValue(member,'Owner') />
				<cfset stMember.TopicArn = getValue(member,'TopicArn') />
				<cfset stMember.SubscriptionArn = getValue(member,'SubscriptionArn') />
				<cfset stMember.Endpoint = getValue(member,'Endpoint') />
				<cfset arrayAppend(stResponse.result, stMember) />
			</cfloop>	
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="Subscribe" access="public" returntype="Struct" >
		<cfargument name="TopicArn" type="string" required="true" >
		<cfargument name="Endpoint" type="string" required="true" >
		<cfargument name="protocol" type="string" required="true" >
		
		<cfset var stResponse = createResponse() />
		<cfset var body = 'Action=Subscribe' & '&Endpoint=' & trim(arguments.Endpoint) & '&Protocol=' & trim(arguments.protocol) & '&TopicArn=' & trim(arguments.topicArn)>

		<cfset var rawResult = makeRequestFull(
									endPoint = variables.endPoint,
									awsAccessKeyId = variables.awsAccessKeyId, 
									secretAccesskey = variables.secretAccesskey, 
									body=body,
									requestMethod=variables.requestMethod ) />
									
		<cfif rawResult.statusCode neq 200>
			<cfset error = getResultNodes(xmlParse(rawResult.fileContent),'Error')[1] />
			<cfset stResponse.success=false />
			<cfset stResponse.statusCode=rawResult.statusCode />
			<cfset stResponse.error=error.Code.xmlText/>
			<cfset stResponse.errorType=error.Type.xmlText/>
			<cfset stResponse.errorMessage=error.Message.xmlText/>
		<cfelse>								
			<cfset stResponse.result = getResultNodes(xmlParse(rawResult.filecontent),'SubscriptionArn')[1].xmlText />
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="unsubscribe" access="public" returntype="Struct" >
		<cfargument name="SubscriptionArn" type="string" required="true" >
		
		<cfset var stResponse = createResponse() />
		<cfset var body = 'Action=Unsubscribe&SubscriptionArn=' & trim(arguments.SubscriptionArn)  />
		
		<cfset var rawResult = makeRequest(
									endPoint = variables.endPoint,
									awsAccessKeyId = variables.awsAccessKeyId, 
									secretAccesskey = variables.secretAccesskey, 
									body=body,
									requestMethod=variables.requestMethod ) />
									
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
	
	<cffunction name="ConfirmSubscription" access="public" returntype="Struct" >
		<cfargument name="TopicArn" type="string" required="true" >
		<cfargument name="Token" type="string" required="true" >
		<cfargument name="AuthenticateOnUnsubscribe" type="string" required="no" default="" >
		
		<cfset var stResponse = createResponse() />
		<cfset var body = 'Action=ConfirmSubscription&TopicArn=' & trim(arguments.TopicArn) & '&Token=' & trim(arguments.token)>
		
		<cfif len(trim(arguments.AuthenticateOnUnsubscribe))>
			<cfset body &= '&AuthenticateOnUnsubscribe=' & trim(arguments.AuthenticateOnUnsubscribe) />
		</cfif>
			
		<cfset var rawResult = makeRequestFull(
									endPoint = variables.endPoint,
									awsAccessKeyId = variables.awsAccessKeyId, 
									secretAccesskey = variables.secretAccesskey, 
									body=body,
									requestMethod=variables.requestMethod ) />
		
		<cfif rawResult.statusCode neq 200>
			<cfset error = getResultNodes(xmlParse(rawResult.fileContent),'Error')[1] />
			<cfset stResponse.success=false />
			<cfset stResponse.statusCode=rawResult.statusCode />
			<cfset stResponse.error=error.Code.xmlText/>
			<cfset stResponse.errorType=error.Type.xmlText/>
			<cfset stResponse.errorMessage=error.Message.xmlText/>
		<cfelse>								
			<cfset stResponse.result = getResultNodes(xmlParse(rawResult.filecontent),'SubscriptionArn')[1].xmlText />
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="CreateTopic" access="public" returntype="Struct" >
		<cfargument name="name" type="string" required="true" >
		
		<cfset var stResponse = createResponse() />
		<cfset var body = 'Action=CreateTopic&Name=' & trim(arguments.name)>
		
		<cfset var rawResult = makeRequestFull(
									endPoint = variables.endPoint,
									awsAccessKeyId = variables.awsAccessKeyId, 
									secretAccesskey = variables.secretAccesskey, 
									body=body,
									requestMethod=variables.requestMethod ) />
									
		<cfif rawResult.statusCode neq 200>
			<cfset error = getResultNodes(xmlParse(rawResult.fileContent),'Error')[1] />
			<cfset stResponse.success=false />
			<cfset stResponse.statusCode=rawResult.statusCode />
			<cfset stResponse.error=error.Code.xmlText/>
			<cfset stResponse.errorType=error.Type.xmlText/>
			<cfset stResponse.errorMessage=error.Message.xmlText/>
		<cfelse>								
			<cfset stResponse.result = getResultNodes(xmlParse(rawResult.filecontent),'TopicArn')[1].xmlText />
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="DeleteTopic" access="public" returntype="Struct" >
		<cfargument name="TopicArn" type="string" required="true" >
		
		<cfset var stResponse = createResponse() />
		<cfset var body = 'Action=DeleteTopic&TopicArn=' & trim(arguments.TopicArn)>
		
		<cfset var rawResult = makeRequestFull(
									endPoint = variables.endPoint,
									awsAccessKeyId = variables.awsAccessKeyId, 
									secretAccesskey = variables.secretAccesskey, 
									body=body,
									requestMethod=variables.requestMethod ) />
		
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
	
	<cffunction name="GetSubscriptionAttributes" access="public" returntype="Struct" >
		<cfargument name="SubscriptionArn" type="string" required="true" >
		
		<cfset var stResponse = createResponse() />
		<cfset var body = 'Action=GetSubscriptionAttributes&SubscriptionArn=' & trim(arguments.SubscriptionArn)>

		<cfset var rawResult = makeRequestFull(
									endPoint = variables.endPoint,
									awsAccessKeyId = variables.awsAccessKeyId, 
									secretAccesskey = variables.secretAccesskey, 
									body=body,
									requestMethod=variables.requestMethod ) />
									
		<cfif rawResult.statusCode neq 200>
			<cfset error = getResultNodes(xmlParse(rawResult.fileContent),'Error')[1] />
			<cfset stResponse.success=false />
			<cfset stResponse.statusCode=rawResult.statusCode />
			<cfset stResponse.error=error.Code.xmlText/>
			<cfset stResponse.errorType=error.Type.xmlText/>
			<cfset stResponse.errorMessage=error.Message.xmlText/>
		<cfelse>							
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'entry') />
			<cfset stResponse.result = {} />
			<cfloop array="#dataResult#" index="entry">
				<cfset stResponse.result[entry.key.xmlText] = entry.value.xmlText />
			</cfloop>
		</cfif>	
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="GetTopicAttributes" access="public" returntype="Struct" >
		<cfargument name="TopicArn" type="string" required="true" >
		
		<cfset var stResponse = createResponse() />
		<cfset var body = 'Action=GetTopicAttributes&TopicArn=' & trim(arguments.TopicArn)>

		<cfset var rawResult = makeRequestFull(
									endPoint = variables.endPoint,
									awsAccessKeyId = variables.awsAccessKeyId, 
									secretAccesskey = variables.secretAccesskey, 
									body=body,
									requestMethod=variables.requestMethod ) />
		
		<cfif rawResult.statusCode neq 200>
			<cfset error = getResultNodes(xmlParse(rawResult.fileContent),'Error')[1] />
			<cfset stResponse.success=false />
			<cfset stResponse.statusCode=rawResult.statusCode />
			<cfset stResponse.error=error.Code.xmlText/>
			<cfset stResponse.errorType=error.Type.xmlText/>
			<cfset stResponse.errorMessage=error.Message.xmlText/>
		<cfelse>							
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'entry') />
			<cfset stResponse.result = {} />
			<cfloop array="#dataResult#" index="entry">
				<cfif isJSON(entry.value.xmlText)>
					<cfset stResponse.result[entry.key.xmlText] = deserializeJSON(entry.value.xmlText) />
				<cfelse>
					<cfset stResponse.result[entry.key.xmlText] = entry.value.xmlText />
				</cfif>
			</cfloop>
		</cfif>	
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="SetSubscriptionAttributes" access="public" returntype="Struct" >
		<cfargument name="SubscriptionArn" type="string" required="true" >
		<cfargument name="AttributeName" type="string" required="true" >
		<cfargument name="minDelayTarget" type="numeric" required="false" >
		<cfargument name="maxDelayTarget" type="numeric" required="false" >
		<cfargument name="numRetries" type="numeric" required="false" >
		<cfargument name="numMaxDelayRetries" type="numeric" required="false" >
		<cfargument name="backoffFunction" type="string" required="false" default="">
		<cfargument name="maxReceivesPerSecond" type="numeric" required="false" >
		
		<cfset var stResponse = createResponse() />
		<cfset var body = 'Action=SetSubscriptionAttributes&SubscriptionArn=' & trim(arguments.SubscriptionArn) & '&AttributeName=' & trim(arguments.AttributeName)>
		
		<cfif val(arguments.minDelayTarget)>
			<cfset body &= "&minDelayTarget=" &  trim(arguments.minDelayTarget) />
		</cfif>	
		
		<cfif val(arguments.maxDelayTarget)>
			<cfset body &= "&maxDelayTarget=" &  trim(arguments.maxDelayTarget) />
		</cfif>	
		
		<cfif val(arguments.numRetries)>
			<cfset body &= "&numRetries=" &  trim(arguments.numRetries) />
		</cfif>	
		
		<cfif val(arguments.numMaxDelayRetries)>
			<cfset body &= "&numMaxDelayRetries=" &  trim(arguments.numMaxDelayRetries) />
		</cfif>	
		
		<cfif val(arguments.backoffFunction)>
			<cfset body &= "&backoffFunction=" &  trim(arguments.backoffFunction) />
		</cfif>	
		
		<cfif val(arguments.maxReceivesPerSecond)>
			<cfset body &= "&maxReceivesPerSecond=" &  trim(arguments.maxReceivesPerSecond) />
		</cfif>	

		<cfset var rawResult = makeRequestFull(
									endPoint = variables.endPoint,
									awsAccessKeyId = variables.awsAccessKeyId, 
									secretAccesskey = variables.secretAccesskey, 
									body=body,
									requestMethod=variables.requestMethod ) />
									
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
	
	<cffunction name="publish" access="public" returntype="Struct" >
		<cfargument name="TopicArn" type="string" required="true" >
		<cfargument name="message" type="string" required="true" >
		<cfargument name="messageStructure" type="string" required="false" default="" >
		<cfargument name="subject" type="string" required="false" default="" >
		
		<cfset var stResponse = createResponse() />
		<cfset var body = 'Action=Publish&TopicArn=' & trim(arguments.TopicArn) & '&Message=' & trim(arguments.message)>
		
		<cfif len(trim(arguments.subject))>
			<cfset body &= '&Subject=' & trim(arguments.subject) />
		</cfif>
		<cfif len(trim(arguments.messageStructure))>
			<cfset body &= '&MessageStructure=' & trim(arguments.messageStructure) />
		</cfif>
		
		<cfset var rawResult = makeRequestFull(
									endPoint = variables.endPoint,
									awsAccessKeyId = variables.awsAccessKeyId, 
									secretAccesskey = variables.secretAccesskey, 
									body=body,
									requestMethod=variables.requestMethod ) />
									
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
	
	<cffunction name="addPermission" access="public" returntype="Struct" >
		<cfargument name="TopicArn" type="string" required="true" >
		<cfargument name="label" type="string" required="true" >
		<cfargument name="principals" type="array" required="true" hint="array of permission objects">
		
		<cfset var stResponse = createResponse() />
		<cfset var body = 'TopicArn=' & trim(arguments.TopicArn) >
		
		<cfloop from="1" to="#arrayLen(arguments.principals)#" index="i">
			<cfset body &= '&ActionName.member.' & i & '=' & trim(arguments.principals[i].actionName) />
		</cfloop>
		
		<cfset body &= '&Label=' & arguments.label />
		
		<cfloop from="1" to="#arrayLen(arguments.principals)#" index="i">
			<cfset body &= '&AWSAccountId.member.' & i & '=' & trim(arguments.principals[i].awsAccountID) />
		</cfloop>	
		
		<cfset body &= '&Action=AddPermission' />

		<cfset var rawResult = makeRequestFull(
									endPoint = variables.endPoint,
									awsAccessKeyId = variables.awsAccessKeyId, 
									secretAccesskey = variables.secretAccesskey, 
									body=body,
									requestMethod=variables.requestMethod ) />
									
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
	
	<cffunction name="SetTopicAttributes" access="public" returntype="Struct" >
		<cfargument name="topicArn" type="string" required="true" >
		<cfargument name="attributeName" type="string" required="true" >
		<cfargument name="attributeValue" type="string" required="true" >
		
		<cfset var stResponse = createResponse() />
		<cfset var body = 'Action=SetTopicAttributes&TopicArn=' & trim(arguments.TopicArn) & '&AttributeName=' & trim(arguments.attributeName) & '&AttributeValue=' & trim(arguments.attributeValue)>
		
		<cfset var rawResult = makeRequestFull(
									endPoint = variables.endPoint,
									awsAccessKeyId = variables.awsAccessKeyId, 
									secretAccesskey = variables.secretAccesskey, 
									body=body,
									requestMethod=variables.requestMethod ) />
									
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
	
	<cffunction name="RemovePermission" access="public" returntype="Struct" >
		<cfargument name="topicArn" type="string" required="true" >
		<cfargument name="Label" type="string" required="true" >
		
		<cfset var stResponse = createResponse() />
		<cfset var body = 'Action=RemovePermission&TopicArn=' & trim(arguments.TopicArn) & '&Label=' & trim(arguments.Label)>
		
		<cfset var rawResult = makeRequestFull(
									endPoint = variables.endPoint,
									awsAccessKeyId = variables.awsAccessKeyId, 
									secretAccesskey = variables.secretAccesskey, 
									body=body,
									requestMethod=variables.requestMethod ) />
									
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
	
	<cffunction name="getBlankPermission" access="public" returntype="Struct" >
		<cfreturn {actionName='',awsAccountID=''} />
	</cffunction>

</cfcomponent>