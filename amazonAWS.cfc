<cfcomponent output="false" >
	
	<cffunction name="createFormattedTime" access="public" returntype="String" >
		<cfargument name="date" required="false" default="#now()#" >
		<cfargument name="iso" required="false" default="false" >
		<cfset var result = '' />
		<cfset var tz = getTimeZoneInfo() />
		<cfset var GDT=dateAdd('s',TZ.utcTotalOffset,arguments.date) />
		<cfif arguments.iso>
			<cfset result = DateFormat(GDT,'yyyy-mm-dd') & 'T' & TimeFormat(GDT,'HH:mm:ss')  & 'Z' />
		<cfelse>	
			<cfset result = DateFormat(GDT,'ddd, dd mmm yyyy') & ' ' & TimeFormat(GDT,'HH:mm:ss')  & ' GMT' />
		</cfif>
		<cfreturn result />
	</cffunction>
	
	<cffunction name="createSignature" access="public" returntype="String" >
		<cfargument name="data" type="string" required="true" />
		<cfargument name="secretKey" type="string" required="true" />
		
		<cfset var result = '' />
		<cfset var signatureMethod = 'HmacSHA256' />
		<cfset var Key = createObject("java", "javax.crypto.spec.SecretKeySpec").init(arguments.secretKey.getBytes(), signatureMethod) />
		<cfset var mac = createObject("java", "javax.crypto.Mac").getInstance(signatureMethod) />
		<cfset mac.init(key) />
		<cfset result = toBase64(mac.doFinal(arguments.data.getBytes())) />
		<cfreturn trim(result) />
	</cffunction> 
	
	<cffunction name="getResultNodes" access="private" returntype="any">
		<cfargument name="xmlData" type="xml" required="true" >
		<cfargument name="node" type="string" required="true" >
		<cfset var result = '' />
		<cfset result = xmlSearch(arguments.xmlData, "//*[ local-name() = '" & arguments.node & "' ]") />
		<cfreturn result />
	</cffunction>
	
	<cffunction name="urlEncode" access="public" returntype="String" >
		<cfargument name="urlString" type="string" required="true" >
		<cfset var result = replacelist(urlencodedformat(arguments.urlString), "%2D,%2E,%5F,%7E,+", "-,.,_,~,%20")/>
		<cfreturn result />
	</cffunction>
	
	<cffunction name="urlEncodeSpecial" access="public" returntype="String" >
		<cfargument name="urlString" type="string" required="true" >
		<cfset var result = replacelist(urlencodedformat(arguments.urlString), "%2D,%2E,%5F,%7E,%3D", "-,.,_,~,=")/>
		<cfreturn result />
	</cffunction>		
	
	<cffunction name="naturalByteOrder">
		<cfargument name="oldOrder">
		<cfargument name="format" required="false" default="false" >
		<cfargument name="skipEncryption" required="false" default="" >
		
		<cfset var newOrder = '' />
		<cfset var stTemp = {} />
		<cfset var del = '&' />
		<cfset var keys = '' />
		
		<cfloop list="#arguments.oldOrder#" index="item" delimiters="&" >
			<cfif format>
				<cfif listfindnocase(arguments.skipEncryption,listfirst(item,'='))>
					<cfset stTemp[listfirst(item,'=')] = urlEncodeSpecial(listrest(item,'=')) />
				<cfelse>
					<cfset stTemp[listfirst(item,'=')] = urlEncode(listrest(item,'=')) />
				</cfif>
			<cfelse>
				<cfset stTemp[listfirst(item,'=')] = listrest(item,'=') />
			</cfif>	
		</cfloop>
		
		<cfset Keys = StructKeyArray(stTemp) />
		<cfset ArraySort(Keys, "textnocase") />
	
		<cfloop array="#keys#" index="key">
			<cfset newOrder &= del & key & '=' & stTemp[key] />
			<cfset del = '&' />
		</cfloop>	
		<cfreturn newOrder />
	</cffunction>

	<cffunction name="makeRequest" access="package" returntype="String" >
		<cfargument name="endPoint" type="string" required="true" />
		<cfargument name="uri" type="string" required="false" default="/"/>
		<cfargument name="awsAccessKeyId" type="string" required="true" > 
		<cfargument name="secretAccesskey" type="string" required="true" > 
		<cfargument name="body" type="string" required="true" >
		<cfargument name="requestMethod" type="string" required="false" default="" >
		<cfargument name="version" type="string" required="false" default="" >
		<cfargument name="protocol" type="string" required="false" default="http://" >
		<cfargument name="params" type="string" required="false" default="" >
		<cfargument name="signatureOrder" type="string" required="false" default="body,AWSAccessKeyId,SignatureMethod,SignatureVersion,Timestamp,signature,params" >
		<cfargument name="skipEncryption" type="string" required="false" default="" >
			
		<cfset var result = '' />
		<cfset var formattedTime = '' />
		<cfset var signature = '' />
		
		<cfif arguments.requestMethod eq 'no-header'>
			<cfset formattedTime = createFormattedTime(iso=true) />
			<cfset signatureBody = 'GET#chr(10)##arguments.endPoint##chr(10)##arguments.uri##chr(10)#AWSAccessKeyId=#arguments.awsAccessKeyId#' />
			<cfset signatureBodySub = "&#arguments.body#&SignatureMethod=HmacSHA256&SignatureVersion=2&Timestamp=#formattedTime#" />			
			<cfif len(trim(arguments.version))>
				<cfset signatureBodySub &= "&Version=" & arguments.version/>
			</cfif>	
			<cfset signatureBody &= naturalByteOrder(signatureBodySub,true,arguments.skipEncryption) />
			<cfset signature = createSignature(trim(signatureBody)) />
			<cfset signatureParams = naturalByteOrder(signatureBodySub,false,arguments.skipEncryption) & '&AWSAccessKeyId=' & arguments.awsAccessKeyId />
			
			<cfhttp method="GET" url="#arguments.protocol##replacenocase(arguments.endPoint,arguments.protocol,'','ALL')##arguments.uri#" charset="UTF-8" result="result">
				<cfloop list="#signatureParams#" index="item" delimiters="&" >
					<cfhttpparam type="url" name="#listfirst(item,'=')#" value="#listrest(item,'=')#" >
				</cfloop>
				<cfhttpparam type="url" name="Signature" value="#trim(Signature)#" >
			</cfhttp>
		<cfelse>	
			<cfset formattedTime = createFormattedTime(iso=false) />
			<cfset signature = createSignature(formattedTime,arguments.secretAccesskey) />
			<cfhttp method="POST" url="#arguments.endPoint#" charset="UTF-8" result="result" >
				<cfhttpparam type="header" name="X-Amzn-Authorization" value="AWS3-HTTPS AWSAccessKeyId=#arguments.awsAccessKeyId#, Algorithm=HmacSHA256, Signature=#signature#" >
				<cfhttpparam type="header" name="Date" value="#formattedTime#"/>
				<cfhttpparam type="header" name="Content-Type" value="application/x-www-form-urlencoded"/>
				<!---<cfhttpparam type="body" value="#arguments.body#&Signature=#signature#" >--->
				<cfhttpparam type="body" value="AWSAccessKeyId=#arguments.awsAccessKeyId#&#arguments.body#"/>
			</cfhttp>
		</cfif>
		<cfreturn result.filecontent />		
	</cffunction>
	
	<cffunction name="makeRequestFull" access="package" returntype="Struct" >
		<cfargument name="endPoint" type="string" required="true" />
		<cfargument name="uri" type="string" required="false" default="/"/>
		<cfargument name="awsAccessKeyId" type="string" required="true" > 
		<cfargument name="secretAccesskey" type="string" required="true" > 
		<cfargument name="body" type="string" required="true" >
		<cfargument name="requestMethod" type="string" required="false" default="" >
		<cfargument name="version" type="string" required="false" default="" >
		<cfargument name="protocol" type="string" required="false" default="http://" >
		<cfargument name="skipEncryption" type="string" required="false" default="" >

		<cfset var result = '' />
		<cfset var formattedTime = '' />
		<cfset var signature = '' />
		
		<cfif arguments.requestMethod eq 'no-header'>
			<cfset formattedTime = createFormattedTime(iso=true) />
			<cfset signatureBody = 'GET#chr(10)##arguments.endPoint##chr(10)##arguments.uri##chr(10)#AWSAccessKeyId=#arguments.awsAccessKeyId#' />
			<cfset signatureBodySub = "&#arguments.body#&SignatureMethod=HmacSHA256&SignatureVersion=2&Timestamp=#formattedTime#" />			
			<cfif len(trim(arguments.version))>
				<cfset signatureBodySub &= "&Version=" & arguments.version/>
			</cfif>	
			<cfset signatureBody &= naturalByteOrder(signatureBodySub,true,arguments.skipEncryption) />
			<cfset signature = createSignature(trim(signatureBody),arguments.secretAccesskey) />
			<cfset signatureParams = naturalByteOrder(signatureBodySub,false) & '&AWSAccessKeyId=' & arguments.awsAccessKeyId />
			
			<cfhttp method="GET" url="#arguments.protocol##replacenocase(arguments.endPoint,arguments.protocol,'','ALL')##arguments.uri#" charset="UTF-8" result="result">
				<cfloop list="#signatureParams#" index="item" delimiters="&" >
					<cfhttpparam type="url" name="#listfirst(item,'=')#" value="#listrest(item,'=')#" >
				</cfloop>
				<cfhttpparam type="url" name="Signature" value="#trim(Signature)#" >
			</cfhttp>
		<cfelse>	
			<cfset formattedTime = createFormattedTime(iso=false) />
			<cfset signature = createSignature(formattedTime,arguments.secretAccesskey) />
			<cfhttp method="POST" url="#arguments.endPoint#" charset="UTF-8" result="result" >
				<cfhttpparam type="header" name="X-Amzn-Authorization" value="AWS3-HTTPS AWSAccessKeyId=#arguments.awsAccessKeyId#, Algorithm=HmacSHA256, Signature=#signature#" >
				<cfhttpparam type="header" name="Date" value="#formattedTime#"/>
				<cfhttpparam type="header" name="Content-Type" value="application/x-www-form-urlencoded"/>
				<!---<cfhttpparam type="body" value="#arguments.body#&Signature=#signature#" >--->
				<cfhttpparam type="body" value="AWSAccessKeyId=#arguments.awsAccessKeyId#&#arguments.body#"/>
			</cfhttp>
		</cfif>
		
		<cfreturn {filecontent=result.filecontent, statusCode=result.Responseheader.status_code}  />		
	</cffunction>
	
	<cffunction name="createResponse" access="private" returntype="Struct" output="false" >
		<cfset var stResponse = {} />
		<cfset stResponse['success'] = true/>
		<cfset stResponse['statusCode'] = '200'/>
		<cfset stResponse['error'] = ''/>
		<cfset stResponse['errorType'] = ''/>
		<cfset stResponse['errorMessage'] = ''/>
		<cfset stResponse['result'] = ''/>
		<cfset stResponse['requestID'] = ''/>
		<cfreturn stResponse />
	</cffunction>	
	
	<cffunction name="getValue" access="private" returntype="String" output="false" >
		<cfargument name="node" type="xml" required="true" >
		<cfargument name="name" type="string" required="true" >
		<cfset var response=''/>
		
		<cfif structKeyExists(arguments.node,arguments.name)>
			<cfset response = arguments.node[arguments.name].xmlText />
		</cfif>	
		
		<cfreturn response />
	</cffunction>
	
</cfcomponent>
