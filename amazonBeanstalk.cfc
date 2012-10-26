<cfcomponent output="false" extends="amazonAWS" >
	<cffunction name="init" access="public" returntype="amazonBeanstalk" >
		<cfargument name="awsAccessKeyId" type="string" required="true"/>
		<cfargument name="secretAccessKey" type="string" required="true"/>
		<cfargument name="endPoint" type="string" required="true" default="elasticbeanstalk.us-east-1.amazonaws.com"/>
				
		<cfset variables.awsAccessKeyId = arguments.awsAccessKeyId />
		<cfset variables.secretAccesskey = arguments.secretAccessKey />
		<cfset variables.endPoint = arguments.endPoint />
		<cfset variables.requestMethod = 'no-header' />
		<cfset variables.version = '2010-12-01' />
		<cfset variables.protocol = 'https://' />
		<cfreturn this />		
	</cffunction>
	
	<cffunction name="DescribeEvents" access="public" returntype="Struct" >
		<cfargument name="ApplicationName" type="string" required="false" default="">
		<cfargument name="EndTime" type="string" required="false" default="">
		<cfargument name="EnvironmentId" type="string" required="false" default="">
		<cfargument name="EnvironmentName" type="string" required="false" default="">
		<cfargument name="MaxRecords" type="string" required="false" default="">
		<cfargument name="NextToken" type="string" required="false" default="">
		<cfargument name="RequestId" type="string" required="false" default="">
		<cfargument name="Severity" type="string" required="false" default="">
		<cfargument name="StartTime" type="string" required="false" default="">
		<cfargument name="TemplateName" type="string" required="false" default="">
		<cfargument name="VersionLabel" type="string" required="false" default="">
		
		<cfset var stResponse = createResponse() />  
		<cfset var body = "Action=DescribeEvents"/>
		
		<cfif len(trim(arguments.ApplicationName))>
			<cfset body &= "&ApplicationName=" & trim(arguments.ApplicationName) />	
		</cfif>	
		
		<cfif len(trim(arguments.EndTime))>
			<cfset body &= "&EndTime=" & trim(arguments.EndTime) />	
		</cfif>	
		
		<cfif len(trim(arguments.EnvironmentId))>
			<cfset body &= "&EnvironmentId=" & trim(arguments.EnvironmentId) />	
		</cfif>	
		
		<cfif len(trim(arguments.EnvironmentName))>
			<cfset body &= "&EnvironmentName=" & trim(arguments.EnvironmentName) />	
		</cfif>	
		
		<cfif len(trim(arguments.MaxRecords))>
			<cfset body &= "&MaxRecords=" & trim(arguments.MaxRecords) />	
		</cfif>	
		
		<cfif len(trim(arguments.NextToken))>
			<cfset body &= "&NextToken=" & trim(arguments.NextToken) />	
		</cfif>	
		
		<cfif len(trim(arguments.RequestId))>
			<cfset body &= "&RequestId=" & trim(arguments.RequestId) />	
		</cfif>	
		
		<cfif len(trim(arguments.Severity))>
			<cfset body &= "&Severity=" & trim(arguments.Severity) />	
		</cfif>	
		
		<cfif len(trim(arguments.StartTime))>
			<cfset body &= "&StartTime=" & trim(arguments.StartTime) />	
		</cfif>	
		
		<cfif len(trim(arguments.TemplateName))>
			<cfset body &= "&TemplateName=" & trim(arguments.TemplateName) />	
		</cfif>	
		
		<cfif len(trim(arguments.VersionLabel))>
			<cfset body &= "&VersionLabel=" & trim(arguments.VersionLabel) />	
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
			<cfset stResponse.result = [] />			
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'Events')[1].xmlChildren />
			
			<cfloop array="#dataResult#" index="result">
				<cfset arrayAppend(stResponse.result,{
					Message=getValue(result,'messageID'),
					EventDate=getValue(result,'EventDate'),
					VersionLabel=getValue(result,'VersionLabel'),
					RequestId=getValue(result,'RequestId'),
					ApplicationName=getValue(result,'ApplicationName'),
					EnvironmentName=getValue(result,'EnvironmentName'),
					Severity=getValue(result,'Severity')
				}) />
			</cfloop>	
		</cfif>						
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    						    
    		<cfreturn stResponse /> 
	</cffunction>	
	
	<cffunction name="DescribeApplications" access="public" returntype="Struct" >
		<cfargument name="applicationName" type="string" required="false" default="">
		<cfset var stResponse = createResponse() />  
		<cfset var body = "Action=DescribeApplications"/>
		
		<cfloop from="1" to="#listLen(arguments.applicationName)#" index="i">
			<cfset body &= "&ApplicationNames.member." & i & "=" & listgetat(arguments.applicationName,i) />
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
			<cfset stResponse.result=[] />									
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'Applications')[1].xmlChildren />
			
			<cfloop array="#dataResult#" index="result">
				<cfset stApplication = {
					Description=getValue(result,'Description'),
					ApplicationName=getValue(result,'ApplicationName'),
					DateCreated=getValue(result,'DateCreated'),
					DateUpdated=getValue(result,'DateUpdated'),
					ConfigurationTemplates=[]}/>
					
					<cfloop array="#result.ConfigurationTemplates.xmlChildren#" index="template" >
						<cfset arrayAppend(stApplication.ConfigurationTemplates,template.xmlText) />
					</cfloop>
					
				<cfset arrayAppend(stResponse.result,stApplication) />
			</cfloop>			
		</cfif>
			
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    						    
    		<cfreturn stResponse /> 
	</cffunction>	
	
	<cffunction name="CheckDNSAvailability" access="public" returntype="Struct" >    
    		<cfargument name="CNAMEPrefix" type="string" required="true" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=CheckDNSAvailability&CNAMEPrefix=" & trim(arguments.CNAMEPrefix)/>    
    		    
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'CheckDNSAvailabilityResult')[1] />    
    			<cfset stResponse.result = {
							FullyQualifiedCNAME=getValue(dataResult,'FullyQualifiedCNAME'),
							Available=getValue(dataResult,'Available')
						 }/>  
    			    
    		</cfif>    
    		    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    						    
    		<cfreturn stResponse />    
    	</cffunction>
    	
    	<cffunction name="CreateApplication" access="public" returntype="Struct" >        
    		<cfargument name="ApplicationName" type="string" required="true" >        
    		<cfargument name="Description" type="string" required="false" default="" >        
    			        
    		<cfset var stResponse = createResponse() />        
    		<cfset var body = "Action=CreateApplication&ApplicationName=" & trim(arguments.ApplicationName)/>        
    		        
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'Application')[1] />        
				
			<cfset stResponse.result = {
				Description=getValue(dataResult,'Description'),
				ApplicationName=getValue(dataResult,'ApplicationName'),
				DateCreated=getValue(dataResult,'DateCreated'),
				DateUpdated=getValue(dataResult,'DateUpdated'),
				ConfigurationTemplates=[]}/>
				
			<cfloop array="#dataResult.ConfigurationTemplates.xmlChildren#" index="template" >
				<cfset arrayAppend(stResponse.result.ConfigurationTemplates,template) />
			</cfloop>     
    		</cfif>        
    		        
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />        
    						        
    		<cfreturn stResponse />        
    	</cffunction>
    	
    	<cffunction name="CreateApplicationVersion" access="public" returntype="Struct" >            
    		<cfargument name="ApplicationName" type="string" required="true" >    
		<cfargument name="VersionLabel" type="string" required="true" >   

    		<cfargument name="AutoCreateApplication" type="boolean" required="false" default="false" > 
		<cfargument name="Description" type="string" required="false" default="" > 
		<cfargument name="SourceBundle" type="string" required="false" default="" > 
					           
    			            
    		<cfset var stResponse = createResponse() />            
    		<cfset var body = "Action=CreateApplicationVersion&ApplicationName=" & trim(arguments.ApplicationName) & "&VersionLabel=" & trim(arguments.VersionLabel)/>            
    		            
    		<cfif arguments.AutoCreateApplication>            
    			<cfset body &= "&AutoCreateApplication=true"/>            
    		</cfif>	
			
		<cfif len(trim(arguments.Description))>            
    			<cfset body &= "&Description=" & trim(arguments.Description) />            
    		</cfif>	  
			
		<cfif len(trim(arguments.SourceBundle))>            
    			<cfset body &= "&SourceBundle=" & trim(arguments.SourceBundle) />            
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'ApplicationVersion')[1] />            
    			<cfset stResponse.result = {
						VersionLabel=getValue(dataResult,'VersionLabel'),
						Description=getValue(dataResult,'Description'),
						ApplicationName=getValue(dataResult,'ApplicationName'),
						DateCreated=getValue(dataResult,'DateCreated'),
						DateUpdated=getValue(dataResult,'DateUpdated'),
						SourceBundle={}
				} />   
				
			<cfloop array="#dataResult.SourceBundle.xmlChildren#" index="bundle">
				<cfset stResponse.result.SourceBundle[bundle.xmlName] = bundle.xmlText />
			</cfloop>	
    		</cfif>            
    		            
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />            
    						            
    		<cfreturn stResponse />            
    	</cffunction>
    	
    	<cffunction name="CreateConfigurationTemplate" access="public" returntype="Struct" >                
    		<cfargument name="ApplicationName" type="string" required="true" >    
		<cfargument name="TemplateName" type="string" required="true" >  	
    		<cfargument name="Description" type="string" required="false" default="" >
		<cfargument name="EnvironmentId" type="string" required="false" default="" >    
		<cfargument name="OptionSettings" type="string" required="false" default="" >    
		<cfargument name="SolutionStackName" type="string" required="false" default="" >    
		<cfargument name="SourceConfiguration" type="string" required="false" default="" >                    
    				                
    		<cfset var stResponse = createResponse() />                
    		<cfset var body = "Action=CreateConfigurationTemplate&ApplicationName=" & trim(arguments.ApplicationName) & "&TemplateName=" & arguments.TemplateName/>                
    		                
    		<cfif len(trim(arguments.Description))>                
    			<cfset body &= "&Description=" & trim(arguments.Description) />                
    		</cfif>	 
    		
    		<cfif len(trim(arguments.EnvironmentId))>                
    			<cfset body &= "&EnvironmentId=" & trim(arguments.EnvironmentId) />                
    		</cfif>	
    		
    		<cfloop from="1" to="#arrayLen(arguments.OptionSettings)#" index="i">             
    			<cfset body &= "&OptionSettings.member." & i & ".Namespace=" & trim(arguments.OptionSettings[i].Namespace)  
						& "&OptionSettings.member." & i & ".OptionName=" & trim(arguments.OptionSettings[i].OptionName)
						& "&OptionSettings.member." & i & ".Value=" & trim(arguments.OptionSettings[i].Value)  />                
		</cfloop>	
    		
    		<cfif len(trim(arguments.SolutionStackName))>                
    			<cfset body &= "&SolutionStackName=" & trim(arguments.SolutionStackName) />                
    		</cfif>	
    		
    		<cfif len(trim(arguments.SourceConfiguration))>                
    			<cfset body &= "&SourceConfiguration=" & trim(arguments.SourceConfiguration) />                
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'CreateConfigurationTemplateResult')[1] />                
    			<cfset stResponse.result = {
						SolutionStackName=getValue(dataResult,'SolutionStackName'),
						OptionSettings=[],
						Description=getValue(dataResult,'Description'),
						ApplicationName=getValue(dataResult,'ApplicationName'),
						DateCreated=getValue(dataResult,'DateCreated'),
						TemplateName=getValue(dataResult,'TemplateName'),
						DateUpdated=getValue(dataResult,'DateUpdated')
				} />                
				
				<cfloop array="#dataResult.OptionSettings.xmlChildren#" index="option">
					<cfset arrayAppend(stResponse.result.OptionSettings,{
												OptionName=getValue(option,'OptionName'),
												Value=getValue(option,'Value'),
												Namespace=getValue(option,'Namespace')
											}) />
				</cfloop>	
    		</cfif>                
    		                
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />                
    						                
    		<cfreturn stResponse />                
    	</cffunction>
    	
    	<cffunction name="CreateEnvironment" access="public" returntype="Struct" >                
    		<cfargument name="ApplicationName" type="string" required="true" >       
		<cfargument name="EnvironmentName" type="string" required="true" >   
    		<cfargument name="CNAMEPrefix" type="string" required="false" default="" >                
		<cfargument name="Description" type="string" required="false" default="" > 
		<cfargument name="OptionSettings" type="array" required="false" default="#[]#" > 
		<cfargument name="OptionsToRemove" type="array" required="false" default="#[]#" > 
		<cfargument name="SolutionStackName" type="string" required="false" default="" > 
		<cfargument name="TemplateName" type="string" required="false" default="" > 
		<cfargument name="VersionLabel" type="string" required="false" default="" > 
		
    		<cfset var stResponse = createResponse() />                
    		<cfset var body = "Action=CreateEnvironment&ApplicationName=" & trim(arguments.ApplicationName) & "&EnvironmentName=" & trim(arguments.EnvironmentName)/>                
    		                
    		<cfif len(trim(arguments.CNAMEPrefix))>                
    			<cfset body &= "&CNAMEPrefix=" & trim(arguments.CNAMEPrefix) />                
    		</cfif>	           
    		
    		<cfif len(trim(arguments.Description))>                
    			<cfset body &= "&Description=" & trim(arguments.Description) />                
    		</cfif>	
    		
    		<cfloop from="1" to="#arrayLen(arguments.OptionSettings)#" index="i">             
    			<cfset body &= "&OptionSettings.member." & i & ".Namespace=" & trim(arguments.OptionSettings[i].Namespace)  
						& "&OptionSettings.member." & i & ".OptionName=" & trim(arguments.OptionSettings[i].OptionName)
						& "&OptionSettings.member." & i & ".Value=" & trim(arguments.OptionSettings[i].Value)  />                
		</cfloop>

		<cfloop from="1" to="#arrayLen(arguments.OptionsToRemove)#" index="i">             
    			<cfset body &= "&OptionsToRemove.member." & i & ".Namespace=" & trim(arguments.OptionSettings[i].Namespace)  
						& "&OptionsToRemove.member." & i & ".OptionName=" & trim(arguments.OptionSettings[i].OptionName)  />                
		</cfloop>	
    		
    		<cfif len(trim(arguments.SolutionStackName))>    
    			<cfset body &= "&SolutionStackName=" & trim(arguments.SolutionStackName) />                
    		</cfif>	
    		
    		<cfif len(trim(arguments.TemplateName))>                
    			<cfset body &= "&TemplateName=" & trim(arguments.TemplateName) />                
    		</cfif>	
    		
    		<cfif len(trim(arguments.VersionLabel))>                
    			<cfset body &= "&VersionLabel=" & trim(arguments.VersionLabel) />                
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'CreateEnvironmentResult')[1] />                
    			<cfset stResponse.result = {
						ApplicationName=getValue(dataResult,'ApplicationName'),
						CNAME=getValue(dataResult,'CNAME'),
						DateCreated=getValue(dataResult,'DateCreated'),
						DateUpdated=getValue(dataResult,'DateUpdated'),
						Description=getValue(dataResult,'Description'),
						EndpointURL=getValue(dataResult,'EndpointURL'),
						EnvironmentId=getValue(dataResult,'EnvironmentId'),
						EnvironmentName=getValue(dataResult,'EnvironmentName'),
						Health=getValue(dataResult,'Health'),
						SolutionStackName=getValue(dataResult,'SolutionStackName'),
						Status=getValue(dataResult,'Status'),
						TemplateName=getValue(dataResult,'TemplateName'),
						VersionLabel=getValue(dataResult,'VersionLabel'),
						VersionLabel=getValue(dataResult,'VersionLabel'),
						Resources={}
				
				} />
				
			<cfif structKeyExists(dataResult,'Resources')>
				<cfset stResponse.result.Resources={LoadBalancer={Listeners=[],LoadBalancerName=getValue(dataResult.Resources.LoadBalancer,'LoadBalancerName')}} />
				
				<cfloop array="#dataResult.Resources.LoadBalancer.Listeners.xmlChildren#" index="listener">
					<cfset arrayAppend(stResponse.result.Resources.LoadBalancer.Listeners,{
																					Port=getValue(listener,'Port'),
																					Protocol=getValue(listener,'Protocol')
																				}) />
				</cfloop>	
			</cfif>		                
    		</cfif>                
    		                
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />                
    						                
    		<cfreturn stResponse />                
    	</cffunction>
    	
    	<cffunction name="CreateStorageLocation" access="public" returntype="Struct" >            
    			            
    		<cfset var stResponse = createResponse() />            
    		<cfset var body = "Action=CreateStorageLocation"/>            
    		            
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'CreateStorageLocationResult')[1] />            
    			<cfset stResponse.result = {S3Bucket=getValue(dataResult,'S3Bucket')} />            
    			            
    		</cfif>            
    		            
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />            
    						            
    		<cfreturn stResponse />            
    	</cffunction>
    	
	<cffunction name="DescribeApplicationVersions" access="public" returntype="Struct" >        
    		<cfargument name="ApplicationName" type="string" required="false" default="" >        
    		<cfargument name="VersionLabels" type="string" required="false" default="" >        
    			        
    		<cfset var stResponse = createResponse() />        
    		<cfset var body = "Action=DescribeApplicationVersions"/>        
    		        
    		<cfif len(trim(arguments.ApplicationName))>        
    			<cfset body &= "&ApplicationName=" & trim(arguments.ApplicationName) />        
    		</cfif>	    
    		
    		<cfloop from="1" to="#listlen(arguments.VersionLabels)#" index="i">
			<cfset body &= "&VersionLabels.member." & i & "=" & trim(listGetAt(arguments.VersionLabels,i)) /> 
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'ApplicationVersions')[1].xmlChildren />        
    			<cfset stResponse.result = [] />
				
			<cfloop array="#dataResult#" index="result">
				<cfset stApplication = {
					VersionLabel=getValue(result,'VersionLabel'),
					Description=getValue(result,'Description'),
					ApplicationName=getValue(result,'ApplicationName'),
					DateCreated=getValue(result,'DateCreated'),
					DateUpdated=getValue(result,'DateUpdated'),
					SourceBundle=[]}/>
					
					<cfloop array="#result.SourceBundle.xmlChildren#" index="bundle" >
						<cfset arrayAppend(stApplication.SourceBundle,{
															S3Bucket=getValue(bundle,'S3Bucket'),
															S3Key=getValue(bundle,'S3Key')
															}) />
					</cfloop>
					
				<cfset arrayAppend(stResponse.result,stApplication) />
			</cfloop>		        
    			        
    		</cfif>        
    		        
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />        
    						        
    		<cfreturn stResponse />        
    	</cffunction>
    	
    	<cffunction name="DescribeConfigurationOptions" access="public" returntype="Struct" >            
    		<cfargument name="ApplicationName" type="string" required="false" default="" > 
		<cfargument name="EnvironmentName" type="string" required="false" default="" >   
		<cfargument name="Options" type="array" required="false" default="#[]#" >   
		<cfargument name="SolutionStackName" type="string" required="false" default="" >   
		<cfargument name="TemplateName" type="string" required="false" default="" >   		           
    			            
    		<cfset var stResponse = createResponse() />            
    		<cfset var body = "Action=DescribeConfigurationOptions"/>            
    		            
    		<cfif len(trim(arguments.ApplicationName))>            
    			<cfset body &= "&ApplicationName=" & trim(arguments.ApplicationName) />            
    		</cfif>
    		
    		<cfif len(trim(arguments.EnvironmentName))>            
    			<cfset body &= "&EnvironmentName=" & trim(arguments.EnvironmentName) />            
    		</cfif>	     
    		
    		<cfloop from="1" to="#arrayLen(arguments.Options)#" index="i">          
    			<cfset body &= "&Options.member." & i & ".Namespace=" & arguments.Options[i].Namespace
						& "&Options.member." & i & ".OptionName=" & arguments.Options[i].OptionName/>            
    		</cfloop>	     
    		
    		<cfif len(trim(arguments.SolutionStackName))>            
    			<cfset body &= "&SolutionStackName=" & trim(arguments.SolutionStackName) />            
    		</cfif>	     
    		
    		<cfif len(trim(arguments.TemplateName))>            
    			<cfset body &= "&TemplateName=" & trim(arguments.TemplateName) />            
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'DescribeConfigurationOptionsResult')[1] />            
    			<cfset stResponse.result = {
									SolutionStackName=getValue(dataResult,'SolutionStackName'),
									Options=[]
								} />  
			<cfloop array="#dataResult.Options.xmlChildren#" index="option">
				<cfset stOption = {} />
				
				<cfloop array="#option.xmlChildren#" index="optionChild">
					<cfif !ArrayLen(optionChild.xmlChildren)>
						<cfset stOption[optionChild.xmlName] = optionChild.xmlText />
					<cfelse>
						<cfset stOption[optionChild.xmlName] = [] />
						
						<cfloop array="#optionChild.xmlChildren#" index="subOptionChild">
							<cfif subOptionChild.xmlName eq 'member'>
								<cfset arrayAppend(stOption[optionChild.xmlName],subOptionChild.xmlText) />
							<cfelse>
								<cfif !isStruct(stOption[optionChild.xmlName])>
									<cfset stOption[optionChild.xmlName] = {} />	
								</cfif>	
								<cfset stOption[optionChild.xmlName][subOptionChild.xmlName]=subOptionChild.xmlText />
							</cfif>	
						</cfloop>	
					</cfif>	
				</cfloop>	
				<cfset arrayAppend(stResponse.result.Options,stOption) />
			</cfloop>						          
    		</cfif>            
    		            
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />            
    						            
    		<cfreturn stResponse />            
    	</cffunction>
    	
    	<cffunction name="DescribeConfigurationSettings" access="public" returntype="Struct" >            
    		<cfargument name="ApplicationName" type="string" required="true" >            
    		<cfargument name="EnvironmentName" type="string" required="false" default="" >
		<cfargument name="TemplateName" type="string" required="false" default="" >             
    			            
    		<cfset var stResponse = createResponse() />            
    		<cfset var body = "Action=DescribeConfigurationSettings&ApplicationName=" & trim(arguments.ApplicationName)/>            
    		            
    		<cfif len(trim(arguments.EnvironmentName))>            
    			<cfset body &= "&EnvironmentName=" & trim(arguments.EnvironmentName) />            
    		</cfif>
    		
    		<cfif len(trim(arguments.TemplateName))>            
    			<cfset body &= "&TemplateName=" & trim(arguments.TemplateName) />            
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'ConfigurationSettings')[1].xmlChildren />            
    			<cfset stResponse.result = [] />  
				
			<cfloop array="#dataResult#" index="result">
				<cfset stResult = {
									SolutionStackName=getValue(result,'SolutionStackName'),
									Description=getValue(result,'Description'),
									ApplicationName=getValue(result,'ApplicationName'),
									DateCreated=getValue(result,'DateCreated'),
									TemplateName=getValue(result,'TemplateName'),
									DateUpdated=getValue(result,'DateUpdated'),
									OptionSettings=[]
								} />
				<cfloop array="#result.OptionSettings.xmlChildren#" index="option">
						<cfset arrayAppend(stResult.OptionSettings,{
																OptionName=getValue(option,'OptionName'),
																Value=getValue(option,'Value'),
																Namespace=getValue(option,'Namespace')
															}) />
				</cfloop>
				
				<cfset arrayAppend(stResponse.result,stResult) />	
			</cfloop>		          
    		</cfif>            
    		            
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />            
    						            
    		<cfreturn stResponse />            
    	</cffunction>
    	
    	<cffunction name="DescribeEnvironmentResources" access="public" returntype="Struct" >            
    		<cfargument name="EnvironmentId" type="string" required="false" default="" >            
    		<cfargument name="EnvironmentName" type="string" required="false" default="" >            
    			            
    		<cfset var stResponse = createResponse() />            
    		<cfset var body = "Action=DescribeEnvironmentResources"/>            
    		            
    		<cfif len(trim(arguments.EnvironmentId))>            
    			<cfset body &= "&EnvironmentId=" & trim(arguments.EnvironmentId) />            
    		</cfif>
    		
    		<cfif len(trim(arguments.EnvironmentName))>            
    			<cfset body &= "&EnvironmentName=" & trim(arguments.EnvironmentName) />            
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'EnvironmentResources')[1] />            
    			<cfset stResponse.result = {
								LoadBalancers=[],
								LaunchConfigurations=[],
								AutoScalingGroups=[],
								EnvironmentName=getValue(dataResult,'EnvironmentName'),
								Triggers=[],
								Instances=[]
				} />  
				
			<cfloop array="#dataResult.LoadBalancers.xmlChildren#" index="lb">
				<cfif structKeyExists(lb,'Name')>
					<cfset arrayAppend(stResponse.result.LoadBalancers,lb.Name.xmlText) />
				</cfif>
			</cfloop>	
			
			<cfloop array="#dataResult.LaunchConfigurations.xmlChildren#" index="lc">
				<cfif structKeyExists(lb,'Name')>
					<cfset arrayAppend(stResponse.result.LaunchConfigurations,lc.Name.xmlText) />
				</cfif>
			</cfloop>	 
			
			<cfloop array="#dataResult.AutoScalingGroups.xmlChildren#" index="as">
				<cfif structKeyExists(as,'Name')>
					<cfset arrayAppend(stResponse.result.AutoScalingGroups,as.Name.xmlText) />
				</cfif>
			</cfloop>	 
			
			<cfloop array="#dataResult.Triggers.xmlChildren#" index="t">
				<cfif structKeyExists(t,'Name')>
					<cfset arrayAppend(stResponse.result.Triggers,t.Name.xmlText) />
				</cfif>
			</cfloop>	 
			
			<cfloop array="#dataResult.Instances#" index="i">
				<cfif structKeyExists(i,'Name')>
					<cfset arrayAppend(stResponse.result.Instances,i.Name.xmlText) />
				</cfif>
			</cfloop>	           
    			            
    		</cfif>            
    		            
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />            
    						            
    		<cfreturn stResponse />            
    	</cffunction>
    	
    	<cffunction name="DescribeEnvironments" access="public" returntype="Struct" >            
    		<cfargument name="ApplicationName" type="string" required="false" default="" >
			<cfargument name="EnvironmentIds" type="string" required="false" default="" >
			<cfargument name="EnvironmentNames" type="string" required="false" default="" >
			<cfargument name="IncludeDeleted" type="string" required="false" default="" >
			<cfargument name="IncludedDeletedBackTo" type="string" required="false" default="" >
			<cfargument name="VersionLabel" type="string" required="false" default="" >	            
        			            
        		<cfset var stResponse = createResponse() />            
        		<cfset var body = "Action=DescribeEnvironments"/>            
        		            
        		<cfif len(trim(arguments.ApplicationName))>            
        			<cfset body &= "&ApplicationName=" & trim(arguments.ApplicationName) />            
        		</cfif>
        		
        		<cfloop from="1" to="#listlen(arguments.EnvironmentIds)#" index="i">            
        			<cfset body &= "&EnvironmentIds.member." & i & "=" & trim(listgetat(arguments.EnvironmentIds,i)) />            
        		</cfloop>	
        		 
        		<cfloop from="1" to="#listlen(arguments.EnvironmentNames)#" index="j">            
        			<cfset body &= "&EnvironmentNames.member." & j & "=" & trim(listgetat(arguments.EnvironmentNames,j)) />            
        		</cfloop>	
        		 
        		<cfif len(trim(arguments.IncludeDeleted))>            
        			<cfset body &= "&IncludeDeleted=" & trim(arguments.IncludeDeleted) />            
        		</cfif>	
        		 
        		<cfif len(trim(arguments.IncludedDeletedBackTo))>            
        			<cfset body &= "&IncludedDeletedBackTo=" & trim(arguments.IncludedDeletedBackTo) />            
        		</cfif>	 	         
        		
        		<cfif len(trim(arguments.VersionLabel))>            
        			<cfset body &= "&VersionLabel=" & trim(arguments.VersionLabel) />            
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
        			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'Environments')[1].xmlChildren />            
        			<cfset stResponse.result = [] />  
					
				<cfloop array="#dataResult#" index="result">
						<cfset arrayAppend(stResponse.result,{
													VersionLabel=getValue(result,'VersionLabel'),
													Status=getValue(result,'Status'),
													ApplicationName=getValue(result,'ApplicationName'),
													EndpointURL=getValue(result,'EndpointURL'),
													CNAME=getValue(result,'CNAME'),
													Health=getValue(result,'Health'),
													EnvironmentId=getValue(result,'EnvironmentId'),
													DateUpdated=getValue(result,'DateUpdated'),
													SolutionStackName=getValue(result,'SolutionStackName'),
													Description=getValue(result,'Description'),
													EnvironmentName=getValue(result,'EnvironmentName'),
													DateCreated=getValue(result,'DateCreated')												
											}) />
						
				</cfloop>				          
        			            
        		</cfif>            
        		            
        		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />            
        						            
        		<cfreturn stResponse />            
        	</cffunction>
        	
        	<cffunction name="ListAvailableSolutionStacks" access="public" returntype="Struct" >                
        		<cfset var stResponse = createResponse() />                
        		<cfset var body = "Action=ListAvailableSolutionStacks"/>                
        		                
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
        			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'SolutionStacks')[1].xmlChildren />                
        			<cfset stResponse.result = [] />
					
				<cfloop array="#dataResult#" index="result">
					<cfset arrayAppend(stResponse.result,result.xmlText) />	
				</cfloop>			                
        			                
        		</cfif>                
        		                
        		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />                
        						                
        		<cfreturn stResponse />                
        	</cffunction>
        	
        	<cffunction name="RebuildEnvironment" access="public" returntype="Struct" >                
        		<cfargument name="EnvironmentId" type="string" required="false" default="" >                
        		<cfargument name="EnvironmentName" type="string" required="false" default="" >                
        			                
        		<cfset var stResponse = createResponse() />                
        		<cfset var body = "Action=RebuildEnvironment"/>                
        		                
        		<cfif len(trim(arguments.EnvironmentId))>                
        			<cfset body &= "&EnvironmentId=" & trim(arguments.EnvironmentId) />                
        		</cfif>	
        		
        		<cfif len(trim(arguments.EnvironmentName))>                
        			<cfset body &= "&EnvironmentName=" & trim(arguments.EnvironmentName) />                
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
        	
        	<cffunction name="RequestEnvironmentInfo" access="public" returntype="Struct" >                
        		<cfargument name="InfoType" type="string" required="true" hint="available value is tail">                
        		<cfargument name="EnvironmentId" type="string" required="false" default="" >
			<cfargument name="EnvironmentName" type="string" required="false" default="" >   	                
        			                
        		<cfset var stResponse = createResponse() />                
        		<cfset var body = "Action=RequestEnvironmentInfo&InfoType=" & trim(arguments.InfoType)/>                
        		                
        		<cfif len(trim(arguments.EnvironmentId))>                
        			<cfset body &= "&EnvironmentId=" & trim(arguments.EnvironmentId) />                
        		</cfif>
        		
        		<cfif len(trim(arguments.EnvironmentName))>                
        			<cfset body &= "&EnvironmentName=" & trim(arguments.EnvironmentName) />                
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
        	
	<cffunction name="RestartAppServer" access="public" returntype="Struct" >    
    		<cfargument name="EnvironmentId" type="string" required="false" default="" >    
    		<cfargument name="EnvironmentName" type="string" required="false" default="" >
    				    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=RestartAppServer"/>    
    		    
    		<cfif len(trim(arguments.EnvironmentId))>    
    			<cfset body &= "&EnvironmentId=" & trim(arguments.EnvironmentId) />    
    		</cfif>	
    		
    		<cfif len(trim(arguments.EnvironmentName))>    
    			<cfset body &= "&EnvironmentName=" & trim(arguments.EnvironmentName) />    
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
    	
    	<cffunction name="RetrieveEnvironmentInfo" access="public" returntype="Struct" >        
    		<cfargument name="InfoType" type="string" required="true" hint="available value is tail">                
    		<cfargument name="EnvironmentId" type="string" required="false" default="" >
		<cfargument name="EnvironmentName" type="string" required="false" default="" >   	                
    			                
    		<cfset var stResponse = createResponse() />                
    		<cfset var body = "Action=RetrieveEnvironmentInfo&InfoType=" & trim(arguments.InfoType)/>                
    		                
    		<cfif len(trim(arguments.EnvironmentId))>                
    			<cfset body &= "&EnvironmentId=" & trim(arguments.EnvironmentId) />                
    		</cfif>
    		
    		<cfif len(trim(arguments.EnvironmentName))>                
    			<cfset body &= "&EnvironmentName=" & trim(arguments.EnvironmentName) />                
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
				<Cfdump var="#xmlParse(rawResult.filecontent)#" />
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'EnvironmentInfo')[1].xmlChildren />        
    			<cfset stResponse.result = [] />        
    			 
    			 <cfloop array="#dataResult#" index="result">
					<cfset arrayAppend(stResponse.result,{
												Message=getValue(result,'Message'),
												SampleTimestamp=getValue(result,'SampleTimestamp'),
												InfoType=getValue(result,'InfoType'),
												Ec2InstanceId=getValue(Ec2InstanceId,'Message')
											}) />	 
			</cfloop>			 
    		</cfif>        
    		        
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />        
    						        
    		<cfreturn stResponse />        
    	</cffunction>
    	
    	<cffunction name="SwapEnvironmentCNAMEs" access="public" returntype="Struct" >        
    		<cfargument name="DestinationEnvironmentId" type="string" required="false" default="" >
		<cfargument name="DestinationEnvironmentName" type="string" required="false" default="" >  
		<cfargument name="SourceEnvironmentId" type="string" required="false" default="" >  
		<cfargument name="SourceEnvironmentName" type="string" required="false" default="" >          
    			        
    		<cfset var stResponse = createResponse() />        
    		<cfset var body = "Action=SwapEnvironmentCNAMEs"/>        
    		        
    		<cfif len(trim(arguments.DestinationEnvironmentId))>        
    			<cfset body &= "&DestinationEnvironmentId=" & trim(arguments.DestinationEnvironmentId) />        
    		</cfif>	
    		
    		<cfif len(trim(arguments.DestinationEnvironmentName))>        
    			<cfset body &= "&DestinationEnvironmentName=" & trim(arguments.DestinationEnvironmentName) />        
    		</cfif>	
    		
    		<cfif len(trim(arguments.SourceEnvironmentId))>        
    			<cfset body &= "&SourceEnvironmentId=" & trim(arguments.SourceEnvironmentId) />        
    		</cfif>	
    		
    		<cfif len(trim(arguments.SourceEnvironmentName))>        
    			<cfset body &= "&SourceEnvironmentName=" & trim(arguments.SourceEnvironmentName) />        
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
    	
    	<cffunction name="TerminateEnvironment" access="public" returntype="Struct" >        
    		<cfargument name="EnvironmentId" type="string" required="false" default="" >
		<cfargument name="EnvironmentName" type="string" required="false" default="" >  
		<cfargument name="TerminateResources" type="Boolean" required="false" default="true" >          
    			        
    		<cfset var stResponse = createResponse() />        
    		<cfset var body = "Action=TerminateEnvironment"/>        
    		        
    		<cfif len(trim(arguments.EnvironmentId))>        
    			<cfset body &= "&EnvironmentId=" & trim(arguments.EnvironmentId) />        
    		</cfif>
    		
    		<cfif len(trim(arguments.EnvironmentName))>        
    			<cfset body &= "&EnvironmentName=" & trim(arguments.EnvironmentName) />        
    		</cfif>
    		
    		<cfif !arguments.TerminateResources>        
    			<cfset body &= "&TerminateResources=false" />        
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'TerminateEnvironmentResult')[1] />        
    			<cfset stResponse.result = {
										VersionLabel=getValue(dataResult,'VersionLabel'),
										Status=getValue(dataResult,'Status'),
										ApplicationName=getValue(dataResult,'ApplicationName'),
										EndpointURL=getValue(dataResult,'EndpointURL'),
										CNAME=getValue(dataResult,'CNAME'),
										Health=getValue(dataResult,'Health'),
										EnvironmentId=getValue(dataResult,'EnvironmentId'),
										DateUpdated=getValue(dataResult,'DateUpdated'),
										SolutionStackName=getValue(dataResult,'SolutionStackName'),
										Description=getValue(dataResult,'Description'),
										EnvironmentName=getValue(dataResult,'EnvironmentName'),
										DateCreated=getValue(dataResult,'DateCreated')
									} />        
    			        
    		</cfif>        
    		        
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />        
    						        
    		<cfreturn stResponse />        
    	</cffunction>
    	
	<cffunction name="UpdateApplication" access="public" returntype="Struct" >        
    		<cfargument name="ApplicationName" type="string" required="true" >        
    		<cfargument name="Description" type="string" required="false" default="" >        
    			        
    		<cfset var stResponse = createResponse() />        
    		<cfset var body = "Action=UpdateApplication&ApplicationName=" & trim(arguments.ApplicationName)/>        
    		        
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'Application')[1] />        
    			<cfset stResponse.result = {
										Description=getValue(dataResult,'Description'),
										ApplicationName=getValue(dataResult,'ApplicationName'),
										DateCreated=getValue(dataResult,'DateCreated'),
										DateUpdated=getValue(dataResult,'DateUpdated'),
										ConfigurationTemplates=[],
										Versions=[]
									} />   
			<cfloop array="#dataResult.ConfigurationTemplates.xmlChildren#" index="template">
					<cfset arrayAppend(stResponse.result.ConfigurationTemplates,template.xmlText) />
			</cfloop>
			
			<cfloop array="#dataResult.Versions.xmlChildren#" index="version">
					<cfset arrayAppend(stResponse.result.Versions,version.xmlText) />
			</cfloop>									     
    		</cfif>        
    		        
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />        
    						        
    		<cfreturn stResponse />        
    	</cffunction>
    	
	<cffunction name="UpdateApplicationVersion" access="public" returntype="Struct" >        
    		<cfargument name="ApplicationName" type="string" required="true" >
		<cfargument name="VersionLabel" type="string" required="true" >             
    		<cfargument name="Description" type="string" required="false" default="" >        
    			        
    		<cfset var stResponse = createResponse() />        
    		<cfset var body = "Action=UpdateApplicationVersion&ApplicationName=" & trim(arguments.ApplicationName) & "&VersionLabel=" & trim(arguments.VersionLabel)/>        
    		        
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'ApplicationVersion')[1] />        
    			<cfset stResponse.result = {
						VersionLabel=getValue(dataResult,'VersionLabel'),
						Description=getValue(dataResult,'Description'),
						ApplicationName=getValue(dataResult,'ApplicationName'),
						DateCreated=getValue(dataResult,'DateCreated'),
						DateUpdated=getValue(dataResult,'DateUpdated'),
						SourceBundle={}
				} />   
				
			<cfloop array="#dataResult.SourceBundle.xmlChildren#" index="bundle">
				<cfset stResponse.result.SourceBundle[bundle.xmlName] = bundle.xmlText />
			</cfloop>	       
    			        
    		</cfif>        
    		        
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />        
    						        
    		<cfreturn stResponse />        
    	</cffunction>
    	
	<cffunction name="UpdateConfigurationTemplate" access="public" returntype="Struct" >        
    		<cfargument name="ApplicationName" type="string" required="true" >    
		<cfargument name="TemplateName" type="string" required="true" >  	
    		<cfargument name="Description" type="string" required="false" default="" >
		<cfargument name="EnvironmentId" type="string" required="false" default="" >    
		<cfargument name="OptionSettings" type="string" required="false" default="" >    
		<cfargument name="SolutionStackName" type="string" required="false" default="" >    
		<cfargument name="SourceConfiguration" type="string" required="false" default="" >                    
    				                
    		<cfset var stResponse = createResponse() />                
    		<cfset var body = "Action=UpdateConfigurationTemplate&ApplicationName=" & trim(arguments.ApplicationName) & "&TemplateName=" & arguments.TemplateName/>                
    		                
    		<cfif len(trim(arguments.Description))>                
    			<cfset body &= "&Description=" & trim(arguments.Description) />                
    		</cfif>	 
    		
    		<cfif len(trim(arguments.EnvironmentId))>                
    			<cfset body &= "&EnvironmentId=" & trim(arguments.EnvironmentId) />                
    		</cfif>	
    		
    		<cfloop from="1" to="#listlen(arguments.OptionSettings)#" index="i">         
    			<cfset body &= "&OptionSettings.member." & i & "=" & trim(listGetAt(arguments.OptionSettings,i)) />                
		</cfloop>	
    		
    		<cfif len(trim(arguments.SolutionStackName))>                
    			<cfset body &= "&SolutionStackName=" & trim(arguments.SolutionStackName) />                
    		</cfif>	
    		
    		<cfif len(trim(arguments.SourceConfiguration))>                
    			<cfset body &= "&SourceConfiguration=" & trim(arguments.SourceConfiguration) />                
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'UpdateConfigurationTemplateResult')[1] />        
    			<cfset stResponse.result = {
						SolutionStackName=getValue(dataResult,'SolutionStackName'),
						OptionSettings=[],
						Description=getValue(dataResult,'Description'),
						ApplicationName=getValue(dataResult,'ApplicationName'),
						DateCreated=getValue(dataResult,'DateCreated'),
						TemplateName=getValue(dataResult,'TemplateName'),
						DateUpdated=getValue(dataResult,'DateUpdated')
				} />                
				
				<cfloop array="#dataResult.OptionSettings.xmlChildren#" index="option">
					<cfset arrayAppend(stResponse.result.OptionSettings,{
												OptionName=getValue(option,'OptionName'),
												Value=getValue(option,'Value'),
												Namespace=getValue(option,'Namespace')
											}) />
				</cfloop>	     
    			        
    		</cfif>        
    		        
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />        
    						        
    		<cfreturn stResponse />        
    	</cffunction>
    	
    	<cffunction name="UpdateEnvironment" access="public" returntype="Struct" >        
    		<cfargument name="ApplicationName" type="string" required="true" >       
		<cfargument name="EnvironmentName" type="string" required="false" default="" >  
		<cfargument name="environmentID" type="string" required="false" default="" >
    		<cfargument name="CNAMEPrefix" type="string" required="false" default="" >                
		<cfargument name="Description" type="string" required="false" default="" > 
		<cfargument name="OptionSettings" type="array" required="false" default="#[]#" > 
		<cfargument name="OptionsToRemove" type="array" required="false" default="#[]#" > 
		<cfargument name="SolutionStackName" type="string" required="false" default="" > 
		<cfargument name="TemplateName" type="string" required="false" default="" > 
		<cfargument name="VersionLabel" type="string" required="false" default="" >      
    			        
    		<cfset var stResponse = createResponse() />                
    		<cfset var body = "Action=UpdateEnvironment&ApplicationName=" & trim(arguments.ApplicationName)/>                
    		                
    		<cfif len(trim(arguments.EnvironmentName))>                
    			<cfset body &= "&EnvironmentName=" & trim(arguments.EnvironmentName) />                
    		</cfif>
    		
    		<cfif len(trim(arguments.environmentID))>                
    			<cfset body &= "&EnvironmentId=" & trim(arguments.environmentID) />                
    		</cfif>
    		
    		<cfif len(trim(arguments.CNAMEPrefix))>                
    			<cfset body &= "&CNAMEPrefix=" & trim(arguments.CNAMEPrefix) />                
    		</cfif>	           
    		
    		<cfif len(trim(arguments.Description))>                
    			<cfset body &= "&Description=" & trim(arguments.Description) />                
    		</cfif>	
    		
    		<cfloop from="1" to="#arrayLen(arguments.OptionSettings)#" index="i">             
    			<cfset body &= "&OptionSettings.member." & i & ".Namespace=" & trim(arguments.OptionSettings[i].Namespace)  
						& "&OptionSettings.member." & i & ".OptionName=" & trim(arguments.OptionSettings[i].OptionName)
						& "&OptionSettings.member." & i & ".Value=" & trim(arguments.OptionSettings[i].Value)  />                
		</cfloop>

		<cfloop from="1" to="#arrayLen(arguments.OptionsToRemove)#" index="i">             
    			<cfset body &= "&OptionsToRemove.member." & i & ".Namespace=" & trim(arguments.OptionSettings[i].Namespace)  
						& "&OptionsToRemove.member." & i & ".OptionName=" & trim(arguments.OptionSettings[i].OptionName)  />                
		</cfloop>	
    		
    		<cfif len(trim(arguments.SolutionStackName))>    
    			<cfset body &= "&SolutionStackName=" & trim(arguments.SolutionStackName) />                
    		</cfif>	
    		
    		<cfif len(trim(arguments.TemplateName))>                
    			<cfset body &= "&TemplateName=" & trim(arguments.TemplateName) />                
    		</cfif>	
    		
    		<cfif len(trim(arguments.VersionLabel))>                
    			<cfset body &= "&VersionLabel=" & trim(arguments.VersionLabel) />                
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'UpdateEnvironmentResult')[1] />        
    			<cfset stResponse.result = {
						ApplicationName=getValue(dataResult,'ApplicationName'),
						CNAME=getValue(dataResult,'CNAME'),
						DateCreated=getValue(dataResult,'DateCreated'),
						DateUpdated=getValue(dataResult,'DateUpdated'),
						Description=getValue(dataResult,'Description'),
						EndpointURL=getValue(dataResult,'EndpointURL'),
						EnvironmentId=getValue(dataResult,'EnvironmentId'),
						EnvironmentName=getValue(dataResult,'EnvironmentName'),
						Health=getValue(dataResult,'Health'),
						SolutionStackName=getValue(dataResult,'SolutionStackName'),
						Status=getValue(dataResult,'Status'),
						TemplateName=getValue(dataResult,'TemplateName'),
						VersionLabel=getValue(dataResult,'VersionLabel'),
						VersionLabel=getValue(dataResult,'VersionLabel')
				} />         
    			        
    		</cfif>        
    		        
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />        
    						        
    		<cfreturn stResponse />        
    	</cffunction>
    	
	<cffunction name="ValidateConfigurationSettings" access="public" returntype="Struct" >        
    		<cfargument name="ApplicationName" type="string" required="true" > 
		<cfargument name="OptionSettings" type="array" required="true" >
    		<cfargument name="EnvironmentName" type="string" required="false" default="" >
		<cfargument name="TemplateName" type="string" required="false" default="" >        
    			        
    		<cfset var stResponse = createResponse() />        
    		<cfset var body = "Action=ValidateConfigurationSettings&ApplicationName=" & trim(arguments.ApplicationName)/>        
    		 
    		<cfloop from="1" to="#arrayLen(arguments.OptionSettings)#" index="i">             
    			<cfset body &= "&OptionSettings.member." & i & ".Namespace=" & trim(arguments.OptionSettings[i].Namespace)  
						& "&OptionSettings.member." & i & ".OptionName=" & trim(arguments.OptionSettings[i].OptionName)
						& "&OptionSettings.member." & i & ".Value=" & trim(arguments.OptionSettings[i].Value)  />                
		</cfloop>
		
    		<cfif len(trim(arguments.EnvironmentName))>        
    			<cfset body &= "&EnvironmentName=" & trim(arguments.EnvironmentName) />        
    		</cfif>
    		
    		<cfif len(trim(arguments.TemplateName))>        
    			<cfset body &= "&TemplateName=" & trim(arguments.TemplateName) />        
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'Messages')[1].xmlChildren />
    			<cfset stResponse.result = [] />
			<cfloop array="#dataResult#" index="result">
					<cfset arrayAppend(stResponse.result,{
											Message=getValue(result,'Message'),
											Namespace=getValue(result,'Namespace'),
											OptionName=getValue(result,'OptionName'),
											Severity=getValue(result,'Severity')
										}) />
			</cfloop>			        
    			        
    		</cfif>        
    		        
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />        
    						        
    		<cfreturn stResponse />        
    	</cffunction>
    	
	<cffunction name="DeleteEnvironmentConfiguration" access="public" returntype="Struct" >        
    		<cfargument name="ApplicationName" type="string" required="true" >        
    		<cfargument name="EnvironmentName" type="string" required="true" >        
    			        
    		<cfset var stResponse = createResponse() />        
    		<cfset var body = "Action=DeleteEnvironmentConfiguration&ApplicationName=" & trim(arguments.ApplicationName) & "&EnvironmentName=" & trim(arguments.EnvironmentName)/>        
    		        
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
    	
    	<cffunction name="DeleteConfigurationTemplate" access="public" returntype="Struct" >        
    		<cfargument name="ApplicationName" type="string" required="true" >        
    		<cfargument name="TemplateName" type="string" required="true" >        
    			        
    		<cfset var stResponse = createResponse() />        
    		<cfset var body = "Action=DeleteConfigurationTemplate&ApplicationName=" & trim(arguments.ApplicationName) & "&TemplateName=" & trim(arguments.TemplateName)/>        
    		        
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
    	
    	<cffunction name="DeleteApplicationVersion" access="public" returntype="Struct" >        
    		<cfargument name="ApplicationName" type="string" required="true" >        
    		<cfargument name="VersionLabel" type="string" required="true" >        
    		<cfargument name="DeleteSourceBundle" type="Boolean" required="false" default="false" >
    			        
    		<cfset var stResponse = createResponse() />        
    		<cfset var body = "Action=DeleteApplicationVersion&ApplicationName=" & trim(arguments.ApplicationName) & "&VersionLabel=" & trim(arguments.VersionLabel)/>        
    		<cfset body &= "&DeleteSourceBundle=" & trim(arguments.DeleteSourceBundle) />        
    		        
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
    	
    	<cffunction name="DeleteApplication" access="public" returntype="Struct" >        
    		<cfargument name="ApplicationName" type="string" required="true" >        
    			        
    		<cfset var stResponse = createResponse() />        
    		<cfset var body = "Action=DeleteApplication&ApplicationName=" & trim(arguments.ApplicationName)/>        
    		        
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