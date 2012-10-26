<cfcomponent output="false" extends="amazonAWS" >
	<cffunction name="init" access="public" returntype="amazonSWS" >
		<cfargument name="awsAccessKeyId" type="string" required="true"/>
		<cfargument name="secretAccessKey" type="string" required="true"/>
		<cfargument name="endPoint" type="string" required="true" default="https://swf.us-east-1.amazonaws.com"/>
				
		<cfset variables.awsAccessKeyId = arguments.awsAccessKeyId />
		<cfset variables.secretAccesskey = arguments.secretAccessKey />
		<cfset variables.endPoint = arguments.endPoint />
		<cfset variables.requestMethod = '' />
		<cfset variables.version = '2012-01-25' />
		<cfset variables.protocol = 'https://' />
		<cfreturn this />		
	</cffunction>
	
	<cffunction name="ListDomains" access="public" returntype="Array" >
		<cfset var body = "Action=ListDomains" />
		<cfset var rawResult = makeRequestFull(
									endPoint = variables.endPoint,
									awsAccessKeyId = variables.awsAccessKeyId, 
									secretAccesskey = variables.secretAccesskey, 
									body=body,
									requestMethod=variables.requestMethod,
									version = variables.version,
									protocol = variables.protocol) />
									
		<cfdump var="#rawResult#" /><cfabort>							
		<cfset rawResult = getResultNodes(xmlParse(rawResult),'member') />
		<cfset var aResults = [] />
		
		<cfloop array="#rawResult#" index="member">
			<cfset arrayAppend(aResults,member.xmlText) />
		</cfloop>	
		
		<cfreturn aResults />
	</cffunction>
	
	<cffunction name="ListActivityTypes" access="public" returntype="Struct" >    
    		<cfargument name="domain" type="string" required="true" >    
    		<cfargument name="registrationStatus" type="string" required="true" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=ListActivityTypes&domain=" & trim(arguments.domain) & "&registrationStatus=" & trim(arguments.registrationStatus)/>    
    		    
    		<cfset var rawResult = makeRequestFull(    
    							endPoint = variables.endPoint,    
    							awsAccessKeyId = variables.awsAccessKeyId,     
    							secretAccesskey = variables.secretAccesskey,     
    							body=body,    
    							requestMethod = variables.requestMethod,    
    							version = variables.version,    
    							protocol = variables.protocol ) />    
    								    
    		<cfif rawResult.statusCode neq 200>    
				<cfdump var="#rawResult#" /><cfabort>
    			<cfset error = getResultNodes(xmlParse(rawResult.fileContent),'Error')[1] />    
    			<cfset stResponse.success=false />    
    			<cfset stResponse.statusCode=rawResult.statusCode />    
    			<cfset stResponse.error=error.Code.xmlText/>    
    			<cfset stResponse.errorType=error.Type.xmlText/>			
    			<cfset stResponse.errorMessage=error.Message.xmlText/>    
    		<cfelse>			    
    			<cfdump var="#xmlParse(rawResult.filecontent)#" /><cfabort>    
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'AccessKey')[1] />    
    			<cfset stResponse.result = {} />	    
    	    
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>
</cfcomponent>