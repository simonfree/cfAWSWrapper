<cfcomponent output="false" extends="amazonAWS" >
	<cffunction name="init" access="public" returntype="amazonElastiCache" >
		<cfargument name="awsAccessKeyId" type="string" required="true"/>
		<cfargument name="secretAccessKey" type="string" required="true"/>
		<cfargument name="endPoint" type="string" required="true" default="elasticache.us-east-1.amazonaws.com"/>
				
		<cfset variables.awsAccessKeyId = arguments.awsAccessKeyId />
		<cfset variables.secretAccesskey = arguments.secretAccessKey />
		<cfset variables.endPoint = arguments.endPoint />
		<cfset variables.requestMethod = 'no-header' />
		<cfset variables.version = '2012-03-09' />
		<cfset variables.protocol = 'https://' />
		<cfreturn this />		
	</cffunction>
	
	<cffunction name="DescribeEvents" access="public" returntype="Struct" >
		<cfargument name="Duration" type="String" required="false" default=""> 
		<cfargument name="EndTime" type="String" required="false" default=""> 
		<cfargument name="Marker" type="String" required="false" default=""> 
		<cfargument name="MaxRecords" type="String" required="false" default=""> 
		<cfargument name="SourceIdentifier" type="String" required="false" default=""> 
		<cfargument name="SourceType" type="String" required="false" default=""> 
		<cfargument name="StartTime" type="String" required="false" default="">
		 
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=DescribeEvents" />
		
		<cfif len(trim(arguments.Duration))>
			<cfset body &= "&Duration=" & trim(arguments.Duration) />
		</cfif>	
		
		<cfif len(trim(arguments.EndTime))>
			<cfset body &= "&EndTime=" & trim(arguments.EndTime) />
		</cfif>	
		
		<cfif len(trim(arguments.Marker))>
			<cfset body &= "&Marker=" & trim(arguments.Marker) />
		</cfif>	
		
		<cfif len(trim(arguments.MaxRecords))>
			<cfset body &= "&MaxRecords=" & trim(arguments.MaxRecords) />
		</cfif>	
		
		<cfif len(trim(arguments.SourceIdentifier))>
			<cfset body &= "&SourceIdentifier=" & trim(arguments.SourceIdentifier) />
		</cfif>	
		
		<cfif len(trim(arguments.SourceType))>
			<cfset body &= "&SourceType=" & trim(arguments.SourceType) />
		</cfif>	
		
		<cfif len(trim(arguments.StartTime))>
			<cfset body &= "&StartTime=" & trim(arguments.StartTime) />
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
			<cfset dataResult = getResultNodes(xmlParse(rawResult.fileContent),'Events')[1].xmlChildren />
			<cfset stResponse.result = [] />
			
			<cfloop array="#dataResult#" index="event">
				<cfset arrayAppend(stResponse.result,createEvent(event)) />
			</cfloop>
		</cfif>			
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="DescribeCacheClusters" access="public" returntype="Struct" >
		<cfargument name="CacheClusterId" type="String" required="false" default=""> 
		<cfargument name="Marker" type="String" required="false" default=""> 
		<cfargument name="MaxRecords" type="String" required="false" default=""> 
		<cfargument name="ShowCacheNodeInfo" type="String" required="false" default=""> 
		 
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=DescribeCacheClusters" />
		
		<cfif len(trim(arguments.CacheClusterId))>
			<cfset body &= "&CacheClusterId=" & trim(arguments.CacheClusterId) />
		</cfif>	
		
		<cfif len(trim(arguments.Marker))>
			<cfset body &= "&Marker=" & trim(arguments.Marker) />
		</cfif>	
		
		<cfif len(trim(arguments.MaxRecords))>
			<cfset body &= "&MaxRecords=" & trim(arguments.MaxRecords) />
		</cfif>	
		
		<cfif len(trim(arguments.ShowCacheNodeInfo))>
			<cfset body &= "&ShowCacheNodeInfo=" & trim(arguments.ShowCacheNodeInfo) />
		</cfif>	
		
		<cfset var aClusters=[] />
		
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
			<cfset dataResult = getResultNodes(xmlParse(rawResult.fileContent),'CacheClusters')[1].xmlChildren />
			<cfset stResponse.result = [] />
			
			<cfloop array="#dataResult#" index="cluster">
				<cfset arrayAppend(stResponse.result,createCluster(cluster)) />
			</cfloop>	
		</cfif>								
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
		
		<cfreturn stResponse/>
	</cffunction>	
	
	<cffunction name="DescribeCacheParameterGroups" access="public" returntype="Struct" >
		<cfargument name="CacheParameterGroupName" type="String" required="false" default=""> 
		<cfargument name="Marker" type="String" required="false" default=""> 
		<cfargument name="MaxRecords" type="String" required="false" default=""> 
		
		<cfset var stResponse = createResponse() /> 
		<cfset var aGroups = [] />
		<cfset var body = "Action=DescribeCacheParameterGroups" />
		
		<cfif len(trim(arguments.CacheParameterGroupName))>
			<cfset body &= "&CacheParameterGroupName=" & trim(arguments.CacheParameterGroupName) />
		</cfif>	
		
		<cfif len(trim(arguments.Marker))>
			<cfset body &= "&Marker=" & trim(arguments.Marker) />
		</cfif>	
		
		<cfif len(trim(arguments.MaxRecords))>
			<cfset body &= "&MaxRecords=" & trim(arguments.MaxRecords) />
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
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'CacheParameterGroups')[1].xmlChildren />
			<cfset stResponse.result=[] />
			<cfloop array="#dataResult#" index="parameterGroup">
				<cfset arrayAppend(stResponse.result,createCacheParamGroup(parameterGroup)) />
			</cfloop>
		</cfif>

		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />

		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="DescribeCacheParameters" access="public" returntype="Struct" >
		<cfargument name="CacheParameterGroupName" type="String" required="true"> 
		<cfargument name="Marker" type="String" required="false" default=""> 
		<cfargument name="MaxRecords" type="String" required="false" default=""> 
		<cfargument name="Source" type="String" required="false" default=""> 
		 
		<cfset var stResponse = createResponse() />
		<cfset var aParameters = [] />
		<cfset var body = "Action=DescribeCacheParameters&CacheParameterGroupName=" & trim(arguments.CacheParameterGroupName) />
		
		<cfif len(trim(arguments.Marker))>
			<cfset body &= "&Marker=" & trim(arguments.Marker) />
		</cfif>	
		
		<cfif len(trim(arguments.MaxRecords))>
			<cfset body &= "&MaxRecords=" & trim(arguments.MaxRecords) />
		</cfif>	
		
		<cfif len(trim(arguments.Source))>
			<cfset body &= "&Source=" & trim(arguments.Source) />
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
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'CacheNodeTypeSpecificParameters')[1].xmlChildren />
			<cfset stResponse.result = [] />
			
			<cfloop array="#dataResult#" index="cacheParameter">
				<cfset arrayAppend(stResponse.result,createCacheNodeTypeSpecificParameter(cacheParameter)) />
			</cfloop>	
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />

		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="DescribeCacheSecurityGroups" access="public" returntype="Struct" >
		<cfargument name="CacheSecurityGroupName" type="String" required="false" default=""> 
		<cfargument name="Marker" type="String" required="false" default=""> 
		<cfargument name="MaxRecords" type="String" required="false" default=""> 
		
		<cfset var stResponse = createResponse() /> 
		<cfset var aGroups = [] />
		<cfset var body = "Action=DescribeCacheSecurityGroups" />
		
		<cfif len(trim(arguments.CacheSecurityGroupName))>
			<cfset body &= "&CacheSecurityGroupName=" & trim(arguments.CacheSecurityGroupName) />
		</cfif>	
		
		<cfif len(trim(arguments.Marker))>
			<cfset body &= "&Marker=" & trim(arguments.Marker) />
		</cfif>	
		
		<cfif len(trim(arguments.MaxRecords))>
			<cfset body &= "&MaxRecords=" & trim(arguments.MaxRecords) />
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
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'CacheSecurityGroups')[1].xmlChildren />
			<cfset stResponse.result = [] />
			
			<cfloop array="#dataResult#" index="securityGroup">
				<cfset arrayAppend(stResponse.result,createSecurityGroup(securityGroup)) />
			</cfloop>
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
	
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="DescribeEngineDefaultParameters" access="public" returntype="Struct" >
		<cfargument name="CacheParameterGroupFamily" type="String" required="true"> 
		<cfargument name="Marker" type="String" required="false" default=""> 
		<cfargument name="MaxRecords" type="String" required="false" default=""> 
		 
		<cfset var stResponse = createResponse() />
		<cfset var aEngines = [] />
		<cfset var body = "Action=DescribeEngineDefaultParameters&CacheParameterGroupFamily=" & trim(arguments.CacheParameterGroupFamily) />
		
		<cfif len(trim(arguments.Marker))>
			<cfset body &= "&Marker=" & trim(arguments.Marker) />
		</cfif>	
		
		<cfif len(trim(arguments.MaxRecords))>
			<cfset body &= "&MaxRecords=" & trim(arguments.MaxRecords) />
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
			<cfset dataResult = getResultNodes(xmlParse(rawResult.fileContent),'DescribeEngineDefaultParametersResult')[1].xmlChildren />
			<cfset stResponse.result=[] />
				
			<cfloop array="#dataResult#" index="engine">
				<cfset stEngine = {CacheParameterGroupFamily=engine.CacheParameterGroupFamily.xmlText} />
				
				<cfset stEngine.CacheNodeTypeSpecificParameters = [] />
				<cfset stEngine.Parameters = [] />
				
				<cfloop array="#engine.CacheNodeTypeSpecificParameters.xmlChildren#" index="specificParameter">
					<cfset arrayAppend(stEngine.CacheNodeTypeSpecificParameters,createCacheNodeTypeSpecificParameter(specificParameter)) />	
				</cfloop>	
				
				<cfloop array="#engine.Parameters.xmlChildren#" index="Parameter">
					<cfset arrayAppend(stEngine.Parameters,createParameter(Parameter)) />	
				</cfloop>
				
				<cfset arrayAppend(stResponse.result,stEngine) />
			</cfloop>	
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
	
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="DescribeReservedCacheNodes" access="public" returntype="Struct" >
		<cfargument name="CacheNodeType" type="String" required="false" default=""> 
		<cfargument name="Duration" type="String" required="false" default=""> 
		<cfargument name="Marker" type="String" required="false" default=""> 
		<cfargument name="MaxRecords" type="String" required="false" default=""> 
		<cfargument name="OfferingType" type="String" required="false" default=""> 
		<cfargument name="ProductDescription" type="String" required="false" default=""> 
		<cfargument name="ReservedCacheNodeId" type="String" required="false" default=""> 
		<cfargument name="ReservedCacheNodesOfferingId" type="String" required="false" default=""> 
		
		<cfset var stResponse = createResponse() /> 
		<cfset var aNodes = [] />
		<cfset var body = "Action=DescribeReservedCacheNodes" />
		
		<cfif len(trim(arguments.CacheNodeType))>
			<cfset body &= "&CacheNodeType=" & trim(arguments.CacheNodeType) />
		</cfif>	
		
		<cfif len(trim(arguments.Duration))>
			<cfset body &= "&Duration=" & trim(arguments.Duration) />
		</cfif>	
		
		<cfif len(trim(arguments.Marker))>
			<cfset body &= "&Marker=" & trim(arguments.Marker) />
		</cfif>	
		
		<cfif len(trim(arguments.MaxRecords))>
			<cfset body &= "&MaxRecords=" & trim(arguments.MaxRecords) />
		</cfif>	
		
		<cfif len(trim(arguments.OfferingType))>
			<cfset body &= "&OfferingType=" & trim(arguments.OfferingType) />
		</cfif>	
		
		<cfif len(trim(arguments.ProductDescription))>
			<cfset body &= "&ProductDescription=" & trim(arguments.ProductDescription) />
		</cfif>	
		
		<cfif len(trim(arguments.ReservedCacheNodeId))>
			<cfset body &= "&ReservedCacheNodeId=" & trim(arguments.ReservedCacheNodeId) />
		</cfif>	
		
		<cfif len(trim(arguments.ReservedCacheNodesOfferingId))>
			<cfset body &= "&ReservedCacheNodesOfferingId=" & trim(arguments.ReservedCacheNodesOfferingId) />
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
			<cfset dataResult = getResultNodes(xmlParse(rawResult.fileContent),'ReservedCacheNodes') />
			<cfset stResponse.result=[] />
			
			<cfloop array="#dataResult#" index="cachenode">
				<cfset arrayAppend(stResponse.result,createReservedCacheNode(cachenode)) />
			</cfloop>	
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
	
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="DescribeReservedCacheNodesOfferings" access="public" returntype="Struct" >
		<cfargument name="CacheNodeType" type="String" required="false" default=""> 
		<cfargument name="Duration" type="String" required="false" default=""> 
		<cfargument name="Marker" type="String" required="false" default=""> 
		<cfargument name="MaxRecords" type="String" required="false" default=""> 
		<cfargument name="OfferingType" type="String" required="false" default=""> 
		<cfargument name="ProductDescription" type="String" required="false" default=""> 
		<cfargument name="ReservedCacheNodesOfferingId" type="String" required="false" default=""> 
		
		<cfset var stResponse = createResponse() /> 
		<cfset var aNodes = [] />
		<cfset var body = "Action=DescribeReservedCacheNodesOfferings" />
		
		<cfif len(trim(arguments.CacheNodeType))>
			<cfset body &= "&CacheNodeType=" & trim(arguments.CacheNodeType) />
		</cfif>	
		
		<cfif len(trim(arguments.Duration))>
			<cfset body &= "&Duration=" & trim(arguments.Duration) />
		</cfif>	
		
		<cfif len(trim(arguments.Marker))>
			<cfset body &= "&Marker=" & trim(arguments.Marker) />
		</cfif>	
		
		<cfif len(trim(arguments.MaxRecords))>
			<cfset body &= "&MaxRecords=" & trim(arguments.MaxRecords) />
		</cfif>	
		
		<cfif len(trim(arguments.OfferingType))>
			<cfset body &= "&OfferingType=" & trim(arguments.OfferingType) />
		</cfif>	
		
		<cfif len(trim(arguments.ProductDescription))>
			<cfset body &= "&ProductDescription=" & trim(arguments.ProductDescription) />
		</cfif>	
		
		<cfif len(trim(arguments.ReservedCacheNodesOfferingId))>
			<cfset body &= "&ReservedCacheNodesOfferingId=" & trim(arguments.ReservedCacheNodesOfferingId) />
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
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'ReservedCacheNodesOffering') />
			<cfset stResponse.result = [] />
			
			<cfloop array="#dataResult#" index="nodeOffering">
				<cfset arrayAppend(stResponse.result,createReservedCacheNodesOffering(nodeOffering)) />
			</cfloop>	
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
	
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="CreateCacheCluster" access="public" returntype="Struct" >
		<cfargument name="CacheClusterId" type="String" required="true"> 
		<cfargument name="CacheNodeType" type="String" required="true"> 
		<cfargument name="CacheSecurityGroupNames" type="String" required="true"> 
		<cfargument name="NumCacheNodes" type="String" required="true">
		
		<cfargument name="AutoMinorVersionUpgrade" type="Boolean" required="false" default="true">
		<cfargument name="CacheParameterGroupName" type="String" required="false" default=""> 
		<cfargument name="EngineVersion" type="String" required="false" default="">
		<cfargument name="NotificationTopicArn" type="String" required="false" default="">
		<cfargument name="Port" type="String" required="false" default="">
		<cfargument name="PreferredAvailabilityZone" type="String" required="false" default="">	  
		<cfargument name="PreferredMaintenanceWindow" type="String" required="false" default="">  
		<cfargument name="Engine" type="String" required="false" default="memcached"> 

		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=CreateCacheCluster&CacheClusterId=" & trim(arguments.CacheClusterId) &
							"&CacheNodeType=" & trim(arguments.CacheNodeType) &
							"&Engine=" & trim(arguments.Engine) & 
							"&NumCacheNodes=" & trim(arguments.NumCacheNodes) & 
							"&AutoMinorVersionUpgrade=" & trim(arguments.AutoMinorVersionUpgrade) />
		
		<cfloop from="1" to="#listLen(arguments.CacheSecurityGroupNames)#" index="i">
			<cfset body &= "&CacheSecurityGroupNames.member." & i & "=" & listGetAt(trim(arguments.CacheSecurityGroupNames),i) />
		</cfloop>	
		
		<cfif len(trim(arguments.CacheParameterGroupName))>
			<cfset body &= "&CacheParameterGroupName=" & trim(arguments.CacheParameterGroupName) />
		</cfif>	
		
		<cfif len(trim(arguments.NotificationTopicArn))>
			<cfset body &= "&NotificationTopicArn=" & trim(arguments.NotificationTopicArn) />
		</cfif>
		
		<cfif len(trim(arguments.Port))>
			<cfset body &= "&Port=" & trim(arguments.Port) />
		</cfif>
		
		<cfif len(trim(arguments.PreferredAvailabilityZone))>
			<cfset body &= "&PreferredAvailabilityZone=" & trim(arguments.PreferredAvailabilityZone) />
		</cfif>
		
		<cfif len(trim(arguments.PreferredMaintenanceWindow))>
			<cfset body &= "&PreferredMaintenanceWindow=" & trim(arguments.PreferredMaintenanceWindow) />
		</cfif>
		
		<cfif len(trim(arguments.EngineVersion))>
			<cfset body &= "&EngineVersion=" & trim(arguments.EngineVersion) />
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
			<cfset dataResult = getResultNodes(xmlParse(rawResult.fileContent),'CacheCluster')[1] />
			<cfset stResponse.result = createCacheClusterObject(dataresult) />
		</cfif>	
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
				
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="CreateCacheSecurityGroup" access="public" returntype="Struct" >
		<cfargument name="CacheSecurityGroupName" type="String" required="true"> 
		<cfargument name="Description" type="String" required="true"> 

		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=CreateCacheSecurityGroup&CacheSecurityGroupName=" & trim(arguments.CacheSecurityGroupName) & "&Description=" & trim(arguments.Description) />
		
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
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'CacheSecurityGroup')[1] />						
			<cfset stResponse.result = createSecurityGroup(dataResult) />
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
		
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="CreateCacheParameterGroup" access="public" returntype="Struct" >
		<cfargument name="CacheParameterGroupName" type="String" required="true">
		<cfargument name="Description" type="String" required="true"> 
		<cfargument name="CacheParameterGroupFamily" type="String" required="false" default="memcached1.4"> 
		
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=CreateCacheParameterGroup&CacheParameterGroupName=" & trim(arguments.CacheParameterGroupName) & "&Description=" & trim(arguments.Description) & "&CacheParameterGroupFamily=" & trim(arguments.CacheParameterGroupFamily) />
		
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
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'CacheParameterGroup')[1] />	
			<cfset stResponse.result= createCacheParamGroup(dataresult) />					
		</cfif>							
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
		
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="ModifyCacheParameterGroup" access="public" returntype="Struct" >
		<cfargument name="CacheParameterGroupName" type="String" required="true">
		<cfargument name="ParameterNameValues" type="Array" required="true"> 
		
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=ModifyCacheParameterGroup&CacheParameterGroupName=" & trim(arguments.CacheParameterGroupName) />
		
		<cfloop from="1" to="#arrayLen(arguments.ParameterNameValues)#" index="i">
			<cfset body &= "&ParameterNameValues.member." & i & ".ParameterName=" & trim(arguments.ParameterNameValues[i].ParameterName) & "&ParameterNameValues.member." & i & ".ParameterValue=" & trim(arguments.ParameterNameValues[i].ParameterValue) />
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
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'CacheParameterGroupName')[1] />						
			<cfset stResponse.result = dataResult.xmlText />
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
									
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="ResetCacheParameterGroup" access="public" returntype="Struct" >
		<cfargument name="CacheParameterGroupName" type="String" required="true">
		<cfargument name="ParameterNameValues" type="String" required="false" default=""> 
		<cfargument name="ResetAllParameters" type="Boolean" required="false" default="false">
		
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=ResetCacheParameterGroup&CacheParameterGroupName=" & trim(arguments.CacheParameterGroupName) />
		
		<cfif !listlen(arguments.ParameterNameValues) && !arguments.ResetAllParameters>
			You must reset allparameters or supply a list of parameters to reset<cfabort>
		</cfif>	
		
		<cfloop from="1" to="#listLen(arguments.ParameterNameValues)#" index="i">
			<cfset body &= "&ParameterNameValues.member." & i & ".ParameterName=" & listgetat(trim(arguments.ParameterNameValues),i) />
		</cfloop>
			
		<cfset body &= "&ResetAllParameters=" & trim(arguments.ResetAllParameters) />
		
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
			<cfset stResponse.result = getResultNodes(xmlParse(rawResult.filecontent),'CacheParameterGroupName')[1].xmlText />						
		</cfif>							
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
									
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="ModifyCacheCluster" access="public" returntype="Struct" >
		<cfargument name="CacheClusterId" type="String" required="true">
		<cfargument name="ApplyImmediately" type="String" required="false" default="">
		<cfargument name="AutoMinorVersionUpgrade" type="String" required="false" default="">
		<cfargument name="CacheNodeIdsToRemove" type="string" required="false" default="">
		<cfargument name="CacheParameterGroupName" type="String" required="false" default="">
		<cfargument name="CacheSecurityGroupNames" type="String" required="false" default="#[]#">
		<cfargument name="EngineVersion" type="String" required="false" default="">
		<cfargument name="NotificationTopicArn" type="String" required="false" default="">
		<cfargument name="NotificationTopicStatus" type="String" required="false" default="">
		<cfargument name="NumCacheNodes" type="String" required="false" default="">
		<cfargument name="PreferredMaintenanceWindow" type="String" required="false" default="">
		
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=ModifyCacheCluster&CacheClusterId=" & trim(arguments.CacheClusterId) />
		
		<cfloop from="1" to="#listLen(arguments.CacheNodeIdsToRemove)#" index="i">
			<cfset body &= "&CacheNodeIdsToRemove.member" & i & "=" & trim(listGetAt(arguments.CacheNodeIdsToRemove,i)) />
		</cfloop>
			
		<cfloop from="1" to="#listLen(arguments.CacheSecurityGroupNames)#" index="j">
			<cfset body &= "&CacheSecurityGroupNames.member." & j & "=" & trim(listgetat(arguments.CacheSecurityGroupNames,j)) />
		</cfloop>
		
		<cfif len(trim(arguments.ApplyImmediately))>
			<cfset body &= "&ApplyImmediately=" & trim(arguments.ApplyImmediately) />
		</cfif>	
		
		<cfif len(trim(arguments.AutoMinorVersionUpgrade))>
			<cfset body &= "&AutoMinorVersionUpgrade=" & trim(arguments.AutoMinorVersionUpgrade) />
		</cfif>	
		
		<cfif len(trim(arguments.CacheParameterGroupName))>
			<cfset body &= "&CacheParameterGroupName=" & trim(arguments.CacheParameterGroupName) />
		</cfif>	
		
		<cfif len(trim(arguments.EngineVersion))>
			<cfset body &= "&EngineVersion=" & trim(arguments.EngineVersion) />
		</cfif>	
		
		<cfif len(trim(arguments.NotificationTopicArn))>
			<cfset body &= "&NotificationTopicArn=" & trim(arguments.NotificationTopicArn) />
		</cfif>	
		
		<cfif len(trim(arguments.NotificationTopicStatus))>
			<cfset body &= "&NotificationTopicStatus=" & trim(arguments.NotificationTopicStatus) />
		</cfif>	
		
		<cfif len(trim(arguments.NumCacheNodes))>
			<cfset body &= "&NumCacheNodes=" & trim(arguments.NumCacheNodes) />
		</cfif>	
		
		<cfif len(trim(arguments.PreferredMaintenanceWindow))>
			<cfset body &= "&PreferredMaintenanceWindow=" & trim(arguments.PreferredMaintenanceWindow) />
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
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'CacheCluster')[1] />						
			<cfset stResponse.result=createCluster(dataResult) />
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
									
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="RebootCacheCluster" access="public" returntype="Struct" >
		<cfargument name="CacheClusterId" type="String" required="true">
		<cfargument name="CacheNodeIdsToReboot" type="String" required="true"> 
		
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=RebootCacheCluster&CacheClusterId=" & trim(arguments.CacheClusterId) />
		
		<cfloop from="1" to="#listLen(arguments.CacheNodeIdsToReboot)#" index="i">
			<cfset body &= "&CacheNodeIdsToReboot.member." & i & "=" & trim(listGetAt(arguments.CacheNodeIdsToReboot,i)) />
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
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'CacheCluster')[1] />						
			<cfset stResponse.result=createCluster(dataResult) />
		</cfif>	
								
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
									
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="DeleteCacheSecurityGroup" access="public" returntype="Struct" >
		<cfargument name="CacheSecurityGroupName" type="String" required="true">
		
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=DeleteCacheSecurityGroup&CacheSecurityGroupName=" & trim(arguments.CacheSecurityGroupName) />
		
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
	
	<cffunction name="DeleteCacheParameterGroup" access="public" returntype="Struct" >
		<cfargument name="CacheParameterGroupName" type="String" required="true">
		
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=DeleteCacheParameterGroup&CacheParameterGroupName=" & trim(arguments.CacheParameterGroupName) />
		
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

	<cffunction name="DeleteCacheCluster" access="public" returntype="Struct" >
		<cfargument name="CacheClusterId" type="String" required="true">
		
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=DeleteCacheCluster&CacheClusterId=" & trim(arguments.CacheClusterId) />
		
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
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'CacheCluster')[1] />						
			<cfset stResponse.result=CreateCluster(datResult) />
		</cfif>
			 
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
									
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="AuthorizeCacheSecurityGroupIngress" access="public" returntype="Struct" >
		<cfargument name="CacheSecurityGroupName" type="String" required="true">
		<cfargument name="EC2SecurityGroupName" type="String" required="true">
		<cfargument name="EC2SecurityGroupOwnerId" type="String" required="true">
		
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=AuthorizeCacheSecurityGroupIngress&CacheSecurityGroupName=" & trim(arguments.CacheSecurityGroupName) & "&EC2SecurityGroupName=" & trim(arguments.EC2SecurityGroupName) &  "&EC2SecurityGroupOwnerId=" & trim(arguments.EC2SecurityGroupOwnerId)/>
		
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
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'CacheSecurityGroup')[1] />						
			<cfset stResponse.result = createSecurityGroup(dataResult) />
		</cfif>
								
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
									
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="RevokeCacheSecurityGroupIngress" access="public" returntype="Struct" >
		<cfargument name="CacheSecurityGroupName" type="String" required="true">
		<cfargument name="EC2SecurityGroupName" type="String" required="true">
		<cfargument name="EC2SecurityGroupOwnerId" type="String" required="true">
		
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=RevokeCacheSecurityGroupIngress&CacheSecurityGroupName=" & trim(arguments.CacheSecurityGroupName) & "&EC2SecurityGroupName=" & trim(arguments.EC2SecurityGroupName) &  "&EC2SecurityGroupOwnerId=" & trim(arguments.EC2SecurityGroupOwnerId)/>
		
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
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'CacheSecurityGroup')[1] />						
			<cfset stResponse.result = createSecurityGroup(dataResult) />
		</cfif>
								
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
									
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="PurchaseReservedCacheNodesOffering" access="public" returntype="Struct" >
		<cfargument name="ReservedCacheNodesOfferingId" type="String" required="true">
		<cfargument name="CacheNodeCount" type="String" required="false" default="">
		<cfargument name="ReservedCacheNodeId" type="String" required="false" default="">
		
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=PurchaseReservedCacheNodesOffering&ReservedCacheNodesOfferingId=" & trim(arguments.ReservedCacheNodesOfferingId)/>
		
		<cfif len(trim(arguments.CacheNodeCount))>
			<cfset body &= "&CacheNodeCount=" & trim(arguments.CacheNodeCount) />
		</cfif>	
		
		<cfif len(trim(arguments.ReservedCacheNodeId))>
			<cfset body &= "&ReservedCacheNodeId=" & trim(arguments.ReservedCacheNodeId) />
		</cfif>	
		
		<cfset var rawResult = makeRequest(
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
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'ReservedCacheNode')[1] />	
			<cfset stResponse.result = createReservedCacheNode(dataResult) />
		</cfif>					

		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
									
		<cfreturn stResponse />
	</cffunction>
	
	<!--- Data Structures --->
		
	<cffunction name="createSendDataPoint" access="private" returntype="Struct" output="false" >
		<cfargument name="xmlData" type="xml" required="true" >
		
		<cfset var stResult = {} />
		
		<cfset stResult['Bounces'] = getValue(arguments.xmlData,'Bounces') />
		<cfset stResult['Complaints'] = getValue(arguments.xmlData,'Complaints') />
		<cfset stResult['DeliveryAttempts'] = getValue(arguments.xmlData,'DeliveryAttempts') />
		<cfset stResult['Rejects'] = getValue(arguments.xmlData,'Rejects') />
		<cfset stResult['Timestamp'] = getValue(arguments.xmlData,'Timestamp') />
		
		<cfreturn stResult />
	</cffunction>
	
	<cffunction name="createEvent" access="private" returntype="Struct" output="false" >
		<cfargument name="xmlData" type="xml" required="true" >
		
		<cfset var stResult = {} />
		
		<cfset stResult['Date'] = getValue(arguments.xmlData,'Date') />
		<cfset stResult['Message'] = getValue(arguments.xmlData,'Message') />
		<cfset stResult['SourceIdentifier'] = getValue(arguments.xmlData,'SourceIdentifier') />
		<cfset stResult['SourceType'] = getValue(arguments.xmlData,'SourceType') />
		
		<cfreturn stResult />
	</cffunction>	
	
	<cffunction name="createCluster" access="private" returntype="Struct" output="false" >
		<cfargument name="xmlData" type="xml" required="true" >
		
		<cfset var stResult = {
						CacheClusterId=getValue(arguments.xmlData,'CacheClusterId'),
						CacheClusterStatus=getValue(arguments.xmlData,'CacheClusterStatus'),
						CacheNodeType=getValue(arguments.xmlData,'CacheNodeType'),
						Engine=getValue(arguments.xmlData,'Engine'),
						PendingModifiedValues=createPendingModifiedValues(arguments.xmlData.PendingModifiedValues),
						PreferredAvailabilityZone=getValue(arguments.xmlData,'PreferredAvailabilityZone'),
						CacheClusterCreateTime=getValue(arguments.xmlData,'CacheClusterCreateTime'),
						EngineVersion=getValue(arguments.xmlData,'EngineVersion'),
						AutoMinorVersionUpgrade=getValue(arguments.xmlData,'AutoMinorVersionUpgrade'),
						PreferredMaintenanceWindow=getValue(arguments.xmlData,'PreferredMaintenanceWindow'),
						NumCacheNodes=getValue(arguments.xmlData,'NumCacheNodes'),
						CacheSecurityGroups=[],
						CacheNodes=[],
						CacheParameterGroup=createCacheParamGroupStatus(arguments.xmlData.CacheParameterGroup)
					} />
			
			
			<cfif structKeyExists(arguments.xmlData,'CacheSecurityGroups')>
				<cfloop array="#arguments.xmlData.CacheSecurityGroups.xmlChildren#" index="cacheSecurityGroup">
					<cfset arrayAppend(stResult.CacheSecurityGroups,createSecurityGroup(cacheSecurityGroup)) />
				</cfloop>	
			</cfif>
				
			<cfif structKeyExists(arguments.xmlData,'CacheNodes')>
				<cfloop array="#arguments.xmlData.CacheNodes.xmlChildren#" index="cachenode">
					<cfset arrayAppend(stResult.CacheNodes,createCachenode(cachenode)) />
				</cfloop>	
			</cfif>	
			
		<cfreturn stResult />
	</cffunction>	
		 	
	<cffunction name="createCacheParamGroupStatus" access="private" returntype="Struct" >
		<cfargument name="xmlData" type="xml" required="true" >
		
		<cfset var stResult = {
						ParameterApplyStatus=getValue(arguments.xmlData,'ParameterApplyStatus'),
						CacheParameterGroupName=getValue(arguments.xmlData,'CacheParameterGroupName'),
						CacheNodeIdsToReboot=getValue(arguments.xmlData,'CacheNodeIdsToReboot')
					} />
					
		<cfreturn stResult />			
	</cffunction>		 	
	
	<cffunction name="createPendingModifiedValues" access="private" returntype="Struct" >
		<cfargument name="xmlData" type="xml" required="true" >
		
		<cfset var stResult = {} />
		
		<cfloop array="#arguments.xmlData.xmlChildren#" index="modification">
			<cfset stResult[modification.xmlName] = modification.xmlText />
		</cfloop>
			
		<cfreturn stResult />			
	</cffunction>		
	
	<cffunction name="createSecurityGroup" access="private" returntype="Struct" >
		<cfargument name="xmlData" type="xml" required="true" >
		
		<cfset var stResult = {} />
		
		<cfset stResult['CacheSecurityGroupName']=getValue(arguments.xmlData,'CacheSecurityGroupName') />
		<cfset stResult['Status']=getValue(arguments.xmlData,'Status') />
		
		<cfset stResult['EC2SecurityGroups'] = [] />
		<cfloop array="#arguments.xmlData.EC2SecurityGroups.xmlChildren#" index="ec2">
			<cfset arrayAppend(stResult['Status'],createEC2SecurityGroup(ec2)) />
		</cfloop>	
		
		<cfset stResult['OwnerId']=getValue(arguments.xmlData,'OwnerId') />
		<cfset stResult['Description']=getValue(arguments.xmlData,'Description') />
			
		<cfreturn stResult />			
	</cffunction>
	
	<cffunction name="createCachenode" access="private" returntype="Struct" >
		<cfargument name="xmlData" type="xml" required="true" >
		
		<cfset var stResult = {
				CacheNodeCreateTime=getValue(arguments.xmlData,'CacheNodeCreateTime'),
				CacheNodeId=getValue(arguments.xmlData,'CacheNodeId'),
				CacheNodeStatus=getValue(arguments.xmlData,'CacheNodeStatus'),
				Endpoint=createEndPoint(arguments.xmlData.Endpoint),
				ParameterGroupStatus=getValue(arguments.xmlData,'ParameterGroupStatus')
			} />
			
		<cfreturn stResult />			
	</cffunction>
	
	<cffunction name="createEndPoint" access="private" returntype="Struct" >
		<cfargument name="xmlData" type="xml" required="true" >
		
		<cfset var stResult = {
				Address=getValue(arguments.xmlData,'Address'),
				Port=getValue(arguments.xmlData,'Port')
			} />
			
		<cfreturn stResult />			
	</cffunction>
	
	<cffunction name="createCacheParamGroup" access="private" returntype="Struct" >
		<cfargument name="xmlData" type="xml" required="true" >
		
		<cfset var stResult = {
						CacheParameterGroupName=getValue(arguments.xmlData,'CacheParameterGroupName'),
						CacheParameterGroupFamily=getValue(arguments.xmlData,'CacheParameterGroupFamily'),
						Description=getValue(arguments.xmlData,'Description')
						} />
					
		<cfreturn stResult />			
	</cffunction>
	
	<cffunction name="createCacheNodeTypeSpecificParameter" access="private" returntype="Struct" >
		<cfargument name="xmlData" type="xml" required="true" >
		
		<cfset stResult = {
						DataType=getValue(arguments.xmlData,'DataType'),
						Source=getValue(arguments.xmlData,'Source'),
						IsModifiable=getValue(arguments.xmlData,'IsModifiable'),
						Description=getValue(arguments.xmlData,'Description'),
						AllowedValues=getValue(arguments.xmlData,'AllowedValues'),
						ParameterName=getValue(arguments.xmlData,'ParameterName'),
						MinimumEngineVersion=getValue(arguments.xmlData,'MinimumEngineVersion'),
						CacheNodeTypeSpecificValues={}
					} />
		<cfloop array="#arguments.xmlData.CacheNodeTypeSpecificValues.xmlChildren#" index="specificValue">
			<cfset stResult['CacheNodeTypeSpecificValues'][specificValue.CacheNodeType.xmlText] = specificValue.Value.xmlText />
		</cfloop>
						
		<cfreturn stResult />			
	</cffunction>
	
	<cffunction name="createEC2SecurityGroup" access="private" returntype="Struct" >
		<cfargument name="xmlData" type="xml" required="true" >
		
		<cfset var stResult = {
						EC2SecurityGroupName=getValue(arguments.xmlData,'EC2SecurityGroupName'),
						EC2SecurityGroupOwnerId=getValue(arguments.xmlData,'EC2SecurityGroupOwnerId'),
						Status=getValue(arguments.xmlData,'Status')
						} />
					
		<cfreturn stResult />			
	</cffunction>
	
	<cffunction name="createParameter" access="private" returntype="Struct" >
		<cfargument name="xmlData" type="xml" required="true" >
		
		<cfset var stResult = {} />
		
		<cfset stResult['AllowedValues']=getValue(arguments.xmlData,'AllowedValues') />
		<cfset stResult['DataType']=getValue(arguments.xmlData,'DataType') />
		<cfset stResult['Description']=getValue(arguments.xmlData,'Description') />
		<cfset stResult['IsModifiable']=getValue(arguments.xmlData,'IsModifiable') />
		<cfset stResult['MinimumEngineVersion']=getValue(arguments.xmlData,'MinimumEngineVersion') />
		<cfset stResult['ParameterName']=getValue(arguments.xmlData,'ParameterName') />
		<cfset stResult['ParameterValue']=getValue(arguments.xmlData,'ParameterValue') />
		<cfset stResult['Source']=getValue(arguments.xmlData,'Source') />
			
		<cfreturn stResult />			
	</cffunction>
	
	<cffunction name="createReservedCacheNode" access="private" returntype="Struct" >
		<cfargument name="xmlData" type="xml" required="true" >
		
		<cfset var stResult = {} />
		
		<cfset stResult['CacheNodeCount']=getValue(arguments.xmlData,'CacheNodeCount')/>
		<cfset stResult['CacheNodeType']=getValue(arguments.xmlData,'CacheNodeType')/>
		<cfset stResult['Duration']=getValue(arguments.xmlData,'Duration')/>
		<cfset stResult['FixedPrice']=getValue(arguments.xmlData,'FixedPrice')/>
		<cfset stResult['OfferingType']=getValue(arguments.xmlData,'OfferingType')/>
		<cfset stResult['ProductDescription']=getValue(arguments.xmlData,'ProductDescription')/>
		<cfset stResult['ReservedCacheNodeId']=getValue(arguments.xmlData,'ReservedCacheNodeId')/>
		<cfset stResult['ReservedCacheNodesOfferingId']=getValue(arguments.xmlData,'ReservedCacheNodesOfferingId')/>
		<cfset stResult['StartTime']=getValue(arguments.xmlData,'StartTime')/>
		<cfset stResult['State']=getValue(arguments.xmlData,'State')/>
		<cfset stResult['UsagePrice']=getValue(arguments.xmlData,'UsagePrice')/>

		<cfset stResult['RecurringCharges'] = [] />
		<cfloop array="#arguments.xmlData.RecurringCharges.xmlChildren#" index="RecurringCharge">
			<cfset arrayAppend(stResult.RecurringCharges,createRecurringCharge(recurringCharge)) />
		</cfloop>	
			
		<cfreturn stResult />			
	</cffunction>
	
	<cffunction name="createRecurringCharge" access="private" returntype="Struct" >
		<cfargument name="xmlData" type="xml" required="true" >
		
		<cfset var stResult = {
						RecurringChargeAmount=getValue(arguments.xmlData,'RecurringChargeAmount'),
						RecurringChargeFrequency=getValue(arguments.xmlData,'RecurringChargeFrequency')
						} />
					
		<cfreturn stResult />			
	</cffunction>
	
	<cffunction name="createCacheSecurityGroupMembership" access="private" returntype="Struct" >
		<cfargument name="xmlData" type="xml" required="true" >
		
		<cfset var stResult = {
						CacheSecurityGroupName=getValue(arguments.xmlData,'CacheSecurityGroupName'),
						Status=getValue(arguments.xmlData,'Status')
						} />
					
		<cfreturn stResult />			
	</cffunction>
	
	<cffunction name="createReservedCacheNodesOffering" access="private" returntype="Struct" >
		<cfargument name="xmlData" type="xml" required="true" >
		
		<cfset var stResult = {} />
		
			<cfset stResult['CacheNodeType']=getValue(arguments.xmlData,'CacheNodeType') />
			<cfset stResult['Duration']=getValue(arguments.xmlData,'Duration') />
			<cfset stResult['FixedPrice']=getValue(arguments.xmlData,'FixedPrice') />
			<cfset stResult['OfferingType']=getValue(arguments.xmlData,'OfferingType') />
			<cfset stResult['ProductDescription']=getValue(arguments.xmlData,'ProductDescription') />
			<cfset stResult['ReservedCacheNodeId']=getValue(arguments.xmlData,'ReservedCacheNodeId') />
			<cfset stResult['ReservedCacheNodesOfferingId']=getValue(arguments.xmlData,'ReservedCacheNodesOfferingId') />
			<cfset stResult['UsagePrice']=getValue(arguments.xmlData,'UsagePrice') />

			<cfset stResult['RecurringCharges'] = [] />
			<cfloop array="#arguments.xmlData.RecurringCharges.xmlChildren#" index="RecurringCharge">
				<cfset arrayAppend(stResult.RecurringCharges,createRecurringCharge(recurringCharge)) />
			</cfloop>	
			
		<cfreturn stResult />			
	</cffunction>
	
	<cffunction name="createCacheClusterObject" access="private" returntype="Struct" >
		<cfargument name="xmlData" type="xml" required="true" >
		
		<cfset var stResult={
						CacheClusterId=getValue(arguments.xmlData,'CacheClusterId'),
						CacheClusterStatus=getValue(arguments.xmlData,'CacheClusterStatus'),
						CacheNodeType=getValue(arguments.xmlData,'CacheNodeType'),
						Engine=getValue(arguments.xmlData,'Engine'),
						PendingModifiedValues={},
						EngineVersion=getValue(arguments.xmlData,'EngineVersion'),
						AutoMinorVersionUpgrade=getValue(arguments.xmlData,'AutoMinorVersionUpgrade'),
						PreferredMaintenanceWindow=getValue(arguments.xmlData,'PreferredMaintenanceWindow'),
						NumCacheNodes=getValue(arguments.xmlData,'NumCacheNodes'),
						CacheSecurityGroups=[],
						CacheNodes=[],
						CacheParameterGroup={
											CacheParameterGroupName=getValue(arguments.xmlData.CacheParameterGroup,'CacheParameterGroupName'),
											ParameterApplyStatus=getValue(arguments.xmlData.CacheParameterGroup,'ParameterApplyStatus'),
											CacheNodeIdsToReboot=getValue(arguments.xmlData.CacheParameterGroup,'CacheNodeIdsToReboot')
											}

					}/>
							
			<cfloop array="#arguments.xmlData.CacheSecurityGroups.xmlChildren#" index="group">
				<cfset arrayAppend(stResult.CacheSecurityGroups,createCacheSecurityGroupMembership(group)) />
			</cfloop>
			
			<cfif structKeyExists(arguments.xmlData,'CacheNodes')>
				<cfloop array="#arguments.xmlData.CacheNodes.xmlChildren#" index="node">
					<cfset arrayAppend(stResult.CacheNodes,createCacheNode(node)) />
				</cfloop>		
			</cfif>
			
			<cfloop array="#arguments.xmlData.PendingModifiedValues.xmlChildren#" index="modification">
				<cfset stResult.PendingModifiedValues[modification.xmlName] = modification.xmlText />
			</cfloop>
					
		<cfreturn stResult />			
	</cffunction>
	
</cfcomponent>