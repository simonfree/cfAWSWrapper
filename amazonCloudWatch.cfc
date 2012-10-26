<cfcomponent output="false" extends="amazonAWS" >
	<cffunction name="init" access="public" returntype="amazonCloudWatch" >
		<cfargument name="awsAccessKeyId" type="string" required="true"/>
		<cfargument name="secretAccessKey" type="string" required="true"/>
		<cfargument name="endPoint" type="string" required="true" default="monitoring.amazonaws.com"/>
				
		<cfset variables.awsAccessKeyId = arguments.awsAccessKeyId />
		<cfset variables.secretAccesskey = arguments.secretAccessKey />
		<cfset variables.endPoint = arguments.endPoint />
		<cfset variables.requestMethod = 'no-header' />
		<cfset variables.version = '2010-08-01' />
		<cfreturn this />		
	</cffunction>
	
	<cffunction name="ListMetrics" access="public" returntype="Struct" >
		<cfargument name="MetricName" type="string" required="false" default="" >
		<cfargument name="Namespace" type="string" required="false" default="" >
		<cfargument name="NextToken" type="string" required="false" default="" >
		<cfargument name="Dimensions" type="array" required="false" default="#[]#" >
			
		<cfset var stResponse = createResponse() />	
		<cfset var body = "Action=ListMetrics" />
		
		<cfif len(trim(arguments.NextToken))>
			<cfset body = "&NextToken=" & trim(arguments.NextToken) />
		</cfif>	
		
		<cfif len(trim(arguments.Namespace))>
			<cfset body = "&Namespace=" & trim(arguments.Namespace) />
		</cfif>	
		
		<cfif len(trim(arguments.NextToken))>
			<cfset body = "&NextToken=" & trim(arguments.NextToken) />
		</cfif>	
		
		<cfloop from="1" to="#arrayLen(arguments.dimensions)#" index="i">
			<cfset body &= "&Dimensions.member." & i & ".Name=" & trim(arguments.dimensions[i].Name) & "&Dimensions.member." & i & ".Value=" & trim(arguments.dimensions[i].Value) />
		</cfloop>	
		
		<cfset var rawResult = makeRequestFull(
									endPoint = variables.endPoint,
									awsAccessKeyId = variables.awsAccessKeyId, 
									secretAccesskey = variables.secretAccesskey, 
									body=body,
									requestMethod = variables.requestMethod,
									version = variables.version ) />
		
		<cfif rawResult.statusCode neq 200>
			<cfset error = getResultNodes(xmlParse(rawResult.fileContent),'Error')[1] />
			<cfset stResponse.success=false />
			<cfset stResponse.statusCode=rawResult.statusCode />
			<cfset stResponse.error=error.Code.xmlText/>
			<cfset stResponse.errorType=error.Type.xmlText/>
			<cfset stResponse.errorMessage=error.Message.xmlText/>
		<cfelse>
			<cfset stResponse.result={} />
			<cfloop array="#xmlParse(rawResult.filecontent).listMetricsResponse.listMetricsResult.Metrics.xmlChildren#" index="metric">
					<cfset stResponse.result[getValue(metric,'MetricName')]={
											Dimensions = [],
											MetricName=getValue(metric,'MetricName'),
											Namespace=getValue(metric,'Namespace')
											}/>
					<cfloop array="#metric.Dimensions.xmlChildren#" index="dimension">
						<cfset arrayAppend(stResponse.result[getValue(metric,'MetricName')],{Name=getValue(dimension,'Name'),Value=getValue(dimension,'Value')}) />
					</cfloop>						
			</cfloop>	
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="DescribeAlarms" access="public" returntype="Struct" >
		<cfargument name="ActionPrefix" type="string" required="false" default="" >
		<cfargument name="AlarmNamePrefix" type="string" required="false" default="" >
		<cfargument name="MaxRecords" type="string" required="false" default="" >
		<cfargument name="NextToken" type="string" required="false" default="" >
		<cfargument name="StateValue" type="string" required="false" default="" >
		<cfargument name="Dimensions" type="array" required="false" default="#[]#" >
		
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=DescribeAlarms" />
		
		<cfif len(trim(arguments.ActionPrefix))>
			<cfset body = "&ActionPrefix=" & trim(arguments.ActionPrefix) />
		</cfif>
		
		<cfif len(trim(arguments.AlarmNamePrefix))>
			<cfset body = "&AlarmNamePrefix=" & trim(arguments.AlarmNamePrefix) />
		</cfif>	
		
		<cfif len(trim(arguments.MaxRecords))>
			<cfset body = "&MaxRecords=" & trim(arguments.MaxRecords) />
		</cfif>	
		
		<cfif len(trim(arguments.NextToken))>
			<cfset body = "&NextToken=" & trim(arguments.NextToken) />
		</cfif>	
		
		<cfif len(trim(arguments.StateValue))>
			<cfset body = "&StateValue=" & trim(arguments.StateValue) />
		</cfif>	
		
		<cfloop from="1" to="#arrayLen(arguments.Dimensions)#" index="i">
			<cfset body = "&AlarmNames.member." & i & "=" & arguments.Dimensions[i] />
		</cfloop>	
		
		<cfset var rawResult = makeRequestFull(
									endPoint = variables.endPoint,
									awsAccessKeyId = variables.awsAccessKeyId, 
									secretAccesskey = variables.secretAccesskey, 
									body=body,
									requestMethod = variables.requestMethod,
									version = variables.version ) />
		
		<cfif rawResult.statusCode neq 200>
			<cfset error = getResultNodes(xmlParse(rawResult.fileContent),'Error')[1] />
			<cfset stResponse.success=false />
			<cfset stResponse.statusCode=rawResult.statusCode />
			<cfset stResponse.error=error.Code.xmlText/>
			<cfset stResponse.errorType=error.Type.xmlText/>
			<cfset stResponse.errorMessage=error.Message.xmlText/>
		<cfelse>
			<cfset stResponse.result=[] />
										
			<cfloop array="#xmlParse(rawResult.filecontent).DescribeAlarmsResponse.DescribeAlarmsResult.MetricAlarms.xmlChildren#" index="alarm">
				
				<cfset stAlarm={
							StateUpdatedTimestamp=getValue(alarm,'StateUpdatedTimestamp'),
							InsufficientDataActions=getValue(alarm,'InsufficientDataActions'),
							AlarmArn=getValue(alarm,'AlarmArn'),
							AlarmConfigurationUpdatedTimestamp=getValue(alarm,'AlarmConfigurationUpdatedTimestamp'),
							AlarmName=getValue(alarm,'AlarmName'),
							StateValue=getValue(alarm,'StateValue'),
							Period=getValue(alarm,'Period'),
							OKActions=getValue(alarm,'OKActions'),
							ActionsEnabled=getValue(alarm,'ActionsEnabled'),
							Namespace=getValue(alarm,'Namespace'),
							EvaluationPeriods=getValue(alarm,'EvaluationPeriods'),
							Threshold=getValue(alarm,'Threshold'),
							Statistic=getValue(alarm,'Statistic'),
							StateReason=getValue(alarm,'StateReason'),
							ComparisonOperator=getValue(alarm,'ComparisonOperator'),
							MetricName=getValue(alarm,'MetricName'),
							AlarmDescription=getValue(alarm,'AlarmDescription'),	
							AlarmActions=[],
							Dimensions=[]
						} />
						
				<cfloop array="#alarm.AlarmActions.xmlChildren#" index="action">
					<cfset arrayAppend(stAlarm.alarmActions,action.xmlText) />
				</cfloop>			
				
				<cfloop array="#alarm.Dimensions.xmlChildren#" index="dimension">
					<cfset arrayAppend(stAlarm.Dimensions,{Name=getValue(dimension,'Name'),Value=getValue(dimension,'Value')}) />
				</cfloop>
				
				<cfset arrayAppend(stResponse.result,stAlarm) />
			</cfloop>					
		</cfif>	
											
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="DescribeAlarmHistory" access="public" returntype="Struct" >
		<cfargument name="AlarmName" type="string" required="false" default="" >
		<cfargument name="EndDate" type="string" required="false" default="" >
		<cfargument name="HistoryItemType" type="string" required="false" default="" >
		<cfargument name="MaxRecords" type="string" required="false" default="" >
		<cfargument name="NextToken" type="string" required="false" default="" >
		<cfargument name="StartDate" type="string" required="false" default="" >
		
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=DescribeAlarmHistory" />
		
		<cfif len(trim(arguments.AlarmName))>
			<cfset body = "&AlarmName=" & trim(arguments.AlarmName) />
		</cfif>
		
		<cfif len(trim(arguments.EndDate))>
			<cfset body = "&EndDate=" & trim(arguments.EndDate) />
		</cfif>	
		
		<cfif len(trim(arguments.HistoryItemType))>
			<cfset body = "&HistoryItemType=" & trim(arguments.HistoryItemType) />
		</cfif>	
		
		<cfif len(trim(arguments.MaxRecords))>
			<cfset body = "&MaxRecords=" & trim(arguments.MaxRecords) />
		</cfif>	
		
		<cfif len(trim(arguments.NextToken))>
			<cfset body = "&NextToken=" & trim(arguments.NextToken) />
		</cfif>	
		
		<cfif len(trim(arguments.StartDate))>
			<cfset body = "&StartDate=" & trim(arguments.StartDate) />
		</cfif>
		
		<cfset var rawResult = makeRequestFull(
									endPoint = variables.endPoint,
									awsAccessKeyId = variables.awsAccessKeyId, 
									secretAccesskey = variables.secretAccesskey, 
									body=body,
									requestMethod = variables.requestMethod,
									version = variables.version ) />
		
		<cfif rawResult.statusCode neq 200>
			<cfset error = getResultNodes(xmlParse(rawResult.fileContent),'Error')[1] />
			<cfset stResponse.success=false />
			<cfset stResponse.statusCode=rawResult.statusCode />
			<cfset stResponse.error=error.Code.xmlText/>
			<cfset stResponse.errorType=error.Type.xmlText/>
			<cfset stResponse.errorMessage=error.Message.xmlText/>
		<cfelse>
			<cfset stResponse.result=[] />
			<cfloop array="#xmlParse(rawResult.filecontent).DescribeAlarmHistoryResponse.DescribeAlarmHistoryResult.AlarmHistoryItems.xmlChildren#" index="alarm">
				<cfset stAlarm={
								Timestamp=getValue(alarm,'Timestamp'),
								HistoryItemType=getValue(alarm,'HistoryItemType'),
								AlarmName=getValue(alarm,'AlarmName'),
								HistoryData=deserializeJSON(alarm.HistoryData.xmlText),
								HistorySummary=getValue(alarm,'HistorySummary')
							} />
							
				<cfset arrayAppend(stResponse.result,stAlarm) />			
			</cfloop>
		</cfif>	
											
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="DescribeAlarmsForMetric" access="public" returntype="Struct" >
		<cfargument name="MetricName" type="string" required="true" >
		<cfargument name="Namespace" type="string" required="true" >
		<cfargument name="Period" type="string" required="false" default="" >
		<cfargument name="Statistic" type="string" required="false" default="" >
		<cfargument name="Unit" type="string" required="false" default="" >
		<cfargument name="Dimensions" type="array" required="false" default="#[]#" >
		
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=DescribeAlarmsForMetric&MetricName=" & trim(arguments.MetricName) & "&Namespace=" & trim(arguments.Namespace) />
		
		<cfif len(trim(arguments.Period))>
			<cfset body = "&Period=" & trim(arguments.Period) />
		</cfif>
		
		<cfif len(trim(arguments.Statistic))>
			<cfset body = "&Statistic=" & trim(arguments.Statistic) />
		</cfif>	
		
		<cfif len(trim(arguments.Unit))>
			<cfset body = "&Unit=" & trim(arguments.Unit) />
		</cfif>	
		
		<cfloop from="1" to="#arrayLen(arguments.Dimensions)#" index="i">
			<cfset body = "&AlarmNames.member." & i & "=" & trim(arguments.Dimensions[i]) />
		</cfloop>	
		
		<cfset var rawResult = makeRequestFull(
									endPoint = variables.endPoint,
									awsAccessKeyId = variables.awsAccessKeyId, 
									secretAccesskey = variables.secretAccesskey, 
									body=body,
									requestMethod = variables.requestMethod,
									version = variables.version ) />
		
		<cfif rawResult.statusCode neq 200>
			<cfset error = getResultNodes(xmlParse(rawResult.fileContent),'Error')[1] />
			<cfset stResponse.success=false />
			<cfset stResponse.statusCode=rawResult.statusCode />
			<cfset stResponse.error=error.Code.xmlText/>
			<cfset stResponse.errorType=error.Type.xmlText/>
			<cfset stResponse.errorMessage=error.Message.xmlText/>
		<cfelse>
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'MetricAlarms')[1].xmlChildren/>
			<cfset stResponse.result = []/>

			<cfloop array="#dataResult#" index="result">
				<cfset arrayAppend(stResponse.result, {
							ActionsEnabled=getValue(result,'ActionsEnabled'),
							AlarmActions=[],
							AlarmArn=getValue(result,'AlarmArn'),
							AlarmConfigurationUpdatedTimestamp=getValue(result,'AlarmConfigurationUpdatedTimestamp'),
							AlarmDescription=getValue(result,'AlarmDescription'),
							AlarmName=getValue(result,'AlarmName'),
							ComparisonOperator=getValue(result,'ComparisonOperator'),
							Dimensions=[],
							EvaluationPeriods=getValue(result,'EvaluationPeriods'),
							InsufficientDataActions=[],
							MetricName=getValue(result,'MetricName'),
							Namespace=getValue(result,'Namespace'),
							OKActions=getValue(result,'OKActions'),
							Period=getValue(result,'Period'),
							StateReason=getValue(result,'StateReason'),
							StateReasonData=getValue(result,'StateReasonData'),
							StateUpdatedTimestamp=getValue(result,'StateUpdatedTimestamp'),
							StateValue=getValue(result,'StateValue'),
							Statistic=getValue(result,'Statistic'),
							Threshold=getValue(result,'Threshold'),
							Unit=getValue(result,'Unit')
				})/>
				
				<cfloop array="#result.AlarmActions.xmlChildren#" index="alarm">
					<cfset arrayAppend(stResponse.result.AlarmActions,alarm.xmlText) />
				</cfloop>	
				
				<cfloop array="#result.Dimensions.xmlChildren#" index="dimension">
					<cfset arrayAppend(stResponse.result.Dimensions,{Name=getValue(dimension,'Name'),Value=getValue(dimension,'Value')}) />
				</cfloop>
				
				<cfloop array="#result.InsufficientDataActions.xmlChildren#" index="insufficient">
					<cfset arrayAppend(stResponse.result.InsufficientDataActions,insufficient.xmlText) />
				</cfloop>
				
				
			</cfloop>	
		</cfif>	
									
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="SetAlarmState" access="public" returntype="Struct" >
		<cfargument name="AlarmName" type="string" required="true">
		<cfargument name="StateReason" type="string" required="true">
		<cfargument name="StateValue" type="string" required="true">
		<cfargument name="StateReasonData" type="string" required="false" default="">
		
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=SetAlarmState&AlarmName=" & trim(arguments.AlarmName) & "&StateReason=" & trim(arguments.StateReason) & "&StateValue=" & trim(arguments.StateValue) />
		
		<cfif len(trim(arguments.StateReasonData))>
			<cfset body &= "&StateReasonData=" & trim(arguments.StateReasonData) />
		</cfif>
		
		<cfset var rawResult = makeRequestFull(
									endPoint = variables.endPoint,
									awsAccessKeyId = variables.awsAccessKeyId, 
									secretAccesskey = variables.secretAccesskey, 
									body=body,
									requestMethod = variables.requestMethod,
									version = variables.version ) />
		
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
	
	<cffunction name="PutMetricData" access="public" returntype="Struct" >
		<cfargument name="MetricData" type="Array" required="true">
		<cfargument name="Namespace" type="string" required="true">
		
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=PutMetricData&Namespace=" & trim(arguments.Namespace) />
		
		<cfloop from="1" to="#arrayLen(arguments.metricData)#" index="i">
			<cfset data = arguments.metricData[i] />
			<cfif structKeyExists(data,'MetricName')>
				<cfset body &= "&MetricData.member." & i & ".MetricName=" & trim(data.MetricName) />
			</cfif>
			<cfif structKeyExists(data,'Timestamp')>
				<cfset body &= "&MetricData.member." & i & ".Timestamp=" & trim(data.Timestamp) />
			</cfif>
			<cfif structKeyExists(data,'Unit')>
				<cfset body &= "&MetricData.member." & i & ".Unit=" & trim(data.Unit) />
			</cfif>
			<cfif structKeyExists(data,'Value')>
				<cfset body &= "&MetricData.member." & i & ".Value=" & trim(data.Value) />
			</cfif>
			<cfif structKeyExists(data,'Dimensions')>
				<cfloop from="1" to="#arrayLen(data.dimensions)#" index="j">
					<cfset body &= "&MetricData.member." & i & ".Dimensions.member." & j & ".Name=" & trim(data.dimensions[j].Name) />
					<cfset body &= "&MetricData.member." & i & ".Dimensions.member." & j & ".Value=" & trim(data.dimensions[j].Value) />
				</cfloop>	
			</cfif>
			<cfif structKeyExists(data,'StatisticValues')>
				<cfloop from="1" to="#arrayLen(data.StatisticValues)#" index="k">
					<cfset statisticValue=data.StatisticValues[k] />
					<cfif structKeyExists(statisticValue,'Maximum')>
						<cfset body &= "&MetricData.member." & i & ".StatisticSet.member." & k & ".Maximum=" & trim(statisticValue.Maximum) />
					</cfif>
					<cfif structKeyExists(statisticValue,'Minimum')>
						<cfset body &= "&MetricData.member." & i & ".StatisticSet.member." & k & ".Minimum=" & trim(statisticValue.Minimum) />
					</cfif>
					<cfif structKeyExists(statisticValue,'SampleCount')>
						<cfset body &= "&MetricData.member." & i & ".StatisticSet.member." & k & ".SampleCount=" & trim(statisticValue.SampleCount) />
					</cfif>
					<cfif structKeyExists(statisticValue,'Sum')>
						<cfset body &= "&MetricData.member." & i & ".StatisticSet.member." & k & ".Sum=" & trim(statisticValue.Sum) />
					</cfif>	
				</cfloop>
			</cfif>	
		</cfloop>
			
		<cfset var rawResult = makeRequestFull(
									endPoint = variables.endPoint,
									awsAccessKeyId = variables.awsAccessKeyId, 
									secretAccesskey = variables.secretAccesskey, 
									body=body,
									requestMethod = variables.requestMethod,
									version = variables.version ) />
		
		<cfif rawResult.statusCode neq 200>
			<cfset error = getResultNodes(xmlParse(rawResult.fileContent),'Error')[1] />
			<cfset stResponse.success=false />
			<cfset stResponse.statusCode=rawResult.statusCode />
			<cfset stResponse.error=error.Code.xmlText/>
			<cfset stResponse.errorType=error.Type.xmlText/>
			<cfset stResponse.errorMessage=error.Message.xmlText/>
		<cfelse>							
			<cfset stResponse.result = getResultNodes(xmlParse(rawResult),'RequestId')[1].xmlText />
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="PutMetricAlarm" access="public" returntype="Struct" >
		<cfargument name="AlarmName" type="string" required="true">
		<cfargument name="ComparisonOperator" type="string" required="true">
		<cfargument name="EvaluationPeriods" type="string" required="true">
		<cfargument name="MetricName" type="string" required="true">
		<cfargument name="Namespace" type="string" required="true">
		<cfargument name="Period" type="string" required="true">
		<cfargument name="Statistic" type="string" required="true">
		<cfargument name="Threshold" type="string" required="true">
		
		<cfargument name="ActionsEnabled" type="string" required="false" default="" />
		<cfargument name="AlarmActions" type="string" required="false" default="" /> 
		<cfargument name="AlarmDescription" type="string" required="false" default="" />
		<cfargument name="Dimensions" type="array" required="false" default="#[]#" />
		<cfargument name="InsufficientDataActions" type="string" required="false" default="" />
		<cfargument name="OKActions" type="string" required="false" default="" />
		<cfargument name="Unit" type="string" required="false" default="" />
		
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=PutMetricAlarm&AlarmName=" & trim(arguments.AlarmName)
							& "&ComparisonOperator=" & trim(arguments.ComparisonOperator)
							& "&EvaluationPeriods=" & trim(arguments.EvaluationPeriods)
							& "&MetricName=" & trim(arguments.MetricName)
							& "&Namespace=" & trim(arguments.Namespace)
							& "&Period=" & trim(arguments.Period)
							& "&Statistic=" & trim(arguments.Statistic)
							& "&Threshold=" & trim(arguments.Threshold) />
		
		<cfif len(trim(arguments.ActionsEnabled))>
			<cfset body &= "&ActionsEnabled=" & trim(arguments.ActionsEnabled) />
		</cfif>	
		
		<cfif len(trim(arguments.AlarmDescription))>
			<cfset body &= "&AlarmDescription=" & trim(arguments.AlarmDescription) />
		</cfif>	
		
		<cfif len(trim(arguments.Unit))>
			<cfset body &= "&Unit=" & trim(arguments.Unit) />
		</cfif>	
		
		<cfif len(trim(arguments.AlarmActions))>
			<cfloop from="1" to="#listlen(arguments.AlarmActions)#" index="i">
				<cfset body &= "&AlarmActions.member." & i & "=" & trim(listGetAt(arguments.AlarmActions,i)) />
			</cfloop>	
		</cfif>
		
		<cfif len(trim(arguments.InsufficientDataActions))>
			<cfloop from="1" to="#listlen(arguments.InsufficientDataActions)#" index="j">
				<cfset body &= "&InsufficientDataActions.member." & j & "=" & trim(listGetAt(arguments.InsufficientDataActions,j)) />
			</cfloop>	
		</cfif>
		
		<cfif len(trim(arguments.OKActions))>
			<cfloop from="1" to="#listlen(arguments.OKActions)#" index="k">
				<cfset body &= "&OKActions.member." & k & "=" & trim(listGetAt(arguments.OKActions,k)) />
			</cfloop>	
		</cfif>			
		
		<cfif arrayLen(arguments.Dimensions)>
			<cfloop from="1" to="#arrayLen(arguments.Dimensions)#" index="m">
				<cfset body &= "&Dimensions.member." & m & ".Name=" & trim(arguments.dimensions[m].Name) />
				<cfset body &= "&Dimensions.member." & m & ".Value=" & trim(arguments.dimensions[m].Value) />
			</cfloop>	
		</cfif>	
		
		<cfset var rawResult = makeRequestFull(
									endPoint = variables.endPoint,
									awsAccessKeyId = variables.awsAccessKeyId, 
									secretAccesskey = variables.secretAccesskey, 
									body=body,
									requestMethod = variables.requestMethod,
									version = variables.version ) />
									
		<cfif rawResult.statusCode neq 200>
			<cfset error = getResultNodes(xmlParse(rawResult.fileContent),'Error')[1] />
			<cfset stResponse.success=false />
			<cfset stResponse.statusCode=rawResult.statusCode />
			<cfset stResponse.error=error.Code.xmlText/>
			<cfset stResponse.errorType=error.Type.xmlText/>
			<cfset stResponse.errorMessage=error.Message.xmlText/>
		<cfelse>		
			<cfset stResponse.result = getResultNodes(xmlParse(rawResult),'RequestId')[1].xmlText />
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="GetMetricStatistics" access="public" returntype="Struct" >
		<cfargument name="EndTime" type="string" required="true">
		<cfargument name="MetricName" type="string" required="true">
		<cfargument name="Namespace" type="string" required="true">
		<cfargument name="Period" type="string" required="true">
		<cfargument name="StartTime" type="string" required="true">
		<cfargument name="Statistics" type="string" required="true">
		<cfargument name="Unit" type="string" required="true">
		<cfargument name="Dimensions" type="array" required="false" default="#[]#">
		
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=GetMetricStatistics&EndTime=" & arguments.EndTime
							& "&MetricName=" & arguments.MetricName
							& "&Namespace=" & arguments.Namespace
							& "&Period=" & arguments.Period
							& "&StartTime=" & arguments.StartTime
							& "&Unit=" & arguments.Unit />
							
		<cfif len(trim(arguments.Statistics))>
			<cfloop from="1" to="#listLen(arguments.Statistics)#" index="i">
				<cfset body &= "&Statistics.member." & i & '=' & trim(listGetAt(arguments.Statistics,i)) />
			</cfloop>	
		</cfif>	
		
		<cfif arrayLen(arguments.Dimensions)>
			<cfloop from="1" to="#arrayLen(arguments.Dimensions)#" index="m">
				<cfset body &= "&Dimensions.member." & m & ".Name=" & trim(arguments.dimensions[m].Name) />
				<cfset body &= "&Dimensions.member." & m & ".Value=" & trim(arguments.dimensions[m].Value) />
			</cfloop>	
		</cfif>			
		
		<cfset var rawResult = makeRequestFull(
									endPoint = variables.endPoint,
									awsAccessKeyId = variables.awsAccessKeyId, 
									secretAccesskey = variables.secretAccesskey, 
									body=body,
									requestMethod = variables.requestMethod,
									version = variables.version ) />
		
		<cfif rawResult.statusCode neq 200>
			<cfset error = getResultNodes(xmlParse(rawResult.fileContent),'Error')[1] />
			<cfset stResponse.success=false />
			<cfset stResponse.statusCode=rawResult.statusCode />
			<cfset stResponse.error=error.Code.xmlText/>
			<cfset stResponse.errorType=error.Type.xmlText/>
			<cfset stResponse.errorMessage=error.Message.xmlText/>
		<cfelse>	
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'Metrics')[1].xmlChildren/>
			<cfset stResponse.result = []/>
		
			<cfloop array="#dataResult#" index="result">
				<cfset arrayAppend(stResponse.result, result.xmlText)/>
				<cfset stResponse.result[getValue(metric,'MetricName')]={
						Dimensions = [],
						MetricName=getValue(metric,'MetricName'),
						Namespace=getValue(metric,'Namespace')
						}/>
				
				<cfloop array="#metric.Dimensions.Member.xmlChildren#" index="member">
					<cfset arrayAppend(stResponse.result.Dimensions,{
											Name=getValue(member,'Name'),
											Value=getValue(member,'Value')
					}) />
				</cfloop>			
			</cfloop>
										
			<cfdump var="#xmlParse(rawResult)#" /><cfabort>	
		</cfif>
									
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="EnableAlarmActions" access="public" returntype="Struct" >
		<cfargument name="AlarmNames" type="string" required="true">
		
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=EnableAlarmActions" />
							
		<cfloop from="1" to="#listLen(arguments.AlarmNames)#" index="i">
			<cfset body &= "&AlarmNames.member." & i & '=' & trim(listGetAt(arguments.AlarmNames,i)) />
		</cfloop>	

		<cfset var rawResult = makeRequestFull(
									endPoint = variables.endPoint,
									awsAccessKeyId = variables.awsAccessKeyId, 
									secretAccesskey = variables.secretAccesskey, 
									body=body,
									requestMethod = variables.requestMethod,
									version = variables.version ) />
		
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
	
	<cffunction name="DisableAlarmActions" access="public" returntype="Struct" >
		<cfargument name="AlarmNames" type="string" required="true">
		
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=DisableAlarmActions" />
							
		<cfloop from="1" to="#listLen(arguments.AlarmNames)#" index="i">
			<cfset body &= "&AlarmNames.member." & i & '=' & trim(listGetAt(arguments.AlarmNames,i)) />
		</cfloop>	

		<cfset var rawResult = makeRequestFull(
									endPoint = variables.endPoint,
									awsAccessKeyId = variables.awsAccessKeyId, 
									secretAccesskey = variables.secretAccesskey, 
									body=body,
									requestMethod = variables.requestMethod,
									version = variables.version ) />

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
	
	<cffunction name="DeleteAlarms" access="public" returntype="Struct" >
		<cfargument name="AlarmNames" type="string" required="true">
		
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=DeleteAlarms" />
							
		<cfloop from="1" to="#listLen(arguments.AlarmNames)#" index="i">
			<cfset body &= "&AlarmNames.member." & i & '=' & trim(listGetAt(arguments.AlarmNames,i)) />
		</cfloop>	

		<cfset var rawResult = makeRequestFull(
									endPoint = variables.endPoint,
									awsAccessKeyId = variables.awsAccessKeyId, 
									secretAccesskey = variables.secretAccesskey, 
									body=body,
									requestMethod = variables.requestMethod,
									version = variables.version ) />

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