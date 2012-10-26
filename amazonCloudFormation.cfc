<cfcomponent output="false" extends="amazonAWS" >
	<cffunction name="init" access="public" returntype="amazonCloudFormation" >
		<cfargument name="awsAccessKeyId" type="string" required="true"/>
		<cfargument name="secretAccessKey" type="string" required="true"/>
		<cfargument name="endPoint" type="string" required="true" default="cloudformation.us-east-1.amazonaws.com"/>
				
		<cfset variables.awsAccessKeyId = arguments.awsAccessKeyId />
		<cfset variables.secretAccesskey = arguments.secretAccessKey />
		<cfset variables.endPoint = arguments.endPoint />
		<cfset variables.requestMethod = 'no-header' />
		<cfset variables.version = '2010-05-15' />
		<cfset variables.protocol = 'https://' />
		<cfreturn this />		
	</cffunction>
	
	<cffunction name="DescribeStacks" access="public" returntype="Struct" >
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=DescribeStacks"/>
		
		<cfset var rawResult = makeRequestFull(
									endPoint = variables.endPoint,
									awsAccessKeyId = variables.awsAccessKeyId, 
									secretAccesskey = variables.secretAccesskey, 
									body=body,
									requestMethod = variables.requestMethod,
									version = variables.version,
									protocol = variables.protocol ) />
			
		<cfif rawResult.statusCode neq 200>
			<cfset error = getResultNodes(xmlParse(rawResult.fileContent),'Error')[1] />
			<cfset stResponse.success=false />
			<cfset stResponse.statusCode=rawResult.statusCode />
			<cfset stResponse.error=error.Code.xmlText/>
			<cfset stResponse.errorType=error.Type.xmlText/>
			<cfset stResponse.errorMessage=error.Message.xmlText/>
		<cfelse>								
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'Stacks')[1].xmlChildren />
			<cfset stResponse.result=[] />
			
			<cfloop array="#dataResult#" index="stack">
				
				<cfset stStack = {
									StackName=getValue(stack,'StackName'),
									StackId=getValue(stack,'StackId'),
									CreationTime=getValue(stack,'CreationTime'),
									StackStatus=getValue(stack,'StackStatus'),
									StackStatusReason=getValue(stack,'StackStatusReason'),
									DisableRollback=getValue(stack,'DisableRollback'),
									Description=getValue(stack,'Description'),
									Parameters=[]
								} />
								
				<cfloop array="#stack.Parameters.xmlChildren#" index="parameter">
					<cfset stParameter = {} />
					<cfset stParameter[parameter.ParameterKey.xmlText] = parameter.ParameterValue.xmlText />
					<cfset arrayAppend(stStack.Parameters,stParameter) />
				</cfloop>		
				
				<cfset arrayAppend(stResponse.result,stStack) />
			</cfloop>	
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>	
	
	<cffunction name="ListStacks" access="public" returntype="Struct" >
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=ListStacks"/>
		
		<cfset var rawResult = makeRequestFull(
									endPoint = variables.endPoint,
									awsAccessKeyId = variables.awsAccessKeyId, 
									secretAccesskey = variables.secretAccesskey, 
									body=body,
									requestMethod = variables.requestMethod,
									version = variables.version,
									protocol = variables.protocol ) />
									
		<cfif rawResult.statusCode neq 200>
			<cfset error = getResultNodes(xmlParse(rawResult.fileContent),'Error')[1] />
			<cfset stResponse.success=false />
			<cfset stResponse.statusCode=rawResult.statusCode />
			<cfset stResponse.error=error.Code.xmlText/>
			<cfset stResponse.errorType=error.Type.xmlText/>
			<cfset stResponse.errorMessage=error.Message.xmlText/>
		<cfelse>	
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'StackSummaries')[1].xmlChildren />
			<cfset stResponse.result = [] />
			
			<cfloop array="#dataResult#" index="stack">
				
				<cfset stStack = {
									StackName=getValue(stack,'StackName'),
									StackId=getValue(stack,'StackId'),
									CreationTime=getValue(stack,'CreationTime'),
									StackStatus=getValue(stack,'StackStatus'),
									StackStatusReason=getValue(stack,'StackStatusReason'),
									TemplateDescription=getValue(stack,'TemplateDescription')
								} />
								
				<cfset arrayAppend(stResponse.result,stStack) />
			</cfloop>	
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>	
	
	<cffunction name="DescribeStackResources" access="public" returntype="Struct" >
		<cfargument name="StackName" type="string" required="false" default=""> 
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=DescribeStackResources"/>
		
		<cfif len(trim(arguments.StackName))>
			<cfset body &= "&StackName=" & trim(arguments.StackName) />
		</cfif>	
		
		<cfset var rawResult = makeRequestFull(
									endPoint = variables.endPoint,
									awsAccessKeyId = variables.awsAccessKeyId, 
									secretAccesskey = variables.secretAccesskey, 
									body=body,
									requestMethod = variables.requestMethod,
									version = variables.version,
									protocol = variables.protocol ) />
		
		<cfif rawResult.statusCode neq 200>
			<cfset error = getResultNodes(xmlParse(rawResult.fileContent),'Error')[1] />
			<cfset stResponse.success=false />
			<cfset stResponse.statusCode=rawResult.statusCode />
			<cfset stResponse.error=error.Code.xmlText/>
			<cfset stResponse.errorType=error.Type.xmlText/>
			<cfset stResponse.errorMessage=error.Message.xmlText/>
		<cfelse>	
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'StackResources')[1] />

			<cfloop array="#dataResult.xmlChildren#" index="resource">
				<cfset stResult.result[getValue(resource,'ResourceType')] = {} />
				
				<cfloop array="#resource.xmlChildren#" index="property">
					<cfif isJSON(property.xmlText)>
						<cfset stResult.result[resource.ResourceType.xmlText][property.xmlName] = DeserializeJSON(property.xmlText) />
					<cfelse>
						<cfset stResult.result[resource.ResourceType.xmlText][property.xmlName] = property.xmlText />
					</cfif>
				</cfloop>	
			</cfloop>	
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="DescribeStackResource" access="public" returntype="Struct" >
		<cfargument name="StackName" type="string" required="true"> 
		<cfargument name="LogicalResourceId" type="string" required="true"> 
		
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=DescribeStackResource&StackName=" & trim(arguments.StackName) & "&LogicalResourceId=" & trim(arguments.LogicalResourceId)/>
		
		<cfif len(trim(arguments.StackName))>
			<cfset body &= "&StackName=" & trim(arguments.StackName) />
		</cfif>	
		
		<cfset var rawResult = makeRequestFull(
									endPoint = variables.endPoint,
									awsAccessKeyId = variables.awsAccessKeyId, 
									secretAccesskey = variables.secretAccesskey, 
									body=body,
									requestMethod = variables.requestMethod,
									version = variables.version,
									protocol = variables.protocol ) />
									
		<cfif rawResult.statusCode neq 200>
			<cfset error = getResultNodes(xmlParse(rawResult.fileContent),'Error')[1] />
			<cfset stResponse.success=false />
			<cfset stResponse.statusCode=rawResult.statusCode />
			<cfset stResponse.error=error.Code.xmlText/>
			<cfset stResponse.errorType=error.Type.xmlText/>
			<cfset stResponse.errorMessage=error.Message.xmlText/>
		<cfelse>	
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'StackResourceDetail')[1] />
			
			<cfset stResponse.result = {
								ResourceStatus=getValue(dataResult,'ResourceStatus'),
								StackId=getValue(dataResult,'StackId'),
								LogicalResourceId=getValue(dataResult,'LogicalResourceId'),
								LastUpdatedTimestamp=getValue(dataResult,'LastUpdatedTimestamp'),
								StackName=getValue(dataResult,'StackName'),
								PhysicalResourceId=getValue(dataResult,'PhysicalResourceId'),
								ResourceType=getValue(dataResult,'ResourceType')
							} />
		</cfif>
						
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="DescribeStackEvents" access="public" returntype="struct" >
		<cfargument name="NextToken" type="string" required="false" default=""> 
		<cfargument name="StackName" type="string" required="false" default=""> 
		
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=DescribeStackEvents"/>
		
		<cfif len(trim(arguments.NextToken))>
			<cfset body &= "&NextToken=" & trim(arguments.NextToken) />
		</cfif>
		
		<cfif len(trim(arguments.StackName))>
			<cfset body &= "&StackName=" & trim(arguments.StackName) />
		</cfif>		
		
		<cfset var rawResult = makeRequestFull(
									endPoint = variables.endPoint,
									awsAccessKeyId = variables.awsAccessKeyId, 
									secretAccesskey = variables.secretAccesskey, 
									body=body,
									requestMethod = variables.requestMethod,
									version = variables.version,
									protocol = variables.protocol ) />
		
		<cfif rawResult.statusCode neq 200>
			<cfset error = getResultNodes(xmlParse(rawResult.fileContent),'Error')[1] />
			<cfset stResponse.success=false />
			<cfset stResponse.statusCode=rawResult.statusCode />
			<cfset stResponse.error=error.Code.xmlText/>
			<cfset stResponse.errorType=error.Type.xmlText/>
			<cfset stResponse.errorMessage=error.Message.xmlText/>
		<cfelse>	
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'StackEvents')[1] />
		
			<cfloop array="#dataResult.xmlChildren#" index="resource">
				<cfset stResponse.result[resource.ResourceType.xmlText] = {} />
				
				<cfloop array="#resource.xmlChildren#" index="property">
					<cfif isJSON(property.xmlText)>
						<cfset stResponse.result[resource.ResourceType.xmlText][property.xmlName] = DeserializeJSON(property.xmlText) />
					<cfelse>
						<cfset stResponse.result[resource.ResourceType.xmlText][property.xmlName] = property.xmlText />
					</cfif>
				</cfloop>	
			</cfloop>
		</cfif>

		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="ListStackResources" access="public" returntype="Struct" >
		<cfargument name="StackName" type="string" required="true"> 
		<cfargument name="NextToken" type="string" required="false" default=""> 
		
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=ListStackResources&StackName=" & trim(arguments.StackName)/>
		
		<cfif len(trim(arguments.NextToken))>
			<cfset body &= "&NextToken=" & trim(arguments.NextToken) />
		</cfif>	
		
		<cfset var rawResult = makeRequestFull(
									endPoint = variables.endPoint,
									awsAccessKeyId = variables.awsAccessKeyId, 
									secretAccesskey = variables.secretAccesskey, 
									body=body,
									requestMethod = variables.requestMethod,
									version = variables.version,
									protocol = variables.protocol ) />
		
		<cfif rawResult.statusCode neq 200>
			<cfset error = getResultNodes(xmlParse(rawResult.fileContent),'Error')[1] />
			<cfset stResponse.success=false />
			<cfset stResponse.statusCode=rawResult.statusCode />
			<cfset stResponse.error=error.Code.xmlText/>
			<cfset stResponse.errorType=error.Type.xmlText/>
			<cfset stResponse.errorMessage=error.Message.xmlText/>
		<cfelse>								
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'StackResourceSummaries')[1] />
			
			<cfloop array="#dataResult.xmlChildren#" index="resource">
				<cfset stResponse.result[resource.ResourceType.xmlText] = {} />
				
				<cfloop array="#resource.xmlChildren#" index="property">
					<cfif isJSON(property.xmlText)>
						<cfset stResponse.result[resource.ResourceType.xmlText][property.xmlName] = DeserializeJSON(property.xmlText) />
					<cfelse>
						<cfset stResponse.result[resource.ResourceType.xmlText][property.xmlName] = property.xmlText />
					</cfif>
				</cfloop>	
			</cfloop>	
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="CreateStack" access="public" returntype="Struct" >
		<cfargument name="StackName" type="string" required="true"> 
		<cfargument name="DisableRollback" type="string" required="false" default=""> 
		<cfargument name="TemplateBody" type="string" required="false" default=""> 
		<cfargument name="TemplateURL" type="string" required="false" default="">
		<cfargument name="TimeoutInMinutes" type="string" required="false" default=""> 
		<cfargument name="Capabilities" type="string" required="false" default=""> 
		<cfargument name="NotificationARNs" type="string" required="false" default="">
		<cfargument name="Parameters" type="array" required="false" default="#[]#">
		
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=CreateStack&StackName=" & trim(arguments.StackName)/>
		
		<cfif len(trim(arguments.DisableRollback))>
			<cfset body &= "&DisableRollback=" & trim(arguments.DisableRollback) />
		</cfif>
		
		<cfif len(trim(arguments.TemplateBody))>
			<cfset body &= "&TemplateBody=" & trim(arguments.TemplateBody) />
		</cfif>	
		
		<cfif len(trim(arguments.TemplateURL))>
			<cfset body &= "&TemplateURL=" & trim(arguments.TemplateURL) />
		</cfif>	
		
		<cfif len(trim(arguments.TimeoutInMinutes))>
			<cfset body &= "&TimeoutInMinutes=" & trim(arguments.TimeoutInMinutes) />
		</cfif>	

		<cfloop from="1" to="#listLen(arguments.capabilities)#" index="i">
			<cfset body &= '&Capabilities.member.' & i & '=' & trim(listGetAt(arguments.capabilities,i)) />
		</cfloop>
		
		<cfloop from="1" to="#listLen(arguments.NotificationARNs)#" index="j">
			<cfset body &= '&NotificationARNs.member.' & j & '=' & trim(listGetAt(arguments.NotificationARNs,j)) />
		</cfloop>
		
		<cfloop from="1" to="#arrayLen(arguments.Parameters)#" index="k">
			<cfset body &= '&Parameters.member.' & k & '.ParameterKey=' & trim(arguments.Parameters[k].ParameterKey) & '&Parameters.member.' & k & '.ParameterValue=' & trim(arguments.Parameters[k].ParameterValue) />
		</cfloop>	
					
		<cfset var rawResult = makeRequestFull(
									endPoint = variables.endPoint,
									awsAccessKeyId = variables.awsAccessKeyId, 
									secretAccesskey = variables.secretAccesskey, 
									body=body,
									requestMethod = variables.requestMethod,
									version = variables.version,
									protocol = variables.protocol ) />
		
		<cfif rawResult.statusCode neq 200>
			<cfset error = getResultNodes(xmlParse(rawResult.fileContent),'Error')[1] />
			<cfset stResponse.success=false />
			<cfset stResponse.statusCode=rawResult.statusCode />
			<cfset stResponse.error=error.Code.xmlText/>
			<cfset stResponse.errorType=error.Type.xmlText/>
			<cfset stResponse.errorMessage=error.Message.xmlText/>
		<cfelse>	
			<cfset stResponse.result = {stackID=getResultNodes(xmlParse(rawResult.filecontent),'StackId')[1].xmlText} />
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="UpdateStack" access="public" returntype="Struct" >
		<cfargument name="StackName" type="string" required="true"> 
		<cfargument name="TemplateBody" type="string" required="false" default=""> 
		<cfargument name="TemplateURL" type="string" required="false" default="">
		<cfargument name="Capabilities" type="string" required="false" default=""> 
		<cfargument name="Parameters" type="array" required="false" default="#[]#">
		
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=UpdateStack&StackName=" & trim(arguments.StackName)/>
		
		<cfif len(trim(arguments.TemplateBody))>
			<cfset body &= "&TemplateBody=" & trim(arguments.TemplateBody) />
		</cfif>	
		
		<cfif len(trim(arguments.TemplateURL))>
			<cfset body &= "&TemplateURL=" & trim(arguments.TemplateURL) />
		</cfif>	

		<cfloop from="1" to="#listLen(arguments.capabilities)#" index="i">
			<cfset body &= '&Capabilities.member.' & i & '=' & trim(listGetAt(arguments.capabilities,i)) />
		</cfloop>
		
		<cfloop from="1" to="#arrayLen(arguments.Parameters)#" index="k">
			<cfset body &= '&Parameters.member.' & k & '.ParameterKey=' & trim(arguments.Parameters[k].ParameterKey) & '&Parameters.member.' & k & '.ParameterValue=' & trim(arguments.Parameters[k].ParameterValue) />
		</cfloop>	
					
		<cfset var rawResult = makeRequestFull(
									endPoint = variables.endPoint,
									awsAccessKeyId = variables.awsAccessKeyId, 
									secretAccesskey = variables.secretAccesskey, 
									body=body,
									requestMethod = variables.requestMethod,
									version = variables.version,
									protocol = variables.protocol ) />

		<cfif rawResult.statusCode neq 200>
			<cfset error = getResultNodes(xmlParse(rawResult.fileContent),'Error')[1] />
			<cfset stResponse.success=false />
			<cfset stResponse.statusCode=rawResult.statusCode />
			<cfset stResponse.error=error.Code.xmlText/>
			<cfset stResponse.errorType=error.Type.xmlText/>
			<cfset stResponse.errorMessage=error.Message.xmlText/>
		<cfelse>	
			<cfset stResponse.result = {stackID=getResultNodes(xmlParse(rawResult.filecontent),'StackId')[1].xmlText} />
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="ValidateTemplate" access="public" returntype="Struct" >
		<cfargument name="TemplateBody" type="string" required="false" default=""> 
		<cfargument name="TemplateURL" type="string" required="false" default="">
		
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=ValidateTemplate"/>
		
		<cfif len(trim(arguments.TemplateBody))>
			<cfset body &= "&TemplateBody=" & trim(arguments.TemplateBody) />
		</cfif>	
		
		<cfif len(trim(arguments.TemplateURL))>
			<cfset body &= "&TemplateURL=" & trim(arguments.TemplateURL) />
		</cfif>	

		<cfset var rawResult = makeRequestFull(
									endPoint = variables.endPoint,
									awsAccessKeyId = variables.awsAccessKeyId, 
									secretAccesskey = variables.secretAccesskey, 
									body=body,
									requestMethod = variables.requestMethod,
									version = variables.version,
									protocol = variables.protocol ) />
		
		<cfif rawResult.statusCode neq 200>
			<cfset error = getResultNodes(xmlParse(rawResult.fileContent),'Error')[1] />
			<cfset stResponse.success=false />
			<cfset stResponse.statusCode=rawResult.statusCode />
			<cfset stResponse.error=error.Code.xmlText/>
			<cfset stResponse.errorType=error.Type.xmlText/>
			<cfset stResponse.errorMessage=error.Message.xmlText/>
		<cfelse>	
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'ValidateTemplateResult')[1] />
			<cfset stResponse.result={} />
			<cfset stResponse.result.description = getValue(dataResult,'Description') />
			<cfset stResponse.result.properties = {} />
			
			<cfloop array="#dataResult.parameters.xmlChildren#" index="parameter">
				<cfloop array="#parameter.xmlChildren#" index="property">
					<cfif isJSON(property.xmlText)>
						<cfset stResponse.result.properties[parameter.ParameterKey.xmlText][property.xmlName] = DeserializeJSON(property.xmlText) />
					<cfelse>
						<cfset stResponse.result.properties[parameter.ParameterKey.xmlText][property.xmlName] = property.xmlText />
					</cfif>
				</cfloop>	
			</cfloop>
		</cfif>
				
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="GetTemplate" access="public" returntype="Struct" >
		<cfargument name="StackName" type="string" required="true"> 

		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=GetTemplate&StackName=" & trim(arguments.StackName)/>

		<cfset var rawResult = makeRequestFull(
									endPoint = variables.endPoint,
									awsAccessKeyId = variables.awsAccessKeyId, 
									secretAccesskey = variables.secretAccesskey, 
									body=body,
									requestMethod = variables.requestMethod,
									version = variables.version,
									protocol = variables.protocol ) />
		
		<cfif rawResult.statusCode neq 200>
			<cfset error = getResultNodes(xmlParse(rawResult.fileContent),'Error')[1] />
			<cfset stResponse.success=false />
			<cfset stResponse.statusCode=rawResult.statusCode />
			<cfset stResponse.error=error.Code.xmlText/>
			<cfset stResponse.errorType=error.Type.xmlText/>
			<cfset stResponse.errorMessage=error.Message.xmlText/>
		<cfelse>
			<cfset stResponse.result = getResultNodes(xmlParse(rawResult.filecontent),'TemplateBody')[1].xmlText />
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="EstimateTemplateCost" access="public" returntype="Struct" >
		<cfargument name="TemplateBody" type="string" required="false" default=""> 
		<cfargument name="TemplateURL" type="string" required="false" default="">
		<cfargument name="Parameters" type="array" required="false" default="#[]#">
		
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=EstimateTemplateCost"/>
		
		<cfif len(trim(arguments.TemplateBody))>
			<cfset body &= "&TemplateBody=" & trim(arguments.TemplateBody) />
		</cfif>	
		
		<cfif len(trim(arguments.TemplateURL))>
			<cfset body &= "&TemplateURL=" & trim(arguments.TemplateURL) />
		</cfif>	
		
		<cfloop from="1" to="#arrayLen(arguments.Parameters)#" index="k">
			<cfset body &= '&Parameters.member.' & k & '.ParameterKey=' & trim(arguments.Parameters[k].ParameterKey) & '&Parameters.member.' & k & '.ParameterValue=' & trim(arguments.Parameters[k].ParameterValue) />
		</cfloop>
		
		<cfset var rawResult = makeRequestFull(
									endPoint = variables.endPoint,
									awsAccessKeyId = variables.awsAccessKeyId, 
									secretAccesskey = variables.secretAccesskey, 
									body=body,
									requestMethod = variables.requestMethod,
									version = variables.version,
									protocol = variables.protocol ) />
									
		<cfif rawResult.statusCode neq 200>
			<cfset error = getResultNodes(xmlParse(rawResult.fileContent),'Error')[1] />
			<cfset stResponse.success=false />
			<cfset stResponse.statusCode=rawResult.statusCode />
			<cfset stResponse.error=error.Code.xmlText/>
			<cfset stResponse.errorType=error.Type.xmlText/>
			<cfset stResponse.errorMessage=error.Message.xmlText/>
		<cfelse>
			<cfset stResponse.result = getResultNodes(xmlParse(rawResult.filecontent),'Url')[1].xmlText />
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>

	<cffunction name="DeleteStack" access="public" returntype="Struct" >
		<cfargument name="StackName" type="string" required="true"> 
		
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=DeleteStack&StackName=" & trim(arguments.StackName)/>
		
		<cfset var rawResult = makeRequestFull(
									endPoint = variables.endPoint,
									awsAccessKeyId = variables.awsAccessKeyId, 
									secretAccesskey = variables.secretAccesskey, 
									body=body,
									requestMethod = variables.requestMethod,
									version = variables.version,
									protocol = variables.protocol ) />

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

</cfcomponent>