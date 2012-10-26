<cfcomponent output="false" extends="amazonAWS" >
	<cffunction name="init" access="public" returntype="amazonEC2" >
		<cfargument name="awsAccessKeyId" type="string" required="true"/>
		<cfargument name="secretAccessKey" type="string" required="true"/>
		<cfargument name="endPoint" type="string" required="true" default="ec2.amazonaws.com"/>
				
		<cfset variables.awsAccessKeyId = arguments.awsAccessKeyId />
		<cfset variables.secretAccesskey = arguments.secretAccessKey />
		<cfset variables.endPoint = arguments.endPoint />
		<cfset variables.requestMethod = 'no-header' />
		<cfset variables.version = '2012-03-01' />
		<cfset variables.protocol = 'https://' />
		<cfreturn this />		
	</cffunction>
	
	<cffunction name="CreateInternetGateway" access="public" returntype="Struct" >
		
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=CreateInternetGateway" />
		
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
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'internetGateway')[1] />
			<cfset stResponse.result = createInternetGatewayTypeObject(dataResult) />
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>	
	
	<cffunction name="DeleteInternetGateway" access="public" returntype="Struct" >
		<cfargument name="InternetGatewayId" type="string" required="true" >
		
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=DeleteInternetGateway&InternetGatewayId=" & arguments.InternetGatewayId />
		
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
	
	<cffunction name="DescribeAddresses" access="public" returntype="Struct" >
		<cfargument name="PublicIp" type="string" required="false" default="" >
		<cfargument name="AllocationId" type="string" required="false" default="" >
		<cfargument name="Filter" type="array" required="false" default="#[]#" >
		
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=DescribeAddresses" />
		
		<cfloop from="1" to="#listLen(arguments.PublicIp)#" index="i">
			<cfset body &= "&PublicIp." & i & "=" & trim(listgetat(arguments.PublicIp,i)) />
		</cfloop>
		
		<cfloop from="1" to="#listLen(arguments.AllocationId)#" index="j">
			<cfset body &= "&AllocationId." & j & "=" & trim(listgetat(arguments.PublicIp,j)) />
		</cfloop>	
		
		<cfloop from="1" to="#arrayLen(arguments.Filter)#" index="k">
			<cfset body &= "&Filter." & k & ".Name=" & arguments.Filter[k].name />
			<cfloop from="1" to="#listLen(arguments.Filter[k].value)#" index="m">
				<cfset body &= "&Filter." & k & ".Value." & m & "=" & trim(listgetat(arguments.Filter[k].value,m)) />
			</cfloop>	
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
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'addressesSet')[1].xmlChildren />    
    			<cfset stResponse.result = [] />	    
    	    
    	    		<cfloop array="#dataResult#" index="result">
				<cfset arrayAppend(stResponse.result,createDescribeAddressesResponseItemTypeObject(result)) />				
			</cfloop>
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="DescribeAvailabilityZones" access="public" returntype="Struct" >
		<cfargument name="ZoneName" type="string" required="false" default="" >
		<cfargument name="Filter" type="array" required="false" default="#[]#" >
		
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=DescribeAvailabilityZones" />
		
		<cfloop from="1" to="#listLen(arguments.ZoneName)#" index="i">
			<cfset body &= "&ZoneName." & i & "=" & trim(listgetat(arguments.ZoneName,i)) />
		</cfloop>
		
		<cfloop from="1" to="#arrayLen(arguments.Filter)#" index="k">
			<cfset body &= "&Filter." & k & ".Name=" & arguments.Filter[k].name />
			<cfloop from="1" to="#listLen(arguments.Filter[k].value)#" index="m">
				<cfset body &= "&Filter." & k & ".Value." & m & "=" & trim(listgetat(arguments.Filter[k].value,m)) />
			</cfloop>	
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
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'availabilityZoneInfo')[1].xmlChildren />    
    			<cfset stResponse.result = [] />	    
    	    
    	    		<cfloop array="#dataResult#" index="result">
				<cfset arrayAppend(stResponse.result,createAvailabilityZoneItemTypeObject(result)) />				
			</cfloop>
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>		
	
	<cffunction name="DescribeBundleTasks" access="public" returntype="Struct" >
		<cfargument name="BundleId" type="string" required="false" default="" >
		<cfargument name="Filter" type="array" required="false" default="#[]#" >
		
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=DescribeBundleTasks" />
		
		<cfloop from="1" to="#listLen(arguments.BundleId)#" index="i">
			<cfset body &= "&BundleId." & i & "=" & trim(listgetat(arguments.BundleId,i)) />
		</cfloop>
		
		<cfloop from="1" to="#arrayLen(arguments.Filter)#" index="k">
			<cfset body &= "&Filter." & k & ".Name=" & arguments.Filter[k].name />
			<cfloop from="1" to="#listLen(arguments.Filter[k].value)#" index="m">
				<cfset body &= "&Filter." & k & ".Value." & m & "=" & trim(listgetat(arguments.Filter[k].value,m)) />
			</cfloop>	
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
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'bundleInstanceTasksSet')[1].xmlChildren />    
    			<cfset stResponse.result = [] />	    
    	    
    	    		<cfloop array="#dataResult#" index="result">
				<cfset arrayAppend(stResponse.result,createBundleInstanceTaskTypeObject(result)) />				
			</cfloop>
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
		
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="DescribeConversionTasks" access="public" returntype="Struct" >
		<cfargument name="ConversionTaskId" type="string" required="false" default="" >
		
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=DescribeConversionTasks" />
		
		<cfloop from="1" to="#listLen(arguments.ConversionTaskId)#" index="i">
			<cfset body &= "&ConversionTaskId." & i & "=" & trim(listgetat(arguments.ConversionTaskId,i)) />
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
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'conversionTasks')[1].xmlChildren />    
    			<cfset stResponse.result = [] />	    
    	    
    	    		<cfloop array="#dataResult#" index="result">
				<cfset arrayAppend(stResponse.result,createConversionTaskTypeObject(result)) />				
			</cfloop>
		</cfif>	
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
		
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="DescribeCustomerGateways" access="public" returntype="Struct" >
		<cfargument name="CustomerGatewayId" type="string" required="false" default="" >
		<cfargument name="Filter" type="array" required="false" default="#[]#" >
		
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=DescribeCustomerGateways" />
		
		<cfloop from="1" to="#listLen(arguments.CustomerGatewayId)#" index="i">
			<cfset body &= "&CustomerGatewayId." & i & "=" & trim(listgetat(arguments.CustomerGatewayId,i)) />
		</cfloop>
		
		<cfloop from="1" to="#arrayLen(arguments.Filter)#" index="k">
			<cfset body &= "&Filter." & k & ".Name=" & arguments.Filter[k].name />
			<cfloop from="1" to="#listLen(arguments.Filter[k].value)#" index="m">
				<cfset body &= "&Filter." & k & ".Value." & m & "=" & trim(listgetat(arguments.Filter[k].value,m)) />
			</cfloop>	
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
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'customerGatewaySet')[1].xmlChildren />    
    			<cfset stResponse.result = [] />	    
    	    
    	    		<cfloop array="#dataResult#" index="result">
				<cfset arrayAppend(stResponse.result,createCustomerGatewayTypeObject(result)) />				
			</cfloop>
		</cfif>		
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
		
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="DescribeDhcpOptions" access="public" returntype="Struct" >
		<cfargument name="DhcpOptionsId" type="string" required="false" default="" >
		<cfargument name="Filter" type="array" required="false" default="#[]#" >
		
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=DescribeDhcpOptions" />
		
		<cfloop from="1" to="#listLen(arguments.DhcpOptionsId)#" index="i">
			<cfset body &= "&DhcpOptionsId." & i & "=" & trim(listgetat(arguments.DhcpOptionsId,i)) />
		</cfloop>
		
		<cfloop from="1" to="#arrayLen(arguments.Filter)#" index="k">
			<cfset body &= "&Filter." & k & ".Name=" & arguments.Filter[k].name />
			<cfloop from="1" to="#listLen(arguments.Filter[k].value)#" index="m">
				<cfset body &= "&Filter." & k & ".Value." & m & "=" & trim(listgetat(arguments.Filter[k].value,m)) />
			</cfloop>	
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
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'dhcpOptionsSet')[1].xmlChildren />    
    			<cfset stResponse.result = [] />	    
    	    
    	    		<cfloop array="#dataResult#" index="result">
				<cfset arrayAppend(stResponse.result,createDhcpOptionsTypeObject(result)) />				
			</cfloop>
		</cfif>	
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
		
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="DescribeImageAttribute" access="public" returntype="Struct" >
		<cfargument name="ImageId" type="string" required="false" default="" >
		<cfargument name="Attribute" type="string" required="false" default="" >
					
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=DescribeImageAttribute" />
		
		<cfif len(trim(arguments.ImageId))>
			<cfset body &= '&ImageId=' & arguments.ImageId />
		</cfif>	
		
		<cfif len(trim(arguments.Attribute))>
			<cfset body &= '&Attribute=' & arguments.Attribute />
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
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'DescribeImageAttributeResponse')[1] />    
    			<cfset stResponse.result = {
										imageId=getValue(dataResult,'imageId'),
										launchPermission=[],
										productCodes=[],
										kernel=getValue(dataResult,'kernel'),
										ramdisk=getValue(dataResult,'ramdisk'),
										description=getValue(dataResult,'description'),
										blockDeviceMapping=[]
									} />	    
    	    
    	    		<cfloop array="#dataResult.launchPermission.xmlChildren#" index="result">
				<cfset arrayAppend(stResponse.result.launchPermission,createLaunchPermissionItemTypeObject(result)) />				
			</cfloop>
			
			<cfloop array="#dataResult.productCodes.xmlChildren#" index="result">
				<cfset arrayAppend(stResponse.result.productCodes,createProductCodeItemTypeObject(result)) />				
			</cfloop>
			
			<cfloop array="#dataResult.blockDeviceMapping.xmlChildren#" index="result">
				<cfset arrayAppend(stResponse.result.blockDeviceMapping,createBlockDeviceMappingItemTypeObject(result)) />				
			</cfloop>
		</cfif>		
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
		
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="DescribeImages" access="public" returntype="Struct" >
		<cfargument name="ExecutableBy" type="string" required="false" default="" >
		<cfargument name="ImageId" type="string" required="false" default="" >
		<cfargument name="Owner" type="string" required="false" default="" >
		<cfargument name="Filter" type="array" required="false" default="#[]#" >
		
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=DescribeImages" />
		
		<cfloop from="1" to="#listLen(arguments.ExecutableBy)#" index="i">
			<cfset body &= "&ExecutableBy." & i & "=" & trim(listgetat(arguments.ExecutableBy,i)) />
		</cfloop>
		
		<cfloop from="1" to="#listLen(arguments.ImageId)#" index="j">
			<cfset body &= "&ImageId." & j & "=" & trim(listgetat(arguments.ImageId,j)) />
		</cfloop>
		
		<cfloop from="1" to="#listLen(arguments.Owner)#" index="m">
			<cfset body &= "&Owner." & m & "=" & trim(listgetat(arguments.Owner,m)) />
		</cfloop>
		
		<cfloop from="1" to="#arrayLen(arguments.Filter)#" index="k">
			<cfset body &= "&Filter." & k & ".Name=" & arguments.Filter[k].name />
			<cfloop from="1" to="#listLen(arguments.Filter[k].value)#" index="m">
				<cfset body &= "&Filter." & k & ".Value." & m & "=" & trim(listgetat(arguments.Filter[k].value,m)) />
			</cfloop>	
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
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'imagesSet')[1].xmlChildren />    
    			<cfset stResponse.result = [] />	    
    	    
    	    		<cfloop array="#dataResult#" index="result">
				<cfset arrayAppend(stResponse.result,createDescribeImagesResponseItemTypeObject(result)) />				
			</cfloop>
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
		
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="DescribeInstances" access="public" returntype="Struct" >
		<cfargument name="InstanceId" type="string" required="false" default="" >
		<cfargument name="Filter" type="array" required="false" default="#[]#" >
		
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=DescribeInstances" />
		
		<cfloop from="1" to="#listLen(arguments.InstanceId)#" index="i">
			<cfset body &= "&InstanceId." & i & "=" & trim(listgetat(arguments.InstanceId,i)) />
		</cfloop>
		
		<cfloop from="1" to="#arrayLen(arguments.Filter)#" index="k">
			<cfset body &= "&Filter." & k & ".Name=" & arguments.Filter[k].name />
			<cfloop from="1" to="#listLen(arguments.Filter[k].value)#" index="m">
				<cfset body &= "&Filter." & k & ".Value." & m & "=" & trim(listgetat(arguments.Filter[k].value,m)) />
			</cfloop>	
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
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'reservationSet')[1].xmlChildren />    
    			<cfset stResponse.result = [] />	    
    	    
    	    		<cfloop array="#dataResult#" index="result">
				<cfset arrayAppend(stResponse.result,createReservationInfoTypeObject(result)) />				
			</cfloop>	
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
		
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="DescribeInstanceAttribute" access="public" returntype="Struct" >
		<cfargument name="InstanceId" type="string" required="true">
		<cfargument name="Attribute" type="string" required="true">
		
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=DescribeInstanceAttribute&InstanceId=" & arguments.InstanceId & "&Attribute=" & arguments.Attribute />
	
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
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'reservationSet')[1] />    
    			<cfset stResponse.result = {
										instanceId=getValue(dataResult,'instanceId'),
										instanceType=getValue(dataResult,'instanceType'),
										kernel=getValue(dataResult,'kernel'),
										ramdisk=getValue(dataResult,'ramdisk'),
										userData=getValue(dataResult,'userData'),
										disableApiTermination=getValue(dataResult,'disableApiTermination'),
										instanceInitiatedShutdownBehavior=getValue(dataResult,'instanceInitiatedShutdownBehavior'),
										rootDeviceName=getValue(dataResult,'rootDeviceName'),
										blockDeviceMapping=[],
										sourceDestCheck=getValue(dataResult,'sourceDestCheck'),
										groupSet=[],
										productCodes=[]
									} />	    
    	    
    	    		<cfloop array="#dataResult.blockDeviceMapping.xmlChildren#" index="result">
				<cfset arrayAppend(stResponse.result.blockDeviceMapping,createInstanceBlockDeviceMappingResponseItemTypeObject(result)) />				
			</cfloop>
			
			<cfloop array="#dataResult.groupSet.xmlChildren#" index="result">
				<cfset arrayAppend(stResponse.result.groupSet,createGroupItemTypeObject(result)) />				
			</cfloop>
			
			<cfloop array="#dataResult.productCodes.xmlChildren#" index="result">
				<cfset arrayAppend(stResponse.result.productCodes,createProductCodesSetItemTypeObject(result)) />				
			</cfloop>	
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
		
		<cfreturn stResponse />
	</cffunction>
	

	<cffunction name="DescribeInstanceStatus" access="public" returntype="Struct" >
		<cfargument name="InstanceId" type="string" required="false" default="" >
		<cfargument name="MaxResults" type="numeric" required="false" default="" >
		<cfargument name="NextToken" type="string" required="false" default="" >
			
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=DescribeInstanceStatus"/>
		
		<cfif val(trim(arguments.InstanceId))>
			<cfset body &= "&InstanceId=" & trim(arguments.InstanceId) />
		</cfif>
		
		<cfif val(trim(arguments.MaxResults))>
			<cfset body &= "&MaxResults=" & trim(arguments.MaxResults) />
		</cfif>
		
		<cfif val(trim(arguments.NextToken))>
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
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'DescribeInstanceStatusResponse')[1] />    
    			<cfset stResponse.result = {
										InstanceStatusSet=getValue(dataResult,'InstanceStatusSet')
									} />	  
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>	
	
	<cffunction name="DescribeInternetGateways" access="public" returntype="Struct" >
		<cfargument name="UserName" type="string" required="true" >
		<cfargument name="something" type="string" required="false" default="" >
			
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=DescribeInternetGateways&UserName=" & trim(arguments.UserName)/>
		
		<cfif val(trim(arguments.something))>
			<cfset body &= "&something=" & trim(arguments.something) />
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
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'internetGatewaysSet')[1].xmlChildren />    
    			<cfset stResponse.result = [] />	    
    	    
    	    		<cfloop array="#dataResult#" index="result">
				<cfset arrayAppend(stResponse.result,createInternetGatewayTypeObject(result)) />				
			</cfloop>
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>	
	
	<cffunction name="AllocateAddress" access="public" returntype="Struct" >    
    		<cfargument name="Domain" type="string" required="false" default="" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=AllocateAddress"/>    
    		    
    		<cfif len(trim(arguments.Domain))>    
    			<cfset body &= "&Domain=" & trim(arguments.Domain) />    
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'AllocateAddressResponse')[1] />    
    			<cfset stResponse.result = {
							publicIp=getValue(dataResult,'publicIp'),
							domain=getValue(dataResult,'domain'),
							allocationId=getValue(dataResult,'allocationId')
						} />	    
    	    
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="AssociateAddress" access="public" returntype="Struct" >    
    		<cfargument name="PublicIp" type="string" required="false" default="" >    
    		<cfargument name="InstanceId" type="string" required="false" default="" >
    		<cfargument name="AllocationId" type="string" required="false" default="" >
		<cfargument name="NetworkInterfaceId" type="string" required="false" default="" >
					    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=AssociateAddress"/>    
    		    
    		<cfif len(trim(arguments.PublicIp))>    
    			<cfset body &= "&PublicIp=" & trim(arguments.PublicIp) />    
    		</cfif>
			
		<cfif len(trim(arguments.InstanceId))>    
    			<cfset body &= "&InstanceId=" & trim(arguments.InstanceId) />    
    		</cfif>	
			
		<cfif len(trim(arguments.AllocationId))>    
    			<cfset body &= "&AllocationId=" & trim(arguments.AllocationId) />    
    		</cfif>	
			
		<cfif len(trim(arguments.NetworkInterfaceId))>    
    			<cfset body &= "&NetworkInterfaceId=" & trim(arguments.NetworkInterfaceId) />    
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
    			<cfdump var="#xmlParse(rawResult.filecontent)#" /><cfabort>    
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'AssociateAddressResponse')[1] />    
    			<cfset stResponse.result = {associationId=getValue(dataResult,'associationId')} />	    
    	    
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="AssociateDhcpOptions" access="public" returntype="Struct" >    
    		<cfargument name="DhcpOptionsId" type="string" required="true" >    
    		<cfargument name="VpcId" type="string" required="true" >
    				    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=AssociateDhcpOptions&DhcpOptionsId=" & trim(arguments.DhcpOptionsId) & "&VpcId=" & trim(arguments.VpcId)/>    
    		    
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
    	
    	<cffunction name="AssociateRouteTable" access="public" returntype="Struct" >        
    		<cfargument name="RouteTableId" type="string" required="true" >        
    		<cfargument name="SubnetId" type="string" required="true" >        
    			        
    		<cfset var stResponse = createResponse() />        
    		<cfset var body = "Action=AssociateRouteTable&RouteTableId=" & trim(arguments.RouteTableId) & "&SubnetId=" & trim(arguments.SubnetId)/>        
    		        
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'AssociateRouteTableResponse')[1] />        
    			<cfset stResponse.result = {associationId=getValue(dataResult,'associationId')} />	        
    		</cfif>        
    	        
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />        
    					        
    		<cfreturn stResponse />        
    	</cffunction>

	<cffunction name="AttachInternetGateway" access="public" returntype="Struct" >    
    		<cfargument name="InternetGatewayId" type="string" required="true" >    
    		<cfargument name="VpcId" type="string" required="true" >     
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=AttachInternetGateway&InternetGatewayId=" & trim(arguments.InternetGatewayId) & "&VpcId=" & trim(arguments.VpcId)/>    
    		    
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
    	
    	<cffunction name="AttachNetworkInterface" access="public" returntype="Struct" >        
    		<cfargument name="NetworkInterfaceId" type="string" required="true" >
		<cfargument name="InstanceId" type="string" required="true" >   
		<cfargument name="DeviceIndex" type="string" required="true" >   		        
    			        
    		<cfset var stResponse = createResponse() />        
    		<cfset var body = "Action=AttachNetworkInterface&NetworkInterfaceId=" & trim(arguments.NetworkInterfaceId) & "&InstanceId=" & trim(arguments.InstanceId) & "&DeviceIndex=" & trim(arguments.DeviceIndex) />        
    		        
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'AttachNetworkInterfaceResponse')[1] />        
    			<cfset stResponse.result = {attachmentId=getValue(dataResult,'attachmentId')} />	        
    		</cfif>        
    	        
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />        
    					        
    		<cfreturn stResponse />        
    	</cffunction>

	<cffunction name="AttachVolume" access="public" returntype="Struct" >    
    		<cfargument name="VolumeId" type="string" required="true" >
		<cfargument name="InstanceId" type="string" required="true" >  
		<cfargument name="Device" type="string" required="true" >  		    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=AttachVolume&VolumeId=" & trim(arguments.VolumeId) & "&InstanceId=" & trim(arguments.InstanceId) & "&Device=" & trim(arguments.Device)/>    
    		    
    		<cfif len(trim(arguments.something))>    
    			<cfset body &= "&something=" & trim(arguments.something) />    
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'AttachVolumeResponse')[1] />    
    			<cfset stResponse.result = {
									volumeId=getValue(dataResult,'volumeId'),
									instanceId=getValue(dataResult,'instanceId'),
									device=getValue(dataResult,'device'),
									status=getValue(dataResult,'status'),
									attachTime=getValue(dataResult,'attachTime')
									} />	    
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="AttachVpnGateway" access="public" returntype="Struct" >    
    		<cfargument name="VpnGatewayId" type="string" required="true" >    
    		<cfargument name="VpcId" type="string" required="true" > 
					    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=AttachVpnGateway&VpnGatewayId=" & trim(arguments.VpnGatewayId) & "&VpcId=" & trim(arguments.VpcId)/>    
    		    
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'attachment')[1] />    
    			<cfset stResponse.result = createAttachmentTypeObject(dataResult) />	    
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="AuthorizeSecurityGroupEgress" access="public" returntype="Struct" >    
    		<cfargument name="GroupId" type="string" required="true" >
    		<cfargument name="IpPermissions" type="array" required="true" >    
					    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=AuthorizeSecurityGroupEgress&GroupId=" & trim(arguments.GroupId)/>    
    		    
    		<cfif len(trim(arguments.GroupName))>    
    			<cfset body &= "&GroupName=" & trim(arguments.GroupName) />    
    		</cfif>	    
    		
		<cfloop from="1" to="#arrayLen(arguments.IpPermissions)#" index="i">
			<cfset permission = arguments.IpPermissions[i] />
			
			<cfif StructKeyExists(permission,'IpProtocol')>
				<cfset body &= "&IpPermissions." & i & ".IpProtocol=" & trim(permission.IpProtocol) />  
			</cfif>	
			<cfif StructKeyExists(permission,'FromPort')>
				<cfset body &= "&IpPermissions." & i & ".FromPort=" & trim(permission.FromPort) />  
			</cfif>	
			<cfif StructKeyExists(permission,'ToPort')>
				<cfset body &= "&IpPermissions." & i & ".ToPort=" & trim(permission.ToPort) />  
			</cfif>	
			<cfif StructKeyExists(permission,'Groups')>
				<cfloop from="1" to="#arrayLen(permission.groups)#" index="j">
						<cfset group = permission.groups[j] />
						
						<cfif structKeyExists(group,'GroupId')>
							<cfset body &= "&IpPermissions." & i & ".Groups." & j & ".GroupId=" & trim(group.GroupId) />
						</cfif>
				</cfloop>		
			</cfif>	
			<cfif StructKeyExists(permission,'IpRanges')>
				<cfloop from="1" to="#arrayLen(permission.IpRanges)#" index="k">
					<cfset body &= "&IpPermissions." & i & ".IpRanges." & k & ".CidrIp=" & trim(permission.IpRanges[k]) />
				</cfloop>	
			</cfif>	
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
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="AuthorizeSecurityGroupIngress" access="public" returntype="Struct" >    
    		<cfargument name="IpPermissions" type="array" required="true" >    
    		<cfargument name="GroupName" type="string" required="false" default="" >    
					    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=AuthorizeSecurityGroupIngress&UserName=" & trim(arguments.UserName)/>    
    		    
    		<cfif len(trim(arguments.GroupName))>    
    			<cfset body &= "&GroupName=" & trim(arguments.GroupName) />    
    		</cfif>	    
    		
		<cfloop from="1" to="#arrayLen(arguments.IpPermissions)#" index="i">
			<cfset permission = arguments.IpPermissions[i] />
			
			<cfif StructKeyExists(permission,'IpProtocol')>
				<cfset body &= "&IpPermissions." & i & ".IpProtocol=" & trim(permission.IpProtocol) />  
			</cfif>	
			<cfif StructKeyExists(permission,'FromPort')>
				<cfset body &= "&IpPermissions." & i & ".FromPort=" & trim(permission.FromPort) />  
			</cfif>	
			<cfif StructKeyExists(permission,'ToPort')>
				<cfset body &= "&IpPermissions." & i & ".ToPort=" & trim(permission.ToPort) />  
			</cfif>	
			<cfif StructKeyExists(permission,'Groups')>
				<cfloop from="1" to="#arrayLen(permission.groups)#" index="j">
						<cfset group = permission.groups[j] />
						
						<cfif structKeyExists(group,'UserId')>
							<cfset body &= "&IpPermissions." & i & ".Groups." & j & ".UserId=" & trim(group.UserId) />
						</cfif>	
						
						<cfif structKeyExists(group,'GroupName')>
							<cfset body &= "&IpPermissions." & i & ".Groups." & j & ".GroupName=" & trim(group.GroupName) />
						</cfif>
						
						<cfif structKeyExists(group,'GroupId')>
							<cfset body &= "&IpPermissions." & i & ".Groups." & j & ".GroupId=" & trim(group.GroupId) />
						</cfif>
				</cfloop>		
			</cfif>	
			<cfif StructKeyExists(permission,'IpRanges')>
				<cfloop from="1" to="#arrayLen(permission.IpRanges)#" index="k">
					<cfset body &= "&IpPermissions." & i & ".IpRanges." & k & ".CidrIp=" & trim(permission.IpRanges[k]) />
				</cfloop>	
			</cfif>	
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
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<!---<cffunction name="AuthorizeSecurityGroupIngress" access="public" returntype="Struct" >    
    		<cfargument name="UserName" type="string" required="true" >    
    		<cfargument name="something" type="string" required="false" default="" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=AuthorizeSecurityGroupIngress&UserName=" & trim(arguments.UserName)/>    
    		    
    		<cfif len(trim(arguments.something))>    
    			<cfset body &= "&something=" & trim(arguments.something) />    
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
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>--->

	<cffunction name="BundleInstance" access="public" returntype="Struct" >    
    		<cfargument name="InstanceId" type="string" required="true" >    
    		<cfargument name="Bucket" type="string" required="true" >    
    		<cfargument name="Prefix" type="string" required="true" >     
    		<cfargument name="AWSAccessKeyId" type="string" required="true" >     
    		<cfargument name="UploadPolicy" type="string" required="true" >     
    		<cfargument name="UploadPolicySignature" type="string" required="true" >      
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=BundleInstance&InstanceId=" & trim(arguments.InstanceId) & "&Bucket=" & trim(arguments.Bucket) & "&Prefix=" & trim(arguments.Prefix) & "&AWSAccessKeyId=" & trim(arguments.AWSAccessKeyId) & "&UploadPolicy=" & trim(arguments.UploadPolicy) & "&UploadPolicySignature=" & trim(arguments.UploadPolicySignature) />    
    		    
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'BundleInstanceResponse')[1] />    
    			<cfset stResponse.result = createBundleInstanceTasktypeObject(dataResult) />	    
    	    
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="CancelBundleTask" access="public" returntype="Struct" >    
    		<cfargument name="BundleId" type="string" required="true" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=CancelBundleTask&BundleId=" & trim(arguments.BundleId)/>    
    		    
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'CancelBundleTaskResponse')[1] />    
    			<cfset stResponse.result = createBundleInstanceTaskTypeObject(dataResult) />	    
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="CancelConversionTask" access="public" returntype="Struct" >    
    		<cfargument name="ConversionTaskId" type="string" required="true" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=CancelConversionTask&ConversionTaskId=" & trim(arguments.ConversionTaskId)/>    
    		    
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

	<cffunction name="CancelSpotInstanceRequests" access="public" returntype="Struct" >    
    		<cfargument name="SpotInstanceRequestId" type="string" required="true" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=CancelSpotInstanceRequests"/>    
    		    
		<cfloop from="1" to="#listlen(arguments.SpotInstanceRequestId)#" index="i">
    			<cfset body &= "&SpotInstanceRequestId." & i & "=" & trim(listgetat(arguments.SpotInstanceRequestId,i)) />    
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'spotInstanceRequestSet')[1].xmlChildren />    
    			<cfset stResponse.result = [] />	    
    	    		
    	    		<cfloop array="#dataResult#" index="result">
					<cfset arrayAppend(stResponse.result,createCancelSpotInstanceRequestsResponseSetItemTypeObject(result)) />		
			</cfloop>				
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="ConfirmProductInstance" access="public" returntype="Struct" >    
    		<cfargument name="ProductCode" type="string" required="true" >    
    		<cfargument name="InstanceId" type="string" required="true" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=ConfirmProductInstance&ProductCode=" & trim(arguments.ProductCode) & "&InstanceId=" & trim(arguments.InstanceId)/>    
    		    
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
    			<cfset stResponse.result = getResultNodes(xmlParse(rawResult.filecontent),'ownerId')[1].xmlText />    
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="CreateCustomerGateway" access="public" returntype="Struct" >    
    		<cfargument name="Type" type="string" required="true" >    
    		<cfargument name="IpAddress" type="string" required="true" >    
    		<cfargument name="BgpAsn" type="string" required="true" >     
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=CreateCustomerGateway&Type=" & trim(arguments.Type) & "&IpAddress=" & trim(arguments.IpAddress) & "&BgpAsn=" & trim(arguments.BgpAsn)/>    
    		    
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'customerGateway')[1] />    
    			<cfset stResponse.result = createCustomerGatewayTypeObject(dataResult) />	    
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="CreateDhcpOptions" access="public" returntype="Struct" >    
    		<cfargument name="DhcpConfiguration" type="array" required="true" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=CreateDhcpOptions"/>    
    		    
    		<cfloop from="1" to="#arrayLen(arguments.DhcpConfiguration)#" index="i">
			<cfset body &= "&DhcpConfiguration." & i & ".Key=" & trim(arguments.SpotInstanceRequestId[i].DhcpConfiguration) /> 
			
			<cfloop from="1" to="#listlen(arguments.DhcpConfiguration.Value)#" index="j">
	    			<cfset body &= "&DhcpConfiguration." & i & ".Value." & j & "=" & trim(listgetat(arguments.DhcpConfiguration.Value,j)) />    
	    		</cfloop>
			   		
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'dhcpOptions')[1] />    
    			<cfset stResponse.result = createDhcpOptionsTypeObject(dataResult) />	    
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="CreateImage" access="public" returntype="Struct" >    
    		<cfargument name="InstanceId" type="string" required="true" >
		<cfargument name="Name" type="string" required="true" >	    
    		<cfargument name="Description" type="string" required="false" default="" >	    
    		<cfargument name="NoReboot" type="boolean" required="false" default="false" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=CreateImage&InstanceId=" & trim(arguments.InstanceId) & "&Name=" & trim(arguments.Name)/>    
    		    
    		<cfif len(trim(arguments.Description))>    
    			<cfset body &= "&Description=" & trim(arguments.Description) />    
    		</cfif>
    		
    		<cfif len(trim(arguments.NoReboot))>    
    			<cfset body &= "&NoReboot=" & trim(arguments.NoReboot) />    
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
    			<cfset stResponse.result = getResultNodes(xmlParse(rawResult.filecontent),'imageId')[1].xmlText />    
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="CreateKeyPair" access="public" returntype="Struct" >    
    		<cfargument name="KeyName" type="string" required="true" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=CreateKeyPair&KeyName=" & trim(arguments.KeyName)/>    
    		    
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'CreateKeyPairResponse')[1] />    
    			<cfset stResponse.result = {
					keyName=getValue(dataResult,'keyName'),
					keyFingerprint=getValue(dataResult,'keyFingerprint'),
					keyMaterial=getValue(dataResult,'keyMaterial')
				} />	    
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="CreateNetworkAcl" access="public" returntype="Struct" >    
    		<cfargument name="VpcId" type="string" required="true" >    
    		<cfargument name="something" type="string" required="false" default="" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=CreateNetworkAcl&VpcId=" & trim(arguments.VpcId)/>    
    		    
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'networkAcl')[1] />    
    			<cfset stResponse.result = createNetworkAclTypeObject(dataResult) />	    
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="CreateNetworkAclEntry" access="public" returntype="Struct" >    
    		<cfargument name="NetworkAclId" type="string" required="true" >
		<cfargument name="RuleNumber" type="string" required="true" >
		<cfargument name="Protocol" type="string" required="true" >
		<cfargument name="RuleAction" type="string" required="true" >
		<cfargument name="CidrBlock" type="string" required="true" >
    		<cfargument name="Egress" type="string" required="false" default="" >
    		<cfargument name="IcmpCode" type="string" required="false" default="" > 
    		<cfargument name="IcmpType" type="string" required="false" default="" > 
    		<cfargument name="PortRangeFrom" type="string" required="false" default="" > 
    		<cfargument name="PortRangeTo" type="string" required="false" default="" > 
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=CreateNetworkAclEntry&NetworkAclId=" & trim(arguments.NetworkAclId) & "&RuleNumber=" & trim(arguments.RuleNumber) & "&Protocol=" & trim(arguments.Protocol) & "&RuleAction=" & trim(arguments.RuleAction) & "&CidrBlock=" & trim(arguments.CidrBlock) />    
    		    
    		<cfif len(trim(arguments.Egress))>    
    			<cfset body &= "&Egress=" & trim(arguments.Egress) />    
    		</cfif>
    		
    		<cfif len(trim(arguments.IcmpCode))>    
    			<cfset body &= "&IcmpCode=" & trim(arguments.IcmpCode) />    
    		</cfif>	 
    		
    		<cfif len(trim(arguments.IcmpType))>    
    			<cfset body &= "&IcmpType=" & trim(arguments.IcmpType) />    
    		</cfif>	 
    		
    		<cfif len(trim(arguments.PortRangeFrom))>    
    			<cfset body &= "&PortRangeFrom=" & trim(arguments.PortRangeFrom) />    
    		</cfif>	 
    		
    		<cfif len(trim(arguments.PortRangeTo))>    
    			<cfset body &= "&PortRangeTo=" & trim(arguments.PortRangeTo) />    
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
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="CreateNetworkInterface" access="public" returntype="Struct" >    
    		<cfargument name="SubnetId" type="string" required="true" >    
    		<cfargument name="PrivateIpAddress" type="string" required="false" default="" >    
    		<cfargument name="Description" type="string" required="false" default="" >    
    		<cfargument name="SecurityGroupId" type="string" required="false" default="" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=CreateNetworkInterface&SubnetId=" & trim(arguments.SubnetId)/>    
    		    
    		<cfif len(trim(arguments.PrivateIpAddress))>    
    			<cfset body &= "&PrivateIpAddress=" & trim(arguments.PrivateIpAddress) />    
    		</cfif>	    
    		    
    		<cfif len(trim(arguments.Description))>    
    			<cfset body &= "&Description=" & trim(arguments.Description) />    
    		</cfif>	
    		
    		<cfloop from="1" to="#listlen(arguments.SecurityGroupId)#" index="i">
			<cfset body &= "&SecurityGroupId." & i & ".groupId=" & trim(listGetAt(arguments.SecurityGroupId,i)) /> 	
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'networkInterface')[1] />    
    			<cfset stResponse.result = createNetWorkInterfaceTypeObject(dataResult) />	    
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="CreatePlacementGroup" access="public" returntype="Struct" >    
    		<cfargument name="GroupName" type="string" required="true" >    
    		<cfargument name="Strategy" type="string" required="true" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=CreatePlacementGroup&GroupName=" & trim(arguments.GroupName) & "&Strategy=" & trim(arguments.Strategy)/>    
    		    
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

	<cffunction name="CreateRoute" access="public" returntype="Struct" >    
    		<cfargument name="RouteTableId" type="string" required="true" >
		<cfargument name="DestinationCidrBlock" type="string" required="true" >    
    		<cfargument name="GatewayId" type="string" required="false" default="" >   
    		<cfargument name="InstanceId" type="string" required="false" default="" >   
    		<cfargument name="NetworkInterfaceId" type="string" required="false" default="" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=CreateRoute&RouteTableId=" & trim(arguments.RouteTableId) & "&DestinationCidrBlock=" & trim(arguments.DestinationCidrBlock)/>    
    		    
    		<cfif len(trim(arguments.GatewayId))>    
    			<cfset body &= "&GatewayId=" & trim(arguments.GatewayId) />    
    		</cfif>
    		
    		<cfif len(trim(arguments.InstanceId))>    
    			<cfset body &= "&InstanceId=" & trim(arguments.InstanceId) />    
    		</cfif>	
    		
    		<cfif len(trim(arguments.NetworkInterfaceId))>    
    			<cfset body &= "&NetworkInterfaceId=" & trim(arguments.NetworkInterfaceId) />    
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
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="CreateRouteTable" access="public" returntype="Struct" >    
    		<cfargument name="VpcId" type="string" required="true" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=CreateRouteTable&VpcId=" & trim(arguments.VpcId)/>    
    		    
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'routeTable')[1] />    
    			<cfset stResponse.result = createRouteTableTypeObject(dataResult) />	    
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="CreateSecurityGroup" access="public" returntype="Struct" >    
    		<cfargument name="GroupName" type="string" required="true" >    
    		<cfargument name="GroupDescription" type="string" required="true" >    
    		<cfargument name="VpcId" type="string" required="false" default="" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=CreateSecurityGroup&GroupName=" & trim(arguments.GroupName) & "&GroupDescription=" & trim(arguments.GroupDescription)/>    
    		    
    		<cfif len(trim(arguments.VpcId))>    
    			<cfset body &= "&VpcId=" & trim(arguments.VpcId) />    
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
    			<cfset stResponse.result = getResultNodes(xmlParse(rawResult.filecontent),'groupId')[1].xmlText />    
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="CreateSnapshot" access="public" returntype="Struct" >    
    		<cfargument name="VolumeId" type="string" required="true" >    
    		<cfargument name="Description" type="string" required="false" default="" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=CreateSnapshot&VolumeId=" & trim(arguments.VolumeId)/>    
    		    
    		<cfif len(trim(arguments.Description))>    
    			<cfset body &= "&Description=" & trim(arguments.Description) />    
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'CreateSnapshotResponse')[1] />    
    			<cfset stResponse.result = {
							snapshotId=getValue(arguments.stXML,'snapshotId'),
							status=getValue(arguments.stXML,'status'),
							startTime=getValue(arguments.stXML,'startTime'),
							progress=getValue(arguments.stXML,'progress'),
							ownerId=getValue(arguments.stXML,'ownerId'),
							volumeSize=getValue(arguments.stXML,'volumeSize'),
							description=getValue(arguments.stXML,'description')
					} />	    
    	    
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="CreateSpotDatafeedSubscription" access="public" returntype="Struct" >    
    		<cfargument name="Bucket" type="string" required="true" >    
    		<cfargument name="Prefix" type="string" required="false" default="" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=CreateSpotDatafeedSubscription&Bucket=" & trim(arguments.Bucket)/>    
    		    
    		<cfif len(trim(arguments.Prefix))>    
    			<cfset body &= "&Prefix=" & trim(arguments.Prefix) />    
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'spotDatafeedSubscription')[1] />    
    			<cfset stResponse.result = createSpotDatafeedSubscriptionTypeObject(dataResult) />	    
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="CreateSubnet" access="public" returntype="Struct" >    
    		<cfargument name="VpcId" type="string" required="true" >    
    		<cfargument name="CidrBlock" type="string" required="true" >    
    		<cfargument name="AvailabilityZone" type="string" required="false" default="" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=CreateSubnet&VpcId=" & trim(arguments.VpcId) & "&CidrBlock=" & trim(arguments.CidrBlock)/>    
    		    
    		<cfif len(trim(arguments.AvailabilityZone))>    
    			<cfset body &= "&AvailabilityZone=" & trim(arguments.AvailabilityZone) />    
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'subnet')[1] />    
    			<cfset stResponse.result = createSubnetTypeObject(dataResult) />	    
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="CreateTags" access="public" returntype="Struct" >    
    		<cfargument name="ResourceId" type="string" required="true" >    
    		<cfargument name="Tag" type="array" required="true" > 
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=CreateTags"/>    
    		    
    		<cfloop from="1" to="#listLen(arguments.ResourceId)#" index="i">    
    			<cfset body &= "&ResourceId." & i & "=" & trim(listGetAt(arguments.ResourceId,i)) />    
    		</cfloop>
    		
    		<cfloop from="1" to="#arrayLen(arguments.tag)#" index="j">    
    			<cfset body &= "&Tag." & j & ".Key=" & trim(arguments.ResourceId[j].Key)
						& "&Tag." & j & ".Value=" & trim(arguments.ResourceId[j].Value) />    
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
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="CreateVolume" access="public" returntype="Struct" >    
    		<cfargument name="AvailabilityZone" type="string" required="true" >    
    		<cfargument name="Size" type="string" required="false" default="" >    
    		<cfargument name="SnapshotId" type="string" required="false" default="" >      
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=CreateVolume&AvailabilityZone=" & trim(arguments.AvailabilityZone)/>    
    		    
    		<cfif len(trim(arguments.Size))>    
    			<cfset body &= "&Size=" & trim(arguments.Size) />    
    		</cfif>
    		
    		<cfif len(trim(arguments.SnapshotId))>    
    			<cfset body &= "&SnapshotId=" & trim(arguments.SnapshotId) />    
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'CreateVolumeResponse')[1] />    
    			<cfset stResponse.result = {
							volumeId=getValue(arguments.stXML,'volumeId'),
							size=getValue(arguments.stXML,'size'),
							snapshotId=getValue(arguments.stXML,'snapshotId'),
							availabilityZone=getValue(arguments.stXML,'availabilityZone'),
							status=getValue(arguments.stXML,'status'),
							createTime=getValue(arguments.stXML,'createTime')
						} />	    
    	    
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="CreateVpc" access="public" returntype="Struct" >    
    		<cfargument name="CidrBlock" type="string" required="true" >    
    		<cfargument name="instanceTenancy" type="string" required="false" default="" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=CreateVpc&CidrBlock=" & trim(arguments.CidrBlock)/>    
    		    
    		<cfif len(trim(arguments.instanceTenancy))>    
    			<cfset body &= "&instanceTenancy=" & trim(arguments.instanceTenancy) />    
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'vpc')[1] />    
    			<cfset stResponse.result = createVpcTypeObject(dataResult) />	    
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="CreateVpnConnection" access="public" returntype="Struct" >    
    		<cfargument name="Type" type="string" required="true" >    
    		<cfargument name="CustomerGatewayId" type="string" required="true" >    
    		<cfargument name="VpnGatewayId" type="string" required="true" >    
    		<cfargument name="AvailabilityZone" type="string" required="false" default="" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=CreateVpnConnection&Type=" & trim(arguments.Type) & "&CustomerGatewayId=" & trim(arguments.CustomerGatewayId) & "&VpnGatewayId=" & trim(arguments.VpnGatewayId)/>    
    		    
    		<cfif len(trim(arguments.AvailabilityZone))>    
    			<cfset body &= "&AvailabilityZone=" & trim(arguments.AvailabilityZone) />    
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'vpnConnection')[1] />    
    			<cfset stResponse.result = createVpnConnectionTypeObject(dataResult) />	    
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="CreateVpnGateway" access="public" returntype="Struct" >    
    		<cfargument name="Type" type="string" required="true" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=CreateVpnGateway&Type=" & trim(arguments.Type)/>    
    		    
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'vpnGateway')[1] />    
    			<cfset stResponse.result = createVpnGatewayTypeObject(dataResult) />	    
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="DeleteCustomerGateway" access="public" returntype="Struct" >    
    		<cfargument name="CustomerGatewayId" type="string" required="true" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=DeleteCustomerGateway&CustomerGatewayId=" & trim(arguments.CustomerGatewayId)/>    
    		    
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

	<cffunction name="DeleteDhcpOptions" access="public" returntype="Struct" >    
    		<cfargument name="DhcpOptionsId" type="string" required="true" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=DeleteDhcpOptions&DhcpOptionsId=" & trim(arguments.DhcpOptionsId)/>    
    		    
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

	<cffunction name="DeleteKeyPair" access="public" returntype="Struct" >    
    		<cfargument name="KeyName" type="string" required="true" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=DeleteKeyPair&KeyName=" & trim(arguments.KeyName)/>    
    		    
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

	<cffunction name="DeleteNetworkAcl" access="public" returntype="Struct" >    
    		<cfargument name="NetworkAclId" type="string" required="true" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=DeleteNetworkAcl&NetworkAclId=" & trim(arguments.NetworkAclId)/>    
    		    
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


	<cffunction name="DeleteNetworkAclEntry" access="public" returntype="Struct" >    
    		<cfargument name="NetworkAclId" type="string" required="true" >    
    		<cfargument name="RuleNumber" type="string" required="true" >    
    		<cfargument name="Egress" type="string" required="false" default="" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=DeleteNetworkAclEntry&NetworkAclId=" & trim(arguments.NetworkAclId) & "&RuleNumber=" & trim(arguments.RuleNumber)/>    
    		    
    		<cfif len(trim(arguments.Egress))>    
    			<cfset body &= "&Egress=" & trim(arguments.Egress) />    
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
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="DeleteNetworkInterface" access="public" returntype="Struct" >    
    		<cfargument name="NetworkInterfaceId" type="string" required="true" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=DeleteNetworkInterface&NetworkInterfaceId=" & trim(arguments.NetworkInterfaceId)/>    
    		    
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

	<cffunction name="DeletePlacementGroup" access="public" returntype="Struct" >    
    		<cfargument name="GroupName" type="string" required="true" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=DeletePlacementGroup&GroupName=" & trim(arguments.GroupName)/>    
    		    
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

	<cffunction name="DeleteRoute" access="public" returntype="Struct" >    
    		<cfargument name="RouteTableId" type="string" required="true" >    
    		<cfargument name="DestinationCidrBlock" type="string" required="true" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=DeleteRoute&RouteTableId=" & trim(arguments.RouteTableId) & "&DestinationCidrBlock=" & trim(arguments.DestinationCidrBlock)/>    
    		    
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

	<cffunction name="DeleteRouteTable" access="public" returntype="Struct" >    
    		<cfargument name="RouteTableId" type="string" required="true" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=DeleteRouteTable&RouteTableId=" & trim(arguments.RouteTableId)/>    
    		    
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

	<cffunction name="DeleteSecurityGroup" access="public" returntype="Struct" >    
    		<cfargument name="GroupName" type="string" required="false" default="" >    
    		<cfargument name="GroupId" type="string" required="false" default="" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=DeleteSecurityGroup"/>    
    		    
    		<cfif len(trim(arguments.GroupName))>    
    			<cfset body &= "&GroupName=" & trim(arguments.GroupName) />    
    		</cfif>	
    		
    		<cfif len(trim(arguments.GroupId))>    
    			<cfset body &= "&GroupId=" & trim(arguments.GroupId) />    
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
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="DeleteSnapshot" access="public" returntype="Struct" >    
    		<cfargument name="SnapshotId" type="string" required="true" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=DeleteSnapshot&SnapshotId=" & trim(arguments.SnapshotId)/>    
    		    
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

	<cffunction name="DeleteSpotDatafeedSubscription" access="public" returntype="Struct" >    
    		    
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

	<cffunction name="DeleteSubnet" access="public" returntype="Struct" >    
    		<cfargument name="SubnetId" type="string" required="true" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=DeleteSubnet&SubnetId=" & trim(arguments.SubnetId)/>    
    		    
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

	<cffunction name="DeleteTags" access="public" returntype="Struct" >    
    		<cfargument name="ResourceId" type="string" required="true" >    
    		<cfargument name="Tag" type="array" required="true" > 
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=DeleteTags"/>    
    		    
    		<cfloop from="1" to="#listLen(arguments.ResourceId)#" index="i">    
    			<cfset body &= "&ResourceId." & i & "=" & trim(listGetAt(arguments.ResourceId,i)) />    
    		</cfloop>
    		
    		<cfloop from="1" to="#arrayLen(arguments.tag)#" index="j">    
    			<cfset body &= "&Tag." & j & ".Key=" & trim(arguments.ResourceId[j].Key)
						& "&Tag." & j & ".Value=" & trim(arguments.ResourceId[j].Value) />    
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
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="DeleteVolume" access="public" returntype="Struct" >    
    		<cfargument name="VolumeId" type="string" required="true" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=DeleteVolume&VolumeId=" & trim(arguments.VolumeId)/>    
    		    
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

	<cffunction name="DeleteVpc" access="public" returntype="Struct" >    
    		<cfargument name="VpcId" type="string" required="true" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=DeleteVpc&VpcId=" & trim(arguments.VpcId)/>    
    		    
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

	<cffunction name="DeleteVpnConnection" access="public" returntype="Struct" >    
    		<cfargument name="VpnConnectionId" type="string" required="true" >    
    		<cfargument name="something" type="string" required="false" default="" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=DeleteVpnConnection&VpnConnectionId=" & trim(arguments.VpnConnectionId)/>    
    		    
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

	<cffunction name="DeleteVpnGateway" access="public" returntype="Struct" >    
    		<cfargument name="VpnGatewayId" type="string" required="true" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=DeleteVpnGateway&VpnGatewayId=" & trim(arguments.VpnGatewayId)/>    
    		    
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

	<cffunction name="DeregisterImage" access="public" returntype="Struct" >    
    		<cfargument name="ImageId" type="string" required="true" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=DeregisterImage&ImageId=" & trim(arguments.ImageId)/>    
    		    
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

	<cffunction name="DescribeKeyPairs" access="public" returntype="Struct" >    
    		<cfargument name="KeyName" type="string" required="false" default="" >    
    		<cfargument name="Filter" type="array" required="false" default="" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=DescribeKeyPairs"/>    
    		    
    		<cfloop from="1" to="#listLen(arguments.keyName)#" index="i">
			<cfset body &= "&KeyName." & i & "=" & trim(listGetAt(arguments.keyName,i)) />		
		</cfloop>
		
		<cfloop from="1" to="#arrayLen(arguments.filter)#" index="j">
			<cfset body &= "&Filter." & j & ".Name=" & trim(arguments.filter[i].Name) />
			
			<cfloop from="1" to="#listLen(arguments.filter[i].Value)#" index="k">
				<cfset body &= "&Filter." & j & ".Value." & k & "=" & trim(listGetAt(arguments.filter[i].Value,k)) />	
			</cfloop>		
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
    		<cfelse>			    
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'keySet')[1].xmlChildren />    
    			<cfset stResponse.result = [] />	    
    	    
    	    		<cfloop array="#dataResult#" index="result">
				<cfset arrayAppend(stResponse.result,createDescribeKeyPairsResponseItemTypeObject(result)) />				
			</cfloop>				
							
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="DescribeNetworkAcls" access="public" returntype="Struct" >    
    		<cfargument name="NetworkAclId" type="string" required="false" default="" >    
    		<cfargument name="Filter" type="string" required="false" default="" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=DescribeNetworkAcls"/>    
    		    
    		<cfloop from="1" to="#listLen(arguments.NetworkAclId)#" index="i">
			<cfset body &= "&NetworkAclId." & i & "=" & trim(listGetAt(arguments.NetworkAclId,i)) />		
		</cfloop>
		
		<cfloop from="1" to="#arrayLen(arguments.filter)#" index="j">
			<cfset body &= "&Filter." & j & ".Name=" & trim(arguments.filter[i].Name) />
			
			<cfloop from="1" to="#listLen(arguments.filter[i].Value)#" index="k">
				<cfset body &= "&Filter." & j & ".Value." & k & "=" & trim(listGetAt(arguments.filter[i].Value,k)) />	
			</cfloop>		
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'networkAclSet')[1].xmlChildren />    
    			<cfset stResponse.result = [] />	    
    	    
    	    		<cfloop array="#dataResult#" index="result">
				<cfset arrayAppend(stResponse.result,createNetworkAclTypeObject(result)) />				
			</cfloop>  
    	    
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="DescribeNetworkInterfaceAttribute" access="public" returntype="Struct" >    
    		<cfargument name="NetworkInterfaceId" type="string" required="true" >    
    		<cfargument name="Description" type="string" required="false" default="" >    
    		<cfargument name="groupSet" type="string" required="false" default="" >    
    		<cfargument name="SourceDestCheck" type="string" required="false" default="" >    
    		<cfargument name="Attachment" type="string" required="false" default="" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=DescribeNetworkInterfaceAttribute&NetworkInterfaceId=" & trim(arguments.NetworkInterfaceId)/>    
    		    
    		<cfif len(trim(arguments.Description))>    
    			<cfset body &= "&Description=" & trim(arguments.Description) />    
    		</cfif>	    
    		
    		<cfif len(trim(arguments.groupSet))>    
    			<cfset body &= "&groupSet=" & trim(arguments.groupSet) />    
    		</cfif>	
    		
    		<cfif len(trim(arguments.SourceDestCheck))>    
    			<cfset body &= "&SourceDestCheck=" & trim(arguments.SourceDestCheck) />    
    		</cfif>	
    		
    		<cfif len(trim(arguments.Attachment))>    
    			<cfset body &= "&Attachment=" & trim(arguments.Attachment) />    
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
    			<cfset stResponse.result = getResultNodes(xmlParse(rawResult.filecontent),'networkInterfaceId')[1].xmlText />    
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="DescribeNetworkInterfaces" access="public" returntype="Struct" >    
    		<cfargument name="NetworkInterfaceIdSet" type="string" required="false" default="" >    
    		<cfargument name="Filter" type="string" required="false" default="" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=DescribeNetworkInterfaces"/>    
    		    
    		<cfloop from="1" to="#listLen(arguments.NetworkInterfaceIdSet)#" index="i">
			<cfset body &= "&NetworkInterfaceIdSet." & i & "=" & trim(listGetAt(arguments.NetworkInterfaceIdSet,i)) />		
		</cfloop>
		
		<cfloop from="1" to="#arrayLen(arguments.filter)#" index="j">
			<cfset body &= "&Filter." & j & ".Name=" & trim(arguments.filter[i].Name) />
			
			<cfloop from="1" to="#listLen(arguments.filter[i].Value)#" index="k">
				<cfset body &= "&Filter." & j & ".Value." & k & "=" & trim(listGetAt(arguments.filter[i].Value,k)) />	
			</cfloop>		
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
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="DescribePlacementGroups" access="public" returntype="Struct" >    
    		<cfargument name="GroupName" type="string" required="false" default="" >    
    		<cfargument name="Filter" type="string" required="false" default="" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=DescribePlacementGroups"/>    
    		    
    		<cfloop from="1" to="#listLen(arguments.GroupName)#" index="i">
			<cfset body &= "&GroupName." & i & "=" & trim(listGetAt(arguments.GroupName,i)) />		
		</cfloop>
		
		<cfloop from="1" to="#arrayLen(arguments.filter)#" index="j">
			<cfset body &= "&Filter." & j & ".Name=" & trim(arguments.filter[i].Name) />
			
			<cfloop from="1" to="#listLen(arguments.filter[i].Value)#" index="k">
				<cfset body &= "&Filter." & j & ".Value." & k & "=" & trim(listGetAt(arguments.filter[i].Value,k)) />	
			</cfloop>		
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
    			<cfdump var="#xmlParse(rawResult.filecontent)#" /><cfabort>    
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'placementGroupSet').xmlChildren />    
    			<cfset stResponse.result = [] />	    
    	    
    	    		<cfloop array="#dataResult#" index="result">
				<cfset arrayAppend(stResponse.result,createPlacementGroupInfoTypeObject(result)) />				
			</cfloop>      
    	    
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="DescribeRegions" access="public" returntype="Struct" >    
    		<cfargument name="RegionName" type="string" required="false" default="" >    
    		<cfargument name="Filter" type="string" required="false" default="" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=DescribeRegions"/>    
    		    
    		<cfloop from="1" to="#listLen(arguments.RegionName)#" index="i">
			<cfset body &= "&RegionName." & i & "=" & trim(listGetAt(arguments.RegionName,i)) />		
		</cfloop>
		
		<cfloop from="1" to="#arrayLen(arguments.filter)#" index="j">
			<cfset body &= "&Filter." & j & ".Name=" & trim(arguments.filter[i].Name) />
			
			<cfloop from="1" to="#listLen(arguments.filter[i].Value)#" index="k">
				<cfset body &= "&Filter." & j & ".Value." & k & "=" & trim(listGetAt(arguments.filter[i].Value,k)) />	
			</cfloop>		
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
    			<cfdump var="#xmlParse(rawResult.filecontent)#" /><cfabort>    
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'regionInfo')[1].xmlChildren />    
    			<cfset stResponse.result = [] />	    
    	    
    	    		<cfloop array="#dataResult#" index="result">
				<cfset arrayAppend(stResponse.result,createRegionItemTypeObject(result)) />				
			</cfloop>    
    	    
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="DescribeReservedInstances" access="public" returntype="Struct" >    
    		<cfargument name="ReservedInstancesId" type="string" required="false" default="" >    
    		<cfargument name="Filter" type="array" required="false" default="" >    
    		<cfargument name="offeringType" type="string" required="false" default="" >  
    				    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=DescribeReservedInstances"/>    
    		    
    		<cfloop from="1" to="#listLen(arguments.ReservedInstancesId)#" index="i">
			<cfset body &= "&ReservedInstancesId." & i & "=" & trim(listGetAt(arguments.ReservedInstancesId,i)) />		
		</cfloop>
		
		<cfloop from="1" to="#arrayLen(arguments.filter)#" index="j">
			<cfset body &= "&Filter." & j & ".Name=" & trim(arguments.filter[i].Name) />
			
			<cfloop from="1" to="#listLen(arguments.filter[i].Value)#" index="k">
				<cfset body &= "&Filter." & j & ".Value." & k & "=" & trim(listGetAt(arguments.filter[i].Value,k)) />	
			</cfloop>		
		</cfloop> 
		
		<cfif len(trim(arguments.offeringType))>        
    			<cfset body &= "&offeringType=" & trim(arguments.offeringType) />        
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
    			<cfdump var="#xmlParse(rawResult.filecontent)#" /><cfabort>    
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'reservedInstancesSet').xmlChildren />    
    			<cfset stResponse.result = [] />	    
    	    
    	    		<cfloop array="#dataResult#" index="result">
				<cfset arrayAppend(stResponse.result,createDescribeReservedInstancesResponseSetItemTypeObject(result)) />				
			</cfloop> 	    
    	    
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>
    	
	<cffunction name="DescribeReservedInstancesOfferings" access="public" returntype="Struct" >    
    		<cfargument name="ReservedInstancesOfferingId" type="string" required="false" default="" >    
    		<cfargument name="InstanceType" type="string" required="false" default="" >    
    		<cfargument name="AvailabilityZone" type="string" required="false" default="" >    
    		<cfargument name="ProductDescription" type="string" required="false" default="" >    
    		<cfargument name="Filter" type="array" required="false" default="" >    
    		<cfargument name="instanceTenancy" type="string" required="false" default="" >
    		<cfargument name="offeringType" type="string" required="false" default="" >
					    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=DescribeReservedInstancesOfferings"/>    
    		    
    		<cfloop from="1" to="#listLen(arguments.ReservedInstancesOfferingId)#" index="i">
			<cfset body &= "&ReservedInstancesOfferingId." & i & "=" & trim(listGetAt(arguments.ReservedInstancesOfferingId,i)) />		
		</cfloop>
		
		<cfloop from="1" to="#arrayLen(arguments.filter)#" index="j">
			<cfset body &= "&Filter." & j & ".Name=" & trim(arguments.filter[i].Name) />
			
			<cfloop from="1" to="#listLen(arguments.filter[i].Value)#" index="k">
				<cfset body &= "&Filter." & j & ".Value." & k & "=" & trim(listGetAt(arguments.filter[i].Value,k)) />	
			</cfloop>		
		</cfloop> 
		
		<cfif len(trim(arguments.InstanceType))>        
    			<cfset body &= "&InstanceType=" & trim(arguments.InstanceType) />        
    		</cfif>
    		
    		<cfif len(trim(arguments.AvailabilityZone))>        
    			<cfset body &= "&AvailabilityZone=" & trim(arguments.AvailabilityZone) />        
    		</cfif>    
    		
    		<cfif len(trim(arguments.ProductDescription))>        
    			<cfset body &= "&ProductDescription=" & trim(arguments.ProductDescription) />        
    		</cfif>    
    		
    		<cfif len(trim(arguments.instanceTenancy))>        
    			<cfset body &= "&instanceTenancy=" & trim(arguments.instanceTenancy) />        
    		</cfif>    
    		
    		<cfif len(trim(arguments.offeringType))>        
    			<cfset body &= "&offeringType=" & trim(arguments.offeringType) />        
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'reservedInstancesOfferingsSet').xmlChildren />    
    			<cfset stResponse.result = [] />	    
    	    
    	    		<cfloop array="#dataResult#" index="result">
				<cfset arrayAppend(stResponse.result,createDescribeReservedInstancesOfferingsResponseSetItemTypeObject(result)) />				
			</cfloop>    
    	    
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="DescribeRouteTables" access="public" returntype="Struct" >    
    		<cfargument name="RouteTableId" type="string" required="false" default="" >    
    		<cfargument name="Filter" type="array" required="false" default="" >    
    				    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=DescribeRouteTables"/>    
    		    
    		<cfloop from="1" to="#listLen(arguments.RouteTableId)#" index="i">
			<cfset body &= "&RouteTableId." & i & "=" & trim(listGetAt(arguments.RouteTableId,i)) />		
		</cfloop>
		
		<cfloop from="1" to="#arrayLen(arguments.filter)#" index="j">
			<cfset body &= "&Filter." & j & ".Name=" & trim(arguments.filter[i].Name) />
			
			<cfloop from="1" to="#listLen(arguments.filter[i].Value)#" index="k">
				<cfset body &= "&Filter." & j & ".Value." & k & "=" & trim(listGetAt(arguments.filter[i].Value,k)) />	
			</cfloop>		
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
    			<cfdump var="#xmlParse(rawResult.filecontent)#" /><cfabort>    
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'routeTableSet').xmlChildren />    
    			<cfset stResponse.result = [] />	    
    	    
    	    		<cfloop array="#dataResult#" index="result">
				<cfset arrayAppend(stResponse.result,createRouteTableTypeObject(result)) />				
			</cfloop>    	    
    	    
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="DescribeSecurityGroups" access="public" returntype="Struct" >    
    		<cfargument name="GroupName" type="string" required="false" default="" >    
    		<cfargument name="Filter" type="array" required="false" default="" >    
    		<cfargument name="GroupId" type="string" required="false" default="" >  
    				    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=DescribeSecurityGroups"/>    
    		    
    		<cfloop from="1" to="#listLen(arguments.ReservedInstancesId)#" index="i">
			<cfset body &= "&ReservedInstancesId." & i & "=" & trim(listGetAt(arguments.ReservedInstancesId,i)) />		
		</cfloop>
		
		<cfloop from="1" to="#arrayLen(arguments.filter)#" index="j">
			<cfset body &= "&Filter." & j & ".Name=" & trim(arguments.filter[i].Name) />
			
			<cfloop from="1" to="#listLen(arguments.filter[i].Value)#" index="k">
				<cfset body &= "&Filter." & j & ".Value." & k & "=" & trim(listGetAt(arguments.filter[i].Value,k)) />	
			</cfloop>		
		</cfloop> 
		
		<cfloop from="1" to="#listLen(arguments.GroupId)#" index="m">
			<cfset body &= "&GroupId." & m & "=" & trim(listGetAt(arguments.GroupId,m)) />		
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'securityGroupInfo').xmlChildren />    
    			<cfset stResponse.result = [] />	    
    	    
    	    		<cfloop array="#dataResult#" index="result">
				<cfset arrayAppend(stResponse.result,createSecurityGroupItemTypeObject(result)) />				
			</cfloop>	    
    	    
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="DescribeSnapshotAttribute" access="public" returntype="Struct" >    
    		<cfargument name="SnapshotId" type="string" required="true" >    
    		<cfargument name="Attribute" type="string" required="true" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=DescribeSnapshotAttribute&SnapshotId=" & trim(arguments.SnapshotId) & "&Attribute=" & trim(arguments.Attribute)/>    
    		    
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'DescribeSnapshotAttributeResponse')[1] />    
    			<cfset stResponse.result = {
						snapshotId=getValue(dataResult,'snapshotId'),
						createVolumePermission=[],
						productCodes=[]
				} />	  
				
			<cfloop array="#dataResult.createVolumePermission.xmlChildren#" index="permission">
				<cfset arrayAppend(stResponse.result.createVolumePermission,createCreateVolumePermissionItemTypeObject(permission)) />	
			</cfloop>
			
			<cfloop array="#dataResult.productCodes.xmlChildren#" index="product">
				<cfset arrayAppend(stResponse.result.productCodes,createProductCodesSetItemTypeObject(product)) />	
			</cfloop>			  
    	    
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="DescribeSnapshots" access="public" returntype="Struct" >    
    		<cfargument name="SnapshotId" type="string" required="false" default="" >    
    		<cfargument name="Filter" type="array" required="false" default="" >    
    		<cfargument name="Owner" type="string" required="false" default="" >  
    		<cfargument name="RestorableBy" type="string" required="false" default="" >  
    				    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=DescribeSnapshots"/>    
    		    
    		<cfloop from="1" to="#listLen(arguments.SnapshotId)#" index="i">
			<cfset body &= "&SnapshotId." & i & "=" & trim(listGetAt(arguments.SnapshotId,i)) />		
		</cfloop>
		
		<cfloop from="1" to="#arrayLen(arguments.filter)#" index="j">
			<cfset body &= "&Filter." & j & ".Name=" & trim(arguments.filter[i].Name) />
			
			<cfloop from="1" to="#listLen(arguments.filter[i].Value)#" index="k">
				<cfset body &= "&Filter." & j & ".Value." & k & "=" & trim(listGetAt(arguments.filter[i].Value,k)) />	
			</cfloop>		
		</cfloop> 
		
		<cfloop from="1" to="#listLen(arguments.Owner)#" index="m">
			<cfset body &= "&Owner." & m & "=" & trim(listGetAt(arguments.Owner,m)) />		
		</cfloop>
		
		<cfloop from="1" to="#listLen(arguments.RestorableBy)#" index="n">
			<cfset body &= "&RestorableBy." & n & "=" & trim(listGetAt(arguments.RestorableBy,n)) />		
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'snapshotSet')[1].xmlChildren />    
    			<cfset stResponse.result = [] />	    
    	    
    	    		<cfloop array="#dataResult#" index="result">
				<cfset arrayAppend(stResponse.result,createDescribeSnapshotsSetItemResponseTypeObject(result)) />				
			</cfloop>	    
    	    
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="DescribeSpotDatafeedSubscription" access="public" returntype="Struct" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=DescribeSpotDatafeedSubscription"/>    
    		    
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'spotDatafeedSubscription')[1] />    
    			<cfset stResponse.result = createSpotDatafeedSubscriptionTypeObject(dataResult) />	    
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="DescribeSpotInstanceRequests" access="public" returntype="Struct" >    
    		<cfargument name="SpotInstanceRequestId" type="string" required="false" default="" >    
    		<cfargument name="Filter" type="array" required="false" default="" >    
    				    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=DescribeSpotInstanceRequests"/>    
    		    
    		<cfloop from="1" to="#listLen(arguments.SpotInstanceRequestId)#" index="i">
			<cfset body &= "&SpotInstanceRequestId." & i & "=" & trim(listGetAt(arguments.SpotInstanceRequestId,i)) />		
		</cfloop>
		
		<cfloop from="1" to="#arrayLen(arguments.filter)#" index="j">
			<cfset body &= "&Filter." & j & ".Name=" & trim(arguments.filter[i].Name) />
			
			<cfloop from="1" to="#listLen(arguments.filter[i].Value)#" index="k">
				<cfset body &= "&Filter." & j & ".Value." & k & "=" & trim(listGetAt(arguments.filter[i].Value,k)) />	
			</cfloop>		
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'spotInstanceRequestSet') />    
    			<cfset stResponse.result = {spotInstanceRequestSet=[],networkInterfaceId=[]} />	    
    	    
    	    		<cfloop array="#dataResult.spotInstanceRequestSet.xmlChildren#" index="result">
				<cfset arrayAppend(stResponse.result.spotInstanceRequestSet,createSpotInstanceRequestSetItemTypeObject(result.item)) />				
			</cfloop>
			
			<cfloop array="#dataResult.networkInterfaceId.xmlChildren#" index="result">
				<cfset arrayAppend(stResponse.result.networkInterfaceId,createInstanceNetworkInterfaceSetTypeObject(result.item)) />				
			</cfloop>
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="DescribeSpotPriceHistory" access="public" returntype="Struct" >    
    		<cfargument name="StartTime" type="string" required="false" default="" >    
    		<cfargument name="EndTime" type="string" required="false" default="" >    
    		<cfargument name="InstanceType" type="string" required="false" default="" >    
    		<cfargument name="ProductDescription" type="string" required="false" default="" >    
    		<cfargument name="Filter" type="array" required="false" default="" >    
    		<cfargument name="AvailabilityZone" type="string" required="false" default="" >    
    		<cfargument name="MaxResults" type="string" required="false" default="" >    
    		<cfargument name="NextToken" type="string" required="false" default="" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=DescribeSpotPriceHistory&UserName=" & trim(arguments.UserName)/>    
    		    
    		 <cfloop from="1" to="#listLen(arguments.InstanceType)#" index="i">
			<cfset body &= "&InstanceType." & i & "=" & trim(listGetAt(arguments.InstanceType,i)) />		
		</cfloop>
		
		<cfloop from="1" to="#listLen(arguments.ProductDescription)#" index="m">
			<cfset body &= "&ProductDescription." & m & "=" & trim(listGetAt(arguments.ProductDescription,m)) />		
		</cfloop>
		
		
		<cfloop from="1" to="#arrayLen(arguments.filter)#" index="j">
			<cfset body &= "&Filter." & j & ".Name=" & trim(arguments.filter[i].Name) />
			
			<cfloop from="1" to="#listLen(arguments.filter[i].Value)#" index="k">
				<cfset body &= "&Filter." & j & ".Value." & k & "=" & trim(listGetAt(arguments.filter[i].Value,k)) />	
			</cfloop>		
		</cfloop> 
		   
    		<cfif len(trim(arguments.AvailabilityZone))>    
    			<cfset body &= "&AvailabilityZone=" & trim(arguments.AvailabilityZone) />    
    		</cfif>	
    		
    		<cfif len(trim(arguments.MaxResults))>    
    			<cfset body &= "&MaxResults=" & trim(arguments.MaxResults) />    
    		</cfif>
    		
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'spotPriceHistorySet')[1].xmlChildren />    
    			<cfset stResponse.result = [] />
				
				
			<cfloop array="#dataResult#" index="result">
					<cfset arrayAppend(stResponse.result,createSpotPriceHistorySetItemTypeObject(result)) />
			</cfloop>				    
    	    
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="DescribeSubnets" access="public" returntype="Struct" >    
    		<cfargument name="SubnetId" type="string" required="false" default="" >    
    		<cfargument name="Filter" type="array" required="false" default="" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=DescribeSubnets"/>    
    		    
    		<cfloop from="1" to="#listLen(arguments.SubnetId)#" index="i">
			<cfset body &= "&SubnetId." & i & "=" & trim(listGetAt(arguments.SubnetId,i)) />		
		</cfloop>
		
		<cfloop from="1" to="#arrayLen(arguments.filter)#" index="j">
			<cfset body &= "&Filter." & j & ".Name=" & trim(arguments.filter[i].Name) />
			
			<cfloop from="1" to="#listLen(arguments.filter[i].Value)#" index="k">
				<cfset body &= "&Filter." & j & ".Value." & k & "=" & trim(listGetAt(arguments.filter[i].Value,k)) />	
			</cfloop>		
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'subnetSet').xmlChildren />    
    			<cfset stResponse.result = [] />	    
    	    
    	    		<cfloop array="#dataResult#" index="result">
				<cfset arrayAppend(stResponse.result,createSubnetTypeObject(result)) />				
			</cfloop>				
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="DescribeTags" access="public" returntype="Struct" >    
    		<cfargument name="filter" type="array" required="false" default="" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=DescribeTags"/>    
    		    
    		<cfloop from="1" to="#arrayLen(arguments.filter)#" index="j">
			<cfset body &= "&Filter." & j & ".Name=" & trim(arguments.filter[i].Name) />
			
			<cfloop from="1" to="#listLen(arguments.filter[i].Value)#" index="k">
				<cfset body &= "&Filter." & j & ".Value." & k & "=" & trim(listGetAt(arguments.filter[i].Value,k)) />	
			</cfloop>		
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'tagSet')[1].xmlChildren />    
    			<cfset stResponse.result = [] />	    
    	    
    	    		<cfloop array="#dataResult#" index="result">
				<cfset arrayAppend(stResponse.result,createTagSetItemTypeObject(result)) />				
			</cfloop>    
    	    
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="DescribeVolumes" access="public" returntype="Struct" >    
    		<cfargument name="VolumeId" type="string" required="false" default="" >    
    		<cfargument name="Filter" type="array" required="false" default="" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=DescribeVolumes"/>    
    		    
    		<cfloop from="1" to="#listLen(arguments.VolumeId)#" index="i">
			<cfset body &= "&VolumeId." & i & "=" & trim(listGetAt(arguments.VolumeId,i)) />		
		</cfloop>
		
		<cfloop from="1" to="#arrayLen(arguments.filter)#" index="j">
			<cfset body &= "&Filter." & j & ".Name=" & trim(arguments.filter[i].Name) />
			
			<cfloop from="1" to="#listLen(arguments.filter[i].Value)#" index="k">
				<cfset body &= "&Filter." & j & ".Value." & k & "=" & trim(listGetAt(arguments.filter[i].Value,k)) />	
			</cfloop>		
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'volumeSet')[1].xmlChildren />    
    			<cfset stResponse.result = [] />	    
    	    
    	    		<cfloop array="#dataResult#" index="result">
				<cfset arrayAppend(stResponse.result,createDescribeVolumesSetItemResponseTypeObject(result)) />				
			</cfloop>	    
    	    
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="DescribeVolumeAttribute" access="public" returntype="Struct" >    
    		<cfargument name="VolumeId" type="string" required="true" >
		<cfargument name="Attribute" type="string" required="true" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=DescribeVolumeAttribute&VolumeId=" & trim(arguments.VolumeId) & "&VolumeId=" & trim(arguments.VolumeId)/>    
    		    
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'DescribeVolumeAttributeResponse')[1] />    
    			<cfset stResponse.result = {
							volumeId=getValue(dataResult,'volumeId'),
							autoEnableIO=getValue(dataResult,'autoEnableIO'),
							productCodes=[]
						} />	  
						  
    	    		<cfloop array="#dataResult.productCodes.xmlChildren#" index="result">
				<cfset arrayAppend(stResponse.result,createProductCodesSetItemTypeObject(result)) />				
			</cfloop>
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="DescribeVolumeStatus" access="public" returntype="Struct" >    
    		<cfargument name="VolumeId" type="string" required="false" default="" >    
    		<cfargument name="Filter" type="array" required="false" default="" >    
    		<cfargument name="MaxResults" type="string" required="false" default="" >    
    		<cfargument name="NextToken" type="string" required="false" default="" > 
			 	    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=DescribeVolumeStatus"/>    
    		    
    		<cfloop from="1" to="#listLen(arguments.VolumeId)#" index="i">
			<cfset body &= "&VolumeId." & i & "=" & trim(listGetAt(arguments.VolumeId,i)) />		
		</cfloop>
		
		<cfloop from="1" to="#arrayLen(arguments.filter)#" index="j">
			<cfset body &= "&Filter." & j & ".Name=" & trim(arguments.filter[i].Name) />
			
			<cfloop from="1" to="#listLen(arguments.filter[i].Value)#" index="k">
				<cfset body &= "&Filter." & j & ".Value." & k & "=" & trim(listGetAt(arguments.filter[i].Value,k)) />	
			</cfloop>		
		</cfloop>	
		    
    		<cfif len(trim(arguments.MaxResults))>    
    			<cfset body &= "&MaxResults=" & trim(arguments.MaxResults) />    
    		</cfif>	    
    		
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'volumeStatusSet')[1].xmlChildren />    
    			<cfset stResponse.result = [] />	    
    	    
    	    		<cfloop array="#dataResult#" index="result">
				<cfset arrayAppend(stResponse.result,createVolumeStatusItemTypeObject(result)) />				
			</cfloop>
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="DescribeVpcs" access="public" returntype="Struct" >    
    		<cfargument name="VpcId" type="string" required="false" default="" >    
    		<cfargument name="Filter" type="array" required="false" default="" >    
			 	    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=DescribeVpcs"/>    
    		    
    		<cfloop from="1" to="#listLen(arguments.VpcId)#" index="i">
			<cfset body &= "&VpcId." & i & "=" & trim(listGetAt(arguments.VpcId,i)) />		
		</cfloop>
		
		<cfloop from="1" to="#arrayLen(arguments.filter)#" index="j">
			<cfset body &= "&Filter." & j & ".Name=" & trim(arguments.filter[i].Name) />
			
			<cfloop from="1" to="#listLen(arguments.filter[i].Value)#" index="k">
				<cfset body &= "&Filter." & j & ".Value." & k & "=" & trim(listGetAt(arguments.filter[i].Value,k)) />	
			</cfloop>		
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
    			<cfdump var="#xmlParse(rawResult.filecontent)#" /><cfabort>    
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'vpcSet')[1].xmlChildren />    
    			<cfset stResponse.result = [] />	    
    	    
    	    		<cfloop array="#dataResult#" index="result">
				<cfset arrayAppend(stResponse.result,createVpcTypeObject(result)) />				
			</cfloop>
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="DescribeVpnConnections" access="public" returntype="Struct" >    
    		<cfargument name="VpnConnectionId" type="string" required="false" default="" >    
    		<cfargument name="Filter" type="array" required="false" default="" >    
			 	    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=DescribeVpnConnections"/>    
    		    
    		<cfloop from="1" to="#listLen(arguments.VpnConnectionId)#" index="i">
			<cfset body &= "&VpnConnectionId." & i & "=" & trim(listGetAt(arguments.VpnConnectionId,i)) />		
		</cfloop>
		
		<cfloop from="1" to="#arrayLen(arguments.filter)#" index="j">
			<cfset body &= "&Filter." & j & ".Name=" & trim(arguments.filter[i].Name) />
			
			<cfloop from="1" to="#listLen(arguments.filter[i].Value)#" index="k">
				<cfset body &= "&Filter." & j & ".Value." & k & "=" & trim(listGetAt(arguments.filter[i].Value,k)) />	
			</cfloop>		
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'vpnConnectionSet')[1].xmlChildren />    
    			<cfset stResponse.result = [] />	    
    	    
    	    		<cfloop array="#dataResult#" index="result">
				<cfset arrayAppend(stResponse.result,createVpnConnectionTypeObject(result)) />				
			</cfloop>
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="DescribeVpnGateways" access="public" returntype="Struct" >    
    		<cfargument name="VpnGatewayId" type="string" required="false" default="" >    
    		<cfargument name="Filter" type="array" required="false" default="" >    
			 	    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=DescribeVpnGateways"/>    
    		    
    		<cfloop from="1" to="#listLen(arguments.VpnGatewayId)#" index="i">
			<cfset body &= "&VpnGatewayId." & i & "=" & trim(listGetAt(arguments.VpnGatewayId,i)) />		
		</cfloop>
		
		<cfloop from="1" to="#arrayLen(arguments.filter)#" index="j">
			<cfset body &= "&Filter." & j & ".Name=" & trim(arguments.filter[i].Name) />
			
			<cfloop from="1" to="#listLen(arguments.filter[i].Value)#" index="k">
				<cfset body &= "&Filter." & j & ".Value." & k & "=" & trim(listGetAt(arguments.filter[i].Value,k)) />	
			</cfloop>		
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'vpnGatewaySet')[1].xmlChildren />    
    			<cfset stResponse.result = [] />	    
    	    
    	    		<cfloop array="#dataResult#" index="result">
				<cfset arrayAppend(stResponse.result,createVpnGatewayTypeObject(result)) />				
			</cfloop>
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="DetachInternetGateway" access="public" returntype="Struct" >    
    		<cfargument name="InternetGatewayId" type="string" required="true" >    
    		<cfargument name="VpcId" type="string" required="true" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=DetachInternetGateway&InternetGatewayId=" & trim(arguments.InternetGatewayId) & "&InternetGatewayId=" & trim(arguments.InternetGatewayId)/>    
    		    
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

	<cffunction name="DetachNetworkInterface" access="public" returntype="Struct" >    
    		<cfargument name="AttachmentId" type="string" required="true" >    
    		<cfargument name="Force" type="string" required="false" default="" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=DetachNetworkInterface&AttachmentId=" & trim(arguments.AttachmentId)/>    
    		    
    		<cfif len(trim(arguments.Force))>    
    			<cfset body &= "&Force=" & trim(arguments.Force) />    
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
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>


	<cffunction name="DetachVolume" access="public" returntype="Struct" >    
    		<cfargument name="VolumeId" type="string" required="true" >    
    		<cfargument name="InstanceId" type="string" required="false" default="" >    
    		<cfargument name="Device" type="string" required="false" default="" >    
    		<cfargument name="Force" type="string" required="false" default="" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=DetachVolume&VolumeId=" & trim(arguments.VolumeId)/>    
    		    
    		<cfif len(trim(arguments.InstanceId))>    
    			<cfset body &= "&InstanceId=" & trim(arguments.InstanceId) />    
    		</cfif>
    		
    		<cfif len(trim(arguments.Device))>    
    			<cfset body &= "&Device=" & trim(arguments.Device) />    
    		</cfif>
    		
    		<cfif len(trim(arguments.Device))>    
    			<cfset body &= "&Device=" & trim(arguments.Device) />    
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'DetachVolumeResponse')[1] />    
    			<cfset stResponse.result = {
									volumeId=getValue(volumeId,'volumeId'),
									instanceId=getValue(volumeId,'instanceId'),
									device=getValue(volumeId,'device'),
									status=getValue(volumeId,'status'),
									attachTime=getValue(volumeId,'attachTime')
									} />	    
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="DetachVpnGateway" access="public" returntype="Struct" >    
    		<cfargument name="VpnGatewayId" type="string" required="true" >    
    		<cfargument name="VpcId" type="string" required="true" >      
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=DetachVpnGateway&VpnGatewayId=" & trim(arguments.VpnGatewayId) & "&VpcId=" & trim(arguments.VpcId)/>    
    		    
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

	<cffunction name="DisassociateAddress" access="public" returntype="Struct" >    
    		<cfargument name="PublicIp" type="string" required="false" default="" >
		<cfargument name="AssociationId" type="string" required="false" default="" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=DisassociateAddress"/>    
    		    
    		<cfif len(trim(arguments.PublicIp))>    
    			<cfset body &= "&PublicIp=" & trim(arguments.PublicIp) />    
    		</cfif>	    
    		
    		<cfif len(trim(arguments.AssociationId))>    
    			<cfset body &= "&AssociationId=" & trim(arguments.AssociationId) />    
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
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="DisassociateRouteTable" access="public" returntype="Struct" >    
    		<cfargument name="AssociationId" type="string" required="true" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=DisassociateRouteTable&AssociationId=" & trim(arguments.AssociationId)/>    
    		    
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

	<cffunction name="EnableVolumeIO" access="public" returntype="Struct" >    
    		<cfargument name="VolumeId" type="string" required="true" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=EnableVolumeIO&VolumeId=" & trim(arguments.VolumeId)/>    
    		    
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

	<cffunction name="GetConsoleOutput" access="public" returntype="Struct" >    
    		<cfargument name="InstanceId" type="string" required="true" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=GetConsoleOutput&InstanceId=" & trim(arguments.InstanceId)/>    
    		    
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'GetConsoleOutputResponse')[1] />    
    			<cfset stResponse.result = {
									instanceId=getValue(dataResult,'instanceId'),
									timestamp=getValue(dataResult,'timestamp'),
									output=getValue(dataResult,'output')
									} />	    
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="GetPasswordData" access="public" returntype="Struct" >    
    		<cfargument name="InstanceId" type="string" required="true" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=GetPasswordData&InstanceId=" & trim(arguments.InstanceId)/>    
    		    
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'GetPasswordDataResponse')[1] />    
    			<cfset stResponse.result = {
										instanceId=getValue(dataResult,'instanceId'),
										timestamp=getValue(dataResult,'timestamp'),
										passwordData=getValue(dataResult,'passwordData')
									} />	    
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="ImportInstance" access="public" returntype="Struct" >    
    		<cfargument name="Architecture" type="string" required="true" >
		<cfargument name="InstanceType" type="string" required="true" >
		<cfargument name="DiskImage" type="array" required="true" >
		<cfargument name="Platform" type="string" required="true" >
			    
    		<cfargument name="Description" type="string" required="false" default="" >    
    		<cfargument name="SecurityGroup" type="string" required="false" default="" >    
    		<cfargument name="UserData" type="string" required="false" default="" >    
    		<cfargument name="Placement" type="string" required="false" default="" >    
    		<cfargument name="MonitoringEnabled" type="string" required="false" default="" >    
    		<cfargument name="SubnetId" type="string" required="false" default="" >    
    		<cfargument name="InstanceInitiatedShutdownBehavior" type="string" required="false" default="" >    
    		<cfargument name="PrivateIpAddress" type="string" required="false" default="" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=ImportInstance&Architecture=" & trim(arguments.Architecture) & "&InstanceType=" & trim(arguments.InstanceType) & "&Platform=" & trim(arguments.Platform) />    
    		    
    		<cfif len(trim(arguments.Description))>    
    			<cfset body &= "&Description=" & trim(arguments.Description) />    
    		</cfif>	
    		
    		<cfloop from="1" to="#arrayLen(arguments.DiskImage)#" index="j">
    			<cfset image=arguments.DiskImage[j] />
				
			<cfif structKeyExists(image,'Format')>
				<cfset body &= "&DiskImage." & j & ".Image.Format=" & image.Format />
			</cfif>
			
			<cfif structKeyExists(image,'Bytes')>
				<cfset body &= "&DiskImage." & j & ".Image.Bytes=" & image.Bytes />
			</cfif>
			
			<cfif structKeyExists(image,'ImportManifestUrl')>
				<cfset body &= "&DiskImage." & j & ".Image.ImportManifestUrl=" & image.ImportManifestUrl />
			</cfif>
			
			<cfif structKeyExists(image,'Description')>
				<cfset body &= "&DiskImage." & j & ".Image.Description=" & image.Description />
			</cfif>
			
			<cfif structKeyExists(image,'volumesize')>
				<cfset body &= "&DiskImage." & j & ".Volume.Size=" & image.volumesize />
			</cfif>	
    		
    		</cfloop>
    		
    		
    		<cfloop from="1" to="#listLen(arguments.SecurityGroup)#" index="i">
			<cfset body &= "&SecurityGroup." & i & "=" & trim(listgetat(SecurityGroup,i)) /> 		
		</cfloop>			
    		
    		<cfif len(trim(arguments.UserData))>    
    			<cfset body &= "&UserData=" & trim(arguments.UserData) />    
    		</cfif>	
    		
    		<cfif len(trim(arguments.Placement))>    
    			<cfset body &= "&Placement.AvailabilityZone=" & trim(arguments.Placement) />    
    		</cfif>	
    		
    		<cfif len(trim(arguments.MonitoringEnabled))>    
    			<cfset body &= "&Monitoring.Enabled=" & trim(arguments.MonitoringEnabled) />    
    		</cfif>	
    		
    		<cfif len(trim(arguments.SubnetId))>    
    			<cfset body &= "&SubnetId=" & trim(arguments.SubnetId) />    
    		</cfif>	
    		
    		<cfif len(trim(arguments.InstanceInitiatedShutdownBehavior))>    
    			<cfset body &= "&InstanceInitiatedShutdownBehavior=" & trim(arguments.InstanceInitiatedShutdownBehavior) />    
    		</cfif>	    
    		 
    		 <cfif len(trim(arguments.PrivateIpAddress))>    
    			<cfset body &= "&PrivateIpAddress=" & trim(arguments.PrivateIpAddress) />    
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'conversionTask')[1] />    
    			<cfset stResponse.result = createConversionTaskTypeObject(dataResult) />	    
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="ImportKeyPair" access="public" returntype="Struct" >    
    		<cfargument name="KeyName" type="string" required="true" >    
    		<cfargument name="PublicKeyMaterial" type="string" required="true" >     
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=ImportKeyPair&KeyName=" & trim(arguments.KeyName) & "&PublicKeyMaterial=" & trim(arguments.PublicKeyMaterial)/>    
    		    
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'ImportKeyPairResponse')[1] />    
    			<cfset stResponse.result = {
										keyName=getValue(dataResult,'keyName'),
										keyFingerprint=getValue(dataResult,'keyFingerprint')
									} />	    
    	    
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="ImportVolume" access="public" returntype="Struct" >    
    		<cfargument name="AvailabilityZone" type="string" required="true" >  
		<cfargument name="Volume" type="string" required="true" >  
    		<cfargument name="Image" type="array" required="true" >    
    		<cfargument name="Description" type="String" required="false" default="" > 
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=ImportVolume&AvailabilityZone=" & trim(arguments.AvailabilityZone) & "&olume.Size=" & trim(arguments.Volume)/>    
    		    
    		<cfloop from="1" to="#arrayLen(arguments.image)#" index="i">
			<cfset image = arguments.image[i] />
			
			<cfif structKeyExists(image,'Format')>
				<cfset body &= "&Image.Format=" & trim(arguments.Format) />   
			</cfif>
			
			<cfif structKeyExists(image,'Bytes')>
				<cfset body &= "&Image.Bytes=" & trim(arguments.Bytes) />  
			</cfif>	
			
			<cfif structKeyExists(image,'ImportManifestUrl')>
				<cfset body &= "&Image.ImportManifestUrl=" & trim(arguments.ImportManifestUrl) />  
			</cfif>			
		</cfloop>			    
    		    
    		<cfif len(trim(arguments.Description))>    
    			<cfset body &= "&Description=" & trim(arguments.Description) />    
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'conversionTask')[1] />    
    			<cfset stResponse.result = createConversionTaskTypeObject(dataResult) />	    
    	    
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="ModifyImageAttribute" access="public" returntype="Struct" >    
    		<cfargument name="ImageId" type="string" required="true" >    
    		<cfargument name="addUser" type="string" required="false" default="" >
		<cfargument name="removeUser" type="string" required="false" default="" >     
    		<cfargument name="addGroup" type="string" required="false" default="" >     
    		<cfargument name="removeGroup" type="string" required="false" default="" >     
    		<cfargument name="ProductCode" type="string" required="false" default="" >
    		<cfargument name="Description" type="string" required="false" default="" >
				    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=ModifyImageAttribute&ImageId=" & trim(arguments.ImageId)/>    
    		 
    		 <cfloop from="1" to="#listLen(arguments.addUser)#" index="i">
			<cfset body &= "&LaunchPermission.Add." & i & ".UserId=" & trim(listgetat(addUser,i)) /> 		
		</cfloop>
		
		<cfloop from="1" to="#listLen(arguments.removeUser)#" index="j">
			<cfset body &= "&LaunchPermission.Remove." & j & ".UserId=" & trim(listgetat(removeUser,j)) />		
		</cfloop>
		
		<cfloop from="1" to="#listLen(arguments.addGroup)#" index="k">
			<cfset body &= "&LaunchPermission.Add." & k & ".Group=" & trim(listgetat(addGroup,k)) /> 		
		</cfloop>
		
		<cfloop from="1" to="#listLen(arguments.removeGroup)#" index="m">
			<cfset body &= "&LaunchPermission.Remove." & m & ".Group=" & trim(listgetat(removeGroup,m)) /> 		
		</cfloop> 
		
		<cfloop from="1" to="#listLen(arguments.ProductCode)#" index="n">
			<cfset body &= "&ProductCode." & n & "=" & trim(listgetat(ProductCode,n)) /> 		
		</cfloop>   
    		    
    		<cfif len(trim(arguments.Description))>    
    			<cfset body &= "&Description.Value=" & trim(arguments.Description) />    
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
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="ModifyInstanceAttribute" access="public" returntype="Struct" >    
    		<cfargument name="InstanceId" type="string" required="true" >    
    		<cfargument name="InstanceType" type="string" required="false" default="" >    
    		<cfargument name="Kernel" type="string" required="false" default="" >    
    		<cfargument name="Ramdisk" type="string" required="false" default="" >    
    		<cfargument name="UserData" type="string" required="false" default="" >    
    		<cfargument name="DisableApiTermination" type="string" required="false" default="" >    
    		<cfargument name="InstanceInitiatedShutdownBehavior" type="string" required="false" default="" >    
    		<cfargument name="BlockMappingDevice" type="string" required="false" default="" >    
    		<cfargument name="SourceDestCheck" type="string" required="false" default="" >    
    		<cfargument name="GroupId" type="string" required="false" default="" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=ModifyInstanceAttribute&InstanceId=" & trim(arguments.InstanceId)/>    
    		    
    		<cfif len(trim(arguments.InstanceType))>    
    			<cfset body &= "&InstanceType.Value=" & trim(arguments.InstanceType) />    
    		</cfif>	    
    		
    		<cfif len(trim(arguments.Kernel))>    
    			<cfset body &= "&Kernel.Value=" & trim(arguments.Kernel) />    
    		</cfif>	    
    		
    		<cfif len(trim(arguments.Ramdisk))>    
    			<cfset body &= "&Ramdisk.Value=" & trim(arguments.Ramdisk) />    
    		</cfif>	    
    		        
    		<cfif len(trim(arguments.UserData))>    
    			<cfset body &= "&UserData.Value=" & trim(arguments.UserData) />    
    		</cfif>	    
    		
    		<cfif len(trim(arguments.DisableApiTermination))>    
    			<cfset body &= "&DisableApiTermination.Value=" & trim(arguments.DisableApiTermination) />    
    		</cfif>	    
    		
    		<cfif len(trim(arguments.InstanceInitiatedShutdownBehavior))>    
    			<cfset body &= "&InstanceInitiatedShutdownBehavior.Value=" & trim(arguments.InstanceInitiatedShutdownBehavior) />    
    		</cfif>	    
    		
    		<cfif len(trim(arguments.BlockMappingDevice))>    
    			<cfset body &= "&BlockMappingDevice.Value=" & trim(arguments.BlockMappingDevice) />    
    		</cfif>	    
    		
    		<cfif len(trim(arguments.SourceDestCheck))>    
    			<cfset body &= "&SourceDestCheck.Value=" & trim(arguments.SourceDestCheck) />    
    		</cfif>	    
    		
    		<cfloop from="1" to="#listlen(arguments.GroupID)#" index="i">
				<cfset body &= "&GroupId." & i & "=" & trim(listGetAt(arguments.GroupID,i)) /> 		
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
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="ModifyNetworkInterfaceAttribute" access="public" returntype="Struct" >    
    		<cfargument name="NetworkInterfaceId" type="string" required="true" >    
    		<cfargument name="Description" type="string" required="false" default="" >    
    		<cfargument name="SecurityGroupId" type="string" required="false" default="" >    
    		<cfargument name="SourceDestCheck" type="string" required="false" default="" >    
    		<cfargument name="AttachmentId" type="string" required="false" default="" >    
    		<cfargument name="DeleteOnTermination" type="string" required="false" default="" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=ModifyNetworkInterfaceAttribute&NetworkInterfaceId=" & trim(arguments.NetworkInterfaceId)/>    
    		    
    		<cfif len(trim(arguments.Description))>    
    			<cfset body &= "&Description.Value=" & trim(arguments.Description) />    
    		</cfif>	    
    		
    		<cfif len(trim(arguments.SourceDestCheck))>    
    			<cfset body &= "&SourceDestCheck.Value=" & trim(arguments.SourceDestCheck) />    
    		</cfif>
    		
    		<cfif len(trim(arguments.AttachmentId))>    
    			<cfset body &= "&Attachment.AttachmentId=" & trim(arguments.AttachmentId) />    
    		</cfif>
    		
    		<cfif len(trim(arguments.DeleteOnTermination))>    
    			<cfset body &= "&Attachment.DeleteOnTermination=" & trim(arguments.DeleteOnTermination) />    
    		</cfif>
    		
    		<cfloop from="1" to="#listlen(arguments.SecurityGroupId)#" index="i">
				<cfset body &= "&SecurityGroupId." & i & "=" & trim(listGetAt(arguments.SecurityGroupId,i)) /> 		
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
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="ModifySnapshotAttribute" access="public" returntype="Struct" >    
    		<cfargument name="SnapshotId" type="string" required="true" > 
		<cfargument name="Adduser" type="string" required="true" > 	   
    		<cfargument name="AddGroup" type="string" required="true" > 	   
    		<cfargument name="RemoveUser" type="string" required="false" default="" >	   
    		<cfargument name="RemoveGroup" type="string" required="false" default="" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=ModifySnapshotAttribute&SnapshotId=" & trim(arguments.SnapshotId)/>    
    		    
    		<cfloop from="1" to="#listlen(arguments.Adduser)#" index="i">
			<cfset body &= "&CreateVolumePermission.Add." & i & ".UserId=" & trim(listGetAt(arguments.Adduser,i)) /> 		
		</cfloop>
		
		<cfloop from="1" to="#listlen(arguments.AddGroup)#" index="j">
			<cfset body &= "&CreateVolumePermission.Add." & j & ".Group=" & trim(listGetAt(arguments.AddGroup,j)) /> 		
		</cfloop>
		
		<cfloop from="1" to="#listlen(arguments.RemoveUser)#" index="k">
			<cfset body &= "&CreateVolumePermission.Remove." & k & ".UserId=" & trim(listGetAt(arguments.RemoveUser,k)) /> 		
		</cfloop>
		
		<cfloop from="1" to="#listlen(arguments.RemoveGroup)#" index="m">
			<cfset body &= "&CreateVolumePermission.Remove." & m & ".Group=" & trim(listGetAt(arguments.RemoveGroup,m)) /> 		
		</cfloop>
		
		<cfloop from="1" to="#listlen(arguments.Adduser)#" index="i">
				<cfset body &= "&CreateVolumePermission.Add." & i & "UserId=" & trim(listGetAt(arguments.Adduser,i)) /> 		
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
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="ModifyVolumeAttribute" access="public" returntype="Struct" >    
    		<cfargument name="VolumeId" type="string" required="true" >    
    		<cfargument name="AutoEnableIO" type="string" required="true" >     
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=ModifyVolumeAttribute&VolumeId=" & trim(arguments.VolumeId) & "&AutoEnableIO=" & trim(arguments.AutoEnableIO)/>    
    		    
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

	<cffunction name="MonitorInstances" access="public" returntype="Struct" >    
    		<cfargument name="InstanceId" type="string" required="true" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=MonitorInstances"/>    
    		    
    		<cfloop from="1" to="#listlen(arguments.InstanceId)#" index="i">
			<cfset body &= "&InstanceId." & i & "=" & trim(listGetAt(arguments.InstanceId,i)) /> 		
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
    			<cfset stResponse.errorMessage=error.Message.xmlText /> 
				   
    		<cfelse>			    
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'instancesSet')[1].xmlChildren />    
    			<cfset stResponse.result = [] />
				
			<cfloop array="#dataResult#" index="result">
				<cfset arrayAppend(stResponse.result,createMonitorInstancesResponseSetItemTypeObject(result)) />
			</cfloop>		    
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="PurchaseReservedInstancesOffering" access="public" returntype="Struct" >    
    		<cfargument name="ReservedInstancesOfferingId" type="string" required="true" >    
    		<cfargument name="InstanceCount" type="string" required="false" default="" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=PurchaseReservedInstancesOffering&ReservedInstancesOfferingId=" & trim(arguments.ReservedInstancesOfferingId)/>    
    		    
    		<cfif len(trim(arguments.InstanceCount))>    
    			<cfset body &= "&InstanceCount=" & trim(arguments.InstanceCount) />    
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
    			<cfset stResponse.result = getResultNodes(xmlParse(rawResult.filecontent),'reservedInstancesId')[1].xmlText />    
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="RebootInstances" access="public" returntype="Struct" >    
    		<cfargument name="InstanceId" type="string" required="true" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=RebootInstances"/>    
    		    
    		 <cfloop from="1" to="#listlen(arguments.InstanceId)#" index="i">
			<cfset body &= "&InstanceId." & i & "=" & trim(listGetAt(arguments.InstanceId,i)) /> 		
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
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="RegisterImage" access="public" returntype="Struct" >    
    		<cfargument name="Name" type="string" required="true" >    
    		<cfargument name="ImageLocation" type="string" required="false" default="" >    
    		<cfargument name="Description" type="string" required="false" default="" >    
    		<cfargument name="Architecture" type="string" required="false" default="" >    
    		<cfargument name="KernelId" type="string" required="false" default="" >    
    		<cfargument name="RamdiskId" type="string" required="false" default="" >    
    		<cfargument name="RootDeviceName" type="string" required="false" default="" >    
    		<cfargument name="BlockDeviceMapping" type="array" required="false" default="" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=RegisterImage&Name=" & trim(arguments.Name)/>    
    		    
    		<cfif len(trim(arguments.ImageLocation))>    
    			<cfset body &= "&ImageLocation=" & trim(arguments.ImageLocation) />    
    		</cfif>	    
    		
		<cfif len(trim(arguments.Description))>    
    			<cfset body &= "&Description=" & trim(arguments.Description) />    
    		</cfif>	   
		
		<cfif len(trim(arguments.Architecture))>    
    			<cfset body &= "&Architecture=" & trim(arguments.Architecture) />    
    		</cfif>	   
		
		<cfif len(trim(arguments.RootDeviceName))>    
    			<cfset body &= "&RootDeviceName=" & trim(arguments.RootDeviceName) />    
    		</cfif>	   
		
		<cfif len(trim(arguments.KernelId))>    
    			<cfset body &= "&KernelId=" & trim(arguments.KernelId) />    
    		</cfif>	   
		
		<cfif len(trim(arguments.RamdiskId))>    
    			<cfset body &= "&RamdiskId=" & trim(arguments.RamdiskId) />    
    		</cfif>	  
			
		<cfloop from="1" to="#arrayLen(arguments.BlockDeviceMapping)#" index="i">
			<cfset mapping = arguments.BlockDeviceMapping[i] />
			
			<cfif structKeyExists(mapping,'DeviceName')>
				<cfset body &= "&BlockDeviceMapping." & i & ".BlockDeviceMapping=" & trim(mapping.BlockDeviceMapping) />
			</cfif>
			
			<cfif structKeyExists(mapping,'VirtualName')>
				<cfset body &= "&BlockDeviceMapping." & i & ".VirtualName=" & trim(mapping.VirtualName) />
			</cfif>
			
			<cfif structKeyExists(mapping.ebs,'SnapshotId')>
				<cfset body &= "&BlockDeviceMapping." & i & ".Ebs.SnapshotId=" & trim(mapping.ebs.SnapshotId) />
			</cfif>
			
			<cfif structKeyExists(mapping.ebs,'VolumeSize')>
				<cfset body &= "&BlockDeviceMapping." & i & ".Ebs.VolumeSize=" & trim(mapping.ebs.VolumeSize) />
			</cfif>
			
			<cfif structKeyExists(mapping.ebs,'NoDevice')>
				<cfset body &= "&BlockDeviceMapping." & i & ".Ebs.NoDevice=" & trim(mapping.ebs.NoDevice) />
			</cfif>
			
			<cfif structKeyExists(mapping.ebs,'DeleteOnTermination')>
				<cfset body &= "&BlockDeviceMapping." & i & ".Ebs.DeleteOnTermination=" & trim(mapping.ebs.DeleteOnTermination) />
			</cfif>
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
    			<cfset stResponse.result = getResultNodes(xmlParse(rawResult.filecontent),'imageId')[1].xmlText />    
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="ReleaseAddress" access="public" returntype="Struct" >    
    		<cfargument name="PublicIp" type="string" required="false" default="" >    
    		<cfargument name="AllocationId" type="string" required="false" default="" > 
    				    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=ReleaseAddress"/>    
    		    
    		<cfif len(trim(arguments.PublicIp))>    
    			<cfset body &= "&PublicIp=" & trim(arguments.PublicIp) />    
    		</cfif>	    
    		
		<cfif len(trim(arguments.AllocationId))>    
    			<cfset body &= "&AllocationId=" & trim(arguments.AllocationId) />    
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
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="ReplaceNetworkAclAssociation" access="public" returntype="Struct" >    
    		<cfargument name="AssociationId" type="string" required="true" >    
    		<cfargument name="NetworkAclId" type="string" required="true" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=ReplaceNetworkAclAssociation&AssociationId=" & trim(arguments.AssociationId) & "&NetworkAclId=" & trim(arguments.NetworkAclId)/>    
    		    
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

	<cffunction name="ReplaceNetworkAclEntry" access="public" returntype="Struct" >    
    		<cfargument name="NetworkAclId" type="string" required="true" >    
    		<cfargument name="RuleNumber" type="string" required="true" >    
    		<cfargument name="Protocol" type="string" required="true" >    
    		<cfargument name="RuleAction" type="string" required="true" >    
    		<cfargument name="CidrBlock" type="string" required="true" >
			    
    		<cfargument name="Egress" type="string" required="false" default="" >    
    		<cfargument name="IcmpCode" type="string" required="false" default="" >    
    		<cfargument name="IcmpType" type="string" required="false" default="" >    
    		<cfargument name="PortRangeFrom" type="string" required="false" default="" >    
    		<cfargument name="PortRangeTo" type="string" required="false" default="" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=ReplaceNetworkAclEntry&NetworkAclId=" & trim(arguments.NetworkAclId) & "&RuleNumber=" & trim(arguments.RuleNumber) & "&Protocol=" & trim(arguments.Protocol) & "&RuleAction=" & trim(arguments.RuleAction) & "&CidrBlock=" & trim(arguments.CidrBlock) />    
    		    
    		<cfif len(trim(arguments.Egress))>    
    			<cfset body &= "&Egress=" & trim(arguments.Egress) />    
    		</cfif>
			
		<cfif len(trim(arguments.IcmpCode))>    
    			<cfset body &= "&Icmp.Code=" & trim(arguments.IcmpCode) />    
    		</cfif>	    
			
		<cfif len(trim(arguments.IcmpType))>    
    			<cfset body &= "&Icmp.Type=" & trim(arguments.IcmpType) />    
    		</cfif>	    
			
		<cfif len(trim(arguments.PortRangeFrom))>    
    			<cfset body &= "&PortRange.From=" & trim(arguments.PortRangeFrom) />    
    		</cfif>	    
			
		<cfif len(trim(arguments.PortRangeTo))>    
    			<cfset body &= "&PortRange.To=" & trim(arguments.PortRangeTo) />    
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
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="ReplaceRoute" access="public" returntype="Struct" >    
    		<cfargument name="RouteTableId" type="string" required="true" >    
    		<cfargument name="DestinationCidrBlock" type="string" required="true" >    
    		<cfargument name="GatewayId" type="string" required="false" default="" >    
    		<cfargument name="InstanceId" type="string" required="false" default="" >    
    		<cfargument name="NetworkInterfaceId" type="string" required="false" default="" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=ReplaceRoute&RouteTableId=" & trim(arguments.RouteTableId) & "&DestinationCidrBlock=" & trim(arguments.DestinationCidrBlock)/>    
    		    
    		<cfif len(trim(arguments.GatewayId))>    
    			<cfset body &= "&GatewayId=" & trim(arguments.GatewayId) />    
    		</cfif>	    
    		 
		<cfif len(trim(arguments.InstanceId))>    
    			<cfset body &= "&InstanceId=" & trim(arguments.InstanceId) />    
    		</cfif>
			
		<cfif len(trim(arguments.NetworkInterfaceId))>    
    			<cfset body &= "&NetworkInterfaceId=" & trim(arguments.NetworkInterfaceId) />    
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
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="ReplaceRouteTableAssociation" access="public" returntype="Struct" >    
    		<cfargument name="AssociationId" type="string" required="true" >    
    		<cfargument name="RouteTableId" type="string" required="true" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=ReplaceRouteTableAssociation&AssociationId=" & trim(arguments.AssociationId) & "&RouteTableId=" & trim(arguments.RouteTableId)/>    
    		    
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
    			<cfset stResponse.result = getResultNodes(xmlParse(rawResult.filecontent),'newAssociationId')[1].xmlText />    
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="ReportInstanceStatus" access="public" returntype="Struct" >    
    		<cfargument name="InstanceID" type="string" required="true" >    
    		<cfargument name="Status" type="string" required="true" >    
    		<cfargument name="ReasonCodes" type="string" required="true" >    
    		<cfargument name="StartTime" type="string" required="false" default="" >    
    		<cfargument name="EndTime" type="string" required="false" default="" >    
    		<cfargument name="Description" type="string" required="false" default="" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=ReportInstanceStatus&Status=" & trim(arguments.Status)/>    
    		
		<cfloop from="1" to="#listlen(arguments.InstanceId)#" index="i">
			<cfset body &= "&InstanceId." & i & "=" & trim(listGetAt(arguments.InstanceId,i)) /> 		
		</cfloop>
		
		<cfloop from="1" to="#listlen(arguments.ReasonCodes)#" index="j">
			<cfset body &= "&ReasonCodes." & j & "=" & trim(listGetAt(arguments.ReasonCodes,j)) /> 		
		</cfloop>
		    
    		<cfif len(trim(arguments.StartTime))>    
    			<cfset body &= "&StartTime=" & trim(arguments.StartTime) />    
    		</cfif>
			
		<cfif len(trim(arguments.EndTime))>    
    			<cfset body &= "&EndTime=" & trim(arguments.EndTime) />    
    		</cfif>
			
		<cfif len(trim(arguments.Description))>    
    			<cfset body &= "&Description=" & trim(arguments.Description) />    
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
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="RequestSpotInstances" access="public" returntype="Struct" >    
    		<cfargument name="SpotPrice" type="string" required="true" >    
    		<cfargument name="LaunchSpecification" type="struct" required="true" >
		<cfargument name="InstanceCount" type="string" required="false" default="" >    
    		<cfargument name="Type" type="string" required="false" default="" >    
    		<cfargument name="ValidFrom" type="string" required="false" default="" >    
    		<cfargument name="ValidUntil" type="string" required="false" default="" >    
    		<cfargument name="Subnet" type="string" required="false" default="" >    
    		<cfargument name="LaunchGroup" type="string" required="false" default="" >    
    		<cfargument name="AvailabilityZoneGroup" type="string" required="false" default="" >    
    		<cfargument name="GroupName" type="string" required="false" default="" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=RequestSpotInstances&SpotPrice=" & trim(arguments.SpotPrice)/>    
    		    
    		<cfif len(trim(arguments.InstanceCount))>    
    			<cfset body &= "&InstanceCount=" & trim(arguments.InstanceCount) />    
    		</cfif>	    
    		
		<cfif len(trim(arguments.Type))>    
    			<cfset body &= "&Type=" & trim(arguments.Type) />    
    		</cfif>	   
			
		<cfif len(trim(arguments.ValidFrom))>    
    			<cfset body &= "&ValidFrom=" & trim(arguments.ValidFrom) />    
    		</cfif>	   
			
		<cfif len(trim(arguments.ValidUntil))>    
    			<cfset body &= "&ValidUntil=" & trim(arguments.ValidUntil) />    
    		</cfif>	   
			
		<cfif len(trim(arguments.Subnet))>    
    			<cfset body &= "&Subnet=" & trim(arguments.Subnet) />    
    		</cfif>	   
			
		<cfif len(trim(arguments.LaunchGroup))>    
    			<cfset body &= "&LaunchGroup=" & trim(arguments.LaunchGroup) />    
    		</cfif>
				
		<cfif len(trim(arguments.AvailabilityZoneGroup))>    
    			<cfset body &= "&AvailabilityZoneGroup=" & trim(arguments.AvailabilityZoneGroup) />    
    		</cfif>
				
		<cfif len(trim(arguments.GroupName))>    
    			<cfset body &= "&Placement.GroupName=" & trim(arguments.GroupName) />    
    		</cfif>
		
		<cfif structKeyExists(arguments.LaunchSpecification,'ImageId')>
			<cfset body &= "&LaunchSpecification.ImageId=" & trim(arguments.LaunchSpecification.ImageId) />
		</cfif>
		
		<cfif structKeyExists(arguments.LaunchSpecification,'KeyName')>
			<cfset body &= "&LaunchSpecification.KeyName=" & trim(arguments.LaunchSpecification.KeyName) />
		</cfif>
				
		<cfif structKeyExists(arguments.LaunchSpecification,'SecurityGroupId')>			
			<cfloop from="1" to="#listLen(arguments.LaunchSpecification.SecurityGroupId)#" index="i">
				<cfset body &= "&LaunchSpecification.SecurityGroupId." & i & "=" & trim(listgetat(arguments.LaunchSpecification.SecurityGroupId,i)) />
			</cfloop>	
		</cfif>
		
		<cfif structKeyExists(arguments.LaunchSpecification,'SecurityGroup')>			
			<cfloop from="1" to="#listLen(arguments.LaunchSpecification.SecurityGroup)#" index="j">
				<cfset body &= "&LaunchSpecification.SecurityGroup." & j & "=" & trim(listgetat(arguments.LaunchSpecification.SecurityGroup,j)) />
			</cfloop>	
		</cfif>	
		
		<cfif structKeyExists(arguments.LaunchSpecification,'UserData')>
			<cfset body &= "&LaunchSpecification.UserData=" & trim(arguments.LaunchSpecification.UserData) />
		</cfif>
		
		<cfif structKeyExists(arguments.LaunchSpecification,'AddressingType')>
			<cfset body &= "&LaunchSpecification.AddressingType=" & trim(arguments.LaunchSpecification.AddressingType) />
		</cfif>
		
		<cfif structKeyExists(arguments.LaunchSpecification,'InstanceType')>
			<cfset body &= "&LaunchSpecification.InstanceType=" & trim(arguments.LaunchSpecification.InstanceType) />
		</cfif>
		
		<cfif structKeyExists(arguments.LaunchSpecification,'AvailabilityZone')>
			<cfset body &= "&LaunchSpecification.Placement.AvailabilityZone=" & trim(arguments.LaunchSpecification.AvailabilityZone) />
		</cfif>
		
		<cfif structKeyExists(arguments.LaunchSpecification,'KernelId')>
			<cfset body &= "&LaunchSpecification.KernelId=" & trim(arguments.LaunchSpecification.KernelId) />
		</cfif>
		
		<cfif structKeyExists(arguments.LaunchSpecification,'RamdiskId')>
			<cfset body &= "&LaunchSpecification.RamdiskId=" & trim(arguments.LaunchSpecification.RamdiskId) />
		</cfif>
		
		<cfif structKeyExists(arguments.LaunchSpecification,'BlockDeviceMapping')>
			<cfloop from="1" to="#arrayLen(arguments.LaunchSpecification.BlockDeviceMapping)#" index="m">
				<cfset deviceMapping = arguments.LaunchSpecification.BlockDeviceMapping[m] />
				
				<cfif structKeyExists(deviceMapping,'DeviceName')>
					<cfset body &= "&LaunchSpecification.BlockDeviceMapping." & m & ".DeviceName=" & trim(deviceMapping.DeviceName) />
				</cfif>
				
				<cfif structKeyExists(deviceMapping,'VirtualName')>
					<cfset body &= "&LaunchSpecification.BlockDeviceMapping." & m & ".VirtualName=" & trim(deviceMapping.VirtualName) />
				</cfif>
				
				<cfif structKeyExists(deviceMapping,'SnapshotId')>
					<cfset body &= "&LaunchSpecification.BlockDeviceMapping." & m & ".Ebs.SnapshotId=" & trim(deviceMapping.SnapshotId) />
				</cfif>
				
				<cfif structKeyExists(deviceMapping,'VolumeSize')>
					<cfset body &= "&LaunchSpecification.BlockDeviceMapping." & m & ".Ebs.VolumeSize=" & trim(deviceMapping.VolumeSize) />
				</cfif>
				
				<cfif structKeyExists(deviceMapping,'NoDevice')>
					<cfset body &= "&LaunchSpecification.BlockDeviceMapping." & m & ".Ebs.NoDevice=" & trim(deviceMapping.NoDevice) />
				</cfif>
				
				<cfif structKeyExists(deviceMapping,'DeleteOnTermination')>
					<cfset body &= "&LaunchSpecification.BlockDeviceMapping." & m & ".Ebs.DeleteOnTermination=" & trim(deviceMapping.DeleteOnTermination) />
				</cfif>
			</cfloop>
		</cfif>	
		
		<cfif structKeyExists(arguments.LaunchSpecification,'Monitoring')>
			<cfset body &= "&LaunchSpecification..Monitoring.Enabled=" & trim(arguments.LaunchSpecification.Monitoring) />
		</cfif>			
		
		<cfif structKeyExists(arguments.LaunchSpecification,'NetworkInterface')>
			<cfloop from="1" to="#arrayLen(arguments.LaunchSpecification.NetworkInterface)#" index="n">
				<cfset NetworkInterface = arguments.LaunchSpecification.NetworkInterface[n] />
				
				<cfif structKeyExists(NetworkInterface,'NetworkInterfaceId')>
					<cfset body &= "&LaunchSpecification.NetworkInterface." & n & ".NetworkInterfaceId=" & trim(NetworkInterface.NetworkInterfaceId) />
				</cfif>
				
				<cfif structKeyExists(NetworkInterface,'DeviceIndex')>
					<cfset body &= "&LaunchSpecification.NetworkInterface." & n & ".DeviceIndex=" & trim(NetworkInterface.DeviceIndex) />
				</cfif>
				
				<cfif structKeyExists(NetworkInterface,'SubnetId')>
					<cfset body &= "&LaunchSpecification.NetworkInterface." & n & ".SubnetId=" & trim(NetworkInterface.SubnetId) />
				</cfif>
					
					<cfif structKeyExists(NetworkInterface,'Description')>
					<cfset body &= "&LaunchSpecification.NetworkInterface." & n & ".Description=" & trim(NetworkInterface.Description) />
				</cfif>
				
				<cfif structKeyExists(NetworkInterface,'SecurityGroupId')>
					<cfloop from="1" to="#listLen(NetworkInterface.SecurityGroupId)#" index="p">
						<cfset body &= "&LaunchSpecification.NetworkInterface." & n & ".SecurityGroupId." & p & "=" & trim(listgetat(NetworkInterface.SecurityGroupId,p)) />
					</cfloop>
				</cfif>
				
				<cfif structKeyExists(NetworkInterface,'DeleteOnTermination')>
					<cfset body &= "&LaunchSpecification.NetworkInterface." & n & ".DeleteOnTermination=" & trim(NetworkInterface.DeleteOnTermination) />
				</cfif>
				
			</cfloop>
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
    			<cfdump var="#xmlParse(rawResult.filecontent)#" /><cfabort>    
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'RequestSpotInstancesResponse')[1] />    
    			<cfset stResponse.result = {
										spotInstanceRequestSet=[],
										networkInterfaceId=createInstanceNetworkInterfaceSetRequestTypeObject(dataResult.networkInterfaceId)
									} />	    
    	    		<cfloop array="#dataResult.spotInstanceRequestSet.xmlChildren#" index="spot">
				<cfset arrayAppend(stResponse.result.spotInstanceRequestSet,createSpotInstanceRequestSetItemTypeObject(spot)) />	
			</cfloop>		
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="ResetImageAttribute" access="public" returntype="Struct" >    
    		<cfargument name="ImageId" type="string" required="true" >    
    		<cfargument name="Attribute" type="string" required="true" >     
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=ResetImageAttribute&ImageId=" & trim(arguments.ImageId) & "&ImageId=" & trim(arguments.ImageId)/>    
    		    
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

	<cffunction name="ResetInstanceAttribute" access="public" returntype="Struct" >    
    		<cfargument name="InstanceId" type="string" required="true" >    
    		<cfargument name="Attribute" type="string" required="true"  >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=ResetInstanceAttribute&InstanceId=" & trim(arguments.InstanceId) & "&Attribute=" & trim(arguments.Attribute)/>    
    		    
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

	<cffunction name="ResetNetworkInterfaceAttribute" access="public" returntype="Struct" >    
    		<cfargument name="NetworkInterfaceId" type="string" required="true" >    
    		<cfargument name="Attribute" type="string" required="true" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=ResetNetworkInterfaceAttribute&NetworkInterfaceId=" & trim(arguments.NetworkInterfaceId) & "&Attribute=" & trim(arguments.Attribute)/>    
    		    
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

	<cffunction name="ResetSnapshotAttribute" access="public" returntype="Struct" >    
    		<cfargument name="SnapshotId" type="string" required="true" >    
    		<cfargument name="Attribute" type="string" required="true" >     
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=ResetSnapshotAttribute&SnapshotId=" & trim(arguments.SnapshotId) & "&Attribute=" & trim(arguments.Attribute)/>    
    		    
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

	<cffunction name="RevokeSecurityGroupEgress" access="public" returntype="Struct" >    
    		<cfargument name="GroupId" type="string" required="true" >    
    		<cfargument name="IpPermissions" type="array" required="true" > 
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=RevokeSecurityGroupEgress&IpPermissions=" & trim(arguments.IpPermissions)/>    
    		    
		<cfloop from="1" to="#arrayLen(arguments.IpPermissions)#" index="i">
			<cfset perm=arguments.IpPermissions[i] />
				
			<cfif structKeyExists(perm,'FromPort')>
				<cfset body &= "&IpPermissions." & i & ".FromPort=" & perm.FromPort />			
			</cfif>
			
			<cfif structKeyExists(perm,'ToPort')>
				<cfset body &= "&IpPermissions." & i & ".ToPort=" & perm.ToPort />			
			</cfif>
			
			<cfif structKeyExists(perm,'Groups')>
				<cfloop from="1" to="#listLen(perm.Groups)#" index="j">
					<cfset body &= "&IpPermissions." & i & ".Groups." & j & ".GroupId=" & listGetAt(perm.Groups,j) />
				</cfloop>				
			</cfif>
			
			<cfif structKeyExists(perm,'IpRanges')>
				<cfloop from="1" to="#listLen(perm.IpRanges)#" index="k">
					<cfset body &= "&IpPermissions." & i & ".IpRanges." & k & ".CidrIp=" & listGetAt(perm.IpRanges,k) />
				</cfloop>			
			</cfif>		
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
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="RevokeSecurityGroupIngress" access="public" returntype="Struct" >    
    		<cfargument name="IpPermissions" type="array" required="true" > 
    		<cfargument name="GroupId" type="string" required="false" default="" />
    		<cfargument name="GroupName" type="string" required="false" default="" />
    					    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=RevokeSecurityGroupIngress&IpPermissions=" & trim(arguments.IpPermissions)/>    
    		  
		<cfif len(trim(arguments.GroupId))>    
    			<cfset body &= "&GroupId=" & trim(arguments.GroupId) />    
    		</cfif>	
		
		<cfif len(trim(arguments.GroupId))>    
    			<cfset body &= "&GroupId=" & trim(arguments.GroupId) />    
    		</cfif>	
				  
		<cfloop from="1" to="#arrayLen(arguments.IpPermissions)#" index="i">
			<cfset perm=arguments.IpPermissions[i] />
				
			<cfif structKeyExists(perm,'FromPort')>
				<cfset body &= "&IpPermissions." & i & ".FromPort=" & perm.FromPort />			
			</cfif>
			
			<cfif structKeyExists(perm,'ToPort')>
				<cfset body &= "&IpPermissions." & i & ".ToPort=" & perm.ToPort />			
			</cfif>
			
			<cfif structKeyExists(perm,'Groups')>
				<cfloop from="1" to="#listLen(perm.Groups)#" index="j">
					<cfset body &= "&IpPermissions." & i & ".Groups." & j & ".GroupId=" & listGetAt(perm.Groups,j) />
				</cfloop>				
			</cfif>
			
			<cfif structKeyExists(perm,'IpRanges')>
				<cfloop from="1" to="#listLen(perm.IpRanges)#" index="k">
					<cfset body &= "&IpPermissions." & i & ".IpRanges." & k & ".CidrIp=" & listGetAt(perm.IpRanges,k) />
				</cfloop>			
			</cfif>		
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
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="RunInstances" access="public" returntype="Struct" >    
    		<cfargument name="ImageId" type="string" required="true" >    
    		<cfargument name="MinCount" type="string" required="true" >    
    		<cfargument name="MaxCount" type="string" required="true" >    
    		<cfargument name="KeyName" type="string" required="false" default="" >    
    		<cfargument name="SecurityGroupId" type="string" required="false" default="" >    
    		<cfargument name="SecurityGroup" type="string" required="false" default="" >    
    		<cfargument name="UserData" type="string" required="false" default="" >    
    		<cfargument name="AddressingType" type="string" required="false" default="" >    
    		<cfargument name="InstanceType" type="string" required="false" default="" >    
    		<cfargument name="AvailabilityZone" type="string" required="false" default="" >    
    		<cfargument name="GroupName" type="string" required="false" default="" >    
    		<cfargument name="Tenancy" type="string" required="false" default="" >    
    		<cfargument name="KernelId" type="string" required="false" default="" >    
    		<cfargument name="RamdiskId" type="string" required="false" default="" >    
    		<cfargument name="BlockDeviceMapping" type="array" required="false" default="" >    
    		<cfargument name="Monitoring" type="string" required="false" default="" >    
    		<cfargument name="SubnetId" type="string" required="false" default="" >    
    		<cfargument name="DisableApiTermination" type="string" required="false" default="" >    
    		<cfargument name="InstanceInitiatedShutdownBehavior" type="string" required="false" default="" >    
    		<cfargument name="PrivateIpAddress" type="string" required="false" default="" >    
    		<cfargument name="ClientToken" type="string" required="false" default="" >    
    		<cfargument name="NetworkInterface" type="array" required="false" default="" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=RunInstances&ImageId=" & trim(arguments.ImageId) & "&MinCount=" & trim(arguments.MinCount) & "&MaxCount=" & trim(arguments.MaxCount)/>    
    		    
    		<cfif len(trim(arguments.KeyName))>    
    			<cfset body &= "&KeyName=" & trim(arguments.KeyName) />    
    		</cfif>	    
    		  
    		 <cfloop from="1" to="#listLen(arguments.SecurityGroupId)#" index="i">
			<cfset body &= "&SecurityGroupId." & i & "=" & listGetAt(arguments.SecurityGroupId,i) />
		</cfloop>   
		
		<cfloop from="1" to="#listLen(arguments.SecurityGroup)#" index="j">
			<cfset body &= "&SecurityGroup." & j & "=" & listGetAt(arguments.SecurityGroup,j) />
		</cfloop> 
		
		<cfif len(trim(arguments.UserData))>    
    			<cfset body &= "&UserData=" & trim(arguments.UserData) />    
    		</cfif>
    		
    		<cfif len(trim(arguments.AddressingType))>    
    			<cfset body &= "&AddressingType=" & trim(arguments.AddressingType) />    
    		</cfif>
    		
    		<cfif len(trim(arguments.InstanceType))>    
    			<cfset body &= "&InstanceType=" & trim(arguments.InstanceType) />    
    		</cfif>
    		
    		<cfif len(trim(arguments.AvailabilityZone))>    
    			<cfset body &= "&Placement.AvailabilityZone=" & trim(arguments.AvailabilityZone) />    
    		</cfif>
    		
    		<cfif len(trim(arguments.GroupName))>    
    			<cfset body &= "&Placement.GroupName=" & trim(arguments.GroupName) />    
    		</cfif>
    		
    		<cfif len(trim(arguments.Tenancy))>    
    			<cfset body &= "&Placement.Tenancy=" & trim(arguments.Tenancy) />    
    		</cfif>
    		
    		<cfif len(trim(arguments.KernelId))>    
    			<cfset body &= "&KernelId=" & trim(arguments.KernelId) />    
    		</cfif>
    		
    		<cfif len(trim(arguments.RamdiskId))>    
    			<cfset body &= "&RamdiskId=" & trim(arguments.RamdiskId) />    
    		</cfif>
    		
    		<cfif len(trim(arguments.Monitoring))>    
    			<cfset body &= "&Monitoring.Enabled=" & trim(arguments.Monitoring) />    
    		</cfif>
    		
    		<cfif len(trim(arguments.SubnetId))>    
    			<cfset body &= "&SubnetId=" & trim(arguments.SubnetId) />    
    		</cfif>
    		
    		<cfif len(trim(arguments.DisableApiTermination))>    
    			<cfset body &= "&DisableApiTermination=" & trim(arguments.DisableApiTermination) />    
    		</cfif>
    		
    		<cfif len(trim(arguments.InstanceInitiatedShutdownBehavior))>    
    			<cfset body &= "&InstanceInitiatedShutdownBehavior=" & trim(arguments.InstanceInitiatedShutdownBehavior) />    
    		</cfif>
    		
    		<cfif len(trim(arguments.PrivateIpAddress))>    
    			<cfset body &= "&PrivateIpAddress=" & trim(arguments.PrivateIpAddress) />    
    		</cfif>
    		
    		<cfif len(trim(arguments.ClientToken))>    
    			<cfset body &= "&ClientToken=" & trim(arguments.ClientToken) />    
    		</cfif>
    		
    		<cfloop from="1" to="#arrayLen(arguments.BlockDeviceMapping)#" index="i">
			<cfset mapping = arguments.BlockDeviceMapping[i] />
			
			<cfif structKeyExists(mapping,'DeviceName')>
				<cfset body &= "&BlockDeviceMapping." & i & ".BlockDeviceMapping=" & trim(mapping.BlockDeviceMapping) />
			</cfif>
			
			<cfif structKeyExists(mapping,'VirtualName')>
				<cfset body &= "&BlockDeviceMapping." & i & ".VirtualName=" & trim(mapping.VirtualName) />
			</cfif>
			
			<cfif structKeyExists(mapping.ebs,'SnapshotId')>
				<cfset body &= "&BlockDeviceMapping." & i & ".Ebs.SnapshotId=" & trim(mapping.ebs.SnapshotId) />
			</cfif>
			
			<cfif structKeyExists(mapping.ebs,'VolumeSize')>
				<cfset body &= "&BlockDeviceMapping." & i & ".Ebs.VolumeSize=" & trim(mapping.ebs.VolumeSize) />
			</cfif>
			
			<cfif structKeyExists(mapping.ebs,'NoDevice')>
				<cfset body &= "&BlockDeviceMapping." & i & ".Ebs.NoDevice=" & trim(mapping.ebs.NoDevice) />
			</cfif>
			
			<cfif structKeyExists(mapping.ebs,'DeleteOnTermination')>
				<cfset body &= "&BlockDeviceMapping." & i & ".Ebs.DeleteOnTermination=" & trim(mapping.ebs.DeleteOnTermination) />
			</cfif>
		</cfloop>
    		
    		<cfloop from="1" to="#arrayLen(arguments.NetworkInterface)#" index="n">
			<cfset NetworkInterface = arguments.NetworkInterface[n] />
			
			<cfif structKeyExists(NetworkInterface,'NetworkInterfaceId')>
				<cfset body &= "&NetworkInterface." & n & ".NetworkInterfaceId=" & trim(NetworkInterface.NetworkInterfaceId) />
			</cfif>
			
			<cfif structKeyExists(NetworkInterface,'DeviceIndex')>
				<cfset body &= "&NetworkInterface." & n & ".DeviceIndex=" & trim(NetworkInterface.DeviceIndex) />
			</cfif>
			
			<cfif structKeyExists(NetworkInterface,'SubnetId')>
				<cfset body &= "&NetworkInterface." & n & ".SubnetId=" & trim(NetworkInterface.SubnetId) />
			</cfif>
				
				<cfif structKeyExists(NetworkInterface,'Description')>
				<cfset body &= "&NetworkInterface." & n & ".Description=" & trim(NetworkInterface.Description) />
			</cfif>
			
			<cfif structKeyExists(NetworkInterface,'SecurityGroupId')>
				<cfloop from="1" to="#listLen(NetworkInterface.SecurityGroupId)#" index="p">
					<cfset body &= "&NetworkInterface." & n & ".SecurityGroupId." & p & "=" & trim(listgetat(NetworkInterface.SecurityGroupId,p)) />
				</cfloop>
			</cfif>
			
			<cfif structKeyExists(NetworkInterface,'DeleteOnTermination')>
				<cfset body &= "&NetworkInterface." & n & ".DeleteOnTermination=" & trim(NetworkInterface.DeleteOnTermination) />
			</cfif>
			
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'RunInstancesResponse')[1] />    
    			<cfset stResponse.result = {
										reservationId=getValue(dataResult,'dataResult'),
										ownerId=getValue(dataResult,'ownerId'),
										groupSet=[],
										instancesSet=[],
										requesterId=getValue(dataResult,'requesterId')
									} />	    
    	    
    	   	 	<cfloop array="#dataResult.groupSet.xmlChildren#" index="result">
				<cfset arrayAppend(stResponse.result.groupSet,createGroupItemTypeObject(result)) />
			</cfloop>
			
			<cfloop array="#dataResult.instancesSet.xmlChildren#" index="result">
				<cfset arrayAppend(stResponse.result.instancesSet,createRunningInstancesItemTypeObject(result)) />
			</cfloop>
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="StartInstances" access="public" returntype="Struct" >    
    		<cfargument name="InstanceId" type="string" required="true" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=StartInstances"/>    
    		    
    		<cfloop from="1" to="#listLen(arguments.InstanceId)#" index="i">    
    			<cfset body &= "&InstanceId." & i & "=" & trim(listGetAt(arguments.InstanceId,i)) />    
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'instancesSet')[1].xmlChildren />    
    			<cfset stResponse.result = [] />	    
    	    
			<cfloop array="#dataResult#" index="result">
				<cfset arrayAppend(stResponse.result,createInstanceStateChangeTypeObject(result)) />
			</cfloop>
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="StopInstances" access="public" returntype="Struct" >    
    		<cfargument name="InstanceId" type="string" required="true" >    
    		<cfargument name="Force" type="string" required="false" default="" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=StopInstances"/>    
    		
		<cfloop from="1" to="#listLen(arguments.InstanceId)#" index="i">    
    			<cfset body &= "&InstanceId." & i & "=" & trim(listGetAt(arguments.InstanceId,i)) />    
    		</cfloop>
			    
    		<cfif len(trim(arguments.Force))>    
    			<cfset body &= "&Force=" & trim(arguments.Force) />    
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'instancesSet')[1].xmlChildren />    
    			<cfset stResponse.result = [] />	    
    	    
			<cfloop array="#dataResult#" index="result">
				<cfset arrayAppend(stResponse.result,createInstanceStateChangeTypeObject(result)) />
			</cfloop>
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="TerminateInstances" access="public" returntype="Struct" >    
    		<cfargument name="InstanceId" type="string" required="true" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=TerminateInstances"/>    
    		
		<cfloop from="1" to="#listLen(arguments.InstanceId)#" index="i">    
    			<cfset body &= "&InstanceId." & i & "=" & trim(listGetAt(arguments.InstanceId,i)) />    
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'instancesSet')[1].xmlChildren />    
    			<cfset stResponse.result = [] />	    
    	    
			<cfloop array="#dataResult#" index="result">
				<cfset arrayAppend(stResponse.result,createInstanceStateChangeTypeObject(result)) />
			</cfloop>
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="UnmonitorInstances" access="public" returntype="Struct" >    
    		<cfargument name="InstanceId" type="string" required="true" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=UnmonitorInstances"/>    
    		    
    		 <cfloop from="1" to="#listLen(arguments.InstanceId)#" index="i">    
    			<cfset body &= "&InstanceId." & i & "=" & trim(listGetAt(arguments.InstanceId,i)) />    
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'instancesSet')[1].xmlChildren />    
    			<cfset stResponse.result = [] />	    
    	    
			<cfloop array="#dataResult#" index="result">
				<cfset arrayAppend(stResponse.result,createInstanceStateChangeTypeObject(result)) />
			</cfloop>
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>
    	
    		<!--- Object Creation --->
		
		
	<cffunction name="createAttachmentSetItemResponseTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						volumeId=getValue(arguments.stXML,'volumeId'),
						instanceId=getValue(arguments.stXML,'instanceId'),
						device=getValue(arguments.stXML,'device'),
						status=getValue(arguments.stXML,'status'),
						attachTime=getValue(arguments.stXML,'attachTime'),
						deleteOnTermination=getValue(arguments.stXML,'deleteOnTermination')
					} />
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createAttachmentTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						vpcId=getValue(arguments.stXML,'vpcId'),
						state=getValue(arguments.stXML,'state')
					} />
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createAvailabilityZoneItemTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						zoneName=getValue(arguments.stXML,'zoneName'),
						zoneState=getValue(arguments.stXML,'zoneState'),
						regionName=getValue(arguments.stXML,'regionName'),
						messageSet=[]
					} />
		
		<cfloop array="#arguments.stXml.messageSet.xmlChildren#" index="result">
			<cfset arrayAppend(response.messageSet,createAvailabilityZoneMessageTypeObject(result)) />		
		</cfloop>		
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createAvailabilityZoneMessageTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						message=getValue(arguments.stXML,'message')
					} />
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createBlockDeviceMappingItemTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						deviceName=getValue(arguments.stXML,'deviceName'),
						virtualName=getValue(arguments.stXML,'virtualName'),
						ebs=createEbsBlockDeviceTypeObject(arguments.stXML.ebs),
						noDevice=getValue(arguments.stXML,'noDevice')
					} />
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createBundleInstanceS3StorageTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						awsAccessKeyId=getValue(arguments.stXML,'awsAccessKeyId'),
						bucket=getValue(arguments.stXML,'bucket'),
						prefix=getValue(arguments.stXML,'prefix'),
						uploadPolicy=getValue(arguments.stXML,'uploadPolicy'),
						uploadPolicySignature=getValue(arguments.stXML,'uploadPolicySignature')
					} />
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createBundleInstanceTaskErrorTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						code=getValue(arguments.stXML,'code'),
						message=getValue(arguments.stXML,'message')
					} />
		
		<cfreturn response />	
	</cffunction>	
	
	<cffunction name="createBundleInstanceTaskStorageTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						S3=createBundleInstanceS3StorageTypeObject(arguments.stXML.S3)
					} />
		
		<cfreturn response />	
	</cffunction>
	 
	 <cffunction name="createBundleInstanceTaskTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						instanceId=getValue(arguments.stXML,'instanceId'),
						bundleId=getValue(arguments.stXML,'bundleId'),
						state=getValue(arguments.stXML,'state'),
						startTime=getValue(arguments.stXML,'startTime'),
						updateTime=getValue(arguments.stXML,'updateTime'),
						storage=createBundleInstanceTaskStorageTypeObject(arguments.stXML.storage),
						progress=getValue(arguments.stXML,'progress')
					} />
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createCancelSpotInstanceRequestsResponseSetItemTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						spotInstanceRequestId=getValue(arguments.stXML,'spotInstanceRequestId'),
						state=getValue(arguments.stXML,'state')
					} />
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createConversionTaskTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						conversionTaskId=getValue(arguments.stXML,'conversionTaskId'),
						expirationTime=getValue(arguments.stXML,'expirationTime'),
						importVolume={},
						importInstance={},
						state=getValue(arguments.stXML,'state'),
						statusMessage=getValue(arguments.stXML,'statusMessage')
					} />
					
		<cfif structKeyExists(arguments.stXml,'importVolume')>
			<cfset response.importVolume = createConversionTaskTypeObject(arguments.stXml.importVolume) />
		</cfif>	
		
		<cfif structKeyExists(arguments.stXml,'importInstance')>
			<cfset response.importInstance = createImportInstanceTaskDetailsTypeObject(arguments.stXml.importInstance) />
		</cfif>	
		<cfreturn response />	
	</cffunction>	
	
	<cffunction name="createCreateVolumePermissionItemTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						userId=getValue(arguments.stXML,'userId'),
						group=getValue(arguments.stXML,'group')
					} />
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createCustomerGatewayTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						customerGatewayId=getValue(arguments.stXML,'customerGatewayId'),
						state=getValue(arguments.stXML,'state'),
						type=getValue(arguments.stXML,'type'),
						ipAddress=getValue(arguments.stXML,'ipAddress'),
						bgpAsn=getValue(arguments.stXML,'bgpAsn'),
						tagSet=[]
					} />
					
		<cfloop array="#arguments.stXML.tagSet.xmlChildren#" index="result">
			<cfset arrayAppend(response.tagSet,createResourceTagSetItemTypeObject(result)) />	
		</cfloop>		
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createDescribeAddressesResponseItemTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						publicIp=getValue(arguments.stXML,'publicIp'),
						allocationId=getValue(arguments.stXML,'allocationId'),
						domain=getValue(arguments.stXML,'domain'),
						instanceId=getValue(arguments.stXML,'instanceId'),
						associationId=getValue(arguments.stXML,'associationId'),
						networkInterfaceId=getValue(arguments.stXML,'networkInterfaceId'),
						networkInterfaceOwnerId=getValue(arguments.stXML,'networkInterfaceOwnerId')
					} />
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createDescribeImagesResponseItemTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						imageId=getValue(arguments.stXML,'imageId'),
						imageLocation=getValue(arguments.stXML,'imageLocation'),
						imageState=getValue(arguments.stXML,'imageState'),
						imageOwnerId=getValue(arguments.stXML,'imageOwnerId'),
						isPublic=getValue(arguments.stXML,'isPublic'),
						productCodes=[],
						architecture=getValue(arguments.stXML,'architecture'),
						imageType=getValue(arguments.stXML,'imageType'),
						kernelId=getValue(arguments.stXML,'kernelId'),
						ramdiskId=getValue(arguments.stXML,'ramdiskId'),
						platform=getValue(arguments.stXML,'platform'),
						stateReason=createStateReasonTypeObject(arguments.stXML.stateReason),
						imageOwnerAlias=getValue(arguments.stXML,'imageOwnerAlias'),
						name=getValue(arguments.stXML,'name'),
						description=getValue(arguments.stXML,'description'),
						rootDeviceType=getValue(arguments.stXML,'rootDeviceType'),
						rootDeviceName=getValue(arguments.stXML,'rootDeviceName'),
						blockDeviceMapping=[],
						virtualizationType=getValue(arguments.stXML,'virtualizationType'),
						tagSet=[],
						hypervisor=getValue(arguments.stXML,'networkInterfaceOwnerId')
					} />
					
		<cfloop array="#arguments.stXML.productCodes.xmlChildren#" index="result">
			<cfset arrayAppend(response.productCodes,createProductCodesSetItemTypeObject(result)) />	
		</cfloop>
		
		<cfloop array="#arguments.stXML.blockDeviceMapping.xmlChildren#" index="result">
			<cfset arrayAppend(response.blockDeviceMapping,createBlockDeviceMappingItemTypeObject(result)) />	
		</cfloop>

		<cfloop array="#arguments.stXML.tagSet.xmlChildren#" index="result">
			<cfset arrayAppend(response.tagSet,createResourceTagSetItemTypeObject(result)) />	
		</cfloop>
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createDescribeKeyPairsResponseItemTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						keyName=getValue(arguments.stXML,'keyName'),
						keyFingerprint=getValue(arguments.stXML,'keyFingerprint')
					} />
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createDescribeReservedInstancesOfferingsResponseSetItemTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						reservedInstancesOfferingId=getValue(arguments.stXML,'reservedInstancesOfferingId'),
						instanceType=getValue(arguments.stXML,'instanceType'),
						availabilityZone=getValue(arguments.stXML,'availabilityZone'),
						duration=getValue(arguments.stXML,'duration'),
						fixedPrice=getValue(arguments.stXML,'fixedPrice'),
						usagePrice=getValue(arguments.stXML,'usagePrice'),
						productDescription=getValue(arguments.stXML,'productDescription'),
						instanceTenancy=getValue(arguments.stXML,'instanceTenancy'),
						currencyCode=getValue(arguments.stXML,'currencyCode'),
						offeringType=getValue(arguments.stXML,'offeringType'),
						recurringCharges=createRecurringChargesSetItemTypeObject(arguments.stXML.recurringCharges)
					} />
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createDescribeReservedInstancesResponseSetItemTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						reservedInstancesId=getValue(arguments.stXML,'reservedInstancesId'),
						instanceType=getValue(arguments.stXML,'instanceType'),
						availabilityZone=getValue(arguments.stXML,'availabilityZone'),
						start=getValue(arguments.stXML,'start'),
						duration=getValue(arguments.stXML,'duration'),
						fixedPrice=getValue(arguments.stXML,'fixedPrice'),
						usagePrice=getValue(arguments.stXML,'usagePrice'),
						instanceCount=getValue(arguments.stXML,'instanceCount'),
						productDescription=getValue(arguments.stXML,'productDescription'),
						state=getValue(arguments.stXML,'state'),
						tagSet=[],
						instanceTenancy=getValue(arguments.stXML,'instanceTenancy'),
						currencyCode=getValue(arguments.stXML,'currencyCode'),
						offeringType=getValue(arguments.stXML,'offeringType'),
						instanceType=[]
					} />
		
		<cfloop array="#arguments.stXML.tagSet.xmlChildren#" index="result">
			<cfset arrayAppend(response.tagSet,createResourceTagSetItemTypeObject(result)) />	
		</cfloop>
		
		<cfloop array="#arguments.stXML.instanceType.xmlChildren#" index="result">
			<cfset arrayAppend(response.instanceType,createRecurringChargesSetItemTypeObject(result)) />	
		</cfloop>
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createDescribeSnapshotsSetItemResponseTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						snapshotId=getValue(arguments.stXML,'snapshotId'),
						volumeId=getValue(arguments.stXML,'volumeId'),
						status=getValue(arguments.stXML,'status'),
						startTime=getValue(arguments.stXML,'startTime'),
						progress=getValue(arguments.stXML,'progress'),
						ownerId=getValue(arguments.stXML,'ownerId'),
						volumeSize=getValue(arguments.stXML,'volumeSize'),
						description=getValue(arguments.stXML,'description'),
						ownerAlias=getValue(arguments.stXML,'ownerAlias'),
						tagSet=[]
					} />
		
		<cfloop array="#arguments.stXML.tagSet.xmlChildren#" index="result">
			<cfset arrayAppend(response.tagSet,createResourceTagSetItemTypeObject(result)) />	
		</cfloop>
			
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createDescribeVolumesSetItemResponseTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						volumeId=getValue(arguments.stXML,'volumeId'),
						size=getValue(arguments.stXML,'size'),
						snapshotId=getValue(arguments.stXML,'snapshotId'),
						availabilityZone=getValue(arguments.stXML,'availabilityZone'),
						status=getValue(arguments.stXML,'status'),
						createTime=getValue(arguments.stXML,'createTime'),
						attachmentSet=[],
						tagSet=[]
					} />
		
		<cfloop array="#arguments.stXML.attachmentSet.xmlChildren#" index="result">
			<cfset arrayAppend(response.attachmentSet,createAttachmentSetItemResponseTypeObject(result)) />	
		</cfloop>

		<cfloop array="#arguments.stXML.tagSet.xmlChildren#" index="result">
			<cfset arrayAppend(response.tagSet,createResourceTagSetItemTypeObject(result)) />	
		</cfloop>
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createDhcpConfigurationItemTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						key=getValue(arguments.stXML,'key'),
						valueSet=[]
					} />
					
		<cfloop array="#arguments.stXML.valueSet.xmlChildren#" index="result">
			<cfset arrayAppend(response.valueSet,createDhcpValueTypeObject(result)) />	
		</cfloop>
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createDhcpOptionsTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						dhcpOptionsId=getValue(arguments.stXML,'dhcpOptionsId'),
						dhcpConfigurationSet=[],
						tagSet=[]
					} />
					
		<cfloop array="#arguments.stXML.dhcpConfigurationSet.xmlChildren#" index="result">
			<cfset arrayAppend(response.dhcpConfigurationSet,createDhcpConfigurationItemTypeObject(result)) />	
		</cfloop>
		
		<cfloop array="#arguments.stXML.tagSet.xmlChildren#" index="result">
			<cfset arrayAppend(response.tagSet,createResourceTagSetItemTypeObject(result)) />	
		</cfloop>
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createDhcpValueTypeObject" access="public" returntype="String" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= getValue(arguments.stXML,'value') />

		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createDiskImageDescriptionTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						format=getValue(arguments.stXML,'format'),
						size=getValue(arguments.stXML,'size'),
						importManifestUrl=getValue(arguments.stXML,'importManifestUrl'),
						checksum=getValue(arguments.stXML,'checksum')
					} />
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createDiskImageVolumeDescriptionTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						size=getValue(arguments.stXML,'size'),
						id=getValue(arguments.stXML,'id')
					} />
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createEbsBlockDeviceTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						snapshotId=getValue(arguments.stXML,'snapshotId'),
						volumeSize=getValue(arguments.stXML,'volumeSize'),
						deleteOnTermination=getValue(arguments.stXML,'deleteOnTermination')
					} />
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createEbsInstanceBlockDeviceMappingResponseTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						volumeId=getValue(arguments.stXML,'volumeId'),
						status=getValue(arguments.stXML,'status'),
						attachTime=getValue(arguments.stXML,'attachTime'),
						deleteOnTermination=getValue(arguments.stXML,'deleteOnTermination')
					} />
		
		<cfreturn response />	
	</cffunction>	
	
	<cffunction name="createGroupItemTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						groupId=getValue(arguments.stXML,'groupId'),
						groupName=getValue(arguments.stXML,'groupName')
					} />
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createIcmpTypeCodeTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						code=getValue(arguments.stXML,'code'),
						type=getValue(arguments.stXML,'type')
					} />
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createImportInstanceTaskDetailsTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						volumes=[],
						instanceId=getValue(arguments.stXML,'instanceId'),
						platform=getValue(arguments.stXML,'platform'),
						description=getValue(arguments.stXML,'description')
					} />
		
		<cfloop array="#arguments.stXML.volumes.xmlChildren#" index="result">
			<cfset arrayAppend(response.volumes,createImportInstanceVolumeDetailItemTypeObject(result)) />	
		</cfloop>
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createImportInstanceVolumeDetailItemTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						bytesConverted=getValue(arguments.stXML,'bytesConverted'),
						availabilityZone=getValue(arguments.stXML,'availabilityZone'),
						image=createDiskImageDescriptionTypeObject(arguments.stXML.image),
						description=getValue(arguments.stXML,'description'),
						volume=createDiskImageVolumeDescriptionTypeObject(arguments.stXML.volume),
						status=getValue(arguments.stXML,'status'),
						statusMessage=getValue(arguments.stXML,'statusMessage')
					} />
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createImportVolumeTaskDetailsTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						bytesConverted=getValue(arguments.stXML,'bytesConverted'),
						availabilityZone=getValue(arguments.stXML,'availabilityZone'),
						image=createDiskImageDescriptionTypeObject(arguments.stXML.image),
						description=getValue(arguments.stXML,'description'),
						volume=createDiskImageVolumeDescriptionTypeObject(arguments.stXML.volume)
					} />
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createInstanceBlockDeviceMappingItemTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						deviceName=getValue(arguments.stXML,'deviceName'),
						virtualName=getValue(arguments.stXML,'virtualName'),
						ebs=createInstanceEbsBlockDeviceTypeObject(arguments.stXML.ebs),
						noDevice=getValue(arguments.stXML,'noDevice')
					} />
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createInstanceBlockDeviceMappingResponseItemTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						deviceName=getValue(arguments.stXML,'deviceName'),
						ebs=createEbsInstanceBlockDeviceMappingResponseTypeObject(arguments.stXML.ebs)
					} />
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createInstanceEbsBlockDeviceTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						deleteOnTermination=getValue(arguments.stXML,'deleteOnTermination'),
						volumeId=getValue(arguments.stXML,'volumeId')
					} />
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createInstanceStatusEventsSetTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= createInstanceStatusEventTypeObject(arguments.stXML.item) />
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createInstanceStatusEventTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						code=getValue(arguments.stXML,'code'),
						description=getValue(arguments.stXML,'description'),
						notBefore=getValue(arguments.stXML,'notBefore'),
						notAfter=getValue(arguments.stXML,'notAfter')
					} />
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createInstanceStatusItemTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						instanceId=getValue(arguments.stXML,'instanceId'),
						availabilityZone=getValue(arguments.stXML,'availabilityZone'),
						eventsSet=createInstanceStatusEventsSetTypeObject(arguments.stXML.eventsSet),
						instanceState=createInstanceStateTypeObject(arguments.stXML.instanceState)
					} />
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createInstanceStatusSetTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= createInstanceStatusEventTypeObject(arguments.stXML.item) />
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createInstanceStatusDetailsSetTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						name=getValue(arguments.stXML,'name'),
						status=getValue(arguments.stXML,'status')
					} />
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createInstanceStatusTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						status=getValue(arguments.stXML,'status'),
						details=createInstanceStatusDetailsSetTypeObject(arguments.stXML.details)
					} />
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createInstanceMonitoringStateTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= getValue(arguments.stXML,'state')  />
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createInstanceNetworkInterfaceSetItemRequestTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						networkInterfaceId=getValue(arguments.stXML,'networkInterfaceId'),
						deviceIndex=getValue(arguments.stXML,'deviceIndex'),
						subnetId=getValue(arguments.stXML,'subnetId'),
						description=getValue(arguments.stXML,'description'),
						privateIpAddress=getValue(arguments.stXML,'privateIpAddress'),
						groupSet=createSecurityGroupIdSetItemTypeObject(arguments.stXML.groupSet),
						deleteOnTermination=getValue(arguments.stXML,'deleteOnTermination')
					} />
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createInstanceNetworkInterfaceSetItemTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						networkInterfaceId=getValue(arguments.stXML,'networkInterfaceId'),
						subnetId=getValue(arguments.stXML,'subnetId'),
						vpcId=getValue(arguments.stXML,'vpcId'),
						description=getValue(arguments.stXML,'description'),
						ownerId=getValue(arguments.stXML,'ownerId'),
						status=getValue(arguments.stXML,'status'),
						privateIpAddress=getValue(arguments.stXML,'privateIpAddress'),
						privateDnsName=getValue(arguments.stXML,'privateDnsName'),
						sourceDestCheck=getValue(arguments.stXML,'sourceDestCheck'),
						groupSet=createGroupItemTypeObject(arguments.stXML.groupSet),
						attachment=createNetworkInterfaceAttachmentTypeObject(arguments.stXML.attachment),
						association=createNetworkInterfaceAssociationTypeObject(arguments.stXML.association)
					} />
		
		<cfreturn response />	
	</cffunction>

	<cffunction name="createInstanceNetworkInterfaceSetRequestTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						networkInterfaceId=getValue(arguments.stXML,'networkInterfaceId'),
						deviceIndex=getValue(arguments.stXML,'deviceIndex'),
						subnetId=getValue(arguments.stXML,'subnetId'),
						description=getValue(arguments.stXML,'description'),
						privateIpAddress=getValue(arguments.stXML,'privateIpAddress'),
						groupSet=createSecurityGroupIdTypeObject(arguments.stXML.groupSet),
						deleteOnTermination=getValue(arguments.stXML,'deleteOnTermination')
					} />
		
		<cfreturn response />	
	</cffunction>

	<cffunction name="createInstanceNetworkInterfaceSetTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						networkInterfaceId=getValue(arguments.stXML,'networkInterfaceId'),
						subnetId=getValue(arguments.stXML,'subnetId'),
						vpcId=getValue(arguments.stXML,'vpcId'),
						description=getValue(arguments.stXML,'description'),
						ownerId=getValue(arguments.stXML,'ownerId'),
						status=getValue(arguments.stXML,'status'),
						privateIpAddress=getValue(arguments.stXML,'privateIpAddress'),
						privateDnsName=getValue(arguments.stXML,'privateDnsName'),
						sourceDestCheck=getValue(arguments.stXML,'sourceDestCheck'),
						groupSet=[],
						attachment=createNetworkInterfaceAttachmentTypeObject(arguments.stXML.attachment),
						association=createNetworkInterfaceAssociationTypeObject(arguments.stXML.association),
						publicIp=getValue(arguments.stXML,'publicIp'),
						ipOwnerId=getValue(arguments.stXML,'ipOwnerId')
					} />
					
		<cfloop array="#arguments.stXML.groupSet.xmlChildren#" index="result">
			<cfset arrayAppend(response.groupSet,createGroupItemTypeObject(result)) />	
		</cfloop>
		
		<cfreturn response />	
	</cffunction>

	<cffunction name="createInstanceStateChangeTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						instanceId=getValue(arguments.stXML,'instanceId'),
						currentState=createInstanceStateTypeObject(arguments.stXML.currentState),
						previousState=createInstanceStateTypeObject(arguments.stXML.previousState)
					} />
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createInstanceStateTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						code=getValue(arguments.stXML,'code'),
						name=getValue(arguments.stXML,'name')
					} />
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createInternetGatewayAttachmentTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						vpcId=getValue(arguments.stXML,'vpcId'),
						state=getValue(arguments.stXML,'state')
					} />
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createInternetGatewayTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						internetGatewayId=getValue(arguments.stXML,'internetGatewayId'),
						attachmentSet=[],
						tagSet=[]
					} />
		
		<cfloop array="#arguments.stXML.attachmentSet.xmlChildren#" index="result">
			<cfset arrayAppend(response.attachmentSet,createInternetGatewayAttachmentTypeObject(result)) />	
		</cfloop>

		<cfloop array="#arguments.stXML.tagSet.xmlChildren#" index="result">
			<cfset arrayAppend(response.tagSet,createResourceTagSetItemTypeObject(result)) />	
		</cfloop>
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createIpPermissionTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						ipProtocol=getValue(arguments.stXML,'ipProtocol'),
						fromPort=getValue(arguments.stXML,'fromPort'),
						toPort=getValue(arguments.stXML,'toPort'),
						groups=[],
						ipRanges=[]
					} />
		
		<cfloop array="#arguments.stXML.groups.xmlChildren#" index="result">
			<cfset arrayAppend(response.groups,createUserIdGroupPairTypeObject(result)) />	
		</cfloop>

		<cfloop array="#arguments.stXML.ipRanges.xmlChildren#" index="result">
			<cfset arrayAppend(response.ipRanges,createIpRangeItemTypeObject(result)) />	
		</cfloop>
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createIpRangeItemTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= getValue(arguments.stXML,'cidrIp') />
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createLaunchPermissionItemTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						group=getValue(arguments.stXML,'group'),
						userId=getValue(arguments.stXML,'userId')
					} />
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createLaunchSpecificationRequestTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						imageId=getValue(arguments.stXML,'imageId'),
						keyName=getValue(arguments.stXML,'keyName'),
						groupSet=[],
						userData=createUserDataTypeObject(arguments.stXML.userData),
						addressingType=getValue(arguments.stXML,'addressingType'),
						instanceType=getValue(arguments.stXML,'instanceType'),
						placement=createPlacementRequestTypeObject(arguments.stXML.placement),
						kernelId=getValue(arguments.stXML,'kernelId'),
						ramdiskId=getValue(arguments.stXML,'ramdiskId'),
						blockDeviceMapping=[],
						monitoring=createMonitoringInstanceTypeObject(arguments.stXML.monitoring),
						subnetId=getValue(arguments.stXML,'subnetId'),
						networkInterfaceSet=createInstanceNetworkInterfaceSetRequestTypeObject(arguments.stXML.networkInterfaceSet)
					} />
		
		<cfloop array="#arguments.stXML.groupSet.xmlChildren#" index="result">
			<cfset arrayAppend(response.groupSet,createGroupItemTypeObject(result)) />	
		</cfloop>
		
		<cfloop array="#arguments.stXML.blockDeviceMapping.xmlChildren#" index="result">
			<cfset arrayAppend(response.blockDeviceMapping,createBlockDeviceMappingItemTypeObject(result)) />	
		</cfloop>
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createLaunchSpecificationResponseTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						imageId=getValue(arguments.stXML,'imageId'),
						keyName=getValue(arguments.stXML,'keyName'),
						groupSet=[],
						addressingType=getValue(arguments.stXML,'addressingType'),
						instanceType=getValue(arguments.stXML,'instanceType'),
						placement=createPlacementRequestTypeObject(arguments.stXML.placement),
						kernelId=getValue(arguments.stXML,'kernelId'),
						ramdiskId=getValue(arguments.stXML,'ramdiskId'),
						blockDeviceMapping=[],
						monitoring=createMonitoringInstanceTypeObject(arguments.stXML.monitoring),
						subnetId=getValue(arguments.stXML,'subnetId'),
						networkInterfaceSet=createInstanceNetworkInterfaceSetRequestTypeObject(arguments.stXML.networkInterfaceSet)
					} />
		
		<cfloop array="#arguments.stXML.groupSet.xmlChildren#" index="result">
			<cfset arrayAppend(response.groupSet,createGroupItemTypeObject(result)) />	
		</cfloop>
		
		<cfloop array="#arguments.stXML.blockDeviceMapping.xmlChildren#" index="result">
			<cfset arrayAppend(response.blockDeviceMapping,createBlockDeviceMappingItemTypeObject(result)) />	
		</cfloop>
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createMonitoringInstanceTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= group=getValue(arguments.stXML,'enabled') />
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createMonitorInstancesResponseSetItemTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						instanceId=getValue(arguments.stXML,'instanceId'),
						monitoring=createInstanceMonitoringStateTypeObject(arguments.stXML.monitoring)
					} />
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createNetworkAclEntryTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						ruleNumber=getValue(arguments.stXML,'ruleNumber'),
						protocol=getValue(arguments.stXML,'protocol'),
						ruleAction=getValue(arguments.stXML,'ruleAction'),
						egress=getValue(arguments.stXML,'egress'),
						cidrBlock=getValue(arguments.stXML,'cidrBlock'),
						icmpTypeCode={},
						portRange={}
					} />
					
		<cfif structKeyExists(arguments.stXML,'icmpTypeCode')>
			<cfset response.icmpTypeCode=createIcmpTypeCodeTypeObject(arguments.stXML.icmpTypeCode) />
		</cfif>
		
		<cfif structKeyExists(arguments.stXML,'portRange')>
			<cfset response.portRange=createPortRangeTypeObject(arguments.stXML.portRange) />
		</cfif>	
			
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createNetworkAclTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						networkAclId=getValue(arguments.stXML,'networkAclId'),
						vpcId=getValue(arguments.stXML,'vpcId'),
						default=getValue(arguments.stXML,'default'),
						entrySet=[],
						associationSet=[],
						tagSet=[]
					} />
		
		<cfloop array="#arguments.stXML.entrySet.xmlChildren#" index="result">
			<cfset arrayAppend(response.entrySet,createNetworkAclEntryTypeObject(result)) />	
		</cfloop>
		
		<cfloop array="#arguments.stXML.associationSet.xmlChildren#" index="result">
			<cfset arrayAppend(response.associationSet,createNetworkAclAssociationTypeObject(result)) />	
		</cfloop>
		
		<cfloop array="#arguments.stXML.tagSet.xmlChildren#" index="result">
			<cfset arrayAppend(response.tagSet,createResourceTagSetItemTypeObject(result)) />	
		</cfloop>
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createNetworkAclAssociationTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						networkAclAssociationId=getValue(arguments.stXML,'networkAclAssociationId'),
						networkAclId=getValue(arguments.stXML,'networkAclId'),
						subnetId=getValue(arguments.stXML,'subnetId')
					} />
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createNetworkInterfaceAssociationTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						attachmentID=getValue(arguments.stXML,'attachmentID'),
						instanceID=getValue(arguments.stXML,'instanceID'),
						publicIp=getValue(arguments.stXML,'publicIp'),
						ipOwnerId=getValue(arguments.stXML,'ipOwnerId')
					} />
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createNetworkInterfaceSetObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						networkInterfaceId=getValue(arguments.stXML,'networkInterfaceId'),
						subnetId=getValue(arguments.stXML,'subnetId'),
						vpcId=getValue(arguments.stXML,'vpcId'),
						description=getValue(arguments.stXML,'description'),
						ownerId=getValue(arguments.stXML,'ownerId'),
						status=getValue(arguments.stXML,'status'),
						privateIpAddress=getValue(arguments.stXML,'privateIpAddress'),
						privateDnsName=getValue(arguments.stXML,'privateDnsName'),
						sourceDestCheck=getValue(arguments.stXML,'sourceDestCheck'),
						groupSet=createGroupItemTypeObject(arguments.stXML.groupSet),
						attachment=createNetworkInterfaceAttachmentTypeObject(arguments.stXML.attachment),
						association=createNetworkInterfaceAssociationTypeObject(arguments.stXML.association)
					} />
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createNetworkInterfaceAttachmentTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						attachmentID=getValue(arguments.stXML,'attachmentID'),
						instanceID=getValue(arguments.stXML,'instanceID')
					} />
		
		<cfreturn response />	
	</cffunction>

	<cffunction name="createNetworkInterfaceTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						networkInterfaceId=getValue(arguments.stXML,'networkInterfaceId'),
						subnetId=getValue(arguments.stXML,'subnetId'),
						vpcId=getValue(arguments.stXML,'vpcId'),
						availabilityZone=getValue(arguments.stXML,'availabilityZone'),
						description=getValue(arguments.stXML,'description'),
						ownerId=getValue(arguments.stXML,'ownerId'),
						requesterId=getValue(arguments.stXML,'requesterId'),
						requesterManaged=getValue(arguments.stXML,'requesterManaged'),
						status=getValue(arguments.stXML,'status'),
						macAddress=getValue(arguments.stXML,'macAddress'),
						privateIpAddress=getValue(arguments.stXML,'privateIpAddress'),
						privateDnsName=getValue(arguments.stXML,'privateDnsName'),
						sourceDestCheck=getValue(arguments.stXML,'sourceDestCheck'),
						groupSet=createGroupSetTypeObject(arguments.stXML.groupSet),
						attachment=createNetworkInterfaceAttachmentTypeObject(arguments.stXML.attachment),
						association=createNetworkInterfaceAssociationTypeObject(arguments.stXML.association),
						tagSet=createResourceTagSetItemTypeObject(arguments.stXML.tagSet)
					} />
		
		<cfreturn response />	
	</cffunction>

	<cffunction name="createPlacementGroupInfoTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						groupName=getValue(arguments.stXML,'groupName'),
						strategy=getValue(arguments.stXML,'strategy'),
						state=getValue(arguments.stXML,'state')
					} />
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createPlacementRequestTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						availabilityZone=getValue(arguments.stXML,'availabilityZone'),
						groupName=getValue(arguments.stXML,'groupName')
					} />
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createPlacementResponseTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						availabilityZone=getValue(arguments.stXML,'availabilityZone'),
						groupName=getValue(arguments.stXML,'groupName'),
						tenancy=getValue(arguments.stXML,'tenancy')
					} />
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createPortRangeTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						from=getValue(arguments.stXML,'from'),
						to=getValue(arguments.stXML,'to')
					} />
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createProductCodeItemTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= getValue(arguments.stXML,'productCode') />
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createProductCodesSetItemTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						productCode=getValue(arguments.stXML,'productCode'),
						type=getValue(arguments.stXML,'type')
					} />
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createProductDescriptionSetItemTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= getValue(arguments.stXML,'productDescription') />
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createRecurringChargesSetItemTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						frequency=getValue(arguments.stXML,'frequency'),
						amount=getValue(arguments.stXML,'amount')
					} />
		
		<cfreturn response />	
	</cffunction>

	<cffunction name="createRegionItemTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						regionName=getValue(arguments.stXML,'regionName'),
						regionEndpoint=getValue(arguments.stXML,'regionEndpoint')
					} />
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createReservationInfoTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						reservationId=getValue(arguments.stXML,'reservationId'),
						ownerId=getValue(arguments.stXML,'ownerId'),
						groupSet=[],
						instancesSet=[],
						requesterId=getValue(arguments.stXML,'requesterId')
					} />
		
		<cfloop array="#arguments.stXML.groupSet.xmlChildren#" index="result">
			<cfset arrayAppend(response.groupSet,createGroupItemTypeObject(result)) />	
		</cfloop>
		
		<cfloop array="#arguments.stXML.instancesSet.xmlChildren#" index="result">
			<cfset arrayAppend(response.instancesSet,createRunningInstancesItemTypeObject(result)) />	
		</cfloop>
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createResourceTagSetItemTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						key=getValue(arguments.stXML,'key'),
						value=getValue(arguments.stXML,'value')
					} />
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createRouteTableAssociationTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						routeTableAssociationId=getValue(arguments.stXML,'routeTableAssociationId'),
						routeTableId=getValue(arguments.stXML,'routeTableId'),
						subnetId=getValue(arguments.stXML,'subnetId'),
						main=getValue(arguments.stXML,'main')
					} />
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createRouteTableTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						routeTableId=getValue(arguments.stXML,'routeTableId'),
						vpcId=getValue(arguments.stXML,'vpcId'),
						routeSet=[],
						associationSet=[],
						tagSet=[]
					} />
		
		<cfloop array="#arguments.stXML.routeSet.xmlChildren#" index="result">
			<cfset arrayAppend(response.routeSet,createRouteTypeObject(result)) />	
		</cfloop>
		
		<cfloop array="#arguments.stXML.associationSet.xmlChildren#" index="result">
			<cfset arrayAppend(response.associationSet,createRouteTableAssociationTypeObject(result)) />	
		</cfloop>
		
		<cfloop array="#arguments.stXML.tagSet.xmlChildren#" index="result">
			<cfset arrayAppend(response.tagSet,createResourceTagSetItemTypeObject(result)) />	
		</cfloop>
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createRouteTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						destinationCidrBlock=getValue(arguments.stXML,'destinationCidrBlock'),
						gatewayId=getValue(arguments.stXML,'gatewayId'),
						instanceId=getValue(arguments.stXML,'instanceId'),
						instanceOwnerId=getValue(arguments.stXML,'instanceOwnerId'),
						networkInterfaceId=getValue(arguments.stXML,'networkInterfaceId'),
						state=getValue(arguments.stXML,'state')
					} />
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createRunningInstancesItemTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						instanceId=getValue(arguments.stXML,'instanceId'),
						imageId=getValue(arguments.stXML,'imageId'),
						instanceState=createInstanceStateTypeObject(arguments.stXML.instanceState),
						privateDnsName=getValue(arguments.stXML,'privateDnsName'),
						dnsName=getValue(arguments.stXML,'dnsName'),
						reason=getValue(arguments.stXML,'reason'),
						keyName=getValue(arguments.stXML,'keyName'),
						amiLaunchIndex=getValue(arguments.stXML,'amiLaunchIndex'),
						productCodes=[],
						instanceType=getValue(arguments.stXML,'instanceType'),
						launchTime=getValue(arguments.stXML,'launchTime'),
						placement=createPlacementResponseTypeObject(arguments.stXML.placement),
						kernelId=getValue(arguments.stXML,'kernelId'),
						ramdiskId=getValue(arguments.stXML,'ramdiskId'),
						platform=getValue(arguments.stXML,'platform'),
						monitoring=createInstanceMonitoringStateTypeObject(arguments.stXML.monitoring),
						subnetId=getValue(arguments.stXML,'subnetId'),
						vpcId=getValue(arguments.stXML,'vpcId'),
						privateIpAddress=getValue(arguments.stXML,'privateIpAddress'),
						ipAddress=getValue(arguments.stXML,'ipAddress'),
						sourceDestCheck=getValue(arguments.stXML,'sourceDestCheck'),
						groupSet=[],
						stateReason=createStateReasonTypeObject(arguments.stXML.stateReason),
						architecture=getValue(arguments.stXML,'architecture'),
						rootDeviceType=getValue(arguments.stXML,'rootDeviceType'),
						rootDeviceName=getValue(arguments.stXML,'rootDeviceName'),
						blockDeviceMapping=[],
						instanceLifecycle=getValue(arguments.stXML,'instanceLifecycle'),
						spotInstanceRequestId=getValue(arguments.stXML,'spotInstanceRequestId'),
						virtualizationType=getValue(arguments.stXML,'virtualizationType'),
						clientToken=getValue(arguments.stXML,'clientToken'),
						tagSet=[],
						hypervisor=getValue(arguments.stXML,'hypervisor'),
						networkInterfaceSet=createInstanceNetworkInterfaceSetTypeObject(arguments.stXML.networkInterfaceSet)
					} />
		
		<cfloop array="#arguments.stXML.productCodes.xmlChildren#" index="result">
			<cfset arrayAppend(response.productCodes,createProductCodesSetItemTypeObject(result)) />	
		</cfloop>
		
		<cfloop array="#arguments.stXML.groupSet.xmlChildren#" index="result">
			<cfset arrayAppend(response.groupSet,createGroupItemTypeObject(result)) />	
		</cfloop>
		
		<cfloop array="#arguments.stXML.blockDeviceMapping.xmlChildren#" index="result">
			<cfset arrayAppend(response.blockDeviceMapping,createInstanceBlockDeviceMappingResponseItemTypeObject(result)) />	
		</cfloop>
		
		<cfloop array="#arguments.stXML.tagSet.xmlChildren#" index="result">
			<cfset arrayAppend(response.tagSet,createResourceTagSetItemTypeObject(result)) />	
		</cfloop>
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createSecurityGroupIdSetItemTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= groupId=getValue(arguments.stXML,'groupId') />
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createSecurityGroupItemTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						ownerId=getValue(arguments.stXML,'ownerId'),
						groupId=getValue(arguments.stXML,'groupId'),
						groupName=getValue(arguments.stXML,'groupName'),
						groupDescription=getValue(arguments.stXML,'groupDescription'),
						vpcId=getValue(arguments.stXML,'vpcId'),
						ipPermissions=[],
						ipPermissionsEgress=[],
						tagSet=[]
					} />
					
		<cfloop array="#arguments.stXML.ipPermissions.xmlChildren#" index="result">
			<cfset arrayAppend(response.ipPermissions,createIpPermissionTypeObject(result)) />	
		</cfloop>
		
		<cfloop array="#arguments.stXML.ipPermissionsEgress.xmlChildren#" index="result">
			<cfset arrayAppend(response.ipPermissionsEgress,createIpPermissionTypeObject(result)) />	
		</cfloop>
		
		<cfloop array="#arguments.stXML.tagSet.xmlChildren#" index="result">
			<cfset arrayAppend(response.tagSet,createResourceTagSetItemTypeObject(result)) />	
		</cfloop>
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createSpotDatafeedSubscriptionTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						ownerId=getValue(arguments.stXML,'ownerId'),
						bucket=getValue(arguments.stXML,'bucket'),
						prefix=getValue(arguments.stXML,'prefix'),
						state=getValue(arguments.stXML,'state'),
						fault={}
					} />
					
		<cfif structkeyExists(arguments.stXML,'fault')>
			<cfset response.response = createSpotInstanceStateFaultTypeObject(arguments.stXML.fault) />
		</cfif>	
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createSpotInstanceRequestSetItemTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						spotInstanceRequestId=getValue(arguments.stXML,'spotInstanceRequestId'),
						spotPrice=getValue(arguments.stXML,'spotPrice'),
						type=getValue(arguments.stXML,'type'),
						state=getValue(arguments.stXML,'state'),
						fault={},
						validFrom=getValue(arguments.stXML,'validFrom'),
						validUntil=getValue(arguments.stXML,'validUntil'),
						launchGroup=getValue(arguments.stXML,'launchGroup'),
						availabilityZoneGroup=getValue(arguments.stXML,'availabilityZoneGroup'),
						launchedAvailabilityZone=getValue(arguments.stXML,'launchedAvailabilityZone'),
						launchSpecification=createLaunchSpecificationResponseTypeObject(arguments.stXML.launchSpecification),
						instanceId=getValue(arguments.stXML,'instanceId'),
						createTime=getValue(arguments.stXML,'createTime'),
						productDescription=getValue(arguments.stXML,'productDescription'),
						tagSet=[]
					} />
			
			<cfif StructKeyExists(arguments.stXML,'fault')>	
				<cfset response.fault = createSpotInstanceStateFaultTypeObject(arguments.stXML.fault) />
			</cfif>		
		
			<cfloop array="#arguments.stXML.tagSet.xmlChildren#" index="result">
				<cfset arrayAppend(response.tagSet,createResourceTagSetItemTypeObject(result)) />	
			</cfloop>
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createSpotInstanceStateFaultTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						code=getValue(arguments.stXML,'code'),
						message=getValue(arguments.stXML,'message')
					} />
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createSpotPriceHistorySetItemTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						instanceType=getValue(arguments.stXML,'instanceType'),
						productDescription=getValue(arguments.stXML,'productDescription'),
						spotPrice=getValue(arguments.stXML,'spotPrice'),
						timestamp=getValue(arguments.stXML,'timestamp'),
						availabilityZone=getValue(arguments.stXML,'availabilityZone')
					} />
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createStateReasonTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						code=getValue(arguments.stXML,'code'),
						message=getValue(arguments.stXML,'message')
					} />
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createSubnetTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						subnetId=getValue(arguments.stXML,'subnetId'),
						state=getValue(arguments.stXML,'state'),
						vpcId=getValue(arguments.stXML,'vpcId'),
						cidrBlock=getValue(arguments.stXML,'cidrBlock'),
						availableIpAddressCount=getValue(arguments.stXML,'availableIpAddressCount'),
						availabilityZone=getValue(arguments.stXML,'availabilityZone'),
						tagSet=[]
					} />
					
			<cfloop array="#arguments.stXML.tagSet.xmlChildren#" index="result">
				<cfset arrayAppend(response.tagSet,createResourceTagSetItemTypeObject(result)) />	
			</cfloop>
			
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createTagSetItemTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						resourceId=getValue(arguments.stXML,'resourceId'),
						resourceType=getValue(arguments.stXML,'resourceType'),
						key=getValue(arguments.stXML,'key'),
						value=getValue(arguments.stXML,'value')
					} />
			
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createUserDataTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= resourceId=getValue(arguments.stXML,'data') />
			
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createUserIdGroupPairTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						userId=getValue(arguments.stXML,'userId'),
						groupId=getValue(arguments.stXML,'groupId'),
						groupName=getValue(arguments.stXML,'groupName')
					} />
			
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createValueTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= getValue(arguments.stXML,'value') />
			
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createVolumeStatusItemTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						volumeId=getValue(arguments.stXML,'volumeId'),
						availabilityZone=getValue(arguments.stXML,'availabilityZone'),
						volumeStatus=[],
						eventSet=[],
						actionSet=[]
					} />
			<cfloop array="#arguments.stXML.volumeStatus.xmlChildren#" index="result">
				<cfset arrayAppend(response.volumeStatus,createVolumeStatusInfoTypeObject(result)) />	
			</cfloop>
			
			<cfloop array="#arguments.stXML.eventSet.xmlChildren#" index="result">
				<cfset arrayAppend(response.eventSet,createVolumeStatusEventItemTypeObject(result)) />	
			</cfloop>

			<cfloop array="#arguments.stXML.eventSet.xmlChildren#" index="result">
				<cfset arrayAppend(response.eventSet,createVolumeStatusActionItemTypeObject(result)) />	
			</cfloop>
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createVolumeStatusInfoTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						status=getValue(arguments.stXML,'status'),
						details=getValue(arguments.stXML,'details')
					} />
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createVolumeStatusDetailsItemTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						name=getValue(arguments.stXML,'name'),
						status=getValue(arguments.stXML,'status')
					} />
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createVolumeStatusEventItemTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						eventType=getValue(arguments.stXML,'eventType'),
						eventId=getValue(arguments.stXML,'eventId'),
						description=getValue(arguments.stXML,'description'),
						notBefore=getValue(arguments.stXML,'notBefore'),
						notAfter=getValue(arguments.stXML,'notAfter')
					} />
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createVolumeStatusActionItemTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						code=getValue(arguments.stXML,'code'),
						eventType=getValue(arguments.stXML,'eventType'),
						eventId=getValue(arguments.stXML,'eventId'),
						description=getValue(arguments.stXML,'description')
					} />
		<cfreturn response />	
	</cffunction>

	<cffunction name="createVpcTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						vpcId=getValue(arguments.stXML,'vpcId'),
						state=getValue(arguments.stXML,'state'),
						cidrBlock=getValue(arguments.stXML,'cidrBlock'),
						dhcpOptionsId=getValue(arguments.stXML,'dhcpOptionsId'),
						tagSet=[],
						instanceTenancy=getValue(arguments.stXML,'instanceTenancy')
					} />
					
			<cfloop array="#arguments.stXML.tagSet.xmlChildren#" index="result">
				<cfset arrayAppend(response.tagSet,createResourceTagSetItemTypeObject(result)) />	
			</cfloop>
			
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createVpnConnectionTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						vpnConnectionId=getValue(arguments.stXML,'vpnConnectionId'),
						state=getValue(arguments.stXML,'state'),
						customerGatewayConfiguration=getValue(arguments.stXML,'customerGatewayConfiguration'),
						type=getValue(arguments.stXML,'type'),
						customerGatewayId=getValue(arguments.stXML,'customerGatewayId'),
						vpnGatewayId=getValue(arguments.stXML,'vpnGatewayId'),
						tagSet=[],
						vgwTelemetry=[]
					} />
					
			<cfloop array="#arguments.stXML.tagSet.xmlChildren#" index="result">
				<cfset arrayAppend(response.tagSet,createResourceTagSetItemTypeObject(result)) />	
			</cfloop>
			
			<cfloop array="#arguments.stXML.vgwTelemetry.xmlChildren#" index="result">
				<cfset arrayAppend(response.vgwTelemetry,createVpnTunnelTelemetryTypeObject(result)) />	
			</cfloop>
			
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createVpnGatewayTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						vpnGatewayId=getValue(arguments.stXML,'vpnGatewayId'),
						state=getValue(arguments.stXML,'state'),
						type=getValue(arguments.stXML,'type'),
						availabilityZone=getValue(arguments.stXML,'availabilityZone'),
						tagSet=[],
						attachments=[]
					} />
					
			<cfloop array="#arguments.stXML.tagSet.xmlChildren#" index="result">
				<cfset arrayAppend(response.tagSet,createResourceTagSetItemTypeObject(result)) />	
			</cfloop>
			
			<cfloop array="#arguments.stXML.attachments.xmlChildren#" index="result">
				<cfset arrayAppend(response.attachments,createAttachmentTypeObject(result)) />	
			</cfloop>
			
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createVpnTunnelTelemetryTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						outsideIpAddress=getValue(arguments.stXML,'outsideIpAddress'),
						status=getValue(arguments.stXML,'status'),
						lastStatusChange=getValue(arguments.stXML,'lastStatusChange'),
						statusMessage=getValue(arguments.stXML,'statusMessage'),
						acceptedRouteCount=getValue(arguments.stXML,'acceptedRouteCount')
					} />
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createGroupSetTypeObject" >
		<cfargument name="arg1" >
		<cfdump var="#arguments.arg1#" />
		<cfabort>
	</cffunction>
	
	<cffunction name="createSecurityGroupIdTypeObject" >
		<cfargument name="arg1" >
		
		<cfdump var="#arguments.arg1#" /><cfabort>
	</cffunction>
	
</cfcomponent>