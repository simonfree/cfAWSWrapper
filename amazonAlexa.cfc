<cfcomponent output="false" extends="amazonAWS" >
	<cffunction name="init" access="public" returntype="amazonAlexa" >
		<cfargument name="awsAccessKeyId" type="string" required="true"/>
		<cfargument name="secretAccessKey" type="string" required="true"/>
				
		<cfset variables.awsAccessKeyId = arguments.awsAccessKeyId />
		<cfset variables.secretAccesskey = arguments.secretAccessKey />
		<cfset variables.endPoint = 'awis.amazonaws.com' />
		<cfset variables.requestMethod = 'no-header' />
		<cfset variables.version = '' />
		<cfset variables.protocol = 'http://' />
		<cfreturn this />		
	</cffunction>
	
	<cffunction name="UrlInfo" access="public" returntype="Struct" >    
    		<cfargument name="fullURL" type="string" required="true" >    
    		<cfargument name="ResponseGroup" type="string" required="true" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=UrlInfo&Url=" & arguments.fullURL & "&ResponseGroup=" & arguments.ResponseGroup />
    		    
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
			
    			<cfswitch expression="#arguments.ResponseGroup#" >
				<cfcase value="RelatedLinks" >
					<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'RelatedLink') />    
    					<cfset stResponse.result = [] />	

					<cfloop array="#dataResult#"	index="result">
						<cfset arrayAppend(stResponse.result,{
											DataUrl=getValue(result,'aws:DataUrl'),
											NavigableUrl=getValue(result,'aws:NavigableUrl'),
											Title=getValue(result,'aws:Title')
										}) />
					</cfloop>						
				</cfcase>	
				
				<cfcase value="Categories">
					<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'CategoryData') />    
    					<cfset stResponse.result = [] />	

					<cfloop array="#dataResult#"	index="result">
						<cfset arrayAppend(stResponse.result,{
											Title=getValue(result,'aws:Title'),
											AbsolutePath=getValue(result,'aws:AbsolutePath')
										}) />
					</cfloop>	
				</cfcase>
				
				<cfcase value="Rank">
					<cfset stResponse.result = getResultNodes(xmlParse(rawResult.filecontent),'Rank').xmlText />    
				</cfcase>	
				
				<cfcase value="RankByCountry">
					<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'Country') />    
    					<cfset stResponse.result = [] />	

					<cfloop array="#dataResult#"	index="result">
						<cfset arrayAppend(stResponse.result,{
											Country=result.xmlAttributes.Code,
											Rank=getValue(result,'aws:Rank'),
											Contribution={
												PageView=result['aws:Contribution']['aws:PageViews'].xmlText,
												Users=result['aws:Contribution']['aws:Users'].xmlText
											}
										}) />
					</cfloop>
				</cfcase>	
				
				<cfcase value="RankByCity">
					<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'City') />    
    					<cfset stResponse.result = [] />	

					<cfloop array="#dataResult#"	index="result">
						<cfset arrayAppend(stResponse.result,{
											Name=result.xmlAttributes.Name,
											Code=result.xmlAttributes.Code,
											Rank=getValue(result,'aws:Rank'),
											Contribution={
												PageView=result['aws:Contribution']['aws:PageViews'].xmlText,
												Users=result['aws:Contribution']['aws:Users'].xmlText,
												PerUser=result['aws:Contribution']['aws:PerUser']['aws:AveragePageViews'].xmlText
											}
										}) />
					</cfloop>
				</cfcase>
				
				<cfcase value="UsageStats">
					<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'UsageStatistic') />    
    					<cfset stResponse.result = [] />
							
					<cfloop array="#dataResult#"	index="result">
						<cfset stResult = {
											TimeRange={
												Days='',
												Months=''
											},
											Rank={
												Value=result['aws:Rank']['aws:Value'].xmlText,
												Delta=result['aws:Rank']['aws:Delta'].xmlText
											},
											Reach={
												Rank={
													Value=result['aws:Reach']['aws:Rank']['aws:Value'].xmlText,
													Delta=result['aws:Reach']['aws:Rank']['aws:Delta'].xmlText
												},
												PerMillion={
													Value=result['aws:Reach']['aws:PerMillion']['aws:Value'].xmlText,
													Delta=result['aws:Reach']['aws:PerMillion']['aws:Delta'].xmlText
												}
											},
											PageViews={
												Rank={
													Value=result['aws:PageViews']['aws:Rank']['aws:Value'].xmlText,
													Delta=result['aws:PageViews']['aws:Rank']['aws:Delta'].xmlText
												},
												PerMillion={
													Value=result['aws:PageViews']['aws:PerMillion']['aws:Value'].xmlText,
													Delta=result['aws:PageViews']['aws:PerMillion']['aws:Delta'].xmlText
												},
												PerUser={
													Value=result['aws:PageViews']['aws:PerUser']['aws:Value'].xmlText,
													Delta=result['aws:PageViews']['aws:PerMillion']['aws:Delta'].xmlText
												}
											}
										} />
					<cfif structKeyExists(result['aws:TimeRange'],'aws:Months')>
						<cfset stResult.TimeRange.Months=result['aws:TimeRange']['aws:Months'].xmlText />
					</cfif>	
					<cfif structKeyExists(result['aws:TimeRange'],'aws:Days')>
						<cfset stResult.TimeRange.Days=result['aws:TimeRange']['aws:Days'].xmlText />
					</cfif>		
					
					<cfset arrayAppend(stResponse.result,stResult) />				
					</cfloop>
				</cfcase>	
				
				<cfcase value="ContactInfo">
					
					<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'ContactInfo')[1] />    
    					<cfset stResponse.result = [] />	

					<cfloop array="#dataResult#"	index="result">
						<cfset stResponse.result = {
											PhoneNumber=getValue(result['aws:PhoneNumbers'],'aws:PhoneNumber'),
											OwnerName=getValue(result,'aws:OwnerName'),
											Email=getValue(result,'aws:Email'),
											PhysicalAddress={
												City=getValue(result['aws:PhysicalAddress'],'aws:City'),
												Street=getValue(result['aws:PhysicalAddress']['aws:Streets'],'aws:Street'),
												State=getValue(result['aws:PhysicalAddress'],'aws:State'),
												PostalCode=getValue(result['aws:PhysicalAddress'],'aws:PostalCode'),
												Country=getValue(result['aws:PhysicalAddress'],'aws:Country')
											},
											CompanyStockTicker=getValue(result,'aws:CompanyStockTicker')
										} />
					</cfloop>
				</cfcase>		
				
				<cfcase value="AdultContent">
					<cfset stResponse.result = getResultNodes(xmlParse(rawResult.filecontent),'AdultContent')[1].xmlText />    
				</cfcase>	
				
				<cfcase value="Speed">
					<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'Speed')[1] />    

					<cfset stResponse.result = {
										MedianLoadTime=getValue(dataResult,'aws:MedianLoadTime'),
										Percentile=getValue(dataResult,'aws:Percentile')
									} />
				</cfcase>	
				
				<cfcase value="Language">
					<cfset stResponse.result = getResultNodes(xmlParse(rawResult.filecontent),'Language')[1].xmlText />    
				</cfcase>		
				
				<cfcase value="Keywords">
					<cfset stResponse.result = getResultNodes(xmlParse(rawResult.filecontent),'Keywords')[1].xmlText /> 
				</cfcase>	
				
				<cfcase value="OwnedDomains">
					<cfset stResponse.result = getResultNodes(xmlParse(rawResult.filecontent),'OwnedDomains')[1].xmlText /> 
				</cfcase>	
				
				<cfcase value="LinksInCount">
					<cfset stResponse.result = getResultNodes(xmlParse(rawResult.filecontent),'LinksInCount')[1].xmlText /> 
				</cfcase>	
				
				<cfcase value="SiteData">
					<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'SiteData')[1] />    

					<cfset stResponse.result = {
										Title=getValue(dataResult,'aws:Title'),
										Description=getValue(dataResult,'aws:Description'),
										OnlineSince=getValue(dataResult,'aws:OnlineSince')
									} />
				</cfcase>		
			</cfswitch>		   
    			    
    		</cfif>    
    		
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="TrafficHistory" access="public" returntype="Struct" >    
    		<cfargument name="fullURL" type="string" required="true" >    
    		<cfargument name="ResponseGroup" type="string" required="true" >  
		<cfargument name="Range" type="string" required="false" default="" > 
		<cfargument name="Start" type="string" required="false" default="" > 	  	  
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=TrafficHistory&Url=" & arguments.fullURL & "&ResponseGroup=" & arguments.ResponseGroup />
    		    
    		<cfif len(trim(arguments.Range))>    
    			<cfset body &= "&Range=" & trim(arguments.Range) />    
    		</cfif>	
    		
    		<cfif len(trim(arguments.Start))>    
    			<cfset body &= "&Start=" & trim(arguments.Start) />    
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'TrafficHistory')[1] />    
    			<cfset stResponse.result = {
					Range=getValue(dataResult,'aws:Range'),
					Site=getValue(dataResult,'aws:Site'),
					Start=getValue(dataResult,'aws:Start'),
					HistoricalData=[]
				} />	 
				
			<cfloop array="#dataResult['aws:HistoricalData'].xmlChildren#" index="data">
				<cfset arrayAppend(stResponse.result.HistoricalData,{
							Date=getValue(data,'aws:Date'),
							PageViews={
								PerMillion=getValue(data['aws:PageViews'],'aws:PerMillion'),
								PerUser=getValue(data['aws:PageViews'],'aws:PerUser')
							},
							Rank=getValue(data,'aws:Rank'),
							Reach={
								PerMillion=getValue(data['aws:Reach'],'aws:PerMillion')
							}
				}) />
			</cfloop>		
    			
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="CategoryBrowse" access="public" returntype="Struct" >    
    		<cfargument name="ResponseGroup" type="string" required="true" >    
    		<cfargument name="Path" type="string" required="true" > 
    		<cfargument name="Descriptions" type="string" required="false" default="" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=CategoryBrowse&ResponseGroup=" & trim(arguments.ResponseGroup) & "&Path=" & trim(arguments.Path)/>    
    		    
    		<cfif len(trim(arguments.Descriptions))>    
    			<cfset body &= "&Descriptions=" & trim(arguments.Descriptions) />    
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
			<cfswitch expression="#arguments.responseGroup#" >	
				<cfcase value="Categories,RelatedCategories,LanguageCategories" delimiters=",">
					<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'Category') />    
    					<cfset stResponse.result = [] />	 
    					
    					<cfloop array="#dataResult#" index="result">
						<cfset arrayAppend(stResponse.result,{
							Path=getValue(result,'aws:Path'),
							Title=getValue(result,'aws:Title'),
							SubCategoryCount=getValue(result,'aws:SubCategoryCount'),
							TotalListingCount=getValue(result,'aws:TotalListingCount')
						}) />		
					</cfloop>		
				</cfcase>	
				
				<cfcase value="LetterBars">
					<cfset stResponse.result = getResultNodes(xmlParse(rawResult.filecontent),'LetterBars')[1].xmlText />    
				</cfcase>		  
				  
			</cfswitch>	  
    			   
    	    
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="CategoryListings" access="public" returntype="Struct" >    
    		<cfargument name="Path" type="string" required="true" > 
    		<cfargument name="SortBy" type="string" required="false" default="" >    
    		<cfargument name="Recursive" type="string" required="false" default="" >    
    		<cfargument name="Start" type="string" required="false" default="" >    
    		<cfargument name="Count" type="string" required="false" default="" >    
    		<cfargument name="Descriptions" type="string" required="false" default="" >    
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=CategoryListings&ResponseGroup=Listings&Path=" & trim(arguments.Path)/>    
    		    
    		<cfif len(trim(arguments.SortBy))>    
    			<cfset body &= "&SortBy=" & trim(arguments.SortBy) />    
    		</cfif>	    
    		
    		<cfif len(trim(arguments.Recursive))>    
    			<cfset body &= "&Recursive=" & trim(arguments.Recursive) />    
    		</cfif>	
    		
    		<cfif len(trim(arguments.Start))>    
    			<cfset body &= "&Start=" & trim(arguments.Start) />    
    		</cfif>	
    		
    		<cfif len(trim(arguments.Count))>    
    			<cfset body &= "&Count=" & trim(arguments.Count) />    
    		</cfif>	
    		
    		<cfif len(trim(arguments.Descriptions))>    
    			<cfset body &= "&Descriptions=" & trim(arguments.Descriptions) />    
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'Listing') />    
    			<cfset stResponse.result = [] />	    
    	    
    	    		<cfloop array="#dataResult#" index="result">
				<cfset arrayAppend(stResponse.result,{
					DataUrl=getValue(result,'aws:DataUrl'),
					Title=getValue(result,'aws:Title'),
					PopularityRank=getValue(result,'aws:PopularityRank'),
					AverageReview=getValue(result,'aws:AverageReview')
				}) />
						
			</cfloop>			
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>

	<cffunction name="SitesLinkingIn" access="public" returntype="Struct" >    
    		<cfargument name="fullURL" type="string" required="true" >    
    		<cfargument name="Count" type="string" required="false" default="" > 
		<cfargument name="Start" type="string" required="false" default="" >   
    			    
    		<cfset var stResponse = createResponse() />    
    		<cfset var body = "Action=SitesLinkingIn&ResponseGroup=SitesLinkingIn&Url=" & trim(arguments.fullURL)/>    
    		    
    		<cfif len(trim(arguments.Count))>    
    			<cfset body &= "&Count=" & trim(arguments.Count) />    
    		</cfif>	
    		
    		<cfif len(trim(arguments.Start))>    
    			<cfset body &= "&Start=" & trim(arguments.Start) />    
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
    			<cfset dataResult = getResultNodes(xmlParse(rawResult.filecontent),'Site')/>    
    			<cfset stResponse.result = [] />	    
    	    
    	    		<cfloop array="#dataResult#" index="result">
				<cfset arrayAppend(stResponse.result,{
							Title=getValue(result,'aws:Title'),
							Uel=getValue(result,'aws:Url')
				})	/>	
			</cfloop>			
    		</cfif>    
    	    
    		<cfset stResponse.requestID = getResultNodes(xmlParse(rawResult.fileContent),'RequestId')[1].xmltext />    
    					    
    		<cfreturn stResponse />    
    	</cffunction>
</cfcomponent>