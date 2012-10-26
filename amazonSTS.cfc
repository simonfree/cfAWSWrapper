<cfcomponent output="false" extends="amazonAWS" >
	<cffunction name="init" access="public" returntype="amazonSTS" >
		<cfargument name="awsAccessKeyId" type="string" required="true"/>
		<cfargument name="secretAccessKey" type="string" required="true"/>
		<cfargument name="endPoint" type="string" required="true" default="sts.amazonaws.com"/>
				
		<cfset variables.awsAccessKeyId = arguments.awsAccessKeyId />
		<cfset variables.secretAccesskey = arguments.secretAccessKey />
		<cfset variables.endPoint = arguments.endPoint />
		<cfset variables.requestMethod = 'no-header' />
		<cfset variables.version = '2011-06-15' />
		<cfset variables.protocol = 'https://' />
		<cfreturn this />		
	</cffunction>
	
	<cffunction name="GetFederationToken" access="public" returntype="Struct" >    
    		<cfargument name="Name" type="string" required="true" >    
    		<cfargument name="DurationSeconds" type="string" required="false" default="" >    
    		<cfargument name="Policy" type="string" required="false" default="" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=GetFederationToken&Name=" & trim(arguments.name)/>    
    		    
    		<cfif len(trim(arguments.DurationSeconds))>    
    			<cfset body &= "&DurationSeconds=" & trim(arguments.DurationSeconds) />    
    		</cfif>	 
    		
    		<cfif len(trim(arguments.Policy))>    
    			<cfset body &= "&Policy=" & trim(arguments.Policy) />    
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
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'GetFederationTokenResult')[1] />  

    			<cfset stResponse.result = {
							Credentials=createCredentialsObject(dataResult.Credentials),
							FederatedUser=createFederatedUserObject(dataResult.FederatedUser),
							PackedPolicySize=getValue(dataResult,'PackedPolicySize')
						} />	    
	 
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>	
	
	<cffunction name="GetSessionToken" access="public" returntype="Struct" >    
    		<cfargument name="TokenCode" type="string" required="false" default="">
		<cfargument name="SerialNumber" type="string" required="false" default="">
		<cfargument name="DurationSeconds" type="string" required="false" default="">	    
    				    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=GetSessionToken"/>    
    		
    		<cfif len(trim(arguments.TokenCode))>    
    			<cfset body &= "&TokenCode=" & trim(arguments.TokenCode) />    
    		</cfif>	
    		
    		<cfif len(trim(arguments.SerialNumber))>    
    			<cfset body &= "&SerialNumber=" & trim(arguments.SerialNumber) />    
    		</cfif>	
    		
    		<cfif len(trim(arguments.DurationSeconds))>    
    			<cfset body &= "&DurationSeconds=" & trim(arguments.DurationSeconds) />    
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'Credentials')[1] />    
    			
    			<cfset stResponse.result = {
							credentials=createCredentialsObject(dataResult)
						} />	        	    
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>
    	
    	<cffunction name="createCredentialsObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response = {
					AccessKeyId=getValue(arguments.stXML,'AccessKeyId'),
					Expiration=getValue(arguments.stXML,'Expiration'),
					SecretAccessKey=getValue(arguments.stXML,'SecretAccessKey'),
					SessionToken=getValue(arguments.stXML,'SessionToken')
				} />	    
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createFederatedUserObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response = {
					Arn=getValue(arguments.stXML,'Arn'),
					FederatedUserId=getValue(arguments.stXML,'FederatedUserId')
				} />	    

		<cfreturn response />	
	</cffunction>
</cfcomponent>