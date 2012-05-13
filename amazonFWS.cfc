<cfcomponent output="false" extends="amazonAWS" >
	<cffunction name="init" access="public" returntype="amazonFWS" >
		<cfargument name="awsAccessKeyId" type="string" required="true"/>
		<cfargument name="secretAccessKey" type="string" required="true"/>
				
		<cfset this.awsAccessKeyId = arguments.awsAccessKeyId />
		<cfset this.secretAccesskey = arguments.secretAccessKey />
		<cfset this.endPoint = 'fba-inbound.amazonaws.com' />
		<cfset this.requestMethod = 'no-header' />
		<cfset this.version = '2007-05-10' />
		<cfset this.protocol = 'https://' />
		<cfreturn this />		
	</cffunction>
	
	<cffunction name="ListAllFulfillmentItems" access="public" returntype="Struct" >    
    		<cfargument name="IncludeInactive" type="string" required="true" >    
    		<cfargument name="MaxCount" type="string" required="true" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=ListAllFulfillmentItems&IncludeInactive=" & trim(arguments.IncludeInactive) & "&MaxCount=" & trim(arguments.MaxCount)/>    
    		    
    		<cfset var rawResult = makeRequestFull(    
    							endPoint = this.endPoint,    
    							awsAccessKeyId = this.awsAccessKeyId,     
    							secretAccesskey = this.secretAccesskey,     
    							body=body,    
    							requestMethod = this.requestMethod,    
    							version = this.version,    
    							protocol = this.protocol ) />    
    								    
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