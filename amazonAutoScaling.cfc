<cfcomponent output="false" extends="amazonAWS" >
	<cffunction name="init" access="public" returntype="amazonAutoScaling" >
		<cfargument name="awsAccessKeyId" type="string" required="true"/>
		<cfargument name="secretAccessKey" type="string" required="true"/>
		<cfargument name="endPoint" type="string" required="true" default="autoscaling.us-east-1.amazonaws.com"/>
				
		<cfset variables.awsAccessKeyId = arguments.awsAccessKeyId />
		<cfset variables.secretAccesskey = arguments.secretAccessKey />
		<cfset variables.endPoint = arguments.endPoint />
		<cfset variables.requestMethod = 'no-header' />
		<cfset variables.version = '2011-01-01' />
		<cfset variables.protocol = 'https://' />
		<cfreturn this />		
	</cffunction>

	<cffunction name="CreateAutoScalingGroup" access="public" returntype="Struct" >    
    		<cfargument name="AutoScalingGroupName" type="string" required="true" >
		<cfargument name="AvailabilityZones" type="string" required="true" >
		<cfargument name="LaunchConfigurationName" type="string" required="true" >
		<cfargument name="MaxSize" type="string" required="true" >
		<cfargument name="MinSize" type="string" required="true" >
		
    		<cfargument name="DefaultCooldown" type="numeric" required="false" default="0" >  
		<cfargument name="DesiredCapacity" type="numeric" required="false" default="0" >
		<cfargument name="HealthCheckGracePeriod" type="numeric" required="false" default="0" >
		<cfargument name="HealthCheckType" type="string" required="false" default="" >
		<cfargument name="LoadBalancerNames" type="string" required="false" default="" >
		<cfargument name="PlacementGroup" type="string" required="false" default="" >
		<cfargument name="Tags" type="array" required="false" default="#[]#" >
		<cfargument name="VPCZoneIdentifier" type="string" required="false" default="" >	  
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=CreateAutoScalingGroup&AutoScalingGroupName=" & trim(arguments.AutoScalingGroupName)
							& "&LaunchConfigurationName=" & trim(arguments.LaunchConfigurationName)
							& "&MaxSize=" & trim(arguments.MaxSize)
							& "&MinSize=" & trim(arguments.MinSize)/>  
							
		<cfloop from="1" to="#listlen(arguments.AvailabilityZones)#" index="i">
			<cfset body &= "&AvailabilityZones.member." & i & "=" & trim(listgetat(arguments.AvailabilityZones,i)) /> 
		</cfloop>
		
		<cfloop from="1" to="#listlen(arguments.LoadBalancerNames)#" index="j">
			<cfset body &= "&LoadBalancerNames.member." & j & "=" & trim(listgetat(arguments.LoadBalancerNames,j)) /> 
		</cfloop>						  
    		    
    		<cfif val(arguments.DefaultCooldown)>    
    			<cfset body &= "&DefaultCooldown=" & trim(arguments.DefaultCooldown) />    
    		</cfif>	
    		
    		<cfif val(arguments.DesiredCapacity)>    
    			<cfset body &= "&DesiredCapacity=" & trim(arguments.DesiredCapacity) />    
    		</cfif>	
    		
    		<cfif val(arguments.HealthCheckGracePeriod)>    
    			<cfset body &= "&HealthCheckGracePeriod=" & trim(arguments.HealthCheckGracePeriod) />    
    		</cfif>
    		
    		<cfif len(trim(arguments.PlacementGroup))>    
    			<cfset body &= "&PlacementGroup=" & trim(arguments.PlacementGroup) />    
    		</cfif>	 
    		
    		<cfif len(trim(arguments.VPCZoneIdentifier))>    
    			<cfset body &= "&VPCZoneIdentifier=" & trim(arguments.VPCZoneIdentifier) />    
    		</cfif>		   
    		
    		<cfloop from="1" to="#arrayLen(arguments.Tags)#" index="k">
				<cfset body &= "&Tags.member." & k & ".Key=" & arguments.Tags[k].Key
							& "&Tags.member." & k & ".PropagateAtLaunch=" & arguments.Tags[k].PropagateAtLaunch
							& "&Tags.member." & k & ".ResourceId=" & arguments.Tags[k].ResourceId
							& "&Tags.member." & k & ".ResourceType =" & arguments.Tags[k].ResourceType 
							& "&Tags.member." & k & ".Value =" & arguments.Tags[k].Value  /> 
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
    	
    	<cffunction name="CreateLaunchConfiguration" access="public" returntype="Struct" >        
        	<cfargument name="ImageId" type="string" required="true" >   
		<cfargument name="InstanceType" type="string" required="true" >
		<cfargument name="LaunchConfigurationName" type="string" required="true" >
		     
        	<cfargument name="BlockDeviceMappings" type="array" required="false" default="#[]#" > 
		<cfargument name="InstanceMonitoring" type="string" required="false" default="" > 
		<cfargument name="KernelId" type="string" required="false" default="" > 
		<cfargument name="KeyName" type="string" required="false" default="" > 
		<cfargument name="RamdiskId" type="string" required="false" default="" > 
		<cfargument name="SecurityGroups" type="string" required="false" default="" > 		       
        	<cfargument name="UserData" type="string" required="false" default="" >
					        
        	<cfset var stResponse = createResponse() />        
        	<cfset var body = "Action=CreateLaunchConfiguration&ImageId=" & trim(arguments.ImageId) & "&InstanceType=" & trim(arguments.InstanceType) & "&LaunchConfigurationName=" & trim(arguments.LaunchConfigurationName)/>        
        		  
        	<cfloop from="1" to="#arrayLen(arguments.BlockDeviceMappings)#" index="k">
				<cfset body &= "&BlockDeviceMappings.member." & k & ".DeviceName=" & arguments.Tags[k].DeviceName
							& "&BlockDeviceMappings.member." & k & ".VirtualName=" & arguments.Tags[k].VirtualName 
							& "&BlockDeviceMappings.member." & k & ".Ebs.SnapshotId=" & arguments.Tags[k].Ebs.SnapshotId
							& "&BlockDeviceMappings.member." & k & ".Ebs.VolumeSize =" & arguments.Tags[k].Ebs.VolumeSize /> 
		</cfloop>
		
		<cfloop from="1" to="#listlen(arguments.SecurityGroups)#" index="j">
			<cfset body &= "&SecurityGroups.member." & j & "=" & trim(listgetat(arguments.SecurityGroups,j)) /> 
		</cfloop>
			        
        	<cfif len(trim(arguments.InstanceMonitoring))>        
        		<cfset body &= "&InstanceMonitoring=" & trim(arguments.InstanceMonitoring) />        
        	</cfif>
        	
        	<cfif len(trim(arguments.KernelId))>        
        		<cfset body &= "&KernelId=" & trim(arguments.KernelId) />        
        	</cfif>
        	
        	<cfif len(trim(arguments.KeyName))>        
        		<cfset body &= "&KeyName=" & trim(arguments.KeyName) />        
        	</cfif>
        	
        	<cfif len(trim(arguments.RamdiskId))>        
        		<cfset body &= "&RamdiskId=" & trim(arguments.RamdiskId) />        
        	</cfif>
        	
        	<cfif len(trim(arguments.UserData))>        
        		<cfset body &= "&UserData=" & trim(arguments.UserData) />        
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
	
	<cffunction name="CreateOrUpdateTags" access="public" returntype="Struct" >    
	    	<cfargument name="Tags" type="array" required="true" >    
	    			    
	    	<cfset var stResponse = createResponse() />    
	    	<cfset var body = "Action=CreateOrUpdateTags"/>    
	    		    
	    	<cfloop from="1" to="#arrayLen(arguments.Tags)#" index="k">
				<cfset body &= "&Tags.member." & k & ".Key=" & arguments.Tags[k].Key
							& "&Tags.member." & k & ".PropagateAtLaunch=" & arguments.Tags[k].PropagateAtLaunch
							& "&Tags.member." & k & ".ResourceId=" & arguments.Tags[k].ResourceId
							& "&Tags.member." & k & ".ResourceType =" & arguments.Tags[k].ResourceType 
							& "&Tags.member." & k & ".Value =" & arguments.Tags[k].Value  /> 
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
    
    <cffunction name="DeleteAutoScalingGroup" access="public" returntype="Struct" >    
	    	<cfargument name="AutoScalingGroupName" type="string" required="true" >    
	    	<cfargument name="ForceDelete" type="string" required="false" default="" >    
	    			    
	    	<cfset var stResponse = createResponse() />    
	    	<cfset var body = "Action=DeleteAutoScalingGroup&AutoScalingGroupName=" & trim(arguments.AutoScalingGroupName)/>    
	    		    
	    	<cfif len(trim(arguments.ForceDelete))>    
	    		<cfset body &= "&ForceDelete=" & trim(arguments.ForceDelete) />    
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
    
    <cffunction name="DeleteLaunchConfiguration" access="public" returntype="Struct" >    
    		<cfargument name="LaunchConfigurationName" type="string" required="true" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=DeleteLaunchConfiguration&LaunchConfigurationName=" & trim(arguments.LaunchConfigurationName)/>    
    		    
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

	<cffunction name="DeleteNotificationConfiguration" access="public" returntype="Struct" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=DeleteNotificationConfiguration"/>    
    		    
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
    	
    	<cffunction name="DeletePolicy" access="public" returntype="Struct" >        
        			        
    		<cfset var stResponse = createResponse() />        
    		<cfset var body = "Action=DeletePolicy"/>        
    		        
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
    	
    	<cffunction name="DeleteScheduledAction" access="public" returntype="Struct" >        
    		<cfargument name="ScheduledActionName" type="string" required="true" >        
    		<cfargument name="AutoScalingGroupName" type="string" required="false" default="" >        
    			        
    		<cfset var stResponse = createResponse() />        
    		<cfset var body = "Action=DeleteScheduledAction&ScheduledActionName=" & trim(arguments.ScheduledActionName )/>        
    		        
    		<cfif len(trim(arguments.AutoScalingGroupName))>        
    			<cfset body &= "&AutoScalingGroupName=" & trim(arguments.AutoScalingGroupName) />        
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
    	
    	<cffunction name="DeleteTags" access="public" returntype="Struct" >        
        		<cfargument name="tags" type="array" required="true" >        
        			        
        		<cfset var stResponse = createResponse() />        
        		<cfset var body = "Action=DeleteTags"/>        
        		        
        		<cfloop from="1" to="#arrayLen(arguments.Tags)#" index="k">
				<cfset body &= "&Tags.member." & k & ".Key=" & arguments.Tags[k].Key
							& "&Tags.member." & k & ".PropagateAtLaunch=" & arguments.Tags[k].PropagateAtLaunch
							& "&Tags.member." & k & ".ResourceId=" & arguments.Tags[k].ResourceId
							& "&Tags.member." & k & ".ResourceType =" & arguments.Tags[k].ResourceType 
							& "&Tags.member." & k & ".Value =" & arguments.Tags[k].Value  /> 
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
        	
        	<cffunction name="DescribeAdjustmentTypes" access="public" returntype="Struct" >            
        			            
        		<cfset var stResponse = createResponse() />            
        		<cfset var body = "Action=DescribeAdjustmentTypes"/>            
        		            
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
        			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'AdjustmentTypes')[1].xmlChildren />            
        			<cfset stResponse.result = [] />
					
				<cfloop array="#dataResult#" index="result">
					<cfset arrayAppend(stResponse.result,result.Adjustmenttype.xmlText) />
				</cfloop>			            
        	            
        		</cfif>            
        	    
        		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />            
        					            
        		<cfreturn stResponse />            
        	</cffunction>
        	
	<cffunction name="DescribeAutoScalingGroups" access="public" returntype="Struct" >    
    		<cfargument name="AutoScalingGroupNames" type="string" required="false" default="" >
		<cfargument name="MaxRecords" type="string" required="false" default="" > 
		<cfargument name="NextToken" type="string" required="false" default="" > 		    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=DescribeAutoScalingGroups"/>    
    		    
    		 <cfloop from="1" to="#listlen(arguments.AutoScalingGroupNames)#" index="j">
			<cfset body &= "&AutoScalingGroupNames.member." & j & "=" & trim(listgetat(arguments.AutoScalingGroupNames,j)) /> 
		</cfloop>
		   
    		<cfif len(trim(arguments.MaxRecords))>    
    			<cfset body &= "&MaxRecords=" & trim(arguments.MaxRecords) />    
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'AutoScalingGroups')[1].xmlChildren />    
    			<cfset stResponse.result = [] />
					
			<cfloop array="#dataResult#" index="result">
				<cfset arrayAppend(stResponse.result,createAutoScalingGroupObject(result)) />
			</cfloop>    
    	    
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>	
    	
    	<cffunction name="DescribeAutoScalingInstances" access="public" returntype="Struct" >        
    		<cfargument name="InstanceIds" type="string" required="false" default="" >        
    		<cfargument name="MaxRecords" type="string" required="false" default="" > 
		<cfargument name="NextToken" type="string" required="false" default="" > 
		      
    		<cfset var stResponse = createResponse() />        
    		<cfset var body = "Action=DescribeAutoScalingInstances"/>        
    		        
    		 <cfloop from="1" to="#listlen(arguments.InstanceIds)#" index="j">
			<cfset body &= "&InstanceIds.member." & j & "=" & trim(listgetat(arguments.InstanceIds,j)) /> 
		</cfloop>
		   
    		<cfif len(trim(arguments.MaxRecords))>    
    			<cfset body &= "&MaxRecords=" & trim(arguments.MaxRecords) />    
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'AutoScalingInstances')[1].xmlChildren />    
    			<cfset stResponse.result = [] />
					
			<cfloop array="#dataResult#" index="result">
				<cfset arrayAppend(stResponse.result,createAutoScalingInstanceDetailsObject(result)) />
			</cfloop>
    		</cfif>        
    	      
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />        
    					        
    		<cfreturn stResponse />        
    	</cffunction>
    	
    	<cffunction name="DescribeAutoScalingNotificationTypes" access="public" returntype="Struct" >        
    			        
    		<cfset var stResponse = createResponse() />        
    		<cfset var body = "Action=DescribeAutoScalingNotificationTypes"/>        
    		        
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'AutoScalingNotificationTypes')[1].xmlChildren />    
    			<cfset stResponse.result = [] />
					
			<cfloop array="#dataResult#" index="result">
				<cfset arrayAppend(stResponse.result,result.xmlText) />
			</cfloop>	        
    	        
    		</cfif>        
    	        
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />        
    					        
    		<cfreturn stResponse />        
    	</cffunction>
    	
    	<cffunction name="DescribeLaunchConfigurations" access="public" returntype="Struct" >        
    		<cfargument name="LaunchConfigurationNames" type="string" required="false" default="" >        
    		<cfargument name="MaxRecords" type="string" required="false" default="" > 
		<cfargument name="NextToken" type="string" required="false" default="" > 
		      
    		<cfset var stResponse = createResponse() />        
    		<cfset var body = "Action=DescribeLaunchConfigurations"/>        
    		        
    		 <cfloop from="1" to="#listlen(arguments.LaunchConfigurationNames)#" index="j">
			<cfset body &= "&LaunchConfigurationNames.member." & j & "=" & trim(listgetat(arguments.LaunchConfigurationNames,j)) /> 
		</cfloop>
		   
    		<cfif len(trim(arguments.MaxRecords))>    
    			<cfset body &= "&MaxRecords=" & trim(arguments.MaxRecords) />    
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'LaunchConfigurations')[1].xmlChildren />    
    			<cfset stResponse.result = [] />
					
			<cfloop array="#dataResult#" index="result">
				<cfset arrayAppend(stResponse.result,createLaunchConfigurationObject(result)) />
			</cfloop>       
    	        
    		</cfif>        
    	      
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />        
    					        
    		<cfreturn stResponse />        
    	</cffunction>
    	
    	<cffunction name="DescribeMetricCollectionTypes" access="public" returntype="Struct" >        
    			        
    		<cfset var stResponse = createResponse() />        
    		<cfset var body = "Action=DescribeMetricCollectionTypes"/>        
    		        
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
    			<cfset stResponse.result = {Metrics=[],Granularities=[]} />
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'DescribeMetricCollectionTypesResult')[1] />    
    					
			<cfloop array="#dataResult.Metrics.xmlChildren#" index="result">
				<cfset arrayAppend(stResponse.result.Metrics,getValue(result,'Metric')) />
			</cfloop>  
			
			<cfloop array="#dataResult.Granularities.xmlChildren#" index="result">
				<cfset arrayAppend(stResponse.result.Granularities,getValue(result,'Granularity')) />
			</cfloop>          	        
    	        
    		</cfif>        
    	        
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />        
    					        
    		<cfreturn stResponse />        
    	</cffunction>

	<cffunction name="DescribeNotificationConfigurations" access="public" returntype="Struct" >    
    		<cfargument name="AutoScalingGroupNames" type="string" required="false" default="" >        
    		<cfargument name="MaxRecords" type="string" required="false" default="" > 
		<cfargument name="NextToken" type="string" required="false" default="" > 
		      
    		<cfset var stResponse = createResponse() />        
    		<cfset var body = "Action=DescribeNotificationConfigurations"/>        
    		        
    		 <cfloop from="1" to="#listlen(arguments.AutoScalingGroupNames)#" index="j">
			<cfset body &= "&AutoScalingGroupNames.member." & j & "=" & trim(listgetat(arguments.AutoScalingGroupNames,j)) /> 
		</cfloop>
		   
    		<cfif len(trim(arguments.MaxRecords))>    
    			<cfset body &= "&MaxRecords=" & trim(arguments.MaxRecords) />    
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'NotificationConfigurations')[1].xmlChildren />    
    			<cfset stResponse.result = [] />
					
			<cfloop array="#dataResult#" index="result">
				<cfset arrayAppend(stResponse.result,createNotificationConfigurationObject(result)) />
			</cfloop> 	    
    	    
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>
    	
    	<cffunction name="DescribePolicies" access="public" returntype="Struct" >        
    		<cfargument name="PolicyNames" type="string" required="false" default="" >        
    		<cfargument name="MaxRecords" type="string" required="false" default="" > 
		<cfargument name="NextToken" type="string" required="false" default="" > 
		<cfargument name="AutoScalingGroupName" type="string" required="false" default="" > 
		  
    		<cfset var stResponse = createResponse() />        
    		<cfset var body = "Action=DescribePolicies"/>        
    		        
    		 <cfloop from="1" to="#listlen(arguments.PolicyNames)#" index="j">
			<cfset body &= "&PolicyNames.member." & j & "=" & trim(listgetat(arguments.PolicyNames,j)) /> 
		</cfloop>
		   
    		<cfif len(trim(arguments.MaxRecords))>    
    			<cfset body &= "&MaxRecords=" & trim(arguments.MaxRecords) />    
    		</cfif>	 
    		
    		<cfif len(trim(arguments.NextToken))>    
    			<cfset body &= "&NextToken=" & trim(arguments.NextToken) />    
    		</cfif>    
    		
    		<cfif len(trim(arguments.AutoScalingGroupName))>    
    			<cfset body &= "&AutoScalingGroupName=" & trim(arguments.AutoScalingGroupName) />    
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'ScalingPolicies')[1].xmlChildren />    
    			<cfset stResponse.result = [] />
					
			<cfloop array="#dataResult#" index="result">
				<cfset arrayAppend(stResponse.result,createScalingPolicyObject(result)) />
			</cfloop>        
    	        
    		</cfif>        
    	        
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />        
    					        
    		<cfreturn stResponse />        
    	</cffunction>
    	
	<cffunction name="DescribeScalingActivities" access="public" returntype="Struct" >    
    		<cfargument name="ActivityIds" type="string" required="false" default="" >        
    		<cfargument name="MaxRecords" type="string" required="false" default="" > 
		<cfargument name="NextToken" type="string" required="false" default="" > 
		<cfargument name="AutoScalingGroupName" type="string" required="false" default="" > 
		  
    		<cfset var stResponse = createResponse() />        
    		<cfset var body = "Action=DescribeScalingActivities"/>        
    		        
    		 <cfloop from="1" to="#listlen(arguments.ActivityIds)#" index="j">
			<cfset body &= "&ActivityIds.member." & j & "=" & trim(listgetat(arguments.ActivityIds,j)) /> 
		</cfloop>
		   
    		<cfif len(trim(arguments.MaxRecords))>    
    			<cfset body &= "&MaxRecords=" & trim(arguments.MaxRecords) />    
    		</cfif>	 
    		
    		<cfif len(trim(arguments.NextToken))>    
    			<cfset body &= "&NextToken=" & trim(arguments.NextToken) />    
    		</cfif>    
    		
    		<cfif len(trim(arguments.AutoScalingGroupName))>    
    			<cfset body &= "&AutoScalingGroupName=" & trim(arguments.AutoScalingGroupName) />    
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'Activities')[1].xmlChildren />    
    			<cfset stResponse.result = [] />
					
			<cfloop array="#dataResult#" index="result">
				<cfset arrayAppend(stResponse.result,createActivityObject(result)) />
			</cfloop>   
    	    
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>
    	
	<cffunction name="DescribeScalingProcessTypes" access="public" returntype="Struct" >    

	    	<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=DescribeScalingProcessTypes"/>    
    		    
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'Processes')[1].xmlChildren />    
    			<cfset stResponse.result = [] />
					
			<cfloop array="#dataResult#" index="result">
				<cfset arrayAppend(stResponse.result,getValue(result,'Processname')) />
			</cfloop>   	    
    	    
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="DescribeScheduledActions" access="public" returntype="Struct" >    
    		<cfargument name="AutoScalingGroupName" type="string" required="false" default="" >        
    		<cfargument name="EndTime" type="string" required="false" default="" > 
		<cfargument name="MaxRecords" type="string" required="false" default="" > 
		<cfargument name="NextToken" type="string" required="false" default="" > 
		<cfargument name="StartTime" type="string" required="false" default="" > 
		<cfargument name="ScheduledActionNames" type="string" required="false" default="" > 
		  
    		<cfset var stResponse = createResponse() />        
    		<cfset var body = "Action=DescribeScalingActivities"/>        
    		        
    		 <cfloop from="1" to="#listlen(arguments.ScheduledActionNames)#" index="j">
			<cfset body &= "&ScheduledActionNames.member." & j & "=" & trim(listgetat(arguments.ScheduledActionNames,j)) /> 
		</cfloop>
		   
    		<cfif len(trim(arguments.AutoScalingGroupName))>    
    			<cfset body &= "&AutoScalingGroupName=" & trim(arguments.AutoScalingGroupName) />    
    		</cfif>	 
    		
    		<cfif len(trim(arguments.EndTime))>    
    			<cfset body &= "&EndTime=" & trim(arguments.EndTime) />    
    		</cfif>    
    		
    		<cfif len(trim(arguments.MaxRecords))>    
    			<cfset body &= "&MaxRecords=" & trim(arguments.MaxRecords) />    
    		</cfif>  
    		
    		<cfif len(trim(arguments.NextToken))>    
    			<cfset body &= "&NextToken=" & trim(arguments.NextToken) />    
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'Activities')[1].xmlChildren />    
    			<cfset stResponse.result = [] />
					
			<cfloop array="#dataResult#" index="result">
				<cfset arrayAppend(stResponse.result,createScheduledUpdateGroupActionObject(result)) />
			</cfloop>      
    	    
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>
    	
    	<cffunction name="DescribeTags" access="public" returntype="Struct" >
		<cfargument name="Filters" type="array" required="false" default="#[]#">
		<cfargument name="MaxRecords" type="string" required="false" default="">
		<cfargument name="NextToken" type="string" required="false" default="">
		
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=DescribeTags"/>
		
		<cfif len(trim(arguments.MaxRecords))>
			<cfset body &= "&MaxRecords=" & trim(arguments.MaxRecords) />
		</cfif>
		
		<cfif len(trim(arguments.NextToken))>
			<cfset body &= "&NextToken=" & trim(arguments.NextToken) />
		</cfif>
		
		<cfloop from="1" to="#arrayLen(arguments.Filters)#" index="i">
			<cfset body &= "&Filters.member." & i & ".Name=" & trim(arguments.PolicyNames[i].name) 
							& "&Filters.member." & i & ".Values =" & trim(arguments.PolicyNames[i].Values) />
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
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'Tags')[1].xmlChildren />    
    			<cfset stResponse.result = [] />
					
			<cfloop array="#dataResult#" index="result">
				<cfset arrayAppend(stResponse.result,createTagDescriptionObject(result)) />
			</cfloop> 
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
		
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="DisableMetricsCollection" access="public" returntype="Struct" >    
    		<cfargument name="AutoScalingGroupName" type="string" required="true" >     
    		<cfargument name="Metrics" type="string" required="false" default="" > 
				    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=DisableMetricsCollection&AutoScalingGroupName=" & trim(arguments.AutoScalingGroupName)/>    
    		 
    		 <cfloop from="1" to="#listlen(arguments.Metrics)#" index="j">
			<cfset body &= "&Metrics.member." & j & "=" & trim(listgetat(arguments.Metrics,j)) /> 
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
    	
    	<cffunction name="EnableMetricsCollection" access="public" returntype="Struct" >        
    		<cfargument name="AutoScalingGroupName" type="string" required="true" >     
		<cfargument name="Granularity" type="string" required="true" > 	
    		<cfargument name="Metrics" type="string" required="false" default="" >        
    			        
    		<cfset var stResponse = createResponse() />        
    		<cfset var body = "Action=EnableMetricsCollection&AutoScalingGroupName=" & trim(arguments.AutoScalingGroupName ) & "&Granularity=" & trim(arguments.Granularity)/>        
    		        
    		<cfloop from="1" to="#listlen(arguments.Metrics)#" index="j">
			<cfset body &= "&Metrics.member." & j & "=" & trim(listgetat(arguments.Metrics,j)) /> 
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

	<cffunction name="ExecutePolicy" access="public" returntype="Struct" >    
    		<cfargument name="PolicyName" type="string" required="true" >    
    		<cfargument name="AutoScalingGroupName" type="string" required="false" default="" >    
    		<cfargument name="HonorCooldown" type="boolean" required="false" default="false" >
				    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=ExecutePolicy&PolicyName=" & trim(arguments.PolicyName )/>    
    		    
    		<cfif len(trim(arguments.AutoScalingGroupName ))>    
    			<cfset body &= "&AutoScalingGroupName=" & trim(arguments.AutoScalingGroupName ) />    
    		</cfif>
    		
    		<cfif arguments.HonorCooldown>    
    			<cfset body &= "&HonorCooldown=true" />    
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

	<cffunction name="PutNotificationConfiguration" access="public" returntype="Struct" >    
    		<cfargument name="AutoScalingGroupName" type="string" required="true" >    
    		<cfargument name="NotificationTypes" type="string" required="true" >   
    		<cfargument name="TopicARN" type="string" required="true" >
				    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=PutNotificationConfiguration&AutoScalingGroupName=" & trim(arguments.AutoScalingGroupName) & "&TopicARN=" & trim(arguments.TopicARN)/>    
    		    
    		<cfloop from="1" to="#listlen(arguments.NotificationTypes)#" index="j">
			<cfset body &= "&NotificationTypes.member." & j & "=" & trim(listgetat(arguments.NotificationTypes,j)) /> 
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

	<cffunction name="PutScalingPolicy" access="public" returntype="Struct" >    
    		<cfargument name="AdjustmentType" type="string" required="true" >
		<cfargument name="AutoScalingGroupName" type="string" required="true" >   
		<cfargument name="PolicyName" type="string" required="true" >   
		<cfargument name="ScalingAdjustment" type="string" required="true" >   			    
    		<cfargument name="Cooldown" type="string" required="false" default="" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=PutScalingPolicy&AdjustmentType=" & trim(arguments.AdjustmentType)
							& "&AutoScalingGroupName=" & trim(arguments.AutoScalingGroupName)
							& "&PolicyName=" & trim(arguments.PolicyName)
							& "&ScalingAdjustment=" & trim(arguments.ScalingAdjustment)/>    
    		    
    		<cfif len(trim(arguments.Cooldown))>    
    			<cfset body &= "&Cooldown=" & trim(arguments.Cooldown) />    
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
    			<cfset stResponse.result = getResultNodes(xmlParse(rawResult.filecontent),'PolicyARN')[1].xmlText />    
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="PutScheduledUpdateGroupAction" access="public" returntype="Struct" >    
    		<cfargument name="AutoScalingGroupName" type="string" required="true" >    
		<cfargument name="ScheduledActionName" type="string" required="true" > 	
			 
    		<cfargument name="DesiredCapacity" type="string" required="false" default="" >
		<cfargument name="EndTime" type="string" required="false" default="" > 
		<cfargument name="MaxSize" type="string" required="false" default="" > 
		<cfargument name="MinSize" type="string" required="false" default="" > 
		<cfargument name="Recurrence" type="string" required="false" default="" > 
		<cfargument name="StartTime" type="string" required="false" default="" > 
		<cfargument name="Time" type="string" required="false" default="" > 
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=PutScheduledUpdateGroupAction&AutoScalingGroupName =" & trim(arguments.AutoScalingGroupName ) & "&ScheduledActionName=" & trim(arguments.ScheduledActionName)/>    
    		    
    		<cfif len(trim(arguments.DesiredCapacity))>    
    			<cfset body &= "&DesiredCapacity=" & trim(arguments.DesiredCapacity) />    
    		</cfif>
    		
    		<cfif len(trim(arguments.EndTime))>    
    			<cfset body &= "&EndTime=" & trim(arguments.EndTime) />    
    		</cfif>	  
    		
    		<cfif len(trim(arguments.MaxSize))>    
    			<cfset body &= "&MaxSize=" & trim(arguments.MaxSize) />    
    		</cfif>	  
    		
    		<cfif len(trim(arguments.MinSize))>    
    			<cfset body &= "&MinSize=" & trim(arguments.MinSize) />    
    		</cfif>	  
    		
    		<cfif len(trim(arguments.Recurrence))>    
    			<cfset body &= "&Recurrence=" & trim(arguments.Recurrence) />    
    		</cfif>	  
    		
    		<cfif len(trim(arguments.StartTime))>    
    			<cfset body &= "&StartTime=" & trim(arguments.StartTime) />    
    		</cfif>	  	    
    		 
    		<cfif len(trim(arguments.Time))>    
    			<cfset body &= "&Time=" & trim(arguments.Time) />    
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

	<cffunction name="ResumeProcesses" access="public" returntype="Struct" >    
    		<cfargument name="AutoScalingGroupName" type="string" required="true" >    
    		<cfargument name="ScalingProcesses" type="string" required="false" default="" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=ResumeProcesses&AutoScalingGroupName=" & trim(arguments.AutoScalingGroupName )/>    
    		    
    		<cfloop from="1" to="#listlen(arguments.ScalingProcesses)#" index="j">
			<cfset body &= "&ScalingProcesses.member." & j & "=" & trim(listgetat(arguments.ScalingProcesses,j)) /> 
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
    	
    	<cffunction name="SetDesiredCapacity" access="public" returntype="Struct" >        
    		<cfargument name="AutoScalingGroupName" type="string" required="true" >
		<cfargument name="DesiredCapacity" type="string" required="true" >	
    		<cfargument name="HonorCooldown" type="boolean" required="false" default="false" >        
    			        
    		<cfset var stResponse = createResponse() />        
    		<cfset var body = "Action=SetDesiredCapacity&AutoScalingGroupName =" & trim(arguments.AutoScalingGroupName ) & "&DesiredCapacity=" & trim(arguments.DesiredCapacity)/>        
    		        
    		<cfif arguments.HonorCooldown >        
    			<cfset body &= "&HonorCooldown=true"/>        
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

	<cffunction name="SetInstanceHealth" access="public" returntype="Struct" >    
    		<cfargument name="InstanceId" type="string" required="true" >
		<cfargument name="HealthStatus" type="string" required="true" >    
    		<cfargument name="ShouldRespectGracePeriod" type="boolean" required="false" default="false" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=SetInstanceHealth&InstanceId=" & trim(arguments.InstanceId) & "&HealthStatus=" & trim(arguments.HealthStatus)/>    
    		    
    		<cfif arguments.ShouldRespectGracePeriod>    
    			<cfset body &= "&ShouldRespectGracePeriod=true" />    
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

	<cffunction name="SuspendProcesses" access="public" returntype="Struct" >    
    		<cfargument name="AutoScalingGroupName" type="string" required="true" >    
    		<cfargument name="ScalingProcesses" type="string" required="false" default="" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=SuspendProcesses&AutoScalingGroupName =" & trim(arguments.AutoScalingGroupName )/>    
    		    
    		<cfloop from="1" to="#listlen(arguments.ScalingProcesses)#" index="j">
			<cfset body &= "&ScalingProcesses.member." & j & "=" & trim(listgetat(arguments.ScalingProcesses,j)) /> 
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

	<cffunction name="TerminateInstanceInAutoScalingGroup" access="public" returntype="Struct" >    
    		<cfargument name="InstanceId" type="string" required="true" >    
    		<cfargument name="ShouldDecrementDesiredCapacity" type="boolean" required="false" default="true" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=TerminateInstanceInAutoScalingGroup&InstanceId=" & trim(arguments.InstanceId)/>    
    		    
    		<cfset body &= "&ShouldDecrementDesiredCapacity=" & trim(arguments.ShouldDecrementDesiredCapacity ) />    
    		    
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'Activity')[1] />    
    			<cfset stResponse.result = createActivityObject(dataResult) />	    
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="UpdateAutoScalingGroup" access="public" returntype="Struct" >    
    		<cfargument name="AutoScalingGroupName" type="string" required="true" >
		<cfargument name="AvailabilityZones" type="string" required="false" default="">	    
    		<cfargument name="DefaultCooldown" type="numeric" required="false" default="" >  
		<cfargument name="DesiredCapacity" type="numeric" required="false" default="" >
		<cfargument name="HealthCheckGracePeriod" type="numeric" required="false" default="" >
		<cfargument name="HealthCheckType" type="string" required="false" default="" >
		<cfargument name="LaunchConfigurationName" type="string"  required="false" default="" >
		<cfargument name="LoadBalancerNames" type="string" required="false" default="" >
		<cfargument name="MaxSize" type="string" required="false" default="" >
		<cfargument name="MinSize" type="string" required="false" default="" >
		<cfargument name="PlacementGroup" type="string" required="false" default="" >
		<cfargument name="VPCZoneIdentifier" type="string" required="false" default="" >	  
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=UpdateAutoScalingGroup&AutoScalingGroupName=" & trim(arguments.AutoScalingGroupName) />  
							
		<cfloop from="1" to="#listlen(arguments.AvailabilityZones)#" index="i">
			<cfset body &= "&AvailabilityZones.member." & i & "=" & trim(listgetat(arguments.AvailabilityZones,i)) /> 
		</cfloop>
		
		<cfloop from="1" to="#listlen(arguments.LoadBalancerNames)#" index="j">
			<cfset body &= "&LoadBalancerNames.member." & j & "=" & trim(listgetat(arguments.LoadBalancerNames,j)) /> 
		</cfloop>						  
    		    
    		<cfif len(trim(arguments.DefaultCooldown))>    
    			<cfset body &= "&DefaultCooldown=" & trim(arguments.DefaultCooldown) />    
    		</cfif>	
    		
    		<cfif len(trim(arguments.DesiredCapacity))>    
    			<cfset body &= "&DesiredCapacity=" & trim(arguments.DesiredCapacity) />    
    		</cfif>	
    		
    		<cfif len(trim(arguments.HealthCheckGracePeriod))>    
    			<cfset body &= "&HealthCheckGracePeriod=" & trim(arguments.HealthCheckGracePeriod) />    
    		</cfif>
    		
    		<cfif len(trim(arguments.HealthCheckType))>    
    			<cfset body &= "&HealthCheckType=" & trim(arguments.HealthCheckType) />    
    		</cfif>
    		
    		<cfif len(trim(arguments.LaunchConfigurationName ))>    
    			<cfset body &= "&LaunchConfigurationName=" & trim(arguments.LaunchConfigurationName ) />    
    		</cfif>
    		
    		<cfif len(trim(arguments.LaunchConfigurationName ))>    
    			<cfset body &= "&LaunchConfigurationName=" & trim(arguments.LaunchConfigurationName ) />    
    		</cfif>
    		
    		<cfif len(trim(arguments.MaxSize  ))>    
    			<cfset body &= "&MaxSize=" & trim(arguments.MaxSize  ) />    
    		</cfif>
    		
    		<cfif len(trim(arguments.MinSize ))>    
    			<cfset body &= "&MinSize=" & trim(arguments.MinSize ) />    
    		</cfif>
    		
    		<cfif len(trim(arguments.PlacementGroup))>    
    			<cfset body &= "&PlacementGroup=" & trim(arguments.PlacementGroup) />    
    		</cfif>	 
    		
    		<cfif len(trim(arguments.VPCZoneIdentifier))>    
    			<cfset body &= "&VPCZoneIdentifier=" & trim(arguments.VPCZoneIdentifier) />    
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
    	
    	<cffunction name="createActivityObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
		<cfset var response= {
						ActivityId =getValue(arguments.stXML,'ActivityId'),
						AutoScalingGroupName =getValue(arguments.stXML,'AutoScalingGroupName'),
						Cause =getValue(arguments.stXML,'Cause'),
						Description =getValue(arguments.stXML,'Description'),
						Details =getValue(arguments.stXML,'Details'),
						EndTime =getValue(arguments.stXML,'EndTime'),
						Progress=getValue(arguments.stXML,'Progress'),
						StartTime=getValue(arguments.stXML,'StartTime'),
						StatusCode=getValue(arguments.stXML,'StatusCode'),
						StatusMessage=getValue(arguments.stXML,'StatusMessage')
					} />
		
		<cfreturn response />	
	</cffunction>
			
	<cffunction name="createAdjustmentTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						AdjustmentType=getValue(arguments.stXML,'AdjustmentType')
					} />
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createAlarmObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						AlarmARN =getValue(arguments.stXML,'AlarmARN'),
						AlarmName =getValue(arguments.stXML,'AlarmName')
					} />
		
		<cfreturn response />	
	</cffunction> 
	
	<cffunction name="createAutoScalingGroupObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">	
			
		<cfset var response= {
						AutoScalingGroupARN=getValue(arguments.stXML,'AutoScalingGroupARN'),
						AutoScalingGroupName=getValue(arguments.stXML,'AutoScalingGroupName'),
						AvailabilityZones=getValue(arguments.stXML,'AvailabilityZones'),
						CreatedTime=getValue(arguments.stXML,'CreatedTime'),
						DefaultCooldown =getValue(arguments.stXML,'DefaultCooldown'),
						DesiredCapacity=getValue(arguments.stXML,'DesiredCapacity'),
						EnabledMetrics=[],
						HealthCheckGracePeriod=getValue(arguments.stXML,'HealthCheckGracePeriod'),
						HealthCheckType=getValue(arguments.stXML,'HealthCheckType'),
						Instances =[],
						LaunchConfigurationName=getValue(arguments.stXML,'LaunchConfigurationName'),
						LoadBalancerNames=getValue(arguments.stXML,'LoadBalancerNames'),
						MaxSize=getValue(arguments.stXML,'MaxSize'),
						MinSize=getValue(arguments.stXML,'MinSize'),
						PlacementGroup=getValue(arguments.stXML,'PlacementGroup'),
						Status=getValue(arguments.stXML,'Status'),
						SuspendedProcesses=[],
						Tags=[],
						VPCZoneIdentifier=getValue(arguments.stXML,'VPCZoneIdentifier')
					} />
		<cfloop array="#arguments.stXML.EnabledMetrics.xmlChildren#" index="metric">
			<cfset arrayAppend(response.EnabledMetrics,createEnabledMetricObject(metric)) />				
		</cfloop>	
		
		<cfloop array="#arguments.stXML.Instances.xmlChildren#" index="instance">
			<cfset arrayAppend(response.Instances,createInstanceObject(instance)) />				
		</cfloop>
		
		<cfloop array="#arguments.stXML.SuspendedProcesses.xmlChildren#" index="SuspendedProcess">
			<cfset arrayAppend(response.SuspendedProcesses,createSuspendedProcessObject(SuspendedProcess)) />				
		</cfloop>
		
		<cfloop array="#arguments.stXML.Tags.xmlChildren#" index="Tag">
			<cfset arrayAppend(response.Tags,createTagObject(Tag)) />				
		</cfloop>
			
		<cfreturn response />	
	</cffunction> 
	
	<cffunction name="createAutoScalingInstanceDetailsObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						AutoScalingGroupName=getValue(arguments.stXML,'AutoScalingGroupName'),
						AvailabilityZone=getValue(arguments.stXML,'AvailabilityZone'),
						HealthStatus=getValue(arguments.stXML,'HealthStatus'),
						InstanceId=getValue(arguments.stXML,'InstanceId'),
						LaunchConfigurationName=getValue(arguments.stXML,'LaunchConfigurationName'),
						LifecycleState=getValue(arguments.stXML,'LifecycleState')
					} />
		
		<cfreturn response />	
	</cffunction> 
	
	<cffunction name="createBlockDeviceMappingObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						DeviceName=getValue(arguments.stXML,'DeviceName'),
						Ebs=createEbsObject(arguments.stXML.Ebs),
						VirtualName=getValue(arguments.stXML,'VirtualName')
					} />
		
		<cfreturn response />	
	</cffunction> 
	
	<cffunction name="createEbsObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						SnapshotId=getValue(arguments.stXML,'SnapshotId'),
						VolumeSize=getValue(arguments.stXML,'VolumeSize')
					} />
		
		<cfreturn response />	
	</cffunction>
		
	<cffunction name="createEnabledMetricObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						Granularity=getValue(arguments.stXML,'Granularity'),
						Metric=getValue(arguments.stXML,'Metric')
					} />
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createFilterObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						Name=getValue(arguments.stXML,'Name'),
						Values=getValue(arguments.stXML,'Values')
					} />
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createInstanceObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						AvailabilityZone=getValue(arguments.stXML,'AvailabilityZone'),
						HealthStatus=getValue(arguments.stXML,'HealthStatus'),
						InstanceId=getValue(arguments.stXML,'InstanceId'),
						LaunchConfigurationName=getValue(arguments.stXML,'LaunchConfigurationName'),
						LifecycleState=getValue(arguments.stXML,'LifecycleState')
					} />
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createInstanceMonitoringObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						Enabled=getValue(arguments.stXML,'Enabled')
					} />
		
		<cfreturn response />	
	</cffunction>  
	
	<cffunction name="createLaunchConfigurationObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">	
			
		<cfset var response= {
						BlockDeviceMappings=[],
						CreatedTime=getValue(arguments.stXML,'CreatedTime'),
						ImageId=getValue(arguments.stXML,'ImageId'),
						InstanceMonitoring=createInstanceMonitoringObject(arguments.stXML.InstanceMonitoring),
						InstanceType=getValue(arguments.stXML,'InstanceType'),
						KernelId=getValue(arguments.stXML,'KernelId'),
						KeyName=getValue(arguments.stXML,'KeyName'),
						LaunchConfigurationARN=getValue(arguments.stXML,'LaunchConfigurationARN'),
						LaunchConfigurationName=getValue(arguments.stXML,'LaunchConfigurationName'),
						RamdiskId=getValue(arguments.stXML,'RamdiskId'),
						SecurityGroups=getValue(arguments.stXML,'SecurityGroups'),
						UserData=getValue(arguments.stXML,'UserData')
					} />
					
		<cfloop array="#arguments.stXML.BlockDeviceMappings.xmlChildren#" index="maping">
			<cfset arrayAppend(response.BlockDeviceMappings,createBlockDeviceMappingObject(maping)) />				
		</cfloop>
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createMetricCollectionTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						Metric=getValue(arguments.stXML,'Metric')
					} />
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createMetricGranularityTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">	
			
		<cfset var response= {
						Granularity=getValue(arguments.stXML,'Granularity')
					} />
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createNotificationConfigurationObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						AutoScalingGroupName=getValue(arguments.stXML,'AutoScalingGroupName'),
						NotificationType=getValue(arguments.stXML,'NotificationType'),
						TopicARN=getValue(arguments.stXML,'TopicARN')
					} />
		
		<cfreturn response />	
	</cffunction> 
	
	<cffunction name="createProcessTypeObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						ProcessName=getValue(arguments.stXML,'ProcessName')
					} />
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createScalingPolicyObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">	
			
		<cfset var response= {
						AdjustmentType=getValue(arguments.stXML,'AdjustmentType'),
						Alarms=[],
						AutoScalingGroupName=getValue(arguments.stXML,'AutoScalingGroupName'),
						Cooldown=getValue(arguments.stXML,'Cooldown'),
						PolicyARN=getValue(arguments.stXML,'PolicyARN'),
						PolicyName=getValue(arguments.stXML,'PolicyName'),
						ScalingAdjustment=getValue(arguments.stXML,'ScalingAdjustment')
					} />
					
		<cfloop array="#arguments.stXML.Alarms.xmlChildren#" index="alarm">
			<cfset arrayAppend(response.Alarms,createAlarmObject(alarm)) />				
		</cfloop>
		
		<cfreturn response />	
	</cffunction> 
	
	<cffunction name="createScheduledUpdateGroupActionObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						AutoScalingGroupName=getValue(arguments.stXML,'AutoScalingGroupName'),
						DesiredCapacity=getValue(arguments.stXML,'DesiredCapacity'),
						EndTime=getValue(arguments.stXML,'EndTime'),
						MaxSize=getValue(arguments.stXML,'MaxSize'),
						MinSize=getValue(arguments.stXML,'MinSize'),
						Recurrence=getValue(arguments.stXML,'Recurrence'),
						ScheduledActionARN=getValue(arguments.stXML,'ScheduledActionARN'),
						ScheduledActionName=getValue(arguments.stXML,'ScheduledActionName'),
						StartTime=getValue(arguments.stXML,'StartTime'),
						Time=getValue(arguments.stXML,'Time')
					} />
		
		<cfreturn response />	
	</cffunction> 
	
	<cffunction name="createSuspendedProcessObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						ProcessName=getValue(arguments.stXML,'ProcessName'),
						SuspensionReason=getValue(arguments.stXML,'SuspensionReason')
					} />
		
		<cfreturn response />	
	</cffunction>
	
	<cffunction name="createTagObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						Key=getValue(arguments.stXML,'Key'),
						PropagateAtLaunch=getValue(arguments.stXML,'PropagateAtLaunch'),
						ResourceId=getValue(arguments.stXML,'ResourceId'),
						ResourceType=getValue(arguments.stXML,'ResourceType'),
						Value=getValue(arguments.stXML,'Value')
					} />
		
		<cfreturn response />	
	</cffunction> 
	
	<cffunction name="createTagDescriptionObject" access="public" returntype="Struct" output="false" >
		<cfargument name="stXML" type="xml" required="false" default="#xmlNew()#">		
			
		<cfset var response= {
						Key=getValue(arguments.stXML,'Key'),
						PropagateAtLaunch=getValue(arguments.stXML,'PropagateAtLaunch'),
						ResourceId=getValue(arguments.stXML,'ResourceId'),
						ResourceType=getValue(arguments.stXML,'ResourceType'),
						Value=getValue(arguments.stXML,'Value')
					} />
		
		<cfreturn response />	
	</cffunction>
</cfcomponent>