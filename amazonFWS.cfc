<cfcomponent output="false" extends="amazonAWS" >
	<cffunction name="init" access="public" returntype="amazonFWS" >
		<cfargument name="awsAccessKeyId" type="string" required="true"/>
		<cfargument name="secretAccessKey" type="string" required="true"/>
		<cfargument name="endPoint" type="string" required="true" default="fba-inbound.amazonaws.com"/>
				
		<cfset variables.awsAccessKeyId = arguments.awsAccessKeyId />
		<cfset variables.secretAccesskey = arguments.secretAccessKey />
		<cfset variables.endPoint = arguments.endPoint />
		<cfset variables.requestMethod = 'no-header' />
		<cfset variables.version = '2007-05-10' />
		<cfset variables.protocol = 'https://' />
		<cfreturn this />		
	</cffunction>
	
	<cffunction name="ListAllFulfillmentItems" access="public" returntype="Struct" >    
    		<cfargument name="IncludeInactive" type="string" required="true" >    
    		<cfargument name="MaxCount" type="string" required="true" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=ListAllFulfillmentItems&IncludeInactive=" & trim(arguments.IncludeInactive) & "&MaxCount=" & trim(arguments.MaxCount)/>    
    		    
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'AccessKey')[1] />    
    			<cfset stResponse.result = {} />	    
    	    
    		</cfif>   
    		<cfdump var="#rawResult#" /> 
    	    <cfabort>
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

</cfcomponent>