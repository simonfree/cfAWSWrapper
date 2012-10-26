<cfcomponent output="false" extends="amazonAWS" >
	<cffunction name="init" access="public" returntype="amazonMapReduce" >
		<cfargument name="awsAccessKeyId" type="string" required="true"/>
		<cfargument name="secretAccessKey" type="string" required="true"/>
		<cfargument name="endPoint" type="string" required="true" default="elasticmapreduce.amazonaws.com"/>
				
		<cfset variables.awsAccessKeyId = arguments.awsAccessKeyId />
		<cfset variables.secretAccesskey = arguments.secretAccessKey />
		<cfset variables.endPoint = arguments.endPoint />
		<cfset variables.requestMethod = 'no-header' />
		<cfset variables.version = '2009-03-31' />
		<cfset variables.protocol = 'https://' />
		<cfreturn this />		
	</cffunction>
	
	<cffunction name="DescribeJobFlows" access="public" returntype="struct" >
		
		<cfset var stResponse = createResponse() /> 
		<cfset var body = "Action=DescribeJobFlows"/>
		
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'JobFlows')[1].xmlChildren />
    			<cfset stResponse.result = [] />
						        
    			<cfloop array="#dataResult#" index="result">
					<cfset arrayAppend(stResponse.result,createJobFlowDetailObject(result)) />
			</cfloop>        
    		</cfif>        
    		        
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />        
    						        
    		<cfreturn stResponse /> 
	</cffunction>	
	
	<cffunction name="AddInstanceGroups" access="public" returntype="Struct" >    
    		<cfargument name="InstanceGroups" type="array" required="true" >    
    		<cfargument name="JobFlowId" type="string" required="true" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=AddInstanceGroups&JobFlowId=" & trim(arguments.JobFlowId)/>    
    		    
    		<cfloop from="1" to="#arrayLen(arguments.instanceGroups)#" index="i">
			<cfset body &= "&InstanceGroups.member." & i & ".BidPrice=" & trim(Arguments.InstanceGroups[i].BidPrice)	
						& "&InstanceGroups.member." & i & ".InstanceCount=" & trim(Arguments.InstanceGroups[i].InstanceCount)
						& "&InstanceGroups.member." & i & ".InstanceRole=" & trim(Arguments.InstanceGroups[i].InstanceRole)
						& "&InstanceGroups.member." & i & ".InstanceType=" & trim(Arguments.InstanceGroups[i].InstanceType)
						& "&InstanceGroups.member." & i & ".Market=" & trim(Arguments.InstanceGroups[i].Market)
						& "&InstanceGroups.member." & i & ".Name=" & trim(Arguments.InstanceGroups[i].Name)	/>
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
    			<cfset stResponse.result = {InstanceGroupId=getResultNodes(xmlParse(rawResult.filecontent),'InstanceGroupId')[1].xmlText} />    
    			    
    		</cfif>    
    		    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    						    
    		<cfreturn stResponse />    
    	</cffunction>
    	
	<cffunction name="AddJobFlowSteps" access="public" returntype="Struct" >        
    		<cfargument name="JobFlowId" type="string" required="true" >        
    		<cfargument name="Steps" type="array" required="false" default="" >        
    			        
    		<cfset var stResponse = createResponse() />        
    		<cfset var body = "Action=AddJobFlowSteps&JobFlowId=" & trim(arguments.JobFlowId)/>        
    		        
    		<cfloop from="1" to="#arrayLen(arguments.steps)#" index="i">
			<cfset body &= "&Steps.member." & i & ".Name=" & arguments.steps[i].Name />	
			<cfset body &= "&Steps.member." & i & ".ActionOnFailure=" & arguments.steps[i].ActionOnFailure />
			
			<cfif structKeyExists(arguments.steps[i],'HadoopJarStep')>
				<cfset body &= "&Steps.member." & i & ".HadoopJarStep.Jar=" & arguments.steps[i].HadoopJarStep.jar />
				<cfset body &= "&Steps.member." & i & ".HadoopJarStep.MainClass=" & arguments.steps[i].HadoopJarStep.MainClass />
				
				<cfif structKeyExists(arguments.steps[i].HadoopJarStep,'Properties')>
					<cfloop from="1" to="#arrayLen(arguments.steps[i].HadoopJarStep.Properties)#" index="j">
						<cfset property = arguments.steps[i].HadoopJarStep.Properties[j] />
						<cfset body &= "&Steps.member." & i & ".HadoopJarStep.Properties.member." & j & ".Key=" & property.key />
						<cfset body &= "&Steps.member." & i & ".HadoopJarStep.Properties.member." & j & ".Value=" & property.Value />
					</cfloop>	
				</cfif>
			
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
    	
	<cffunction name="ModifyInstanceGroups" access="public" returntype="Struct" >
		<cfargument name="InstanceGroups" type="array" required="true" >
			
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=ModifyInstanceGroups"/>
		
		<cfloop from="1" to="#arrayLen(arguments.InstanceGroups)#" index="i">
			<cfset body &= "&InstanceGroups.member." & i & ".InstanceCount=" & arguments.steps[i].InstanceCount />	
			<cfset body &= "&InstanceGroups.member." & i & ".InstanceGroupId=" & arguments.steps[i].InstanceGroupId />
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

	<cffunction name="RunJobFlow" access="public" returntype="Struct" > 
		<cfargument name="Name" type="String" required="true" > 
    		<cfargument name="Instances" type="Struct" required="true" >    
    		<cfargument name="AdditionalInfo" type="string" required="false" default="" >    
    		<cfargument name="AmiVersion" type="string" required="false" default="" >    
    		<cfargument name="BootstrapActions" type="array" required="false" default="#[]#" >    
    		<cfargument name="LogUri" type="string" required="false" default="" >    
    		<cfargument name="Steps" type="array" required="false" default="#[]#" >    
    		<cfargument name="SupportedProducts" type="string" required="false" default="" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=RunJobFlow"/>    
    		
		<cfset body &= createJobFlowInstancesConfigObject(arguments.instances) />		
    		    
    		<cfif len(trim(arguments.AdditionalInfo))>    
    			<cfset body &= "&AdditionalInfo=" & trim(arguments.AdditionalInfo) />    
    		</cfif>	    
    		 
    		<cfif len(trim(arguments.AmiVersion))>    
    			<cfset body &= "&AmiVersion=" & trim(arguments.AmiVersion) />    
    		</cfif>	    
    		
    		<cfloop from="1" to="#arrayLen(arguments.BootstrapActions)#" index="j">
			<cfset body &= createBootstrapActionConfigObject(arguments.instances[j],j) />		
		</cfloop>
    		
    		<cfif len(trim(arguments.LogUri))>    
    			<cfset body &= "&LogUri=" & trim(arguments.LogUri) />    
    		</cfif>
    		
    		<cfloop from="1" to="#arrayLen(arguments.Steps)#" index="k">
			<cfset body &= createStepConfigObject(arguments.Steps[k],k) />		
		</cfloop>
		
		
		<cfloop from="1" to="#listLen(arguments.SupportedProducts)#" index="m">
			<cfset body &= "&SupportedProducts.member." & m & "=" & trim(listGetAt(arguments.SupportedProducts,m)) />		
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
    			<cfset stResponse.result = getResultNodes(xmlParse(rawResult.filecontent),'JobFlowId')[1].xmlText />    
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>
    	
    	
	<cffunction name="SetTerminationProtection" access="public" returntype="Struct" >    
    		<cfargument name="JobFlowIds" type="string" required="true" >    
    		<cfargument name="TerminationProtected" type="string" required="true" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=SetTerminationProtection&TerminationProtected=" & trim(arguments.TerminationProtected)/>    
    		    
    		<cfloop from="1" to="#listLen(arguments.JobFlowIds)#" index="i">
			<cfset body &= "&JobFlowIds.member." & i & "=" & listgetAt(arguments.JobFlowIds,i) />		
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
    	
    <cffunction name="TerminateJobFlows" access="public" returntype="Struct" >    
    		<cfargument name="JobFlowIds" type="string" required="true" >        
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=TerminateJobFlows"/>    
    		    
    		<cfloop from="1" to="#listLen(arguments.JobFlowIds)#" index="i">
			<cfset body &= "&JobFlowIds.member." & i & "=" & listgetAt(arguments.JobFlowIds,i) />		
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
    	
    	
    	<cffunction name="createJobFlowInstancesConfigObject" access="private" returntype="String" output="false" >
		<cfargument name="stData" type="struct" required="true" >		
		
		<cfset var result = '' />
		
		<cfif structKeyExists(arguments.stData,'Ec2KeyName')>
			<cfset result &= '&Instances.Ec2KeyName=' & trim(arguments.stData.Ec2KeyName) />
		</cfif>	
		
		<cfif structKeyExists(arguments.stData,'Ec2SubnetId')>
			<cfset result &= '&Instances.Ec2SubnetId=' & trim(arguments.stData.Ec2SubnetId) />
		</cfif>	
		
		<cfif structKeyExists(arguments.stData,'HadoopVersion')>
			<cfset result &= '&Instances.HadoopVersion=' & trim(arguments.stData.HadoopVersion) />
		</cfif>	
		
		<cfif structKeyExists(arguments.stData,'InstanceGroups')>
			<cfif StructKeyExists(arguments.stData.InstanceGroups,'BidPrice')>
				<cfset result &= '&Instances.InstanceGroups.BidPrice=' & trim(arguments.stData.InstanceGroups.BidPrice) />
			</cfif>
			
			<cfif StructKeyExists(arguments.stData.InstanceGroups,'InstanceCount')>
				<cfset result &= '&Instances.InstanceGroups.InstanceCount=' & trim(arguments.stData.InstanceGroups.InstanceCount) />
			</cfif>
			
			<cfif StructKeyExists(arguments.stData.InstanceGroups,'InstanceRole')>
				<cfset result &= '&Instances.InstanceGroups.InstanceRole=' & trim(arguments.stData.InstanceGroups.InstanceRole) />
			</cfif>
			
			<cfif StructKeyExists(arguments.stData.InstanceGroups,'InstanceType')>
				<cfset result &= '&Instances.InstanceGroups.InstanceType=' & trim(arguments.stData.InstanceGroups.InstanceType) />
			</cfif>
			
			<cfif StructKeyExists(arguments.stData.InstanceGroups,'Market')>
				<cfset result &= '&Instances.InstanceGroups.Market=' & trim(arguments.stData.InstanceGroups.Market) />
			</cfif>
			
			<cfif StructKeyExists(arguments.stData.InstanceGroups,'Name')>
				<cfset result &= '&Instances.InstanceGroups.Name=' & trim(arguments.stData.InstanceGroups.Name) />
			</cfif>	
		</cfif>	
		
		<cfif structKeyExists(arguments.stData,'KeepJobFlowAliveWhenNoSteps')>
			<cfset result &= '&Instances.KeepJobFlowAliveWhenNoSteps=' & trim(arguments.stData.KeepJobFlowAliveWhenNoSteps) />
		</cfif>	
		
		<cfif structKeyExists(arguments.stData,'MasterInstanceType')>
			<cfset result &= '&Instances.MasterInstanceType=' & trim(arguments.stData.MasterInstanceType) />
		</cfif>	
		
		<cfif structKeyExists(arguments.stData,'Placement')>
			<cfset result &= '&Instances.Placement.AvailabilityZone=' & trim(arguments.stData.Placement.AvailabilityZone) />
		</cfif>
		
		<cfif structKeyExists(arguments.stData,'SlaveInstanceType')>
			<cfset result &= '&Instances.SlaveInstanceType=' & trim(arguments.stData.SlaveInstanceType) />
		</cfif>	
		
		<cfif structKeyExists(arguments.stData,'TerminationProtected')>
			<cfset result &= '&Instances.TerminationProtected=' & trim(arguments.stData.TerminationProtected) />
		</cfif>	
		
		<cfreturn result />		
	</cffunction>		
	
	<cffunction name="createBootstrapActionConfigObject" access="private" returntype="String" output="false" >
		<cfargument name="stData" type="struct" required="true" >		
		<cfargument name="position" type="numeric" required="true" >	
		
		<cfset var result = '' />
		
		<cfif structKeyExists(arguments.stData,'Name')>
			<cfset result &= '&BootstrapActions.member.' & arguments.position & '.Name=' & trim(arguments.stData.Name) />
		</cfif>	
		
		<cfif structKeyExists(arguments.stData,'ScriptBootstrapAction')>
			<cfloop from="1" to="#listlen(arguments.stData.ScriptBootstrapAction.Args)#" index="i">
				<cfset result &= '&BootstrapActions.member.' & arguments.position & '.ScriptBootstrapAction.Args.member.' & i & '=' & trim(listgetat(arguments.stData.ScriptBootstrapAction.Args,i)) />
			</cfloop>	
			<cfset result &= '&BootstrapActions.member.' & arguments.position & '.ScriptBootstrapAction.Path=' & trim(arguments.stData.ScriptBootstrapAction.Path) />
		</cfif>	
		
		<cfreturn result />		
	</cffunction>	
	
	<cffunction name="createStepConfigObject" access="private" returntype="String" output="false" >
		<cfargument name="stData" type="struct" required="true" >		
		<cfargument name="position" type="numeric" required="true" >	
		
		<cfset var result = '' />
		
		<cfif structKeyExists(arguments.stData,'ActionOnFailure')>
			<cfset result &= '&Steps.member.' & arguments.position & '.ActionOnFailure=' & trim(arguments.stData.ActionOnFailure) />
		</cfif>	
		
		<cfif structKeyExists(arguments.stData,'ScriptBootstrapAction')>
			
			<cfif structKeyExists(arguments.stData.ScriptBootstrapAction,'Jar')>
				<cfset result &= '&Steps.member.' & arguments.position & '.HadoopJarStep.Jar=' & trim(arguments.stData.ScriptBootstrapAction.Jar) />
			</cfif>
			
			<cfif structKeyExists(arguments.stData.ScriptBootstrapAction,'MainClass')>
				<cfset result &= '&Steps.member.' & arguments.position & '.HadoopJarStep.MainClass=' & trim(arguments.stData.ScriptBootstrapAction.MainClass) />
			</cfif>
			
			<cfif structKeyExists(arguments.stData.ScriptBootstrapAction,'Args')>
				<cfloop from="1" to="#listlen(arguments.stData.ScriptBootstrapAction.Args)#" index="i">
					<cfset result &= '&Steps.member.' & arguments.position & '.HadoopJarStep.Args.member.' & i & '=' & trim(listgetat(arguments.stData.ScriptBootstrapAction.Args,i)) />
				</cfloop>
			</cfif>	
			
			<cfif structKeyExists(arguments.stData.ScriptBootstrapAction,'Properties')>
				<cfloop from="1" to="#arraylen(arguments.stData.ScriptBootstrapAction.Properties)#" index="j">
					<cfset result &= '&Steps.member.' & arguments.position & '.HadoopJarStep.Properties.member.' & i & '.Key=' & trim(arguments.stData.ScriptBootstrapAction.Properties[j].Key) />
					<cfset result &= '&Steps.member.' & arguments.position & '.HadoopJarStep.Properties.member.' & i & '.Value=' & trim(arguments.stData.ScriptBootstrapAction.Properties[j].Value) />
				</cfloop>
			</cfif>
		</cfif>	
		
		<cfif structKeyExists(arguments.stData,'Name')>
			<cfset result &= '&Steps.member.' & arguments.position & '.Name=' & trim(arguments.stData.Name) />
		</cfif>	
		
		<cfreturn result />		
	</cffunction>	
	
</cfcomponent>