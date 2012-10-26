<cfcomponent output="false" extends="amazonAWS" >
	<cffunction name="init" access="public" returntype="amazonImportExport" >
		<cfargument name="awsAccessKeyId" type="string" required="true"/>
		<cfargument name="secretAccessKey" type="string" required="true"/>
		<cfargument name="endPoint" type="string" required="true" default="importexport.amazonaws.com"/>
				
		<cfset variables.awsAccessKeyId = arguments.awsAccessKeyId />
		<cfset variables.secretAccesskey = arguments.secretAccessKey />
		<cfset variables.endPoint = arguments.endPoint />
		<cfset variables.requestMethod = 'no-header' />
		<cfset variables.version = '2010-06-01' />
		<cfset variables.protocol = 'https://' />
		<cfreturn this />		
	</cffunction>	

	<cffunction name="ListJobs" access="public" returntype="Struct" >
		<cfargument name="Marker" type="string" required="false" default="">
		<cfargument name="MaxJobs" type="string" required="false" default="">
		
		<cfset var stResponse = createResponse() />	
		<cfset var body = "Action=ListJobs" />
		
		<cfif len(trim(arguments.Marker))>
			<cfset body &= "&Marker=" & trim(arguments.Marker) />
		</cfif>	
		
		<cfif len(trim(arguments.MaxJobs))>
			<cfset body &= "&MaxJobs=" & trim(arguments.MaxJobs) />
		</cfif>	
		
		<cfset var rawResult = makeRequestFull(
									endPoint = variables.endPoint,
									awsAccessKeyId = variables.awsAccessKeyId, 
									secretAccesskey = variables.secretAccesskey, 
									body=body,
									requestMethod=variables.requestMethod,
									version = variables.version,
									protocol=variables.protocol) />
			
		<cfif rawResult.statusCode neq 200>
			<cfset error = getResultNodes(xmlParse(rawResult.fileContent),'Error')[1] />
			<cfset stResponse.success=false />
			<cfset stResponse.statusCode=rawResult.statusCode />
			<cfset stResponse.error=error.Code.xmlText/>
			<cfset stResponse.errorType=error.Type.xmlText/>
			<cfset stResponse.errorMessage=error.Message.xmlText/>
		<cfelse>	
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'Jobs')[1].xmlChildren />
			<cfset stResponse.result = [] />
			
			<cfloop array="#dataResult#" index="result">
				<cfset arrayAppend(stResponse.result,{
									CreationDate=getValue(result,'CreationDate'),		
									IsCanceled=getValue(result,'IsCanceled'),		
									IsTruncated=getValue(result,'IsTruncated'),		
									JobId=getValue(result,'JobId'),		
									JobType=getValue(result,'JobType')
									}) />
			</cfloop>	
		</cfif>							
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>

	<cffunction name="CreateJob" access="public" returntype="Struct" >    
    		<cfargument name="Action" type="string" required="true" >    
    		<cfargument name="JobType" type="string" required="true" >    
    		<cfargument name="Manifest" type="string" required="true" >    
    		<cfargument name="ValidateOnly" type="boolean" required="false" default="false" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=CreateJob&Action=" & trim(arguments.Action) & "&JobType=" & trim(arguments.JobType) & "&Manifes=" & trim(arguments.Manifest)/>    
    		    
    		<cfif arguments.ValidateOnly>    
    			<cfset body &= "&ValidateOnly=true" />    
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'CreateJobResult')[1] />    
    			<cfset stResponse.result = {
					JobId=getValue(dataResult,'JobId'),
					AwsShippingAddress=getValue(AwsShippingAddress,'JobId'),
					Signature=getValue(dataResult,'Signature'),
					SignatureFileContents=getValue(dataResult,'SignatureFileContents')
					
				} />	    
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="CancelJob" access="public" returntype="Struct" >    
    		<cfargument name="Action" type="string" required="true" >    
    		<cfargument name="JobId" type="string" required="true" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=CancelJob&Action=" & trim(arguments.Action) & "&JobId=" & trim(arguments.JobId)/>    
    		    
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
    			<cfset stResponse.result = getResultNodes(xmlParse(rawResult.filecontent),'Success')[1].xmlText />    
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="UpdateJob" access="public" returntype="Struct" >    
    		<cfargument name="Action" type="string" required="true" >    
    		<cfargument name="JobId" type="string" required="true" >    
    		<cfargument name="JobType" type="string" required="true" >    
    		<cfargument name="Manifest" type="string" required="true" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=UpdateJob&Action=" & trim(arguments.Action) & "&JobId=" & trim(arguments.JobId) & "&JobType=" & trim(arguments.JobType) & "&Manifest=" & trim(arguments.Manifest)/>    
    		    
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
    			<cfset stResponse.result = getResultNodes(xmlParse(rawResult.filecontent),'Success')[1].xmlText />    
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="GetStatus" access="public" returntype="Struct" >    
    		<cfargument name="Action" type="string" required="true" >    
    		<cfargument name="JobId" type="string" required="true" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=GetStatus&Action=" & trim(arguments.Action) & "&JobId=" & trim(arguments.JobId)/>    
    		    
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'GetStatusResult')[1] />    
    			<cfset stResponse.result = {
								JobType=getValue(dataResult,'JobType'),
								CurrentManifest=getValue(dataResult,'CurrentManifest'),
								JobId=getValue(dataResult,'JobId'),
								LocationMessage=getValue(dataResult,'LocationMessage'),
								ProgressCode=getValue(dataResult,'ProgressCode'),
								SignatureFileContents=getValue(dataResult,'SignatureFileContents'),
								ErrorCount=getValue(dataResult,'ErrorCount'),
								ProgressMessage=getValue(dataResult,'ProgressMessage'),
								LocationCode=getValue(dataResult,'LocationCode'),
								CreationDate=getValue(dataResult,'CreationDate'),
								AwsShippingAddress=getValue(dataResult,'AwsShippingAddress'),
								Signature=getValue(dataResult,'Signature')
							} />	    
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>
</cfcomponent>