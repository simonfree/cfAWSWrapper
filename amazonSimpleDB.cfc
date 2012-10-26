<cfcomponent output="false" extends="amazonAWS" >
	<cffunction name="init" access="public" returntype="amazonSimpleDB" >
		<cfargument name="awsAccessKeyId" type="string" required="true"/>
		<cfargument name="secretAccessKey" type="string" required="true"/>
		<cfargument name="endPoint" type="string" required="true" default="sdb.amazonaws.com"/>
				
		<cfset variables.awsAccessKeyId = arguments.awsAccessKeyId />
		<cfset variables.secretAccesskey = arguments.secretAccessKey />
		<cfset variables.endPoint = arguments.endPoint />
		<cfset variables.requestMethod = 'no-header' />
		<cfset variables.version = '2009-04-15' />
		<cfreturn this />		
	</cffunction>	
	
	<cffunction name="ListDomains" access="public" returntype="struct" hint="The ListDomains operation lists all domains associated with the Access Key ID. It returns domain names up to the limit set by MaxNumberOfDomains.">
		<cfargument name="MaxNumberOfDomains" type="numeric" required="false" default="0" hint="The maximum number of domain names you want returned.">
		<cfargument name="NextToken" type="string" required="false" default="" hint="String that tells Amazon SimpleDB where to start the next list of domain names.">
		
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=ListDomains" />
		
		<cfif val(arguments.MaxNumberOfDomains)>
			<cfset body &= '&MaxNumberOfDomains=' & trim(arguments.MaxNumberOfDomains) />
		</cfif>
		
		<cfif len(trim(arguments.NextToken))>
			<cfset body &= '&NextToken=' & trim(arguments.NextToken) />
		</cfif>	

		<cfset var rawResult = makeRequestFull(
									endPoint = variables.endPoint,
									awsAccessKeyId = variables.awsAccessKeyId, 
									secretAccesskey = variables.secretAccesskey, 
									body=body,
									requestMethod = variables.requestMethod,
									version = variables.version  ) />
		
		<cfif rawResult.statusCode neq 200>
			<cfset error = getResultNodes(xmlParse(rawResult.fileContent),'Error')[1] />
			<cfset stResponse.success=false />
			<cfset stResponse.statusCode=rawResult.statusCode />
			<cfset stResponse.error=error.Code.xmlText/>
			<cfset stResponse.errorType=error.Type.xmlText/>
			<cfset stResponse.errorMessage=error.Message.xmlText/>
		<cfelse>	
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'DomainName') />
			<cfset stResponse.result=[] />
		
			<cfloop array="#dataResult#" index="item">
				<cfset arrayAppend(stResponse.result,item.xmlText) />
			</cfloop>
		</cfif>		
			
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="CreateDomain" access="public" returntype="Struct" hint="The CreateDomain operation creates a new domain. The domain name must be unique among the domains associated with the Access Key ID provided in the request. The CreateDomain operation might take 10 or more seconds to complete.">
		<cfargument name="DomainName" type="string" required="true" hint="The name of the domain to create. The name can range between 3 and 255 characters and can contain the following characters: a-z, A-Z, 0-9, '_', '-', and '.'.">
		
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=CreateDomain&DomainName=" & trim(arguments.DomainName)  />
		
		<cfset var rawResult = makeRequestFull(
									endPoint = variables.endPoint,
									awsAccessKeyId = variables.awsAccessKeyId, 
									secretAccesskey = variables.secretAccesskey, 
									body=body,
									requestMethod = variables.requestMethod,
									version = variables.version  ) />
									
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
	
	<cffunction name="DomainMetadata" access="public" returntype="Struct" hint="Returns information about the domain, including when the domain was created, the number of items and attributes, and the size of attribute names and values.">
		<cfargument name="DomainName" type="string" required="true" hint="The name of the domain for which to display metadata.">
		
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=DomainMetadata&DomainName=" & trim(arguments.DomainName)  />
		
		<cfset var rawResult = makeRequestFull(
									endPoint = variables.endPoint,
									awsAccessKeyId = variables.awsAccessKeyId, 
									secretAccesskey = variables.secretAccesskey, 
									body=body,
									requestMethod = variables.requestMethod,
									version = variables.version  ) />
		
		<cfif rawResult.statusCode neq 200>
			<cfset error = getResultNodes(xmlParse(rawResult.fileContent),'Error')[1] />
			<cfset stResponse.success=false />
			<cfset stResponse.statusCode=rawResult.statusCode />
			<cfset stResponse.error=error.Code.xmlText/>
			<cfset stResponse.errorType=error.Type.xmlText/>
			<cfset stResponse.errorMessage=error.Message.xmlText/>
		<cfelse>		
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'DomainMetadataResult')[1] />
			<cfset stResponse.result = {
					ItemCount=getValue(dataResult,'ItemCount'),
					ItemNamesSizeBytes=getValue(dataResult,'ItemNamesSizeBytes'),
					AttributeNameCount=getValue(dataResult,'AttributeNameCount'),
					AttributeNamesSizeBytes=getValue(dataResult,'AttributeNamesSizeBytes'),
					AttributeValueCount=getValue(dataResult,'AttributeValueCount'),
					AttributeValuesSizeBytes=getValue(dataResult,'AttributeValuesSizeBytes'),
					Timestamp=getValue(dataResult,'Timestamp')
				} />
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="PutAttributes" access="public" returntype="Struct" >
		<cfargument name="DomainName" type="string" required="true" hint="The name of the domain in which to perform the operation"/>
		<cfargument name="itemName" type="string" required="true" hint="The name of the item"/>
		<cfargument name="attributes" type="array" required="true" />
		
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=PutAttributes&DomainName=" & trim(arguments.DomainName) & "&ItemName=" & trim(arguments.ItemName) />
		
		<cfloop from="1" to="#arrayLen(arguments.attributes)#" index="i">
			<cfset body &= "&Attribute." & i & ".Name=" & trim(arguments.attributes[i].name) & 
							"&Attribute." & i & ".Value=" & trim(arguments.attributes[i].value) />
			
			<cfif structKeyExists(arguments.attributes[i],'replace') && len(trim(arguments.attributes[i].replace))>
				<cfset body &= "&Attribute." & i & ".Replace=" & trim(arguments.attributes[i].replace) />
			</cfif>				 
		</cfloop>	
		
		<cfset var rawResult = makeRequestFull(
									endPoint = variables.endPoint,
									awsAccessKeyId = variables.awsAccessKeyId, 
									secretAccesskey = variables.secretAccesskey, 
									body=body,
									requestMethod = variables.requestMethod,
									version = variables.version  ) />
		
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
	
	<cffunction name="BatchPutAttributes" access="public" returntype="Struct" >
		<cfargument name="DomainName" type="string" required="true" />
		<cfargument name="items" type="array" required="true" />
		
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=BatchPutAttributes&DomainName=" & trim(arguments.DomainName) />
		
		<cfloop from="1" to="#arrayLen(arguments.items)#" index="j">
			<cfset body &= "&Item." & j & ".ItemName=" & arguments.items[j].ItemName />
			
			<cfloop from="1" to="#arrayLen(arguments.items[j].attributes)#" index="i">
				<cfset body &= "&Item." & j & ".Attribute." & i & ".Name=" & trim(arguments.items[j].attributes[i].name) & 
								"&Item." & j & ".Attribute." & i & ".Value=" & trim(arguments.items[j].attributes[i].value) />
				
				<cfif structKeyExists(arguments.items[j].attributes[i],'replace') && len(trim(arguments.items[j].attributes[i].replace))>
					<cfset body &= "&Item." & j & ".Attribute." & i & ".Replace=" & trim(arguments.items[j].attributes[i].replace) />
				</cfif>				 
			</cfloop>	
		</cfloop>	
		
		<cfset var rawResult = makeRequestFull(
									endPoint = variables.endPoint,
									awsAccessKeyId = variables.awsAccessKeyId, 
									secretAccesskey = variables.secretAccesskey, 
									body=body,
									requestMethod = variables.requestMethod,
									version = variables.version  ) />
									
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
	
	
	<cffunction name="GetAttributes" access="public" returntype="Struct" hint="Returns all of the attributes associated with the item. Optionally, the attributes returned can be limited to one or more specified attribute name parameters.">
		<cfargument name="DomainName" type="string" required="true" hint="The name of the domain in which to perform the operation."/>
		<cfargument name="itemName" type="string" required="true" hint="The name of the item"/>
		<cfargument name="AttributeName" type="String" required="false" default="" hint="The name of the attribute."/>
		<cfargument name="ConsistentRead" type="Boolean" required="false" default="false" hint="When set to true, ensures that the most recent data is returned."/>
		
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=GetAttributes&DomainName=" & trim(arguments.DomainName) & "&ItemName=" & trim(arguments.ItemName) />
		
		<cfif len(trim(arguments.attributeName))>
			<cfset body &= "&AttributeName=" & trim(arguments.AttributeName) />
		</cfif>	
		
		<cfif arguments.ConsistentRead>
			<cfset body &= "&ConsistentRead=true" />
		</cfif>	

		<cfset var rawResult = makeRequestFull(
									endPoint = variables.endPoint,
									awsAccessKeyId = variables.awsAccessKeyId, 
									secretAccesskey = variables.secretAccesskey, 
									body=body,
									requestMethod = variables.requestMethod,
									version = variables.version  ) />
								
		<cfif rawResult.statusCode neq 200>
			<cfset error = getResultNodes(xmlParse(rawResult.fileContent),'Error')[1] />
			<cfset stResponse.success=false />
			<cfset stResponse.statusCode=rawResult.statusCode />
			<cfset stResponse.error=error.Code.xmlText/>
			<cfset stResponse.errorType=error.Type.xmlText/>
			<cfset stResponse.errorMessage=error.Message.xmlText/>
		<cfelse>							
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'Attribute') />						
			<cfset stResponse.result = [] />
			
			<cfloop array="#dataResult#" index="result">
				<cfset arrayAppend(stResponse.result,{name=getValue(result,'name'),value=getValue(result,'value')}) />	
			</cfloop>							
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="Select" access="public" returntype="Struct" hint="The Select operation returns a set of Attributes for ItemNames that match the select expression. Select is similar to the standard SQL SELECT statement.">
		<cfargument name="SelectExpression" type="string" required="true" hint="The expression used to query the domain."/>
		<cfargument name="NextToken" type="String" required="false" default="" hint="String that tells Amazon SimpleDB where to start the next list of ItemNames."/>
		<cfargument name="ConsistentRead" type="Boolean" required="false" default="false" hint="When set to true, ensures that the most recent data is returned. "/>
		
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=Select&SelectExpression=" & trim(arguments.SelectExpression) />
		
		<cfif len(trim(arguments.NextToken))>
			<cfset body &= "&NextToken=" & trim(arguments.NextToken) />
		</cfif>	
		
		<cfif arguments.ConsistentRead>
			<cfset body &= "&ConsistentRead=true" />
		</cfif>	

		<cfset var rawResult = makeRequestFull(
									endPoint = variables.endPoint,
									awsAccessKeyId = variables.awsAccessKeyId, 
									secretAccesskey = variables.secretAccesskey, 
									body=body,
									requestMethod = variables.requestMethod,
									version = variables.version  ) />
					
		<cfif rawResult.statusCode neq 200>
			<cfset error = getResultNodes(xmlParse(rawResult.fileContent),'Error')[1] />
			<cfset stResponse.success=false />
			<cfset stResponse.statusCode=rawResult.statusCode />
			<cfset stResponse.error=error.Code.xmlText/>
			<cfset stResponse.errorType=error.Type.xmlText/>
			<cfset stResponse.errorMessage=error.Message.xmlText/>
		<cfelse>				
			<cfset dataResult = getResultNodes(xmlParse(rawResult.fileContent),'Item') />	
			<cfset stResponse.result = [] />
			
			<cfloop array="#dataResult#" index="result">
				<cfset stItem = {} />
				<cfset stItem['itemName'] = getValue(result,'name') />
				<cfset stItem['attributes'] = {} />
				
				<cfloop array="#result.xmlChildren#" index="node">
					<cfif node.xmlName eq 'Attribute'>
						<cfset stItem['attributes'][node.name.xmltext] = getValue(node,'value') />
					</cfif>	
				</cfloop>	
				
				<cfset arrayAppend(stResponse.result,stResponse) />
			</cfloop>
		</cfif>
			
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="DeleteAttributes" access="public" returntype="Struct" hint="Deletes one or more attributes associated with the item. If all attributes of an item are deleted, the item is deleted." >
		<cfargument name="DomainName" type="string" required="true" hint="The name of the domain in which to perform the operation."/>
		<cfargument name="itemName" type="string" required="true" hint="The name of the item."/>
		<cfargument name="attributes" type="array" required="false" default="#[]#" />
		
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=DeleteAttributes&DomainName=" & trim(arguments.DomainName) & "&ItemName=" & trim(arguments.ItemName) />
		
		<cfloop from="1" to="#arrayLen(arguments.attributes)#" index="i">
			<cfset body &= "&Attribute." & i & ".Name=" & trim(arguments.attributes[i].name) & 
							"&Attribute." & i & ".Value=" & trim(arguments.attributes[i].value) />
			
			<cfif structKeyExists(arguments.attributes[i],'replace') && len(trim(arguments.attributes[i].replace))>
				<cfset body &= "&Attribute." & i & ".Replace=" & trim(arguments.attributes[i].replace) />
			</cfif>				 
		</cfloop>	
		
		<cfset var rawResult = makeRequestFull(
									endPoint = variables.endPoint,
									awsAccessKeyId = variables.awsAccessKeyId, 
									secretAccesskey = variables.secretAccesskey, 
									body=body,
									requestMethod = variables.requestMethod,
									version = variables.version  ) />
									
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
	
	<cffunction name="BatchDeleteAttributes" access="public" returntype="Struct" hint="Performs multiple DeleteAttributes operations in a single call, which reduces round trips and latencies. variables enables Amazon SimpleDB to optimize requests, which generally yields better throughput." >
		<cfargument name="DomainName" type="string" required="true" hint="The name of the domain in which to perform the operation."/>
		<cfargument name="items" type="array" required="true" />
		
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=BatchDeleteAttributes&DomainName=" & trim(arguments.DomainName) />
		
		<cfloop from="1" to="#arrayLen(arguments.items)#" index="j">
			<cfset body &= "&Item." & j & ".ItemName=" & trim(arguments.items[j].ItemName) />
			
			<cfif structKeyExists(arguments.items[j],'attributes')>
				<cfloop from="1" to="#arrayLen(arguments.items[j].attributes)#" index="i">
					<cfset body &= "&Item." & j & ".Attribute." & i & ".Name=" & trim(arguments.items[j].attributes[i].name) & 
									"&Item." & j & ".Attribute." & i & ".Value=" & trim(arguments.items[j].attributes[i].value) />
					
					<cfif structKeyExists(arguments.items[j].attributes[i],'replace') && len(trim(arguments.items[j].attributes[i].replace))>
						<cfset body &= "&Item." & j & ".Attribute." & i & ".Replace=" & trim(arguments.items[j].attributes[i].replace) />
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
									version = variables.version  ) />
									
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
	
	<cffunction name="DeleteDomain" access="public" returntype="Struct" hint="he DeleteDomain operation deletes a domain. Any items (and their attributes) in the domain are deleted as well. The DeleteDomain operation might take 10 or more seconds to complete.">
		<cfargument name="DomainName" type="string" required="true" hint="The name of the domain to delete.">
		
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=DeleteDomain&DomainName=" & trim(arguments.DomainName)  />
		
		<cfset var rawResult = makeRequestFull(
									endPoint = variables.endPoint,
									awsAccessKeyId = variables.awsAccessKeyId, 
									secretAccesskey = variables.secretAccesskey, 
									body=body,
									requestMethod = variables.requestMethod,
									version = variables.version  ) />
			
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