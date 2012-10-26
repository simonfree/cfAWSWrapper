<cfcomponent output="false" extends="amazonAWS">

	<cffunction name="init" access="public" returntype="amazonElasticLoadBalancing">
		<cfargument name="awsAccessKeyId" type="string" required="true"/>
		<cfargument name="secretAccessKey" type="string" required="true"/>
		<cfargument name="endPoint" type="string" required="true" default="elasticloadbalancing.us-east-1.amazonaws.com"/>
	
		<cfset variables.awsAccessKeyId = arguments.awsAccessKeyId/>
		<cfset variables.secretAccesskey = arguments.secretAccessKey/>
		<cfset variables.endPoint = arguments.endPoint />
		<cfset variables.requestMethod = 'no-header'/>
		<cfset variables.version = '2011-11-15'/>
		<cfset variables.protocol = 'https://'/>
		<cfreturn this/>
	</cffunction>
	
	<cffunction name="ApplySecurityGroupsToLoadBalancer" access="public" returntype="Struct">
		<cfargument name="LoadBalancerName" type="string" required="true"/>
		<cfargument name="SecurityGroups" type="string" required="true"/>
	
		<cfset var stResponse = createResponse()/>
		<cfset var body = "Action=ApplySecurityGroupsToLoadBalancer&LoadBalancerName=" & trim(arguments.UserName)/>
	
		<cfloop from="1" to="#listlen(arguments.securityGroups)#" index="i">
			<cfset body &= "&SecurityGroups.member." & i & "=" & trim(listgetat(arguments.SecurityGroups, i))/>
		</cfloop>
	
		<cfset var rawResult = makeRequestFull(endPoint=variables.endPoint, 
		                                       awsAccessKeyId=variables.awsAccessKeyId,
		                                       secretAccesskey=variables.secretAccesskey,body=body, 
		                                       requestMethod=variables.requestMethod,version=variables.version, 
		                                       protocol=variables.protocol)/>
	
		<cfif rawResult.statusCode neq 200>
			<cfset error = getResultNodes(xmlParse(rawResult.fileContent), 'Error')[1]/>
			<cfset stResponse.success = false/>
			<cfset stResponse.statusCode = rawResult.statusCode/>
			<cfset stResponse.error = error.Code.xmlText/>
			<cfset stResponse.errorType = error.Type.xmlText/>
			<cfset stResponse.errorMessage = error.Message.xmlText/>
		<cfelse>
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent), 
			                                   'ApplySecurityGroupsToLoadBalancerResult')[1].xmlChildren/>
			<cfset stResponse.result = []/>
		
			<cfloop array="#dataResult#" index="result">
				<cfset arrayAppend(stResponse.result, result.xmlText)/>
			</cfloop>
		</cfif>
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent), 'RequestId')[1].xmltext/>
	
		<cfreturn stResponse/>
	</cffunction>
	
	<cffunction name="AttachLoadBalancerToSubnets" access="public" returntype="Struct">
		<cfargument name="LoadBalancerName" type="string" required="true"/>
		<cfargument name="Subnets" type="string" required="true"/>
	
		<cfset var stResponse = createResponse()/>
		<cfset var body = "Action=AttachLoadBalancerToSubnets&LoadBalancerName=" & trim(arguments.LoadBalancerName)/>
	
		<cfloop from="1" to="#listlen(arguments.Subnets)#" index="i">
			<cfset body &= "&Subnets.member." & i & "=" & trim(listgetat(arguments.Subnets, i))/>
		</cfloop>
	
		<cfset var rawResult = makeRequestFull(endPoint=variables.endPoint, 
		                                       awsAccessKeyId=variables.awsAccessKeyId,
		                                       secretAccesskey=variables.secretAccesskey,body=body, 
		                                       requestMethod=variables.requestMethod,version=variables.version, 
		                                       protocol=variables.protocol)/>
	
		<cfif rawResult.statusCode neq 200>
			<cfset error = getResultNodes(xmlParse(rawResult.fileContent), 'Error')[1]/>
			<cfset stResponse.success = false/>
			<cfset stResponse.statusCode = rawResult.statusCode/>
			<cfset stResponse.error = error.Code.xmlText/>
			<cfset stResponse.errorType = error.Type.xmlText/>
			<cfset stResponse.errorMessage = error.Message.xmlText/>
		<cfelse>
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent), 
			                                   'AttachLoadBalancerToSubnetsResult')[1].xmlChildren/>
			<cfset stResponse.result = []/>
		
			<cfloop array="#dataResult#" index="result">
				<cfset arrayAppend(stResponse.result, result.xmlText)/>
			</cfloop>
		</cfif>
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent), 'RequestId')[1].xmltext/>
	
		<cfreturn stResponse/>
	</cffunction>
	
	<cffunction name="ConfigureHealthCheck" access="public" returntype="Struct">
		<cfargument name="LoadBalancerName" type="string" required="true"/>
		<cfargument name="HealthyThreshold" type="string" required="false" default=""/>
		<cfargument name="Interval" type="string" required="false" default=""/>
		<cfargument name="Target" type="string" required="false" default=""/>
		<cfargument name="Timeout" type="string" required="false" default=""/>
		<cfargument name="UnhealthyThreshold" type="string" required="false" default=""/>
	
		<cfset var stResponse = createResponse()/>
		<cfset var body = "Action=ConfigureHealthCheck&LoadBalancerName=" & trim(arguments.LoadBalancerName)/>
	
		<cfif len(trim(arguments.HealthyThreshold))>
			<cfset body &= "&HealthCheck.HealthyThreshold=" & trim(arguments.HealthyThreshold)/>
		</cfif>
		<cfif len(trim(arguments.Interval))>
			<cfset body &= "&HealthCheck.Interval=" & trim(arguments.Interval)/>
		</cfif>
		<cfif len(trim(arguments.Target))>
			<cfset body &= "&HealthCheck.Target=" & trim(arguments.Target)/>
		</cfif>
		<cfif len(trim(arguments.Timeout))>
			<cfset body &= "&HealthCheck.Timeout=" & trim(arguments.Timeout)/>
		</cfif>
		<cfif len(trim(arguments.UnhealthyThreshold))>
			<cfset body &= "&HealthCheck.UnhealthyThreshold=" & trim(arguments.UnhealthyThreshold)/>
		</cfif>
		<cfset var rawResult = makeRequestFull(endPoint=variables.endPoint, 
		                                       awsAccessKeyId=variables.awsAccessKeyId,
		                                       secretAccesskey=variables.secretAccesskey,body=body, 
		                                       requestMethod=variables.requestMethod,version=variables.version, 
		                                       protocol=variables.protocol)/>
	
		<cfif rawResult.statusCode neq 200>
			<cfset error = getResultNodes(xmlParse(rawResult.fileContent), 'Error')[1]/>
			<cfset stResponse.success = false/>
			<cfset stResponse.statusCode = rawResult.statusCode/>
			<cfset stResponse.error = error.Code.xmlText/>
			<cfset stResponse.errorType = error.Type.xmlText/>
			<cfset stResponse.errorMessage = error.Message.xmlText/>
		<cfelse>
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent), 'HealthCheck')[1]/>
			<cfset stResponse.result = createHealthCheckObject(dataResult)/>
		</cfif>
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent), 'RequestId')[1].xmltext/>
	
		<cfreturn stResponse/>
	</cffunction>
	
	<cffunction name="CreateAppCookieStickinessPolicy" access="public" returntype="Struct">
		<cfargument name="CookieName" type="string" required="true"/>
		<cfargument name="LoadBalancerName" type="string" required="true"/>
		<cfargument name="PolicyName" type="string" required="true"/>
	
		<cfset var stResponse = createResponse()/>
		<cfset var body = "Action=CreateAppCookieStickinessPolicy&CookieName=" & trim(arguments.CookieName) 
		       & "&LoadBalancerName=" & trim(arguments.LoadBalancerName) & "&PolicyName=" & trim(arguments.PolicyName)/>
	
		<cfset var rawResult = makeRequestFull(endPoint=variables.endPoint, 
		                                       awsAccessKeyId=variables.awsAccessKeyId,
		                                       secretAccesskey=variables.secretAccesskey,body=body, 
		                                       requestMethod=variables.requestMethod,version=variables.version, 
		                                       protocol=variables.protocol)/>
	
		<cfif rawResult.statusCode neq 200>
			<cfset error = getResultNodes(xmlParse(rawResult.fileContent), 'Error')[1]/>
			<cfset stResponse.success = false/>
			<cfset stResponse.statusCode = rawResult.statusCode/>
			<cfset stResponse.error = error.Code.xmlText/>
			<cfset stResponse.errorType = error.Type.xmlText/>
			<cfset stResponse.errorMessage = error.Message.xmlText/>
		</cfif>
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent), 'RequestId')[1].xmltext/>
	
		<cfreturn stResponse/>
	</cffunction>
	
	<cffunction name="CreateLBCookieStickinessPolicy" access="public" returntype="Struct">
		<cfargument name="LoadBalancerName" type="string" required="true"/>
		<cfargument name="PolicyName" type="string" required="true"/>
		<cfargument name="CookieExpirationPeriod" type="string" required="false" default=""/>
	
		<cfset var stResponse = createResponse()/>
		<cfset var body = "Action=CreateLBCookieStickinessPolicy&LoadBalancerName=" & trim(arguments.LoadBalancerName) 
		       & "&PolicyName=" & trim(arguments.PolicyName)/>
	
		<cfif len(trim(arguments.CookieExpirationPeriod))>
			<cfset body &= "&CookieExpirationPeriod=" & trim(arguments.CookieExpirationPeriod)/>
		</cfif>
		<cfset var rawResult = makeRequestFull(endPoint=variables.endPoint, 
		                                       awsAccessKeyId=variables.awsAccessKeyId,
		                                       secretAccesskey=variables.secretAccesskey,body=body, 
		                                       requestMethod=variables.requestMethod,version=variables.version, 
		                                       protocol=variables.protocol)/>
	
		<cfif rawResult.statusCode neq 200>
			<cfset error = getResultNodes(xmlParse(rawResult.fileContent), 'Error')[1]/>
			<cfset stResponse.success = false/>
			<cfset stResponse.statusCode = rawResult.statusCode/>
			<cfset stResponse.error = error.Code.xmlText/>
			<cfset stResponse.errorType = error.Type.xmlText/>
			<cfset stResponse.errorMessage = error.Message.xmlText/>
		</cfif>
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent), 'RequestId')[1].xmltext/>
	
		<cfreturn stResponse/>
	</cffunction>
	
	<cffunction name="CreateLoadBalancer" access="public" returntype="Struct">
		<cfargument name="LoadBalancerName" type="string" required="true"/>
		<cfargument name="Listeners" type="array" required="true"/>
		<cfargument name="AvailabilityZones" type="string" required="false" default=""/>
		<cfargument name="SecurityGroups" type="string" required="false" default=""/>
		<cfargument name="Subnets" type="string" required="false" default=""/>
	
		<cfset var stResponse = createResponse()/>
		<cfset var body = "Action=CreateLoadBalancer&LoadBalancerName=" & trim(arguments.LoadBalancerName)/>
	
		<cfloop from="1" to="#arrayLen(arguments.Listeners)#" index="i">
			<cfset listener = arguments.listeners[i]/>
		
			<cfif structkeyExists(listener, 'InstancePort')>
				<cfset body &= "Listeners.member." & i & ".InstancePort=" & trim(listener.InstancePort)/>
			</cfif>
			<cfif structkeyExists(listener, 'InstanceProtocol')>
				<cfset body &= "Listeners.member." & i & ".InstanceProtocol=" & trim(listener.InstanceProtocol)/>
			</cfif>
			<cfif structkeyExists(listener, 'LoadBalancerPort')>
				<cfset body &= "Listeners.member." & i & ".LoadBalancerPort=" & trim(listener.LoadBalancerPort)/>
			</cfif>
			<cfif structkeyExists(listener, 'Protocol')>
				<cfset body &= "Listeners.member." & i & ".Protocol=" & trim(listener.Protocol)/>
			</cfif>
			<cfif structkeyExists(listener, 'SSLCertificateId')>
				<cfset body &= "Listeners.member." & i & ".SSLCertificateId=" & trim(listener.SSLCertificateId)/>
			</cfif>
		</cfloop>
	
		<cfloop from="1" to="#listlen(arguments.AvailabilityZones)#" index="j">
			<cfset body &= "&AvailabilityZones.member." & j & "=" & trim(listgetat(arguments.AvailabilityZones, j))/>
		</cfloop>
	
		<cfloop from="1" to="#listlen(arguments.SecurityGroups)#" index="k">
			<cfset body &= "&SecurityGroups.member." & k & "=" & trim(listgetat(arguments.SecurityGroups, k))/>
		</cfloop>
	
		<cfloop from="1" to="#listlen(arguments.Subnets)#" index="m">
			<cfset body &= "&Subnets.member." & m & "=" & trim(listgetat(arguments.Subnets, m))/>
		</cfloop>
	
		<cfset var rawResult = makeRequestFull(endPoint=variables.endPoint, 
		                                       awsAccessKeyId=variables.awsAccessKeyId,
		                                       secretAccesskey=variables.secretAccesskey,body=body, 
		                                       requestMethod=variables.requestMethod,version=variables.version, 
		                                       protocol=variables.protocol)/>
	
		<cfif rawResult.statusCode neq 200>
			<cfset error = getResultNodes(xmlParse(rawResult.fileContent), 'Error')[1]/>
			<cfset stResponse.success = false/>
			<cfset stResponse.statusCode = rawResult.statusCode/>
			<cfset stResponse.error = error.Code.xmlText/>
			<cfset stResponse.errorType = error.Type.xmlText/>
			<cfset stResponse.errorMessage = error.Message.xmlText/>
		<cfelse>
			<cfset stResponse.result = getResultNodes(xmlParse(rawResult.filecontent), 'DNSName')[1].xmlText/>
		</cfif>
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent), 'RequestId')[1].xmltext/>
	
		<cfreturn stResponse/>
	</cffunction>
	
	<cffunction name="CreateLoadBalancerListeners" access="public" returntype="Struct">
		<cfargument name="LoadBalancerName" type="string" required="true"/>
		<cfargument name="Listeners" type="string" required="true"/>
	
		<cfset var stResponse = createResponse()/>
		<cfset var body = "Action=CreateLoadBalancerListeners&LoadBalancerName=" & trim(arguments.LoadBalancerName)/>
	
		<cfloop from="1" to="#arrayLen(arguments.Listeners)#" index="i">
			<cfset listener = arguments.listeners[i]/>
		
			<cfif structkeyExists(listener, 'InstancePort')>
				<cfset body &= "Listeners.member." & i & ".InstancePort=" & trim(listener.InstancePort)/>
			</cfif>
			<cfif structkeyExists(listener, 'InstanceProtocol')>
				<cfset body &= "Listeners.member." & i & ".InstanceProtocol=" & trim(listener.InstanceProtocol)/>
			</cfif>
			<cfif structkeyExists(listener, 'LoadBalancerPort')>
				<cfset body &= "Listeners.member." & i & ".LoadBalancerPort=" & trim(listener.LoadBalancerPort)/>
			</cfif>
			<cfif structkeyExists(listener, 'Protocol')>
				<cfset body &= "Listeners.member." & i & ".Protocol=" & trim(listener.Protocol)/>
			</cfif>
			<cfif structkeyExists(listener, 'SSLCertificateId')>
				<cfset body &= "Listeners.member." & i & ".SSLCertificateId=" & trim(listener.SSLCertificateId)/>
			</cfif>
		</cfloop>
	
		<cfset var rawResult = makeRequestFull(endPoint=variables.endPoint, 
		                                       awsAccessKeyId=variables.awsAccessKeyId,
		                                       secretAccesskey=variables.secretAccesskey,body=body, 
		                                       requestMethod=variables.requestMethod,version=variables.version, 
		                                       protocol=variables.protocol)/>
	
		<cfif rawResult.statusCode neq 200>
			<cfset error = getResultNodes(xmlParse(rawResult.fileContent), 'Error')[1]/>
			<cfset stResponse.success = false/>
			<cfset stResponse.statusCode = rawResult.statusCode/>
			<cfset stResponse.error = error.Code.xmlText/>
			<cfset stResponse.errorType = error.Type.xmlText/>
			<cfset stResponse.errorMessage = error.Message.xmlText/>
		</cfif>
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent), 'RequestId')[1].xmltext/>
	
		<cfreturn stResponse/>
	</cffunction>
	
	<cffunction name="CreateLoadBalancerPolicy" access="public" returntype="Struct">
		<cfargument name="LoadBalancerName" type="string" required="true"/>
		<cfargument name="PolicyName" type="string" required="true"/>
		<cfargument name="PolicyTypeName" type="string" required="true"/>
		<cfargument name="PolicyAttributes" type="array" required="false" default="#[]#"/>
	
		<cfset var stResponse = createResponse()/>
		<cfset var body = "Action=CreateLoadBalancerPolicy&LoadBalancerName=" & trim(arguments.LoadBalancerName) 
		       & "&PolicyName=" & trim(rguments.PolicyName) & "&PolicyTypeName=" & trim(arguments.PolicyTypeName)/>
	
		<cfloop from="1" to="#arrayLen(arguments.PolicyAttributes)#" index="i">
			<cfset body &= "&PolicyAttributes.member." & i & ".AttributeName=" & trim(arguments.PolicyAttributes[i].AttributeName) 
			               & "&PolicyAttributes.member." & i & ".AttributeValue=" & trim(arguments.PolicyAttributes[i].AttributeValue)/>
		</cfloop>
	
		<cfset var rawResult = makeRequestFull(endPoint=variables.endPoint, 
		                                       awsAccessKeyId=variables.awsAccessKeyId,
		                                       secretAccesskey=variables.secretAccesskey,body=body, 
		                                       requestMethod=variables.requestMethod,version=variables.version, 
		                                       protocol=variables.protocol)/>
	
		<cfif rawResult.statusCode neq 200>
			<cfset error = getResultNodes(xmlParse(rawResult.fileContent), 'Error')[1]/>
			<cfset stResponse.success = false/>
			<cfset stResponse.statusCode = rawResult.statusCode/>
			<cfset stResponse.error = error.Code.xmlText/>
			<cfset stResponse.errorType = error.Type.xmlText/>
			<cfset stResponse.errorMessage = error.Message.xmlText/>
		</cfif>
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent), 'RequestId')[1].xmltext/>
	
		<cfreturn stResponse/>
	</cffunction>
	
	<cffunction name="DeleteLoadBalancer" access="public" returntype="Struct">
		<cfargument name="LoadBalancerName" type="string" required="true"/>
		<cfargument name="something" type="string" required="false" default=""/>
	
		<cfset var stResponse = createResponse()/>
		<cfset var body = "Action=DeleteLoadBalancer&LoadBalancerName=" & trim(arguments.LoadBalancerName)/>
	
		<cfset var rawResult = makeRequestFull(endPoint=variables.endPoint, 
		                                       awsAccessKeyId=variables.awsAccessKeyId,
		                                       secretAccesskey=variables.secretAccesskey,body=body, 
		                                       requestMethod=variables.requestMethod,version=variables.version, 
		                                       protocol=variables.protocol)/>
	
		<cfif rawResult.statusCode neq 200>
			<cfset error = getResultNodes(xmlParse(rawResult.fileContent), 'Error')[1]/>
			<cfset stResponse.success = false/>
			<cfset stResponse.statusCode = rawResult.statusCode/>
			<cfset stResponse.error = error.Code.xmlText/>
			<cfset stResponse.errorType = error.Type.xmlText/>
			<cfset stResponse.errorMessage = error.Message.xmlText/>
		</cfif>
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent), 'RequestId')[1].xmltext/>
	
		<cfreturn stResponse/>
	</cffunction>
	
	<cffunction name="DeleteLoadBalancerListeners" access="public" returntype="Struct">
		<cfargument name="LoadBalancerName" type="string" required="true"/>
		<cfargument name="LoadBalancerPorts" type="string" required="true"/>
	
		<cfset var stResponse = createResponse()/>
		<cfset var body = "Action=DeleteLoadBalancerListeners&LoadBalancerName=" & trim(arguments.LoadBalancerName)/>
	
		<cfloop from="1" to="#listlen(arguments.LoadBalancerPorts)#" index="j">
			<cfset body &= "&LoadBalancerPorts.member." & j & "=" & trim(listgetat(arguments.LoadBalancerPorts, j))/>
		</cfloop>
	
		<cfset var rawResult = makeRequestFull(endPoint=variables.endPoint, 
		                                       awsAccessKeyId=variables.awsAccessKeyId,
		                                       secretAccesskey=variables.secretAccesskey,body=body, 
		                                       requestMethod=variables.requestMethod,version=variables.version, 
		                                       protocol=variables.protocol)/>
	
		<cfif rawResult.statusCode neq 200>
			<cfset error = getResultNodes(xmlParse(rawResult.fileContent), 'Error')[1]/>
			<cfset stResponse.success = false/>
			<cfset stResponse.statusCode = rawResult.statusCode/>
			<cfset stResponse.error = error.Code.xmlText/>
			<cfset stResponse.errorType = error.Type.xmlText/>
			<cfset stResponse.errorMessage = error.Message.xmlText/>
		</cfif>
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent), 'RequestId')[1].xmltext/>
	
		<cfreturn stResponse/>
	</cffunction>
	
	<cffunction name="DeleteLoadBalancerPolicy" access="public" returntype="Struct">
		<cfargument name="LoadBalancerName" type="string" required="true"/>
		<cfargument name="PolicyName" type="string" required="true"/>
	
		<cfset var stResponse = createResponse()/>
		<cfset var body = "Action=DeleteLoadBalancerPolicy&LoadBalancerName=" & trim(arguments.LoadBalancerName) 
		       & "&PolicyName=" & trim(arguments.PolicyName)/>
	
		<cfset var rawResult = makeRequestFull(endPoint=variables.endPoint, 
		                                       awsAccessKeyId=variables.awsAccessKeyId,
		                                       secretAccesskey=variables.secretAccesskey,body=body, 
		                                       requestMethod=variables.requestMethod,version=variables.version, 
		                                       protocol=variables.protocol)/>
	
		<cfif rawResult.statusCode neq 200>
			<cfset error = getResultNodes(xmlParse(rawResult.fileContent), 'Error')[1]/>
			<cfset stResponse.success = false/>
			<cfset stResponse.statusCode = rawResult.statusCode/>
			<cfset stResponse.error = error.Code.xmlText/>
			<cfset stResponse.errorType = error.Type.xmlText/>
			<cfset stResponse.errorMessage = error.Message.xmlText/>
		</cfif>
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent), 'RequestId')[1].xmltext/>
	
		<cfreturn stResponse/>
	</cffunction>
	
	<cffunction name="DeregisterInstancesFromLoadBalancer" access="public" returntype="Struct">
		<cfargument name="LoadBalancerName" type="string" required="true"/>
		<cfargument name="Instances" type="string" required="true"/>
	
		<cfset var stResponse = createResponse()/>
		<cfset var body = "Action=DeregisterInstancesFromLoadBalancer&LoadBalancerName=" & trim(arguments.LoadBalancerName)/>
	
		<cfloop from="1" to="#listlen(arguments.Instances)#" index="i">
			<cfset body &= "&Instances.member." & i & ".InstanceId=" & trim(listgetat(arguments.Instances, i))/>
		</cfloop>
	
		<cfset var rawResult = makeRequestFull(endPoint=variables.endPoint, 
		                                       awsAccessKeyId=variables.awsAccessKeyId,
		                                       secretAccesskey=variables.secretAccesskey,body=body, 
		                                       requestMethod=variables.requestMethod,version=variables.version, 
		                                       protocol=variables.protocol)/>
	
		<cfif rawResult.statusCode neq 200>
			<cfset error = getResultNodes(xmlParse(rawResult.fileContent), 'Error')[1]/>
			<cfset stResponse.success = false/>
			<cfset stResponse.statusCode = rawResult.statusCode/>
			<cfset stResponse.error = error.Code.xmlText/>
			<cfset stResponse.errorType = error.Type.xmlText/>
			<cfset stResponse.errorMessage = error.Message.xmlText/>
		<cfelse>
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent), 'Instances')[1].xmlChildren/>
			<cfset stResponse.result = []/>
		
			<cfloop array="#dataResult#" index="result">
				<cfset arrayAppend(stResponse.result, getValue(result, 'InstanceID'))/>
			</cfloop>
		</cfif>
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent), 'RequestId')[1].xmltext/>
	
		<cfreturn stResponse/>
	</cffunction>
	
	<cffunction name="DescribeInstanceHealth" access="public" returntype="Struct">
		<cfargument name="LoadBalancerName" type="string" required="true"/>
		<cfargument name="Instances" type="string" required="true"/>
	
		<cfset var stResponse = createResponse()/>
		<cfset var body = "Action=DescribeInstanceHealth&LoadBalancerName=" & trim(arguments.LoadBalancerName)/>
	
		<cfloop from="1" to="#listlen(arguments.Instances)#" index="i">
			<cfset body &= "&Instances.member." & i & ".InstanceId=" & trim(listgetat(arguments.Instances, i))/>
		</cfloop>
	
		<cfset var rawResult = makeRequestFull(endPoint=variables.endPoint, 
		                                       awsAccessKeyId=variables.awsAccessKeyId,
		                                       secretAccesskey=variables.secretAccesskey,body=body, 
		                                       requestMethod=variables.requestMethod,version=variables.version, 
		                                       protocol=variables.protocol)/>
	
		<cfif rawResult.statusCode neq 200>
			<cfset error = getResultNodes(xmlParse(rawResult.fileContent), 'Error')[1]/>
			<cfset stResponse.success = false/>
			<cfset stResponse.statusCode = rawResult.statusCode/>
			<cfset stResponse.error = error.Code.xmlText/>
			<cfset stResponse.errorType = error.Type.xmlText/>
			<cfset stResponse.errorMessage = error.Message.xmlText/>
		<cfelse>
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent), 'InstanceStates')[1]/>
			<cfset stResponse.result = []/>
		
			<cfloop array="#dataResult#" index="result">
				<cfset arrayAppend(stResponse.result, createInstanceStateObject(result))/>
			</cfloop>
		</cfif>
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent), 'RequestId')[1].xmltext/>
	
		<cfreturn stResponse/>
	</cffunction>
	
	<cffunction name="DescribeLoadBalancerPolicies" access="public" returntype="Struct">
		<cfargument name="LoadBalancerName" type="string" required="false" default=""/>
		<cfargument name="PolicyNames" type="string" required="false" default=""/>
	
		<cfset var stResponse = createResponse()/>
		<cfset var body = "Action=DescribeLoadBalancerPolicies"/>
	
		<cfif len(trim(arguments.LoadBalancerName))>
			<cfset body &= "&LoadBalancerName=" & trim(arguments.LoadBalancerName)/>
		</cfif>
		<cfloop from="1" to="#listlen(arguments.PolicyNames)#" index="i">
			<cfset body &= "&PolicyNames.member." & i & "=" & trim(listgetat(arguments.PolicyNames, i))/>
		</cfloop>
	
		<cfset var rawResult = makeRequestFull(endPoint=variables.endPoint, 
		                                       awsAccessKeyId=variables.awsAccessKeyId,
		                                       secretAccesskey=variables.secretAccesskey,body=body, 
		                                       requestMethod=variables.requestMethod,version=variables.version, 
		                                       protocol=variables.protocol)/>
	
		<cfif rawResult.statusCode neq 200>
			<cfset error = getResultNodes(xmlParse(rawResult.fileContent), 'Error')[1]/>
			<cfset stResponse.success = false/>
			<cfset stResponse.statusCode = rawResult.statusCode/>
			<cfset stResponse.error = error.Code.xmlText/>
			<cfset stResponse.errorType = error.Type.xmlText/>
			<cfset stResponse.errorMessage = error.Message.xmlText/>
		<cfelse>
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent), 'PolicyDescriptions')/>
			<cfset stResponse.result = []/>
		
			<cfloop array="#dataResult#" index="result">
				<cfset arrayAppend(stResponse.result, createPolicyDescriptionObject(result))/>
			</cfloop>
		</cfif>
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent), 'RequestId')[1].xmltext/>
	
		<cfreturn stResponse/>
	</cffunction>
	
	<cffunction name="DescribeLoadBalancerPolicyTypes" access="public" returntype="Struct">
		<cfargument name="PolicyTypeNames" type="string" required="false" default=""/>
	
		<cfset var stResponse = createResponse()/>
		<cfset var body = "Action=DescribeLoadBalancerPolicyTypes"/>
	
		<cfloop from="1" to="#listlen(arguments.PolicyTypeNames)#" index="i">
			<cfset body &= "&PolicyTypeNames.member." & i & "=" & trim(listgetat(arguments.PolicyTypeNames, i))/>
		</cfloop>
	
		<cfset var rawResult = makeRequestFull(endPoint=variables.endPoint, 
		                                       awsAccessKeyId=variables.awsAccessKeyId,
		                                       secretAccesskey=variables.secretAccesskey,body=body, 
		                                       requestMethod=variables.requestMethod,version=variables.version, 
		                                       protocol=variables.protocol)/>
	
		<cfif rawResult.statusCode neq 200>
			<cfset error = getResultNodes(xmlParse(rawResult.fileContent), 'Error')[1]/>
			<cfset stResponse.success = false/>
			<cfset stResponse.statusCode = rawResult.statusCode/>
			<cfset stResponse.error = error.Code.xmlText/>
			<cfset stResponse.errorType = error.Type.xmlText/>
			<cfset stResponse.errorMessage = error.Message.xmlText/>
		<cfelse>
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent), 'PolicyTypeDescriptions')/>
			<cfset stResponse.result = []/>
		
			<cfloop array="#dataResult#" index="result">
				<cfset arrayAppend(stResponse.result, createPolicyTypeDescriptionObject(result))/>
			</cfloop>
		</cfif>
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent), 'RequestId')[1].xmltext/>
	
		<cfreturn stResponse/>
	</cffunction>
	
	<cffunction name="DescribeLoadBalancers" access="public" returntype="Struct">
		<cfargument name="LoadBalancerNames" type="string" required="false" default=""/>
		<cfargument name="Marker" type="string" required="false" default=""/>
	
		<cfset var stResponse = createResponse()/>
		<cfset var body = "Action=DescribeLoadBalancers"/>
	
		<cfloop from="1" to="#listlen(arguments.LoadBalancerNames)#" index="i">
			<cfset body &= "&LoadBalancerNames.member." & i & "=" & trim(listgetat(arguments.LoadBalancerNames, i))/>
		</cfloop>
	
		<cfif len(trim(arguments.Marker))>
			<cfset body &= "&Marker=" & trim(arguments.Marker)/>
		</cfif>
		<cfset var rawResult = makeRequestFull(endPoint=variables.endPoint, 
		                                       awsAccessKeyId=variables.awsAccessKeyId,
		                                       secretAccesskey=variables.secretAccesskey,body=body, 
		                                       requestMethod=variables.requestMethod,version=variables.version, 
		                                       protocol=variables.protocol)/>
	
		<cfif rawResult.statusCode neq 200>
			<cfset error = getResultNodes(xmlParse(rawResult.fileContent), 'Error')[1]/>
			<cfset stResponse.success = false/>
			<cfset stResponse.statusCode = rawResult.statusCode/>
			<cfset stResponse.error = error.Code.xmlText/>
			<cfset stResponse.errorType = error.Type.xmlText/>
			<cfset stResponse.errorMessage = error.Message.xmlText/>
		<cfelse>
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent), 'LoadBalancerDescriptions')[1].xmlChildren/>
			<cfset stResponse.result = []/>
		
			<cfloop array="#dataResult#" index="result">
				<cfset arrayAppend(stResponse.result, createLoadBalancerDescriptionObject(result))/>
			</cfloop>
		</cfif>
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent), 'RequestId')[1].xmltext/>
	
		<cfreturn stResponse/>
	</cffunction>
	
	<cffunction name="DetachLoadBalancerFromSubnets" access="public" returntype="Struct">
		<cfargument name="LoadBalancerName" type="string" required="true"/>
		<cfargument name="Subnets" type="string" required="true"/>
	
		<cfset var stResponse = createResponse()/>
		<cfset var body = "Action=DetachLoadBalancerFromSubnets&LoadBalancerName=" & trim(arguments.LoadBalancerName)/>
	
		<cfloop from="1" to="#listlen(arguments.Subnets)#" index="i">
			<cfset body &= "&Subnets.member." & i & "=" & trim(listgetat(arguments.Subnets, i))/>
		</cfloop>
	
		<cfset var rawResult = makeRequestFull(endPoint=variables.endPoint, 
		                                       awsAccessKeyId=variables.awsAccessKeyId,
		                                       secretAccesskey=variables.secretAccesskey,body=body, 
		                                       requestMethod=variables.requestMethod,version=variables.version, 
		                                       protocol=variables.protocol)/>
	
		<cfif rawResult.statusCode neq 200>
			<cfset error = getResultNodes(xmlParse(rawResult.fileContent), 'Error')[1]/>
			<cfset stResponse.success = false/>
			<cfset stResponse.statusCode = rawResult.statusCode/>
			<cfset stResponse.error = error.Code.xmlText/>
			<cfset stResponse.errorType = error.Type.xmlText/>
			<cfset stResponse.errorMessage = error.Message.xmlText/>
		<cfelse>
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent), 'Subnets')[1].xmlChildren/>
			<cfset stResponse.result = []/>
		
			<cfloop array="#dataResult#" index="result">
				<cfset arrayAppend(stResponse.result, result.xmlText)/>
			</cfloop>
		</cfif>
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent), 'RequestId')[1].xmltext/>
	
		<cfreturn stResponse/>
	</cffunction>
	
	<cffunction name="DisableAvailabilityZonesForLoadBalancer" access="public" returntype="Struct">
		<cfargument name="LoadBalancerName" type="string" required="true"/>
		<cfargument name="AvailabilityZones" type="string" required="true"/>
	
		<cfset var stResponse = createResponse()/>
		<cfset var body = "Action=DisableAvailabilityZonesForLoadBalancer&LoadBalancerName=" & trim(arguments.LoadBalancerName)/>
	
		<cfloop from="1" to="#listlen(arguments.AvailabilityZones)#" index="i">
			<cfset body &= "&AvailabilityZones.member." & i & "=" & trim(listgetat(arguments.AvailabilityZones, i))/>
		</cfloop>
	
		<cfset var rawResult = makeRequestFull(endPoint=variables.endPoint, 
		                                       awsAccessKeyId=variables.awsAccessKeyId,
		                                       secretAccesskey=variables.secretAccesskey,body=body, 
		                                       requestMethod=variables.requestMethod,version=variables.version, 
		                                       protocol=variables.protocol)/>
	
		<cfif rawResult.statusCode neq 200>
			<cfset error = getResultNodes(xmlParse(rawResult.fileContent), 'Error')[1]/>
			<cfset stResponse.success = false/>
			<cfset stResponse.statusCode = rawResult.statusCode/>
			<cfset stResponse.error = error.Code.xmlText/>
			<cfset stResponse.errorType = error.Type.xmlText/>
			<cfset stResponse.errorMessage = error.Message.xmlText/>
		<cfelse>
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent), 'AvailabilityZones')[1].xmlChildren/>
			<cfset stResponse.result = []/>
		
			<cfloop array="#dataResult#" index="result">
				<cfset arrayAppend(stResponse.result, result.xmlText)/>
			</cfloop>
		</cfif>
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent), 'RequestId')[1].xmltext/>
	
		<cfreturn stResponse/>
	</cffunction>
	
	<cffunction name="EnableAvailabilityZonesForLoadBalancer" access="public" returntype="Struct">
		<cfargument name="LoadBalancerName" type="string" required="true"/>
		<cfargument name="AvailabilityZones" type="string" required="true"/>
	
		<cfset var stResponse = createResponse()/>
		<cfset var body = "Action=EnableAvailabilityZonesForLoadBalancer&LoadBalancerName=" & trim(arguments.LoadBalancerName)/>
	
		<cfloop from="1" to="#listlen(arguments.AvailabilityZones)#" index="i">
			<cfset body &= "&AvailabilityZones.member." & i & "=" & trim(listgetat(arguments.AvailabilityZones, i))/>
		</cfloop>
	
		<cfset var rawResult = makeRequestFull(endPoint=variables.endPoint, 
		                                       awsAccessKeyId=variables.awsAccessKeyId,
		                                       secretAccesskey=variables.secretAccesskey,body=body, 
		                                       requestMethod=variables.requestMethod,version=variables.version, 
		                                       protocol=variables.protocol)/>
	
		<cfif rawResult.statusCode neq 200>
			<cfset error = getResultNodes(xmlParse(rawResult.fileContent), 'Error')[1]/>
			<cfset stResponse.success = false/>
			<cfset stResponse.statusCode = rawResult.statusCode/>
			<cfset stResponse.error = error.Code.xmlText/>
			<cfset stResponse.errorType = error.Type.xmlText/>
			<cfset stResponse.errorMessage = error.Message.xmlText/>
		<cfelse>
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent), 'AvailabilityZones')[1].xmlChildren/>
			<cfset stResponse.result = []/>
		
			<cfloop array="#dataResult#" index="result">
				<cfset arrayAppend(stResponse.result, result.xmlText)/>
			</cfloop>
		</cfif>
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent), 'RequestId')[1].xmltext/>
	
		<cfreturn stResponse/>
	</cffunction>
	
	<cffunction name="RegisterInstancesWithLoadBalancer" access="public" returntype="Struct">
		<cfargument name="LoadBalancerName" type="string" required="true"/>
		<cfargument name="Instances" type="string" required="true"/>
	
		<cfset var stResponse = createResponse()/>
		<cfset var body = "Action=RegisterInstancesWithLoadBalancer&LoadBalancerName=" & trim(arguments.LoadBalancerName)/>
	
		<cfloop from="1" to="#listlen(arguments.Instances)#" index="i">
			<cfset body &= "&Instances.member." & i & ".InstanceId=" & trim(listgetat(arguments.Instances, i))/>
		</cfloop>
	
		<cfset var rawResult = makeRequestFull(endPoint=variables.endPoint, 
		                                       awsAccessKeyId=variables.awsAccessKeyId,
		                                       secretAccesskey=variables.secretAccesskey,body=body, 
		                                       requestMethod=variables.requestMethod,version=variables.version, 
		                                       protocol=variables.protocol)/>
	
		<cfif rawResult.statusCode neq 200>
			<cfset error = getResultNodes(xmlParse(rawResult.fileContent), 'Error')[1]/>
			<cfset stResponse.success = false/>
			<cfset stResponse.statusCode = rawResult.statusCode/>
			<cfset stResponse.error = error.Code.xmlText/>
			<cfset stResponse.errorType = error.Type.xmlText/>
			<cfset stResponse.errorMessage = error.Message.xmlText/>
		<cfelse>
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent), 'Instances')[1].xmlChildren/>
			<cfset stResponse.result = []/>
		
			<cfloop array="#dataResult#" index="result">
				<cfset arrayAppend(stResponse.result, getValue(result, 'InstanceId'))/>
			</cfloop>
		</cfif>
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent), 'RequestId')[1].xmltext/>
	
		<cfreturn stResponse/>
	</cffunction>
	
	<cffunction name="SetLoadBalancerListenerSSLCertificate" access="public" returntype="Struct">
		<cfargument name="LoadBalancerName" type="string" required="true"/>
		<cfargument name="LoadBalancerPort" type="string" required="true"/>
		<cfargument name="SSLCertificateId" type="string" required="true"/>
	
		<cfset var stResponse = createResponse()/>
		<cfset var body = "Action=SetLoadBalancerListenerSSLCertificate&LoadBalancerName=" & trim(arguments.LoadBalancerName) 
		       & "&LoadBalancerPort=" & trim(arguments.LoadBalancerPort) & "&SSLCertificateId=" & trim(arguments.SSLCertificateId)/>
	
		<cfset var rawResult = makeRequestFull(endPoint=variables.endPoint, 
		                                       awsAccessKeyId=variables.awsAccessKeyId,
		                                       secretAccesskey=variables.secretAccesskey,body=body, 
		                                       requestMethod=variables.requestMethod,version=variables.version, 
		                                       protocol=variables.protocol)/>
	
		<cfif rawResult.statusCode neq 200>
			<cfset error = getResultNodes(xmlParse(rawResult.fileContent), 'Error')[1]/>
			<cfset stResponse.success = false/>
			<cfset stResponse.statusCode = rawResult.statusCode/>
			<cfset stResponse.error = error.Code.xmlText/>
			<cfset stResponse.errorType = error.Type.xmlText/>
			<cfset stResponse.errorMessage = error.Message.xmlText/>
		</cfif>
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent), 'RequestId')[1].xmltext/>
	
		<cfreturn stResponse/>
	</cffunction>
	
	<cffunction name="SetLoadBalancerPoliciesForBackendServer" access="public" returntype="Struct">
		<cfargument name="InstancePort" type="string" required="true"/>
		<cfargument name="LoadBalancerName" type="string" required="true"/>
		<cfargument name="PolicyNames" type="string" required="true"/>
	
		<cfset var stResponse = createResponse()/>
		<cfset var body = "Action=SetLoadBalancerPoliciesForBackendServer&InstancePort=" & trim(arguments.InstancePort) 
		       & "&LoadBalancerName=" & trim(arguments.LoadBalancerName)/>
	
		<cfloop from="1" to="#listlen(arguments.PolicyNames)#" index="i">
			<cfset body &= "&PolicyNames.member." & i & "=" & trim(listgetat(arguments.PolicyNames, i))/>
		</cfloop>
	
		<cfset var rawResult = makeRequestFull(endPoint=variables.endPoint, 
		                                       awsAccessKeyId=variables.awsAccessKeyId,
		                                       secretAccesskey=variables.secretAccesskey,body=body, 
		                                       requestMethod=variables.requestMethod,version=variables.version, 
		                                       protocol=variables.protocol)/>
	
		<cfif rawResult.statusCode neq 200>
			<cfset error = getResultNodes(xmlParse(rawResult.fileContent), 'Error')[1]/>
			<cfset stResponse.success = false/>
			<cfset stResponse.statusCode = rawResult.statusCode/>
			<cfset stResponse.error = error.Code.xmlText/>
			<cfset stResponse.errorType = error.Type.xmlText/>
			<cfset stResponse.errorMessage = error.Message.xmlText/>
		</cfif>
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent), 'RequestId')[1].xmltext/>
	
		<cfreturn stResponse/>
	</cffunction>
	
	<cffunction name="SetLoadBalancerPoliciesOfListener" access="public" returntype="Struct">
		<cfargument name="LoadBalancerName" type="string" required="true"/>
		<cfargument name="LoadBalancerPort" type="string" required="true"/>
		<cfargument name="PolicyNames" type="string" required="true"/>
	
		<cfset var stResponse = createResponse()/>
		<cfset var body = "Action=SetLoadBalancerPoliciesOfListener&LoadBalancerName=" & trim(arguments.LoadBalancerName) 
		       & "&LoadBalancerPort=" & trim(arguments.LoadBalancerPort)/>
	
		<cfloop from="1" to="#listlen(arguments.PolicyNames)#" index="i">
			<cfset body &= "&PolicyNames.member." & i & "=" & trim(listgetat(arguments.PolicyNames, i))/>
		</cfloop>
	
		<cfset var rawResult = makeRequestFull(endPoint=variables.endPoint, 
		                                       awsAccessKeyId=variables.awsAccessKeyId,
		                                       secretAccesskey=variables.secretAccesskey,body=body, 
		                                       requestMethod=variables.requestMethod,version=variables.version, 
		                                       protocol=variables.protocol)/>
	
		<cfif rawResult.statusCode neq 200>
			<cfset error = getResultNodes(xmlParse(rawResult.fileContent), 'Error')[1]/>
			<cfset stResponse.success = false/>
			<cfset stResponse.statusCode = rawResult.statusCode/>
			<cfset stResponse.error = error.Code.xmlText/>
			<cfset stResponse.errorType = error.Type.xmlText/>
			<cfset stResponse.errorMessage = error.Message.xmlText/>
		</cfif>
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent), 'RequestId')[1].xmltext/>
	
		<cfreturn stResponse/>
	</cffunction>
	
	<!--- object creation --->
	
	<cffunction name="createHealthCheckObject" access="public" returntype="Struct" output="false">
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#"/>
	
		<cfset var response = {HealthyThreshold=getValue(arguments.stXML, 'HealthyThreshold'), 
		                         Interval=getValue(arguments.stXML, 'Interval'),
		                         Target=getValue(arguments.stXML, 'Target'),
		                         Timeout=getValue(arguments.stXML, 'Timeout'),
		                         UnhealthyThreshold=getValue(arguments.stXML, 'UnhealthyThreshold')}/>
	
		<cfreturn response/>
	</cffunction>
	
	<cffunction name="createInstanceStateObject" access="public" returntype="Struct" output="false">
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#"/>
	
		<cfset var response = {Description=getValue(arguments.stXML, 'Description'), 
		                         InstanceId=getValue(arguments.stXML, 'InstanceId'),
		                         ReasonCode=getValue(arguments.stXML, 'ReasonCode'),
		                         State=getValue(arguments.stXML, 'State')}/>
	
		<cfreturn response/>
	</cffunction>
	
	<cffunction name="createPolicyDescriptionObject" access="public" returntype="Struct" output="false">
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#"/>
	
		<cfset var response = {PolicyName=getValue(arguments.stXML, 'PolicyName'), 
		                         PolicyTypeName=getValue(arguments.stXML, 'PolicyTypeName'),
		                         PolicyAttributeDescriptions=[]}/>
	
		<cfloop array="#arguments.stXML.PolicyAttributeDescriptions.xmlChildren#" index="result">
			<cfset arrayAppend(response.PolicyAttributeDescriptions, 
			                   createPolicyAttributeDescriptionObject(result))/>
		</cfloop>
	
		<cfreturn response/>
	</cffunction>
	
	<cffunction name="createPolicyAttributeDescriptionObject" access="public" returntype="Struct" 
	            output="false">
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#"/>
	
		<cfset var response = {AttributeName=getValue(arguments.stXML, 'AttributeName'), 
		                         AttributeValue=getValue(arguments.stXML, 'AttributeValue')}/>
	
		<cfreturn response/>
	</cffunction>
	
	<cffunction name="createPolicyTypeDescriptionObject" access="public" returntype="Struct" 
	            output="false">
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#"/>
	
		<cfset var response = {PolicyTypeName=getValue(arguments.stXML, 'PolicyTypeName'), 
		                         Description=getValue(arguments.stXML, 'Description'),
		                         PolicyAttributeTypeDescriptions=[]}/>
	
		<cfloop array="#arguments.stXML.PolicyAttributeTypeDescriptions.xmlChildren#" index="result">
			<cfset arrayAppend(response.PolicyAttributeTypeDescriptions, 
			                   createPolicyAttributeTypeDescriptionObject(result))/>
		</cfloop>
	
		<cfreturn response/>
	</cffunction>
	
	<cffunction name="createPolicyAttributeTypeDescriptionObject" access="public" returntype="Struct" 
	            output="false">
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#"/>
	
		<cfset var response = {AttributeName=getValue(arguments.stXML, 'AttributeName'), 
		                         AttributeType=getValue(arguments.stXML, 'AttributeType'),
		                         Cardinality=getValue(arguments.stXML, 'Cardinality'),
		                         DefaultValue=getValue(arguments.stXML, 'DefaultValue'),
		                         Description=getValue(arguments.stXML, 'Description')}/>
	
		<cfreturn response/>
	</cffunction>
	
	<!---<cffunction name="createPolicyTypeDescriptionObject" access="public" returntype="Struct" 
	output="false" >
	    <cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">        
	        
	    <cfset var response= {
	                    AvailabilityZones=getValue(arguments.stXML,'AvailabilityZones'),
	                    BackendServerDescriptions=[],
	                    CanonicalHostedZoneName=getValue(arguments.stXML,'CanonicalHostedZoneName'),
	                    
	CanonicalHostedZoneNameID=getValue(arguments.stXML,'CanonicalHostedZoneNameID'),
	                    CreatedTime=getValue(arguments.stXML,'CreatedTime'),
	                    DNSName=getValue(arguments.stXML,'DNSName'),
	                    HealthCheck=createHealthCheckObject(arguments.stXML.HealthCheck),
	                    Instances=[],
	                    ListenerDescriptions=[],
	                    LoadBalancerName=getValue(arguments.stXML,'LoadBalancerName'),
	                    Policies=[],
	                    SecurityGroups=getValue(arguments.stXML,'SecurityGroups'),
	                    
	SourceSecurityGroup=createSourceSecurityGroupObject(arguments.stXM.SourceSecurityGroup),
	                    Subnets=getValue(arguments.stXML,'Subnets'),
	                    VPCId=getValue(arguments.stXML,'VPCId')
	                } />
	    
	    <cfloop array="#arguments.stXML.BackendServerDescriptions.xmlChildren#" index="result">
	        <cfset 
	arrayAppend(response.BackendServerDescriptions,createBackendServerDescriptionObject(result)) />
	    </cfloop>
	    
	    <cfloop array="#arguments.stXML.Instances.xmlChildren#" index="result">
	        <cfset arrayAppend(response.Instances,createInstanceObject(result)) />
	    </cfloop>                
	    
	    <cfloop array="#arguments.stXML.ListenerDescriptions.xmlChildren#" index="result">
	        <cfset arrayAppend(response.ListenerDescriptions,createListenerDescriptionObject(result)) 
	/>
	    </cfloop>
	    
	    <cfloop array="#arguments.stXML.Policies.xmlChildren#" index="result">
	        <cfset arrayAppend(response.Policies,createPoliciesObject(result)) />
	    </cfloop>
	    <cfreturn response />    
	</cffunction>--->
	
	<cffunction name="createBackendServerDescriptionObject" access="public" returntype="Struct" 
	            output="false">
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#"/>
	
		<cfset var response = {InstancePort=getValue(arguments.stXML, 'InstancePort'), PolicyNames=[]}/>
		<cfloop array="#arguments.stXML.PolicyNames.xmlChildren#" index="result">
			<cfset arrayAppend(response.PolicyNames, result.xmlText)/>
		</cfloop>
		<cfreturn response/>
	</cffunction>
	
	<cffunction name="createInstanceObject" access="public" returntype="Struct" output="false">
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#"/>
	
		<cfset var response = {InstanceId=getValue(arguments.stXML, 'InstanceId')}/>
	
		<cfreturn response/>
	</cffunction>
	
	<cffunction name="createListenerDescriptionObject" access="public" returntype="Struct" 
	            output="false">
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#"/>
	
		<cfset var response = {Listener=createListenerObject(arguments.stXML.Listener), PolicyNames=[]}/>
	
		<cfloop array="#arguments.stXML.PolicyNames.xmlChildren#" index="result">
			<cfset arrayAppend(response.PolicyNames, result.xmlText)/>
		</cfloop>
	
		<cfreturn response/>
	</cffunction>
	
	<cffunction name="createPoliciesObject" access="public" returntype="Struct" output="false">
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#"/>
	
		<cfset var response = {AppCookieStickinessPolicies=[], LBCookieStickinessPolicies=[], 
		                         OtherPolicies=[]}/>
	
		<cfloop array="#arguments.stXML.AppCookieStickinessPolicies.xmlChildren#" index="result">
			<cfset arrayAppend(response.AppCookieStickinessPolicies, 
			                   createAppCookieStickinessPolicyObject(result))/>
		</cfloop>
	
		<cfloop array="#arguments.stXML.LBCookieStickinessPolicies.xmlChildren#" index="result">
			<cfset arrayAppend(response.LBCookieStickinessPolicies, 
			                   createLBCookieStickinessPolicyObject(result))/>
		</cfloop>
	
		<cfloop array="#arguments.stXML.OtherPolicies.xmlChildren#" index="result">
			<cfset arrayAppend(response.OtherPolicies, result.xmlText)/>
		</cfloop>
	
		<cfreturn response/>
	</cffunction>
	
	<cffunction name="createAppCookieStickinessPolicyObject" access="public" returntype="Struct" 
	            output="false">
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#"/>
	
		<cfset var response = {CookieName=getValue(arguments.stXML, 'CookieName'), 
		                         PolicyName=getValue(arguments.stXML, 'PolicyName')}/>
		<cfreturn response/>
	</cffunction>
	
	<cffunction name="createLBCookieStickinessPolicyObject" access="public" returntype="Struct" 
	            output="false">
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#"/>
	
		<cfset var response = {
		                         CookieExpirationPeriod=getValue(arguments.stXML, 'CookieExpirationPeriod'),
		                         PolicyName=getValue(arguments.stXML, 'PolicyName')}/>
		<cfreturn response/>
	</cffunction>
	
	<cffunction name="createSourceSecurityGroupObject" access="public" returntype="Struct" 
	            output="false">
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#"/>
	
		<cfset var response = {GroupName=getValue(arguments.stXML, 'GroupName'), 
		                         OwnerAlias=getValue(arguments.stXML, 'OwnerAlias')}/>
		<cfreturn response/>
	</cffunction>
	
	<cffunction name="createListenerObject" access="public" returntype="Struct" output="false">
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#"/>
	
		<cfset var response = {InstancePort=getValue(arguments.stXML, 'InstancePort'), 
		                         InstanceProtocol=getValue(arguments.stXML, 'InstanceProtocol'),
		                         LoadBalancerPort=getValue(arguments.stXML, 'LoadBalancerPort'),
		                         Protocol=getValue(arguments.stXML, 'Protocol'),
		                         SSLCertificateId=getValue(arguments.stXML, 'SSLCertificateId')}/>
	
		<cfreturn response/>
	</cffunction>
	
	<cffunction name="createLoadBalancerDescriptionObject" access="public" returntype="Struct" 
	            output="false">
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#"/>
	
		<cfset var response = {AvailabilityZones=[], BackendServerDescriptions=[], 
		                         CanonicalHostedZoneName=getValue(arguments.stXML, 'CanonicalHostedZoneName'),
		                         CanonicalHostedZoneNameID=getValue(arguments.stXML, 'CanonicalHostedZoneNameID'),
		                         CreatedTime=getValue(arguments.stXML, 'CreatedTime'),
		                         DNSName=getValue(arguments.stXML, 'DNSName'),HealthCheck={}, 
		                         Instances=[],ListenerDescriptions=[], 
		                         LoadBalancerName=getValue(arguments.stXML, 'LoadBalancerName'),
		                         Policies=[],SecurityGroups=[], SourceSecurityGroup={}, Subnets=[], 
		                         VPCId=getValue(arguments.stXML, 'VPCId')}/>
	
		<cfif structKeyExists(arguments.stXML, 'HealthCheck')>
			<cfset response.HealthCheck = createHealthCheckObject(arguments.stXML.HealthCheck)/>
		</cfif>
		<cfif structKeyExists(arguments.stXML, 'SourceSecurityGroup')>
			<cfset response.SourceSecurityGroup = createSourceSecurityGroupObject(arguments.stXML.SourceSecurityGroup)/>
		</cfif>
		<cfloop array="#arguments.stXML.AvailabilityZones.xmlChildren#" index="result">
			<cfset arrayAppend(response.AvailabilityZones, result.xmlText)/>
		</cfloop>
	
		<cfloop array="#arguments.stXML.BackendServerDescriptions.xmlChildren#" index="result">
			<cfset arrayAppend(response.BackendServerDescriptions, 
			                   createBackendServerDescriptionObject(result))/>
		</cfloop>
	
		<cfloop array="#arguments.stXML.Instances.xmlChildren#" index="result">
			<cfset arrayAppend(response.Instances, createInstanceObject(result))/>
		</cfloop>
	
		<cfloop array="#arguments.stXML.ListenerDescriptions.xmlChildren#" index="result">
			<cfset arrayAppend(response.ListenerDescriptions, createListenerDescriptionObject(result))/>
		</cfloop>
	
		<cfloop array="#arguments.stXML.Policies.xmlChildren#" index="result">
			<cfset arrayAppend(response.Policies, createPoliciesObject(result))/>
		</cfloop>
	
		<cfloop array="#arguments.stXML.SecurityGroups.xmlChildren#" index="result">
			<cfset arrayAppend(response.SecurityGroups, result.xmlText)/>
		</cfloop>
	
		<cfloop array="#arguments.stXML.Subnets.xmlChildren#" index="result">
			<cfset arrayAppend(response.Subnets, result.xmlText)/>
		</cfloop>
	
		<cfreturn response/>
	</cffunction>
	
</cfcomponent>