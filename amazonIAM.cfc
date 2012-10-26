<cfcomponent output="false" extends="amazonAWS" >
	<cffunction name="init" access="public" returntype="amazonIAM" >
		<cfargument name="awsAccessKeyId" type="string" required="true"/>
		<cfargument name="secretAccessKey" type="string" required="true"/>
		<cfargument name="endPoint" type="string" required="true" default="iam.amazonaws.com"/>
				
		<cfset variables.awsAccessKeyId = arguments.awsAccessKeyId />
		<cfset variables.secretAccesskey = arguments.secretAccessKey />
		<cfset variables.endPoint = arguments.endPoint />
		<cfset variables.requestMethod = 'no-header' />
		<cfset variables.version = '2010-05-08' />
		<cfset variables.protocol = 'https://' />
		<cfreturn this />		
	</cffunction>
	
	<cffunction name="ListUsers" access="public" returntype="Struct" >
		
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=ListUsers"/>
		
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
			<cfset dataResult = getResultNodes(xmlParse(rawResult.fileContent),'Users')[1].xmlChildren />
			<cfset stResponse.result = [] />
			
			<cfloop array="#dataResult#" index="user">
				<cfset arrayAppend(stResponse.result,createUserObject(user)) />
			</cfloop>		
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>	
	
	<cffunction name="ListAccessKeys" access="public" returntype="Struct" >
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=ListAccessKeys"/>
		
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
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'AccessKeyMetadata')[1].xmlChildren />
			<cfset stResponse.result = [] />
			
			<cfloop array="#dataResult#" index="member">
				<cfset arrayAppend(stResponse.result,{
										Status=getValue(member,'Status'),
										AccessKeyID=getValue(member,'AccessKeyID'),
										CreateDate=getValue(member,'CreateDate')
										}) />
			</cfloop>	
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="AddUserToGroup" access="public" returntype="Struct" >
		<cfargument name="GroupName" type="string" required="true" >
		<cfargument name="UserName" type="string" required="true" >
			
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=AddUserToGroup&GroupName=" & trim(arguments.GroupName) & "&UserName=" & trim(arguments.UserName)/>
		
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
	
	<cffunction name="ChangePassword" access="public" returntype="Struct" >
		<cfargument name="NewPassword" type="string" required="true" >
		<cfargument name="OldPassword" type="string" required="true" >
			
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=ChangePassword&NewPassword=" & trim(arguments.NewPassword) & "&OldPassword=" & trim(arguments.OldPassword)/>
		
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
	
	<cffunction name="CreateAccessKey" access="public" returntype="Struct" >
		<cfargument name="UserName" type="string" required="true" >
		
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=CreateAccessKey&UserName=" & trim(arguments.UserName)/>
		
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
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'AccessKey')[1] />
			<cfset stResponse.result = {
						UserName=getValue(dataResult,'UserName'),
						AccessKeyId=getValue(dataResult,'AccessKeyId'),
						Status=getValue(dataResult,'Status'),
						SecretAccessKey=getValue(dataResult,'SecretAccessKey')
						} />
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="CreateAccountAlias" access="public" returntype="Struct" >
		<cfargument name="AccountAlias" type="string" required="true" >
			
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=CreateAccountAlias&AccountAlias=" & trim(arguments.AccountAlias)/>
		
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
	
	<cffunction name="CreateGroup" access="public" returntype="Struct" >
		<cfargument name="GroupName" type="string" required="true" >
		<cfargument name="Path" type="string" required="false" default="" >
			
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=CreateGroup&GroupName=" & trim(arguments.GroupName)/>
		
		<cfif val(len(arguments.Path))>
			<cfset body &= "&Path=" & trim(arguments.path) />
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
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'Group')[1] />
			<cfset stResponse.result = createGroupObject(dataResult) />
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="CreateLoginProfile" access="public" returntype="Struct" >
		<cfargument name="UserName" type="string" required="true" >
		<cfargument name="Password" type="string" required="true" >
			
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=CreateLoginProfile&UserName=" & trim(arguments.UserName) & "&Password=" & trim(arguments.Password)/>
		
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
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'Group')[1] />
			<cfset stResponse.result = {UserName=getValue(dataResult,'UserName'),CreateDate=getValue(dataResult,'CreateDate')} />
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="CreateUser" access="public" returntype="Struct" >
		<cfargument name="UserName" type="string" required="true" >
		<cfargument name="Path" type="string" required="false" default="" >
			
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=CreateUser&UserName=" & trim(arguments.UserName)/>
		
		<cfif len(trim(arguments.Path))>
			<cfset body &= "&Path=" & trim(arguments.Path) />
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
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'User')[1] />
			<cfset stResponse.result = createUserObject(dataResult) />
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="CreateVirtualMFADevice" access="public" returntype="Struct" >
		<cfargument name="VirtualMFADeviceName" type="string" required="true" >
		<cfargument name="Path" type="string" required="false" default="" >
			
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=CreateVirtualMFADevice&VirtualMFADeviceName=" & trim(arguments.VirtualMFADeviceName)/>
		
		<cfif len(trim(arguments.Path))>
			<cfset body &= "&Path=" & trim(arguments.Path) />
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
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'VirtualMFADevice')[1] />
			<cfset stResponse.result = {
										SerialNumber=getValue(dataResult,'SerialNumber'),
										Base32StringSeed=getValue(dataResult,'Base32StringSeed'),
										QRCodePNG=getValue(dataResult,'QRCodePNG')
									} />
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="DeactivateMFADevice" access="public" returntype="Struct" >
		<cfargument name="UserName" type="string" required="true" >
		<cfargument name="SerialNumber" type="string" required="true" >
			
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=DeactivateMFADevice&UserName=" & trim(arguments.UserName) & "&SerialNumber=" & trim(arguments.SerialNumber)/>
		
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
	
	<cffunction name="DeleteAccessKey" access="public" returntype="Struct" >
		<cfargument name="AccessKeyId" type="string" required="true" >
		<cfargument name="UserName" type="string" required="false" default="" >
			
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=DeleteAccessKey&AccessKeyId=" & trim(arguments.AccessKeyId)/>
		
		<cfif len(trim(arguments.UserName))>
			<cfset body &="&UserName=" & trim(arguments.UserName) />	
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
	
	<cffunction name="DeleteAccountPasswordPolicy" access="public" returntype="Struct" >
			
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=DeleteAccountPasswordPolicy"/>
		
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
	
	<cffunction name="DeleteAccountAlias" access="public" returntype="Struct" >
		<cfargument name="AccountAlias" type="string" required="true" >
			
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=DeleteAccountAlias&AccountAlias=" & trim(arguments.AccountAlias)/>
		
		
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
	
	<cffunction name="DeleteGroup" access="public" returntype="Struct" >
		<cfargument name="GroupName" type="string" required="true" >
			
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=DeleteGroup&GroupName=" & trim(arguments.GroupName)/>
		
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
	
	<cffunction name="DeleteGroupPolicy" access="public" returntype="Struct" >
		<cfargument name="GroupName" type="string" required="true" >
		<cfargument name="PolicyName" type="string" required="true" >
			
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=DeleteGroupPolicy&GroupName=" & trim(arguments.GroupName) & "&PolicyName=" & trim(arguments.PolicyName)/>
		
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
	
	<cffunction name="DeleteLoginProfile" access="public" returntype="Struct" >
		<cfargument name="UserName" type="string" required="true" >
			
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=DeleteLoginProfile&UserName=" & trim(arguments.UserName)/>
		
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
	
	<cffunction name="DeleteServerCertificate" access="public" returntype="Struct" >
		<cfargument name="ServerCertificateName" type="string" required="true" >
			
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=DeleteServerCertificate&ServerCertificateName=" & trim(arguments.ServerCertificateName)/>
		
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
	
	<cffunction name="DeleteSigningCertificate" access="public" returntype="Struct" >
		<cfargument name="CertificateId" type="string" required="true" >
		<cfargument name="UserName" type="string" required="false" default="" >
			
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=DeleteSigningCertificate&CertificateId=" & trim(arguments.CertificateId)/>
		
		<cfif len(trim(arguments.UserName))>
			<cfset body &="&UserName=" & trim(arguments.UserName) />	
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
	
	<cffunction name="DeleteUser" access="public" returntype="Struct" >
		<cfargument name="UserName" type="string" required="true" >
			
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=DeleteUser&UserName=" & trim(arguments.UserName)/>
		
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
	
	<cffunction name="DeleteUserPolicy" access="public" returntype="Struct" >
		<cfargument name="PolicyName" type="string" required="true" >
		<cfargument name="UserName" type="string" required="true" >
			
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=DeleteUserPolicy&PolicyName=" & trim(arguments.PolicyName) & "&UserName=" & trim(arguments.UserName)/>
		
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
	
	<cffunction name="DeleteVirtualMFADevice" access="public" returntype="Struct" >
		<cfargument name="SerialNumber" type="string" required="true" >
			
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=DeleteVirtualMFADevice&SerialNumber=" & trim(arguments.SerialNumber)/>
		
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
	
	<cffunction name="EnableMFADevice" access="public" returntype="Struct" >
		<cfargument name="SerialNumber" type="string" required="true" >
		<cfargument name="UserName" type="string" required="true" >
		<cfargument name="AuthenticationCode1" type="string" required="true" >
		<cfargument name="AuthenticationCode2" type="string" required="true" >
			
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=EnableMFADevice&SerialNumber=" & trim(arguments.SerialNumber) &
							"&UserName=" & trim(arguments.UserName) & 
							"&AuthenticationCode1=" & trim(arguments.AuthenticationCode1) &
							"&AuthenticationCode2=" & trim(arguments.AuthenticationCode2) />
		
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
	
	<cffunction name="PutGroupPolicy" access="public" returntype="Struct" >
		<cfargument name="GroupName" type="string" required="true" >
		<cfargument name="PolicyDocument" type="string" required="true" >
		<cfargument name="PolicyName" type="string" required="true" >
			
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=PutGroupPolicy&GroupName=" & trim(arguments.GroupName) &
							"&PolicyDocument=" & trim(arguments.PolicyDocument) & 
							"&PolicyName=" & trim(arguments.PolicyName) />
		
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
	
	<cffunction name="PutUserPolicy" access="public" returntype="Struct" >
		<cfargument name="UserName" type="string" required="true" >
		<cfargument name="PolicyDocument" type="string" required="true" >
		<cfargument name="PolicyName" type="string" required="true" >
			
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=PutUserPolicy&UserName=" & trim(arguments.UserName) &
							"&PolicyDocument=" & trim(arguments.PolicyDocument) & 
							"&PolicyName=" & trim(arguments.PolicyName) />
		
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
	
	<cffunction name="RemoveUserFromGroup" access="public" returntype="Struct" >
		<cfargument name="UserName" type="string" required="true" >
		<cfargument name="GroupName" type="string" required="true" >
			
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=RemoveUserFromGroup&UserName=" & trim(arguments.UserName) &
							"&GroupName=" & trim(arguments.GroupName) />
		
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
	
	<cffunction name="ResyncMFADevice" access="public" returntype="Struct" >
		<cfargument name="SerialNumber" type="string" required="true" >
		<cfargument name="UserName" type="string" required="true" >
		<cfargument name="AuthenticationCode1" type="string" required="true" >
		<cfargument name="AuthenticationCode2" type="string" required="true" >
			
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=ResyncMFADevice&SerialNumber=" & trim(arguments.SerialNumber) &
							"&UserName=" & trim(arguments.UserName) & 
							"&AuthenticationCode1=" & trim(arguments.AuthenticationCode1) &
							"&AuthenticationCode2=" & trim(arguments.AuthenticationCode2) />
		
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
	
	<cffunction name="UpdateAccessKey" access="public" returntype="Struct" >
		<cfargument name="AccessKeyId" type="string" required="true" >
		<cfargument name="Status" type="string" required="true" >
		<cfargument name="UserName" type="string" required="false" default="" >
			
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=UpdateAccessKey&AccessKeyId=" & trim(arguments.AccessKeyId) &
							"&Status=" & trim(arguments.Status) />
		
		<cfif val(trim(arguments.username))>
			<cfset body &= "&UserName=" & trim(arguments.UserName) />
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
	
	<cffunction name="UpdateAccountPasswordPolicy" access="public" returntype="Struct" >
		<cfargument name="AllowUsersToChangePassword" type="boolean" required="false" default="false" >
		<cfargument name="MinimumPasswordLength" type="numeric" required="false" default="0" >
		<cfargument name="RequireLowercaseCharacters" type="boolean" required="false" default="false" >
		<cfargument name="RequireNumbers" type="boolean" required="false" default="false" >
		<cfargument name="RequireSymbols" type="boolean" required="false" default="false" >
		<cfargument name="RequireUppercaseCharacters" type="boolean" required="false" default="false" >
					
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=UpdateAccountPasswordPolicy" />
		
		<cfif arguments.AllowUsersToChangePassword>
			<cfset body &= "&AllowUsersToChangePassword=true" />
		</cfif>
		
		<cfif val(arguments.MinimumPasswordLength)>
			<cfset body &= "&MinimumPasswordLength=" & trim(arguments.MinimumPasswordLength) />
		</cfif>	
		
		<cfif arguments.RequireLowercaseCharacters>
			<cfset body &= "&RequireLowercaseCharacters=true" />
		</cfif>
		
		<cfif arguments.RequireNumbers>
			<cfset body &= "&RequireNumbers=true" />
		</cfif>
		
		<cfif arguments.RequireSymbols>
			<cfset body &= "&RequireSymbols=true" />
		</cfif>
		
		<cfif arguments.RequireUppercaseCharacters>
			<cfset body &= "&RequireUppercaseCharacters=true" />
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
	
	<cffunction name="UpdateGroup" access="public" returntype="Struct" >
		<cfargument name="GroupName" type="string" required="true" >
		<cfargument name="NewGroupName" type="string" required="false" default="" >
		<cfargument name="NewPath" type="string" required="false" default="" >
			
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=UpdateGroup&GroupName=" & trim(arguments.GroupName) />
		
		<cfif val(trim(arguments.NewGroupName))>
			<cfset body &= "&NewGroupName=" & trim(arguments.NewGroupName) />
		</cfif>
		
		<cfif val(trim(arguments.NewPath))>
			<cfset body &= "&NewPath=" & trim(arguments.NewPath) />
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
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'Group')[1] />
			<cfset stResponse.result = {Path=getValue(dataResult,'Path'),GroupName=getValue(dataResult,'GroupName'),GroupId=getValue(dataResult,'GroupId'),Arn=getValue(dataResult,'Arn')} />
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="UpdateLoginProfile" access="public" returntype="Struct" >
		<cfargument name="UserName" type="string" required="true" >
		<cfargument name="Password" type="string" required="true" >
			
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=UpdateLoginProfile&UserName=" & trim(arguments.UserName) &
							"&Password=" & trim(arguments.Password) />
		
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
	
	<cffunction name="UpdateServerCertificate" access="public" returntype="Struct" >
		<cfargument name="ServerCertificateName" type="string" required="true" >
		<cfargument name="NewServerCertificateName" type="string" required="false" default="" >
		<cfargument name="NewPath" type="string" required="false" default="" >
			
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=UpdateServerCertificate&ServerCertificateName=" & trim(arguments.ServerCertificateName) />
		
		<cfif val(trim(arguments.NewServerCertificateName))>
			<cfset body &= "&NewServerCertificateName=" & trim(arguments.NewServerCertificateName) />
		</cfif>	
		
		<cfif val(trim(arguments.NewPath))>
			<cfset body &= "&NewPath=" & trim(arguments.NewPath) />
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
	
	<cffunction name="UpdateSigningCertificate" access="public" returntype="Struct" >
		<cfargument name="CertificateId" type="string" required="true" >
		<cfargument name="Status" type="string" required="true" >
		<cfargument name="UserName" type="string" required="false" default="" >
			
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=UpdateSigningCertificate&CertificateId=" & trim(arguments.CertificateId) &
							"&Status=" & trim(arguments.Status) />
		
		<cfif val(trim(arguments.username))>
			<cfset body &= "&UserName=" & trim(arguments.UserName) />
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
	
	<cffunction name="UpdateUser" access="public" returntype="Struct" >
		<cfargument name="UserName" type="string" required="true" >
		<cfargument name="NewUserName" type="string" required="false" default="" >
		<cfargument name="NewPath" type="string" required="false" default="" >
			
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=UpdateUser&UserName=" & trim(arguments.UserName) />
		
		<cfif val(trim(arguments.NewUserName))>
			<cfset body &= "&NewUserName=" & trim(arguments.NewUserName) />
		</cfif>	
		
		<cfif val(trim(arguments.NewPath))>
			<cfset body &= "&NewPath=" & trim(arguments.NewPath) />
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
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'User')[1] />
			<cfset stResponse.result = {Path=getValue(dataResult,'Path'),UserName=getValue(dataResult,'UserName'),UserId=getValue(dataResult,'UserId'),Arn=getValue(dataResult,'Arn')} />
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="UploadServerCertificate" access="public" returntype="Struct" >
		<cfargument name="ServerCertificateName" type="string" required="true" >
		<cfargument name="PrivateKey" type="string" required="true">
		<cfargument name="CertificateBody" type="string" required="true">
		<cfargument name="CertificateChain" type="string" required="false" default="" >
		<cfargument name="Path" type="string" required="false" default="" >
			
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=UploadServerCertificate&ServerCertificateName=" & trim(arguments.ServerCertificateName) & 
							"&PrivateKey=" & trim(arguments.PrivateKey) & 
							"&CertificateBody=" & trim(arguments.CertificateBody) />
		
		<cfif val(trim(arguments.CertificateChain))>
			<cfset body &= "&CertificateChain=" & trim(arguments.CertificateChain) />
		</cfif>	
		
		<cfif val(trim(arguments.Path))>
			<cfset body &= "&Path=" & trim(arguments.Path) />
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
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'ServerCertificateMetadata')[1] />
			<cfset stResponse.result = {ServerCertificateName=getValue(dataResult,'ServerCertificateName'),Path=getValue(dataResult,'Path'),Arn=getValue(dataResult,'Arn'),UploadDate=getValue(dataResult,'UploadDate'),ServerCertificateId=getValue(dataResult,'ServerCertificateId')} />
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="UploadSigningCertificate" access="public" returntype="Struct" >
		<cfargument name="CertificateBody" type="string" required="true" >
		<cfargument name="UserName" type="string" required="false" default="" >
			
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=UploadSigningCertificate&CertificateBody=" & trim(arguments.CertificateBody)/>
		
		<cfif val(trim(arguments.UserName))>
			<cfset body &= "&UserName=" & trim(arguments.UserName) />
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
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'Certificate')[1] />
			<cfset stResponse.result = {UserName=getValue(dataResult,'UserName'),CertificateId=getValue(dataResult,'CertificateId'),CertificateBody=getValue(dataResult,'CertificateBody'),Status=getValue(dataResult,'Status')} />
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="GetAccountPasswordPolicy" access="public" returntype="Struct" >
			
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=GetAccountPasswordPolicy"/>
		
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
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'PasswordPolicy')[1] />
			<cfset stResponse.result = {
									MinimumPasswordLength=getValue(dataResult,'MinimumPasswordLength'),
									RequireUppercaseCharacters=getValue(dataResult,'RequireUppercaseCharacters'),
									RequireLowercaseCharacters=getValue(dataResult,'RequireLowercaseCharacters'),
									RequireNumbers=getValue(dataResult,'RequireNumbers'),
									RequireSymbols=getValue(dataResult,'RequireSymbols'),
									AllowUsersToChangePassword=getValue(dataResult,'AllowUsersToChangePassword')
								} />
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="GetAccountSummary" access="public" returntype="Struct" >
			
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=GetAccountSummary"/>
		
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
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'SummaryMap')[1].xmlChildren />
			<cfset stResponse.result = {} />
			
			<cfloop array="#dataResult#" index="entry" >
				<cfset stResponse.result[entry.key.xmlText] = entry.value.xmlText />
			</cfloop>
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="GetGroup" access="public" returntype="Struct" >
		<cfargument name="GroupName" type="string" required="true" >
		<cfargument name="MaxItems" type="string" required="false" default="" >
		<cfargument name="Marker" type="string" required="false" default="" >
			
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=GetGroup&GroupName=" & trim(arguments.GroupName)/>
		
		<cfif val(trim(arguments.MaxItems))>
			<cfset body &= "&MaxItems=" & trim(arguments.MaxItems) />
		</cfif>	
		
		<cfif val(trim(arguments.Marker))>
			<cfset body &= "&Marker=" & trim(arguments.Marker) />
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
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'GetGroupResult')[1] />
			<cfset stResponse.result = {
										group={
											Path=getValue(dataResult.Group,'Path'),
											GroupName=getValue(dataResult.Group,'GroupName'),
											GroupId=getValue(dataResult.Group,'GroupId'),
											Arn=getValue(dataResult.Group,'Arn')
										},
										users=[]
									} />
				<cfloop array="#dataResult.Users.xmlChildren#" index="user">
					<cfset arrayAppend(stResponse.result.users,{
											Path=getValue(user,'Path'),
											UserName=getValue(user,'UserName'),
											UserId=getValue(user,'UserId'),
											Arn=getValue(user,'Arn')
										}) />
				</cfloop>						
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="GetGroupPolicy" access="public" returntype="Struct" >
		<cfargument name="GroupName" type="string" required="true" >
		<cfargument name="PolicyName" type="string" required="true" >
				
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=GetGroupPolicy&GroupName=" & trim(arguments.GroupName) & "&PolicyName=" & trim(arguments.PolicyName)/>
		
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
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'GetGroupPolicyResult')[1] />
			<cfset stResponse.result = {GroupName=getValue(dataResult,'GroupName'),PolicyName=getValue(dataResult,'PolicyName'),PolicyDocument=deserializeJSON(getValue(dataResult,'PolicyDocument'))} />
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="GetLoginProfile" access="public" returntype="Struct" >
		<cfargument name="UserName" type="string" required="true" >
				
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=GetLoginProfile&UserName=" & trim(arguments.UserName)/>
		
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
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'LoginProfile')[1] />
			<cfset stResponse.result = {UserName=getValue(dataResult,'UserName'),CreateDate=getValue(dataResult,'CreateDate')} />
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="GetServerCertificate" access="public" returntype="Struct" >
		<cfargument name="ServerCertificateName" type="string" required="true" >
				
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=GetServerCertificate&ServerCertificateName=" & trim(arguments.ServerCertificateName)/>
		
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
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'ServerCertificate')[1] />
			<cfset stResponse.result = {
										ServerCertificateMetadata={
											ServerCertificateName=getValue(dataResult.ServerCertificateMetadata,'ServerCertificateName'),
											Path=getValue(dataResult.ServerCertificateMetadata,'Path'),
											Arn=getValue(dataResult.ServerCertificateMetadata,'Arn'),
											UploadDate=getValue(dataResult.ServerCertificateMetadata,'UploadDate'),
											ServerCertificateId=getValue(dataResult.ServerCertificateMetadata,'ServerCertificateId')
										},
										CertificateBody=getValue(dataResult,'CertificateBody')
									} />
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="GetUser" access="public" returntype="Struct" >
		<cfargument name="UserName" type="string" required="true" >
				
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=GetUser&UserName=" & trim(arguments.UserName)/>
		
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
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'User')[1] />
			<cfset stResponse.result = {
									Path=getValue(dataResult,'Path'),
									UserName=getValue(dataResult,'UserName'),
									UserId=getValue(dataResult,'UserId'),
									Arn=getValue(dataResult,'Arn')
								} />
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="GetUserPolicy" access="public" returntype="Struct" >
		<cfargument name="UserName" type="string" required="true" >
		<cfargument name="PolicyName" type="string" required="true" >
				
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=GetUserPolicy&UserName=" & trim(arguments.UserName) & "&PolicyName=" & trim(arguments.PolicyName)/>
		
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
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'GetUserPolicyResult')[1] />
			<cfset stResponse.result = {
									UserName=getValue(dataResult,'UserName'),
									PolicyName=getValue(dataResult,'PolicyName'),
									PolicyDocument=deserializeJSON(getValue(dataResult,'UserId'))
								} />
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="ListGroups" access="public" returntype="Struct" >
		<cfargument name="PathPrefix" type="string" required="false" default="" >
		<cfargument name="MaxItems" type="string" required="false" default="" >
		<cfargument name="Marker" type="string" required="false" default="" >
					
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=ListGroups" />
		
		<cfif len(trim(arguments.PathPrefix))>
			<cfset body &="&PathPrefix=" & trim(arguments.PathPrefix) />	
		</cfif>
		
		<cfif len(trim(arguments.MaxItems))>
			<cfset body &="&MaxItems=" & trim(arguments.MaxItems) />	
		</cfif>
		
		<cfif len(trim(arguments.Marker))>
			<cfset body &="&Marker=" & trim(arguments.Marker) />	
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
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'Groups').xmlChildren />
			<cfset stResponse.result=[]/>
			
			<cfloop array="#dataResult#" index="group">
				<cfset arrayAppend(stResponse.result,{
										Path=getValue(group,'Path'),
										GroupName=getValue(group,'GroupName'),
										GroupId=getValue(group,'GroupId'),
										Arn=getValue(group,'Arn')
									}) />
			</cfloop>	
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="ListGroupsForUser" access="public" returntype="Struct" >
		<cfargument name="UserName" type="string" required="true" >
		<cfargument name="MaxItems" type="string" required="false" default="" >
		<cfargument name="Marker" type="string" required="false" default="" >
					
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=ListGroupsForUser&UserName=" & trim(arguments.UserName) />
		
		<cfif len(trim(arguments.MaxItems))>
			<cfset body &="&MaxItems=" & trim(arguments.MaxItems) />	
		</cfif>
		
		<cfif len(trim(arguments.Marker))>
			<cfset body &="&Marker=" & trim(arguments.Marker) />	
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
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'Groups').xmlChildren />
			<cfset stResponse.result=[]/>
			
			<cfloop array="#dataResult#" index="group">
				<cfset arrayAppend(stResponse.result,{
										Path=getValue(group,'Path'),
										GroupName=getValue(group,'GroupName'),
										GroupId=getValue(group,'GroupId'),
										Arn=getValue(group,'Arn')
									}) />
			</cfloop>	
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="ListMFADevices" access="public" returntype="Struct" >
		<cfargument name="UserName" type="string" required="false" default="" >
		<cfargument name="MaxItems" type="string" required="false" default="" >
		<cfargument name="Marker" type="string" required="false" default="" >
					
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=ListMFADevices" />
		
		<cfif len(trim(arguments.UserName))>
			<cfset body &="&UserName=" & trim(arguments.UserName) />	
		</cfif>
		
		<cfif len(trim(arguments.MaxItems))>
			<cfset body &="&MaxItems=" & trim(arguments.MaxItems) />	
		</cfif>
		
		<cfif len(trim(arguments.Marker))>
			<cfset body &="&Marker=" & trim(arguments.Marker) />	
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
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'MFADevices').xmlChildren />
			<cfset stResponse.result=[]/>
			
			<cfloop array="#dataResult#" index="device">
				<cfset arrayAppend(stResponse.result,{
										UserName=getValue(device,'Path'),
										SerialNumber=getValue(device,'GroupName')
									}) />
			</cfloop>	
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="ListServerCertificates" access="public" returntype="Struct" >
		<cfargument name="PathPrefix" type="string" required="false" default="" >
		<cfargument name="MaxItems" type="string" required="false" default="" >
		<cfargument name="Marker" type="string" required="false" default="" >
					
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=ListServerCertificates" />
		
		<cfif len(trim(arguments.PathPrefix))>
			<cfset body &="&PathPrefix=" & trim(arguments.PathPrefix) />	
		</cfif>
		
		<cfif len(trim(arguments.MaxItems))>
			<cfset body &="&MaxItems=" & trim(arguments.MaxItems) />	
		</cfif>
		
		<cfif len(trim(arguments.Marker))>
			<cfset body &="&Marker=" & trim(arguments.Marker) />	
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
			
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'ListServerCertificatesResult')[1] />
			<cfset stResponse.result={IsTruncated=getValue(dataResult,'IsTruncated'),ServerCertificateMetadataList=[]}/>
			
			<cfloop array="#dataResult.ServerCertificateMetadataList.xmlChildren#" index="metadata">
				<cfset arrayAppend(stResponse.result.ServerCertificateMetadataList,{
										ServerCertificateName=getValue(metadata.ServerCertificateMetadata,'ServerCertificateName'),
										Path=getValue(metadata.ServerCertificateMetadata,'Path'),
										Arn=getValue(metadata.ServerCertificateMetadata,'Arn'),
										UploadDate=getValue(metadata.ServerCertificateMetadata,'UploadDate'),
										ServerCertificateId=getValue(metadata.ServerCertificateMetadata,'ServerCertificateId')
									}) />
			</cfloop>	
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="ListSigningCertificates" access="public" returntype="Struct" >
		<cfargument name="UserName" type="string" required="false" default="" >
		<cfargument name="MaxItems" type="string" required="false" default="" >
		<cfargument name="Marker" type="string" required="false" default="" >
					
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=ListSigningCertificates" />
		
		<cfif len(trim(arguments.UserName))>
			<cfset body &="&UserName=" & trim(arguments.UserName) />	
		</cfif>
		
		<cfif len(trim(arguments.MaxItems))>
			<cfset body &="&MaxItems=" & trim(arguments.MaxItems) />	
		</cfif>
		
		<cfif len(trim(arguments.Marker))>
			<cfset body &="&Marker=" & trim(arguments.Marker) />	
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
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'ListSigningCertificatesResult')[1] />
			<cfset stResponse.result={UserName=getValue(dataResult,'UserName'),Certificates=[],IsTruncated=getValue(dataResult,'IsTruncated')}/>
			
			<cfloop array="#dataResult.Certificates.xmlChildren#" index="cert">
				<cfset arrayAppend(stResponse.result.Certificates,{
										UserName=getValue(cert,'UserName'),
										CertificateId=getValue(cert,'CertificateId'),
										CertificateBody=getValue(cert,'CertificateBody'),
										Status=getValue(cert,'Status')
									}) />
			</cfloop>	
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="ListUserPolicies" access="public" returntype="Struct" >
		<cfargument name="UserName" type="string" required="true" >
		<cfargument name="MaxItems" type="string" required="false" default="" >
		<cfargument name="Marker" type="string" required="false" default="" >
					
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=ListUserPolicies&UserName=" & trim(arguments.UserName) />
		
		<cfif len(trim(arguments.MaxItems))>
			<cfset body &="&MaxItems=" & trim(arguments.MaxItems) />	
		</cfif>
		
		<cfif len(trim(arguments.Marker))>
			<cfset body &="&Marker=" & trim(arguments.Marker) />	
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
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'ListUserPoliciesResult')[1] />
			<cfset stResponse.result={IsTruncated=getValue(dataResult,'IsTruncated'),PolicyNames=[]}/>
			
			<cfloop array="#dataResult.PolicyNames.xmlChildren#" index="policy">
				<cfset arrayAppend(stResponse.result.PolicyNames,policy.xmlText) />
			</cfloop>	
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="ListVirtualMFADevices" access="public" returntype="Struct" >
		<cfargument name="AssignmentStatus" type="string" required="false" default="" >
		<cfargument name="MaxItems" type="string" required="false" default="" >
		<cfargument name="Marker" type="string" required="false" default="" >
					
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=ListVirtualMFADevices" />
		
		<cfif len(trim(arguments.AssignmentStatus))>
			<cfset body &="&AssignmentStatus=" & trim(arguments.AssignmentStatus) />	
		</cfif>
		
		<cfif len(trim(arguments.MaxItems))>
			<cfset body &="&MaxItems=" & trim(arguments.MaxItems) />	
		</cfif>
		
		<cfif len(trim(arguments.Marker))>
			<cfset body &="&Marker=" & trim(arguments.Marker) />	
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
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'ListVirtualMFADevicesResult')[1] />
			<cfset stResponse.result={VirtualMFADevices=[],IsTruncated=getValue(dataResult,'IsTruncated')}/>
			
			<cfloop array="#dataResult.VirtualMFADevices.xmlChildren#" index="device">
				<cfset stDevice = {SerialNumber=getValue(device,'SerialNumber')} />
				<cfset stDevice.EnableDate = getValue(device,'EnableDate') />
				
				<cfif structKeyExists(device,'User')>
					<cfloop array="#device.user.xmlChildren#" index="user">
						<cfset stDevice.User[user.xmlName] = user.xmlText />
					</cfloop>	
				</cfif>
					
				<cfset arrayAppend(stResponse.result.VirtualMFADevices,stDevice) />
			</cfloop>	
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>
	
	
	<cffunction name="ListGroupPolicies" access="public" returntype="Struct" >
		<cfargument name="GroupName" type="string" required="true" >
		<cfargument name="MaxItems" type="string" required="false" default="" >
		<cfargument name="Marker" type="string" required="false" default="" >
					
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=ListGroupPolicies&GroupName=" & trim(arguments.GroupName) />
		
		<cfif len(trim(arguments.MaxItems))>
			<cfset body &="&MaxItems=" & trim(arguments.MaxItems) />	
		</cfif>
		
		<cfif len(trim(arguments.Marker))>
			<cfset body &="&Marker=" & trim(arguments.Marker) />	
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
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'ListGroupPoliciesResult')[1] />
			<cfset stResponse.result={IsTruncated=getValue(dataResult,'IsTruncated'),PolicyNames=[]}/>
			
			<cfloop array="#dataResult.PolicyNames.xmlChildren#" index="policy">
				<cfset arrayAppend(stResponse.result.PolicyNames,policy.xmlText) />
			</cfloop>	
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>
	
	<cffunction name="ListAccountAliases" access="public" returntype="Struct" >
		<cfargument name="MaxItems" type="string" required="false" default="" >
		<cfargument name="Marker" type="string" required="false" default="" >
					
		<cfset var stResponse = createResponse() />
		<cfset var body = "Action=ListAccountAliases" />
		
		<cfif len(trim(arguments.MaxItems))>
			<cfset body &="&MaxItems=" & trim(arguments.MaxItems) />	
		</cfif>
		
		<cfif len(trim(arguments.Marker))>
			<cfset body &="&Marker=" & trim(arguments.Marker) />	
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
			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'ListAccountAliasesResult')[1] />
			<cfset stResponse.result={IsTruncated=getValue(dataResult,'IsTruncated'),AccountAliases=[]}/>
			
			<cfloop array="#dataResult.AccountAliases.xmlChildren#" index="alias">
				<cfset arrayAppend(stResponse.result.PolicyNames,alias.xmlText) />
			</cfloop>	
		</cfif>
		
		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />
						
		<cfreturn stResponse />
	</cffunction>
	
	
	
	<cffunction name="createGroupObject" access="public" returntype="Struct" >
		<cfargument name="xmlData" type="xml" required="false" >
		
		<cfreturn {
				Path=getValue(arguments.xmlData,'Path'),
				GroupName=getValue(arguments.xmlData,'GroupName'),
				GroupId=getValue(arguments.xmlData,'GroupId'),
				Arn=getValue(arguments.xmlData,'Arn')
			}/>
	
	</cffunction>

	<cffunction name="createUserObject" access="public" returntype="Struct" >
		<cfargument name="xmlData" type="xml" required="false" >
		
		<cfreturn {
					UserId=getValue(arguments.xmlData,'UserId'),
					Path=getValue(arguments.xmlData,'Path'),
					UserName=getValue(arguments.xmlData,'UserName'),
					Arn=getValue(arguments.xmlData,'Arn'),
					CreateDate=getValue(arguments.xmlData,'CreateDate')
				}/>
	
	</cffunction>
</cfcomponent>