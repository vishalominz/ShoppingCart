<!---
  --- Database
  --- --------
  ---
  --- author: mindfire
  --- date:   3/10/17
  --- --------
  --- functions : 
  ---	registerUser : register new user(Customer)
  ---	retrieveUserInfo : gets user info by checking email and password
  --- 	retrieveSellerInfo : gets user info by checking emai and password a
  ---						 and company name
  --->
<cfcomponent accessors = "true" output = "false" persistent = "false">

<!--- registerUser() --->
	<cffunction name = "registerUser"
				access = "public"
				returntype = "numeric"
				hint="Writes user details in database for new user.">
		<cfargument name = "name" required = "true" type = "string"/>
		<cfargument name = "mobileNumber" required = "true" type = "numeric" />
		<cfargument name = "password" required = "true" type = "string" />
		<cfargument name = "email" required = "true" type = "string" />
		<cfargument name = "profilePicture" required = "false" default = "./assets/image/profile/default.jpg" />
		<cfset LOCAL.datetime  =  now()/>
		<cfquery result = "user">
			INSERT INTO [dbo].[Customer]
	           ([CustomerName]
	           ,[Email]
	           ,[MobileNumber]
	           ,[Password]
	           ,[LastModifiedDate]
	           ,[ProfilePicture])
    		 VALUES
	           (
	            <cfqueryparam  cfsqltype = "cf_sql_varchar" value="#ARGUMENTS.name#"/>
	           ,<cfqueryparam  cfsqltype = "cf_sql_varchar" value="#ARGUMENTS.email#"/>
	           ,<cfqueryparam  cfsqltype = "cf_sql_numeric" value="#ARGUMENTS.mobileNumber#"/>
	           ,<cfqueryparam  cfsqltype = "cf_sql_varchar" value="#ARGUMENTS.password#"/>
	           ,<cfqueryparam  cfsqltype = "cf_sql_timestamp" value="#LOCAL.datetime#"/>
	           ,<cfqueryparam  cfsqltype = "cf_sql_varchar" value="#ARGUMENTS.profilePicture#"/>
	           )
		</cfquery>
		<cfreturn user.GENERATEDKEY />
	</cffunction>


<!--- insert into seller --->
	<cffunction name = "insertIntoSeller"
				access="public"
				returntype="numeric"
				returnformat="json" >
			<cfargument name = "customerId"
						type="numeric"
						required="true" />
			<cfargument name = "sellingCompanyId"
						type="numeric"
						required = true />

			<cfquery result = "seller">
				INSERT INTO [dbo].[Seller]
			           ([CustomerId]
			           ,[SellingCompanyId])
			     VALUES
			           (
			           	<cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.customerId#" />
			           ,<cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.sellingCompanyId#"/>
			           )
			</cfquery>	
			<cfreturn seller.GENERATEDKEY />			
	</cffunction>

<!--- retrieveUserInfo() while login--->
	<cffunction name = "retrieveUserInfo"
				access = "public"
				return = "Any"
				returnformat = "json">
		<cfargument
			name = "email"
			type = "string"
			required = "true" />
		<cfargument
			name = "password"
			type = "string"
			required = "true" />

		<cfquery name = "userInfo">
			SELECT [CustomerId]
			      ,[CustomerName]
			      ,[Email]
			      ,[MobileNumber]
			      ,[Password]
			      ,[ProfilePicture]
			      ,[CustomerType]
			  FROM
			  		[dbo].[Customer]
			  WHERE
			  	[Email]  =  <cfqueryparam cfsqltype="cf_sql_varchar"
			  					value = "#ARGUMENTS.email#"/>
			  	and
			  	[Password]  = <cfqueryparam cfsqltype="cf_sql_varchar"
			  					value = "#ARGUMENTS.password#" />
		</cfquery>
		<cfreturn userInfo />
	</cffunction>

<!--- retrieveSellerInfo()  while login--->
	<cffunction name = "retrieveSellerInfo"
				access = "public"
				returnformat = "json"
				returntype = "any">

			<cfargument
				name = "email"
				type = "string"
				required = "true" />
			<cfargument
				name = "password"
				type = "string"
				required = "true" />
			<cfargument
				name = "company"
				type = "string"
				required = "true" />

			<cfquery name = "userInfo" result = "sqlinfo">
				SELECT c.[CustomerId]
			      ,c.[CustomerName]
			      ,c.[Email]
			      ,c.[MobileNumber]
			      ,c.[Password]
			      ,c.[ProfilePicture]
			      ,c.[CustomerType]
			      ,sc.[SellingCompanyId]
			  FROM
			  		[dbo].[Customer] as c
			  INNER JOIN
			  		[dbo].[Seller] as s
			  ON
			  		c.[CustomerId]  =  s.[CustomerId]
			  INNER JOIN
			  		[dbo].[SellingCompany] as sc
			  ON
			  		sc.[SellingCompanyId]  =  s.[sellingCompanyId]
			  WHERE
			  	c.[Email]  =  <cfqueryparam cfsqltype="cf_sql_varchar"
			  						value = "#ARGUMENTS.email#" />
			  	 AND
			  	c.[Password]  =  <cfqueryparam cfsqltype="cf_sql_varchar"
			  						value = "#ARGUMENTS.password#" />
			  	 AND
			  	UPPER(sc.[SellingCompanyName])  =  UPPER(<cfqueryparam cfsqltype="cf_sql_varchar"
			  						value = "#ARGUMENTS.company#" />)
			</cfquery>
			<cfreturn userInfo/>
	</cffunction>

<!--- retrieveUserInformation by Id --->
	<cffunction name = "retrieveUserInformation"
				access = "public"
				return = "Any"
				returnformat = "json">
		<cfargument
			name = "userId"
			required = "true" />

		<cfquery name = "userInformation">
			SELECT [CustomerId]
			      ,[CustomerName]
			      ,[Email]
			      ,[MobileNumber]
			      ,[Password]
			      ,[ProfilePicture]
			  FROM
			  		[dbo].[Customer]
			  WHERE
			  	[CustomerId]  =  <cfqueryparam cfsqltype = "cf_sql_integer"
			  									value = "#ARGUMENTS.userId#" />
		</cfquery>
		<cfreturn userInformation />
	</cffunction>

<!--- Fetch inventory items by productId and quantity form database --->
	<cffunction name = "retrieveFromInventory"
				access = "public"
				returntype = "query"
				returnformat = "json">
		<cfargument name = "productId" require = "true" type = "numeric" />
		<cfargument name = "quantity" require = "true" type = "numeric" />
		<cfargument name = "inventoryId" require = "ture" type="numeric" />
		<cfquery name = "result">
			SELECT  [InventoryId]
					,[SellingCompanyId]
      				,[ProductId],
					[AvailableQuantity]
      				,[SellingPrice]
      				,[DiscountPercent]
					,[SellingPrice]-([SellingPrice]*[DiscountPercent]/100) as DiscountPrice
 			 FROM MyShoppingZone.[dbo].[Inventory]
			 WHERE
			 	AvailableQuantity > =  <cfqueryparam cfsqltype = "cf_sql_integer"
			 										value = #ARGUMENTS.quantity# /> 
			 AND
			 	ProductId  = <cfqueryparam cfsqltype="cf_sql_integer"
			 								value = #ARGUMENTS.productId# />
			 AND
			 	InventoryId = <cfqueryparam cfsqltype="cf_sql_integer"
			 								value = #ARGUMENTS.inventoryId# />
			 ORDER BY
			 	DiscountPrice ASC,AvailableQuantity DESC;
		</cfquery>
		<cfreturn result />
	</cffunction>

<!---- retrieveProductFromInventoryByCompany ---->
	<cffunction name = "retrieveProductFromInventoryByCompany"
				access = "public"
				returnformat = "json"
				returntype = "any">
			<cfargument name = "sellingCompanyId"
						required = "true" />

			<cfquery name = "Products">
			  SELECT p.ProductId
			      ,p.[LeastPrice]
			      ,p.[ProductCategoryId]
			      ,p.[ProductName]
			      ,p.[ProductRating]
			      ,p.[ProductBrand]
			      ,p.[ProductImageLocation]
			      ,p.[ProductSubCategoryId]
			      ,p.[ProductDescription]
			      ,i.[AvailableQuantity]
			      ,i.[InventoryId]
			      ,i.[SellingPrice]
			      ,i.[DiscountPercent]
			      ,pc.[ProductCategory]
			      ,psc.[ProductSubCategoryName]
 			FROM
				[dbo].[Product] as p
			INNER JOIN
				[dbo].[Inventory] as i
			ON
				p.ProductId  =  i.ProductId
			INNER JOIN
				[dbo].[ProductCategory] as pc
			ON
				p.[productCategoryId]  =  pc.[productCategoryId]
			INNER JOIN
				[dbo].[ProductSubCategory] as psc
			ON
				psc.[ProductSubCategoryId]  =   p.[ProductSubCategoryId]
			WHERE
				i.[SellingCompanyId]  =  <cfqueryparam cfsqltype = "cf_sql_integer"
														value = "#sellingCompanyId#" />
			</cfquery>

			<cfreturn Products />
	</cffunction>

<!--- Retrieve Products from database --->
	<cffunction access = "public" name = "retrieveProducts" returntype = "Any">
		<cfargument name = "productId" require = "true" type = "numeric" />
		<cfargument name = "quantity" require = "true" type = "numeric" />
		<cfquery name = "result">
			SELECT TOP 10 p.ProductId
		      ,[LeastPrice]
		      ,[ProductCategoryId]
		      ,[ProductName]
		      ,[ProductRating]
		      ,[ProductBrand]
		      ,[ProductImageLocation]
		      ,[ProductSubCategoryId]
		      ,[ProductDescription]
		      ,[AvailableQuantity]
 			 FROM
				[dbo].[Product] as p
			INNER JOIN
				[dbo].[Inventory] as i
			ON
				p.ProductId  =  i.ProductId
			WHERE
				[AvailableQuantity] > 0
			 ORDER BY
			 	[ProductRating]
		</cfquery>
		<cfreturn result />
	</cffunction>

<!--- Retrieve Products category from database --->
	<cffunction access = "public" name = "retrieveProductCategory" retuntype = "Any">
		<cfquery name = "productCategory">
			SELECT
				ProductCategoryId,ProductCategory
			FROM
				dbo.ProductCategory
		</cfquery>

		<cfreturn productCategory/>
	</cffunction>

<!--- Retrieve Sub Products from Database --->
	<cffunction access = "public" name = "retrieveProductSubCategory" returntype = "Any">
		<cfargument
			name = "productCategoryId"
			required = "true"
			type = "numeric">

		<cfquery name = "productSubCategory">
			SELECT
				ProductSubCategoryId,ProductSubCategoryName
			FROM
				dbo.ProductSubCategory
			WHERE
				 ProductCategoryId  =  <cfqueryparam cfsqltype = "cf_sql_integer"
				             							value = "#ProductCategoryId#" />
		</cfquery>

		<cfreturn productSubCategory/>
	</cffunction>

<!--- Retrieve Products by sub category --->
	<cffunction access = "public" name = "retrieveProductBySubCategory" returntype = "Any">

		<cfargument
					name = "productSubCategoryId"
					type = "numeric"
					required = "true" />

		<cfquery name = "productBySubCategory">
			SELECT
				p.ProductId,
				ProductName,
				ProductBrand,
				ProductImageLocation,
				SellingPrice,
				DiscountPercent,
				[SellingPrice]-([SellingPrice]*ISNULL([DiscountPercent],0)/100) as DiscountPrice
			FROM
				Product p
			INNER JOIN
				Inventory i
			ON
				p.ProductId  =  i.ProductId
			WHERE
				productSubCategoryId  =  <cfqueryparam cfsqltype = "cf_sql_integer"
													value = "#productSubCategoryId#" />
		</cfquery>
		<cfreturn productBySubCategory />
	</cffunction>

<!--- Product Detail --->
	<cffunction access = "public" 
				name = "retrieveProductDetail" 
				returntype = "query">
		<cfargument
				name = "productId"
				type = "numeric"
				required = "true">

		<cfquery name = "productDetail">
			SELECT  i.[InventoryId]
			      ,i.[SellingCompanyId]
			      ,i.[ProductId]
			      ,i.[AvailableQuantity]
			      ,i.[SellingPrice]
			      ,i.[DiscountPercent]
				  ,p.[ProductName]
				  ,p.[ProductDescription]
				  ,p.[ProductBrand]
				  ,p.[productImageLocation]
				  ,sc.[SellingCompanyId]
				  ,sc.[SellingCompanyName]
			  FROM [dbo].[Inventory] as i
			  INNER JOIN
					[dbo].[product] as p
				ON
				 p.[productId] = i.[productId]
			  INNER JOIN
					[dbo].[SellingCompany] as sc
				ON
					sc.[SellingCompanyId] = i.[SellingCompanyId]
			  WHERE 
				i.[productId] = <cfqueryparam cfsqltype = "cf_sql_integer"
												value = "#productId#" />
				AND
				i.[AvailableQuantity] > 0
		</cfquery>
		<cfreturn productDetail/>
	</cffunction>

<!--- Insert Into Address --->
	<cffunction name = "insertIntoAddress"
			access = "public"
			returntype = "Any">
		<cfargument
			name = "customerId"
			required = "true" />
		<cfargument
			name = "addressLine1"
			required = "true" />
		<cfargument
			name = "addressLine2"
			required = "false"
			default = "" />
		<cfargument
			name = "city"
			required = "true" />
		<cfargument
			name = "state"
			required = "true" />
		<cfargument
			name = "addressType"
			required = "true"/>
		<cfargument
			name = "pincode"
			required = "true" />
		<cfset LOCAL.dateTime  =  now() />
		<cfquery result = "address">
		 INSERT INTO [dbo].[Address]
           ([CustomerId]
           ,[AddressLine1]
           ,[AddressLine2]
           ,[City]
           ,[State]
           ,[AddressType]
           ,[LastModifiedDate]
           ,[pincode]
           ,[isUsed])
    	 VALUES ( 
    	 	 <cfqueryparam cfsqltype = "cf_sql_integer" value = "#ARGUMENTS.customerId#" />
           , <cfqueryparam cfsqltype="cf_sql_varchar" value = "#ARGUMENTS.addressLine1#" />
           , <cfqueryparam cfsqltype="cf_sql_varchar" value = "#ARGUMENTS.addressLine2#" />
           , <cfqueryparam cfsqltype="cf_sql_varchar" value = "#ARGUMENTS.city#" />
           , <cfqueryparam cfsqltype="cf_sql_varchar" value = "#ARGUMENTS.state#" />
           , <cfqueryparam cfsqltype="cf_sql_varchar" value = "#ARGUMENTS.addressType#" />
           , <cfqueryparam cfsqltype="cf_sql_timestamp" value = "#LOCAL.dateTime#" />
           , <cfqueryparam cfsqltype="cf_sql_integer" value = "#ARGUMENTS.pincode#" />
           , <cfqueryparam cfsqltype="cf_sql_bit" value = false />
           )
		</cfquery>
		<cfreturn address.GENERATEDKEY />
	</cffunction>

<!--- update address --->
	<cffunction name = "updateAddress"
				access = "public"
			returntype = "Any">
		<cfargument 
			name = "addressId"
			required = "true"/>
		<cfargument
			name = "customerId"
			required = "true" />
		<cfargument
			name = "addressLine1"
			required = "true" />
		<cfargument
			name = "addressLine2"
			required = "false"
			default = "" />
		<cfargument
			name = "city"
			required = "true" />
		<cfargument
			name = "state"
			required = "true" />
		<cfargument
			name = "addressType"
			required = "true"/>
		<cfargument
			name = "pincode"
			required = "true" />
		<cfset LOCAL.dateTime  =  now() />
		<cfquery name = "address">
		 UPDATE [dbo].[Address]
		   SET [CustomerId]  = <cfqueryparam cfsqltype = "cf_sql_integer" 
		   										value = "#ARGUMENTS.customerId#" />
		      ,[AddressLine1]  =  <cfqueryparam cfsqltype="cf_sql_varchar" 
		      									value = "#ARGUMENTS.addressLine1#" />
		      ,[AddressLine2]  =  <cfqueryparam cfsqltype="cf_sql_varchar" 
		      									value = "#ARGUMENTS.addressLine2#" />
		      ,[City]  =  <cfqueryparam cfsqltype="cf_sql_varchar" 
		      							value = "#ARGUMENTS.city#" />
		      ,[State]  =  <cfqueryparam cfsqltype="cf_sql_varchar" 
		      							value = "#ARGUMENTS.state#" />
		      ,[AddressType]  =  <cfqueryparam cfsqltype="cf_sql_varchar" 
		      									value = "#ARGUMENTS.addressType#" />
		      ,[LastModifiedDate]  =  <cfqueryparam cfsqltype="cf_sql_timestamp"
		      										 value = "#LOCAL.dateTime#" />
		      ,[pincode]  =  <cfqueryparam cfsqltype="cf_sql_integer" 
		      								value = "#ARGUMENTS.pincode#" />
		 WHERE 
		 		[AddressId]  =  <cfqueryparam cfsqltype="cf_sql_integer"
		 										value = "#ARGUMENTS.addressId#" />
		 </cfquery>

	</cffunction>


<!--- retrieve from address --->
	<cffunction name = "retrieveAddress"
				access = "public"
				returnType = "any">
		<cfargument
				name = "customerId"
				required = "true">

		<cfquery name = "address">
			SELECT TOP 5 [AddressId]
			      ,[CustomerId]
			      ,[AddressLine1]
			      ,[AddressLine2]
			      ,[City]
			      ,[State]
			      ,[AddressType]
			      ,[LastModifiedDate]
			      ,[pincode]
			      ,[isUsed]
			  FROM [dbo].[Address]
			  WHERE
			  	[CustomerId]  =  <cfqueryparam cfsqltype="cf_sql_integer"
			  								value = "#ARGUMENTS.customerId#" />
			  ORDER BY
			  	[LastModifiedDate] DESC;
		</cfquery>
		<cfreturn address/>
	</cffunction>

<!--- removeAddress --->
	<cffunction name = "removeAddress"
				access = "public"
				returnformat = "json"
				returntype = "any">
			<cfargument name = "addressId"
						required = "true"/>

			<cfquery>

					DELETE FROM [dbo].[Address]
      				WHERE addressId  =  <cfqueryparam cfsqltype="cf_sql_integer"
      													value = "#ARGUMENTS.addressId#" />
      				AND <cfqueryparam cfsqltype="cf_sql_bit" value = false />
			</cfquery>
	</cffunction>

<!--- Insert Order into Order Table --->
	<cffunction	name = "insertOrder"
			access = "public" >

			<cfargument
					name = "customerId"
					required  =  "true" />
			<cfset LOCAL.todayDate  =  now() />
			<cfset LOCAL.currentDate  =  DateFormat(todayDate, "mm/dd/yyyy") />
			<cfset LOCAL.currentTime  =  TimeFormat(todayDate, "HH:nn") />

		<!--- insert order in database --->
			<cfquery result = "order">
				INSERT INTO [dbo].[Order]
			           ([CustomerId]
			           ,[OrderDate]
			           ,[OrderTime]
			           ,[LastModifiedDate])
			     VALUES
			           ( 
			           	<cfqueryparam cfsqltype="cf_sql_integer" value = "#ARGUMENTS.customerId#" />
			           , <cfqueryparam cfsqltype="cf_sql_date" value = "#LOCAL.currentDate#" />
			           , <cfqueryparam cfsqltype="cf_sql_time" value = "#LOCAL.currentTime#" />
			           , <cfqueryparam cfsqltype="cf_sql_timestamp" value = "#LOCAL.todayDate#" />
			           )
			</cfquery>
			<cfreturn order.GENERATEDKEY />
	</cffunction>


<!--- Retrieve order id by customer id from Order Table --->
	<cffunction	name = "retrieveOrderId"
			access = "public"
			hint  =  "get order id for a customer" >

			<cfargument
					name = "customerId"
					required = "true" />

			<cfquery name = "orderInfo">
				SELECT [OrderId]
				      ,[CustomerId]
				      ,[OrderDate]
				      ,[OrderTime]
				  FROM
				  	  [dbo].[Order]
				  WHERE
				  	  [CustomerId]  =  <cfqueryparam cfsqltype="cf_sql_integer" 
				  	  									value = "#ARGUMENTS.customerId#" />
				  ORDER BY
				  	  [OrderDate] DESC, [OrderTime] DESC

			</cfquery>
			<cfreturn orderInfo />
	 </cffunction>


<!--- insertOrderDetail into database --->
	<cffunction name = "insertOrderDetail"
			access = "public">

			<cfargument
					name = "orderId"
					required = "true" />
			<cfargument
					name = "productId"
					required = "true" />
			<cfargument
					name = "orderQuantity"
					required = "true" />
			<cfargument
					name = "shippingAddressId"
					required = "true" />
			<cfargument
					name = "sellingCompanyId"
					required = "true" />
			<cfargument
					name = "unitprice"
					required = "true" />
			<cfargument
					name = "discountPercent"
					required = "true" />
			<cfset LOCAL.datetime  =  now() />
		<!--- insert order detail in database --->
			<cfquery>
				INSERT INTO [dbo].[OrderDetail]
			           ([OrderId]
			           ,[ProductId]
			           ,[LastModifiedDate]
			           ,[OrderQuantity]
			           ,[ShippingAddressId]
			           ,[SellingCompanyId]
			           ,UnitPrice
			  			,DiscountPercent)
			     VALUES
			           (
			           	 <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.orderId#" />
			           , <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.productId#" />
			           , <cfqueryparam cfsqltype="cf_sql_timestamp" value = "#LOCAL.datetime#" />
			           , <cfqueryparam cfsqltype="cf_sql_integer" value= "#ARGUMENTS.orderQuantity#" />
			           , <cfqueryparam cfsqltype="cf_sql_integer" value = "#ARGUMENTS.shippingAddressId#" />
			           , <cfqueryparam cfsqltype="cf_sql_integer" value = "#ARGUMENTS.sellingCompanyId#" />
			           , <cfqueryparam cfsqltype="cf_sql_decimal" value = "#ARGUMENTS.unitprice#" />
			           , <cfqueryparam cfsqltype="cf_sql_tinyint" value = "#ARGUMENTS.discountPercent#" />
			           )
			</cfquery>
	</cffunction>



<!--- retrieve order details (items) by order id --->
	<cffunction	name = "retrieveOrderDetail"
			access = "public"
			hint = "get order detail by order id">

			<cfargument
				name = "orderId"
				required = "true" />

			<cfquery name = "orderDetail">
				SELECT [OrderDetailId]
					      ,[OrderId]
					      ,[Product]
					      ,[OrderQuantity]
					      ,[ShippingAddressId]
					      ,[sellingCompanyId]
				FROM
					  	[dbo].[OrderDetail]
				WHERE
						[OrderId]  =  <cfqueryparam cfsqltype="cf_sql_integer"
													value = "#ARGUMENTS.orderId#" />
			</cfquery>

			<cfreturn orderDetail />
	</cffunction>


<!--- update inventory table to set availableQuantity --->
	<cffunction name = "updateAvailableQuantity"
			access = "public"
			returntype = "Any">
		<cfargument
				name = "availableQuantity"
				required = "true" />
		<cfargument
				name = "sellingCompanyId"
				required = "true" />
		<cfargument
				name = "productId"
				required = "true" />
		<cfquery name = "itemQuantity">
				UPDATE
					[dbo].[Inventory]
			   	SET
			     	[AvailableQuantity]  =  <cfqueryparam cfsqltype = "cf_sql_integer"
			     											value = "#ARGUMENTS.availableQuantity#" />
				WHERE
				 	[SellingCompanyId]  =  <cfqueryparam cfsqltype="cf_sql_integer"
				 											value = "#ARGUMENTS.sellingCompanyId#" />
			      	AND 
			      	[ProductId]  =  <cfqueryparam cfsqltype = "cf_sql_integer"
			      										value = "#ARGUMENTS.productId#" />
		</cfquery>
	</cffunction>


<!--- search by name --->
	<cffunction name = "searchProduct"
				access = "public"
				returntype = "any" >
			<cfargument name = "searchItem"
					required = "true" />
			<cfargument name = "brandList" 
					required = "true"/>
			<cfargument name = "minPrice" 
					required = "true" />
			<cfargument name = "maxPrice" 
					required = "true" />
			<cfset session.database  =  brandList />
			<cfif ARGUMENTS.brandList eq "">
				<cfquery name = "searchResult">
					SELECT
					p.ProductId as ProductId,
					ProductName,
					ProductBrand,
					ProductImageLocation,
					SellingPrice,
					DiscountPercent,
					AvailableQuantity,
					[SellingPrice]-([SellingPrice]*ISNULL([DiscountPercent],0)/100) as DiscountPrice
					FROM
						Product p
					INNER JOIN
						Inventory i
					ON
						p.ProductId  =  i.ProductId
					WHERE
						ProductName LIKE '%#searchItem#%'
						AND
						AvailableQuantity > 0
						AND
						[SellingPrice]-([SellingPrice]*ISNULL([DiscountPercent],0)/100) > =  
							<cfqueryparam cfsqltype = "cf_sql_decimal" value = "#ARGUMENTS.minPrice#" />
						AND
						[SellingPrice]-([SellingPrice]*ISNULL([DiscountPercent],0)/100) < =  
							<cfqueryparam cfsqltype = "cf_sql_decimal" value = "#ARGUMENTS.maxPrice#" />
				</cfquery>
			<cfelse>
				<cfquery name = "searchResult">
					SELECT
					p.ProductId as ProductId,
					ProductName,
					ProductBrand,
					ProductImageLocation,
					SellingPrice,
					DiscountPercent,
					AvailableQuantity,
					[SellingPrice]-([SellingPrice]*ISNULL([DiscountPercent],0)/100) as DiscountPrice
					FROM
						Product p
					INNER JOIN
						Inventory i
					ON
						p.ProductId  =  i.ProductId
					WHERE
						ProductName 
							LIKE 
							<cfqueryparam cfsqltype="cf_sql_varchar" value = "%#searchItem#%" />
						AND
						AvailableQuantity > 0
						AND
						[SellingPrice]-([SellingPrice]*ISNULL([DiscountPercent],0)/100) > =  
							<cfqueryparam cfsqltype = "cf_sql_decimal" value = "#ARGUMENTS.minPrice#" />
						AND
						[SellingPrice]-([SellingPrice]*ISNULL([DiscountPercent],0)/100) < =  
							<cfqueryparam cfsqltype = "cf_sql_decimal" value = "#ARGUMENTS.maxPrice#" />
						AND
						ProductBrand 
							IN 
							(
								<cfqueryparam cfsqltype="cf_sql_varchar" value = "#ARGUMENTS.brandList#" 
											list="true" />
							)
				</cfquery>
			</cfif>
			<cfreturn searchResult />
	</cffunction>

<!--- insertCart --->
	<cffunction name = "insertCart"
			access = "public"
			returntype = "any"
			returnformat = "json">

			<cfargument name = "customerId"
				required = "true" />

			<cfquery result="cart">
				INSERT INTO [dbo].[Cart]
			           ([CustomerId])
			     VALUES
			           (
			           	<cfqueryparam cfsqltype="cf_sql_integer" value ="#customerId#" />
			           )
			</cfquery>
			<cfreturn cart.GENERATEDKEY />
	</cffunction>

<!--- retrieveCart --->
	<cffunction name = "retrieveCart"
			access = "public"
			returntype = "any"
			returnformat = "JSON">

			<cfargument name = "customerId"
					required = "true" />

			<cfquery name = "cart">
				  SELECT [CartId]
				      ,[CustomerId]
				  FROM [dbo].[Cart]
				  WHERE
				  		[CustomerId]  =  <cfqueryparam cfsqltype="cf_sql_integer"
				  										value="#ARGUMENTS.customerId#" />
			</cfquery>
			<cfreturn cart />
	</cffunction>

<!--- delete from cart --->
	<cffunction name = "removeCart"
			access = "public"
			returntype = "any"
			returnformat = "json">

			<cfargument name = "customerId"
					required = "true" />

			<cfquery name = "cart">
				DELETE
				FROM [dbo].[Cart]
      			WHERE
					[CustomerId]  =  <cfqueryparam cfsqltype="cf_sql_integer"
													value="#ARGUMENTS.customerId#" />
			</cfquery>
	</cffunction>

<!--- insertCartDetail --->
	<cffunction name = "insertCartDetail"
			access = "public"
			returntype = "any"
			returnformat = "json">

			<cfargument name = "cartId"
					required = "true" />
			<cfargument name = "inventoryId"
					required = "true" />
			<cfargument name = "quantity"
					required = "true" />
			<cfset LOCAL.datetime  =  now() />

			<cfquery name = "cartItems">
				INSERT INTO [dbo].[CartItem]
			           ([CartId]
			           ,[InventoryId]
			           ,[Quantiy]
			           ,[LastModifiedDate])
			     VALUES
			           (
			           	<cfqueryparam cfsqltype="cf_sql_integer" value = "#ARGUMENTS.cartId#" />
			           ,<cfqueryparam cfsqltype="cf_sql_integer" value = "#ARGUMENTS.inventoryId#" />
			           ,<cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.quantity#" />
			           ,<cfqueryparam cfsqltype="cf_sql_timestamp" value = "#LOCAL.datetime#" />
			           )
			</cfquery>
	</cffunction>

<!--- retrieveCartDetail --->
	<cffunction name = "retrieveCartDetail"
			access = "public"
			returnformat = "json"
			returntype = "any">

			<cfargument name = "cartId"
					required = "true" />

			<cfquery name = "cartItems">
					SELECT [CartItemId]
				      ,[CartId]
				      ,[InventoryId]
				      ,[Quantiy]
				      ,[LastModifiedDate]
				    FROM [dbo].[CartItem]
				    WHERE
				  		[CartId]  = <cfqueryparam cfsqltype="cf_sql_integer"
				  									value = "#ARGUMENTS.cartId#" />
			</cfquery>
			<cfreturn cartItems />
	</cffunction>

<!--- delete from cart Detail--->
	<cffunction name = "removeCartDetail"
			access = "public"
			returntype = "any"
			returnformat = "json">

			<cfargument name = "cartId"
					required = "true" />

			<cfquery name = "cartDetail">
				DELETE
				FROM [dbo].[CartItem]
	      		WHERE
	      			[CartId]  =  <cfqueryparam cfsqltype="cf_sql_integer"
	      										value="#ARGUMENTS.cartId#" />
			</cfquery>
	</cffunction>

<!--- retrieveCartItemDetail --->
	<cffunction name = "retrieveCartItemDetail"
				access = "public"
				returnformat = "json"
				returntype = "any">

				<cfargument name = "cartId"
						required = "true" />

				<cfquery name = "CartItemDetail">
					SELECT
						   c.[InventoryId]
					      ,c.[Quantiy]
						  ,i.[SellingCompanyId]
					      ,i.[ProductId]
					      ,i.[AvailableQuantity]
					      ,i.[SellingPrice]
					      ,i.[DiscountPercent]
					      ,p.[ProductName]
					      ,p.[ProductBrand]
					      ,p.[ProductImageLocation]
					      ,p.[ProductDescription]
					  FROM
						[dbo].[CartItem] as c
					  INNER JOIN
						[dbo].[Inventory] as i
					  ON
						c.[InventoryId]  =  i.[InventoryId]
					  INNER JOIN
						[dbo].[Product] as p
					  ON
						p.[ProductId]  =  i.[ProductId]
					  WHERE
						c.[CartId]  =  <cfqueryparam cfsqltype="cf_sql_integer"
													value= "#ARGUMENTS.cartId#" />
				</cfquery>

				<cfreturn CartItemDetail />
		</cffunction>

<!--- retrieveOrderDetails --->
	<cffunction name = "retrieveOrderDetails"
			access = "public"
			returnformat = "json"
			returntype="query">

			<cfargument name = "userId"
					required = "true" />
			<cfargument name = "orderId"
					required = "true" />
			<cfargument name = "sellingCompanyId"
					required = "true"/>

			<cfquery name = "OrderDetails" result = "order">

				SELECT [OrderDetailId]
				      ,od.[OrderId]
				      ,od.[ProductId]
				      ,od.[OrderQuantity]
				      ,od.[ShippingAddressId]
				      ,od.[SellingCompanyId]
				      ,od.[UnitPrice]
				      ,od.[DiscountPercent]
					  ,o.[OrderDate]
					  ,o.[OrderTime]
					  ,a.[AddressLine1]
					  ,a.[AddressLine2]
					  ,a.[City]
				      ,a.[State]
				      ,a.[AddressType]
				      ,a.[pincode]
					  ,p.[ProductCategoryId]
				      ,p.[ProductName]
				      ,p.[ProductRating]
				      ,p.[ProductBrand]
				      ,p.[ProductImageLocation]
				      ,p.[ProductSubCategoryId]
				      ,p.[ProductDescription]
				      ,sc.[SellingCompanyName]
				  FROM [dbo].[OrderDetail] od
				  INNER JOIN
					[dbo].[Order] o
				  ON
					o.[orderId]  =  od.[OrderId]
				  INNER JOIN
					[dbo].[Address] a
				  ON
					od.[ShippingAddressId] =  a.[AddressId]
				  INNER JOIN
				    [dbo].[Product] p
				  ON
					p.[ProductId]  =  od.[ProductId]
				  INNER JOIN
					[dbo].[SellingCompany] sc
				  ON
					sc.[SellingCompanyId]  =  od.[SellingCompanyId]
				  where
					o.[OrderId] =   #ARGUMENTS.orderId#
					AND
					od.[SellingCompanyId]  =  #ARGUMENTS.sellingCompanyId#
					AND
					o.[CustomerId]  = #ARGUMENTS.userId#
				 ORDER BY
					OrderDate Desc,OrderTime Desc
			</cfquery>
			<cfset session.database = order.SQL />
			<cfreturn OrderDetails />
	</cffunction>

<!--- retrieveSellingCompanyForOrder --->
	<cffunction name = "retrieveSellingCompanyForOrder"
			access = "public"
			returnformat = "json"
			returntype = "query">

			<cfargument name = "orderId"
					required = "true" />

			<cfquery name = "sellingCompany">
				SELECT 
					DISTINCT [SellingCompanyId]
				  FROM [dbo].[OrderDetail]
				  WHERE
					OrderId  =  <cfqueryparam cfsqltype="cf_sql_integer"
												value="#ARGUMENTS.orderId#" />
			</cfquery>
			<cfreturn sellingCompany />
	</cffunction>

<!--- retrieveOrderHistory --->
	<cffunction name = "retrieveOrderHistory"
				access = "public"
				returnformat = "json"
				returntype = "query">

			<cfargument name = "userId"
						required = "true" />

			<cfquery name = "orderDetail">
				  SELECT [OrderId]
				      ,[CustomerId]
				      ,[OrderDate]
				      ,[OrderTime]
				      ,ISNULL([Total],0) as Total
				      ,[LastModifiedDate]
				  FROM [dbo].[Order]
				  WHERE
				  	CustomerId = <cfqueryparam cfsqltype="cf_sql_integer"
				  					value="#ARGUMENTS.userId#" />
			</cfquery>

			<cfreturn orderDetail />
	</cffunction>

<!--- retrieveOrderHistoryDetail --->
	<cffunction name = "retrieveOrderHistoryDetail"
				access = "public"
				returnformat = "json"
				returntype = "query">

		<cfargument name = "orderId"
				required = "true" />

		<cfquery name = "orderDetail">
			SELECT od.[OrderDetailId]
			      ,od.[OrderId]
			      ,od.[ProductId]
			      ,od.[OrderQuantity]
			      ,od.[ShippingAddressId]
			      ,od.[SellingCompanyId]
			      ,od.[UnitPrice]
			      ,od.[DiscountPercent]
			      ,p.[ProductCategoryId]
			      ,p.[ProductName]
			      ,p.[ProductRating]
			      ,p.[ProductBrand]
			      ,p.[ProductImageLocation]
			      ,p.[ProductSubCategoryId]
			      ,p.[ProductDescription]
			  FROM [dbo].[OrderDetail] od
			  INNER JOIN
			  		[dbo].[Product] p
			  ON
			   p.[productId]  =  od.[productId]
			  WHERE
			  	OrderId  =  <cfqueryparam cfsqltype="cf_sql_integer"
			  								value="#ARGUMENTS.orderId#" />
		</cfquery>
		<cfreturn orderDetail />
	</cffunction>

<!--- updateUserProfilePicture --->
	<cffunction name = "updateUserProfilePicture"
				access = "public"
				returnformat = "json"
				returntype = "any">

			<cfargument name = "pictureLocation"
					required = "true"/>
			<cfargument name = "userId"
					required = "true"/>
			<cfquery name = "profilePicture">
					 UPDATE [dbo].[Customer]
					 SET
					 	[ProfilePicture]  = <cfqueryparam cfsqltype="cf_sql_varchar"
					 							value = "#ARGUMENTS.pictureLocation#" />
					 WHERE
						[CustomerId]  =  <cfqueryparam cfsqltype="cf_sql_integer"
												value="#ARGUMENTS.userId#" />
			</cfquery>
	</cffunction>

<!--- insertProduct --->
	<cffunction name = "insertProduct"
				access = "public"
				returnformat = "json"
				returntype = "numeric">
			<cfargument name = "productName"
						required  = "true"/>
			<cfargument name = "productCategoryId"
						required  =  "true"/>
			<cfargument name = "productSubCategoryId"
						required  =  "true"/>
			<cfargument name = "productBrand"
						required = "true"/>
			<cfargument name = "productDescription"
						required = "false"
						default = "" />
			<cfargument name = "productImageLocation"
						required = "false"
						default = "assets/images/product/default.jpg"/>
			<cfargument name = "leastPrice"
						required = "false"
						default = 0/>
			<cfset LOCAL.lastModifiedDate  =  now() />
			<cfquery result = "product">
				INSERT INTO [dbo].[Product]
		           ([LeastPrice]
		           ,[ProductCategoryId]
		           ,[ProductName]
		           ,[ProductBrand]
		           ,[LastModifiedDate]
		           ,[ProductImageLocation]
		           ,[ProductSubCategoryId]
		           ,[ProductDescription])
		     	VALUES
		           (
		           	<cfqueryparam cfsqltype="cf_sql_integer"
		           					value="#ARGUMENTS.leastPrice#" />
       	           ,<cfqueryparam cfsqltype="cf_sql_integer"
       	            				value="#ARGUMENTS.productCategoryId#" />
		           ,<cfqueryparam cfsqltype="cf_sql_varchar"
		           					value="#ARGUMENTS.productName#" />
		           ,<cfqueryparam cfsqltype="cf_sql_varchar"
		           					value="#ARGUMENTS.productBrand#" />
		           ,<cfqueryparam cfsqltype="cf_sql_timestamp"
		           					value="#LOCAL.lastModifiedDate#" />
		           ,<cfqueryparam cfsqltype="cf_sql_varchar"
		           					value="#ARGUMENTS.productImageLocation#" />
		           ,<cfqueryparam cfsqltype="cf_sql_integer"
		           					value="#ARGUMENTS.productSubCategoryId#" />
		           ,<cfqueryparam cfsqltype="cf_sql_varchar"
		           					value="#ARGUMENTS.productDescription#" />
		           )
		</cfquery>
		<cfquery result = "productId">
			UPDATE [dbo].[Product]
   			SET
				[ProductImageLocation]  =  
					<cfqueryparam cfsqltype="cf_sql_varchar"
									value="#ARGUMENTS.productImageLocation##product.GENERATEDKEY#" />
			WHERE 
				[ProductId]  =  
					<cfqueryparam cfsqltype="cf_sql_integer"
									value="#product.GENERATEDKEY#" />
		</cfquery>
		<cfreturn product.GENERATEDKEY />
	</cffunction>

<!--- deleteProductFromInventory --->
	<cffunction name = "deleteProductFromInventory"
				access = "public"
				returnformat = "json"
				returntype="void">
			<cfargument name = "inventoryId"
						required = "true"/>
			<cfquery>
				DELETE 
				FROM [dbo].[Inventory]
      			WHERE
      				InventoryId  = 
      					 <cfqueryparam cfsqltype="cf_sql_integer"
      									value="#ARGUMENTS.inventoryId#" />
			</cfquery>				
	</cffunction>

<!---- updateProductInInventory --->
	<cffunction name = "updateProductInInventory"
				access = "public"
				returntype = "void"
				returnformat = "json">
					
			<cfargument name = "sellingPrice"
						required = "true" />
			<cfargument name = "quantity"
						required = "true" />
			<cfargument name = "discount"
						required = "true" />	
			<cfargument name = "inventoryId"
						required = "true" />	
			<cfset LOCAL.lastModifiedDate  =  now() />
			<cfquery name = "updateInventory">
				UPDATE 
					[dbo].[Inventory]
   				SET    
   					[AvailableQuantity]  = 
   						<cfqueryparam cfsqltype="cf_sql_integer"
   										value="#ARGUMENTS.quantity#" />
				   ,[SellingPrice]  =  
				   		<cfqueryparam cfsqltype="cf_sql_decimal"
				   						value="#ARGUMENTS.sellingPrice#" />
				   ,[DiscountPercent]  =  
				   		<cfqueryparam cfsqltype="cf_sql_tinyint"
				   						value="#ARGUMENTS.discount#" />
				   ,[LastModifiedDate]  =  
				   		<cfqueryparam cfsqltype="cf_sql_timestamp"
				   						value="#LOCAL.lastModifiedDate#" />
				WHERE 
				 	[inventoryId]  =  
				 		<cfqueryparam cfsqltype="cf_sql_integer"
				 						value="#ARGUMENTS.inventoryId#" />
			</cfquery>
	</cffunction>

<!---- insertProductInInventory --->
	<cffunction name = "insertProductInInventory"
				access = "public"
				returntype = "numeric"
				returnformat = "json">
		
		<cfargument name = "sellingCompanyId"
					required = "true" />
		<cfargument name = "productId"
					required = "true" />
		<cfargument name = "availableQuantity"
					required = "true" />
		<cfargument name = "sellingPrice"
					required = "true" />
		<cfargument name = "discount"
					required = "true" />
		<cfset LOCAL.lastModifiedDate  =  now() />
		<cfquery result = "inventoryItem">
			INSERT INTO [dbo].[Inventory]
		           ([SellingCompanyId]
		           ,[ProductId]
		           ,[AvailableQuantity]
		           ,[SellingPrice]
		           ,[DiscountPercent]
		           ,[LastModifiedDate])
		     VALUES
	           (
	           	<cfqueryparam cfsqltype="cf_sql_integer"
	           					value="#ARGUMENTS.sellingCompanyId#" />
	           ,<cfqueryparam cfsqltype="cf_sql_integer"
	           					value="#ARGUMENTS.productId#" />
	           ,<cfqueryparam cfsqltype="cf_sql_integer"
	           					value="#ARGUMENTS.availableQuantity#" />
	           ,<cfqueryparam cfsqltype="cf_sql_decimal"
	           					value="#ARGUMENTS.sellingPrice#" />
	           ,<cfqueryparam cfsqltype="cf_sql_tinyint"
	           					value="#ARGUMENTS.discount#" />
	           ,<cfqueryparam cfsqltype="cf_sql_timestamp"
	           					value="#LOCAL.lastModifiedDate#" />
	           	)
		</cfquery>
		<cfreturn inventoryItem.GENERATEDKEY />
	</cffunction>

<!--- insertProductSubCategory --->
	<cffunction name  =  "insertProductSubCategory"
			access  =  "public"
			returntype  =  "any"
			returnformat  =  "json">
		<cfargument name  =  "categoryId"
					required  =  true />
		<cfargument name  =  "subCategoryName"	
					required  =  true />
		<cfquery result = "productSubCategory">
			INSERT INTO [dbo].[ProductSubCategory]
		           ([ProductSubCategoryName]
		           ,[ProductCategoryId])
		     VALUES
		        (
		         <cfqueryparam cfsqltype="cf_sql_varchar"
		        				value="#ARGUMENTS.subCategoryName#" />
		        ,<cfqueryparam cfsqltype="cf_sql_integer"
		        				value="#ARGUMENTS.categoryId#" />
		        )
		</cfquery>
		<cfreturn productSubCategory.GENERATEDKEY />
	</cffunction>

<!---- insertProductCategory --->
	<cffunction name = "insertProductCategory"
				access = "public"
				returntype = "numeric"
				returnformat = "json">
		<cfargument name = "categoryName"
					required = "true" />	
		<cfquery result = "category">
			INSERT INTO [dbo].[ProductCategory]
		           ([ProductCategory])
		     VALUES
		        (
		        <cfqueryparam cfsqltype="cf_sql_varchar"
		        				value="#ARGUMENTS.categoryName#" />
		        )
		</cfquery>
		<cfreturn category.GENERATEDKEY />		
	</cffunction>

<!---- sellerSearchProducts --->
	<cffunction name = "sellerSearchProducts"
				access = "public"
				returnformat = "json"
				returntype = "query">
			<cfargument name = "searchValue"
					required = "true" />
			
			<cfquery name = "products">
				SELECT p.[ProductId]
			      ,p.[LeastPrice]
			      ,p.[ProductCategoryId]
			      ,p.[ProductName]
			      ,p.[ProductRating]
			      ,p.[ProductBrand]
			      ,p.[LastModifiedDate]
			      ,p.[ProductImageLocation]
			      ,p.[ProductSubCategoryId]
			      ,p.[ProductDescription]
				  ,i.[SellingCompanyId]
				  ,i.[InventoryId]
			      ,i.[AvailableQuantity]
			      ,i.[SellingPrice]
			      ,i.[DiscountPercent]
			      ,pc.[ProductCategory]
	  			  ,psc.[ProductSubCategoryName]
			  FROM [dbo].[Product] p
			  LEFT OUTER JOIN
			  [dbo].[Inventory] i
			  ON
				p.[ProductId]  =  i.[ProductId]
			  INNER JOIN
				[dbo].[ProductCategory] pc
			  ON
				pc.[ProductCategoryId]  =  p.[ProductCategoryId]
			  INNER JOIN
				[dbo].[ProductSubCategory] psc
			  ON
				psc.[ProductSubCategoryId]  =  p.[ProductSubCategoryId]
			  WHERE
				p.[ProductName] 
				LIKE 
					<cfqueryparam cfsqltype="cf_sql_varchar"
									value="%#ARGUMENTS.searchValue#%" /> 
			</cfquery>
			<cfreturn products />					

	</cffunction>

<!--- retrieveBrandNames --->
	<cffunction name = "retrieveBrandNames"
				access = "public"
				returnformat = "json"
				returntype = "query">
			
			<cfquery name = "brands">
				SELECT DISTINCT [ProductBrand]
  				FROM [dbo].[Product]
			</cfquery>		
			<cfreturn brands />		
	</cffunction>

<!--- retrieve Sale Detail --->
	<cffunction name = "retreiveSaleDetail"
				access = "public"
				returnformat = "json"
				returntype = "query">
			<cfargument name = "sellingCompanyId"
						required = "true" />
			<cfargument name = "productList"
						required = "true" />
			<cfargument name = "saleDate"
						required = "false"
						default = "" />
			<cfquery name = "productSale">
				SELECT
					od.[ProductId],
					SUM(od.[OrderQuantity]) as TotalSale,
					CONVERT(DATE,od.[LastModifiedDate]) as SaleDate,
					p.[ProductName]
				FROM [MyShoppingZone].[dbo].[Order] o
				INNER JOIN 
						[MyShoppingZone].[dbo].[OrderDetail] od
				ON
					o.[OrderId]  =  od.[OrderId]
				INNER JOIN
						[MyShoppingZone].[dbo].[Product] p
				ON
					p.[ProductId]  =  od.[ProductId]
				WHERE 
					od.[SellingCompanyId] =  
						<cfqueryparam cfsqltype="cf_sql_integer"
										value="#ARGUMENTS.sellingCompanyId#" />
					AND
					od.[ProductId] 
						IN (
							<cfqueryparam cfsqltype="cf_sql_integer"
										value="#ARGUMENTS.productList#"
										list="true" />
							)
					AND
					CONVERT(DATE,od.[LastModifiedDate])  =  
						<cfqueryparam cfsqltype="cf_sql_date"
										value="#ARGUMENTS.saleDate#" />
				GROUP BY 
					CONVERT(DATE,od.[LastModifiedDate]),
					od.[ProductId],p.[productName]
				ORDER BY
					TotalSale DESC
			</cfquery>	
			<cfreturn productSale />			
	</cffunction>


<!-- retrieve selling company id by name --->
	<cffunction name = "retrieveSellingCompany"
				access = "public"
				returnformat = "json"
				returntype = "query">
			<cfargument name="companyName"
						required="true"
						type="string" /> 
			<cfquery name = "companyDetail">
				SELECT [SellingCompanyId]
				      ,[SellingCompanyName]
				      ,[LastModifiedDate]
				      ,[ShippingCompanyId]
				  FROM [dbo].[SellingCompany]
				  WHERE 
				  	UPPER([SellingCompanyName]) = 
				  		UPPER(<cfqueryparam cfsqltype="cf_sql_varchar" 
				  					value="#ARGUMENTS.companyName#" />)

			</cfquery>		
			<cfreturn companyDetail />		
	</cffunction>


<!---- insert selling company ---->
	<cffunction name="insertSellingCompany"
				access="public"
				returntype="numeric"
				returnformat="json">
		<cfargument name="sellingCompanyName"
					required="true" />
		<!--- <cfargument name="shippingCompanyId"
					required="true" /> --->

		<cfquery result="sellingCompany">
			INSERT INTO [dbo].[SellingCompany]
		           ([SellingCompanyName]
		           ,[LastModifiedDate])
		     VALUES
		           (
		           	<cfqueryparam cfsqltype="cf_sql_varchar" 
		           					value="#ARGUMENTS.sellingCompanyName#" />
		           ,<cfqueryparam cfsqltype="cf_sql_timestamp" 
		           					value="#now()#" />
		          	)
		</cfquery>
		<cfreturn sellingCompany.GENERATEDKEY />
	</cffunction>


<!--- retrieve PopularSoldProducts --->
	<cffunction name = "retrieveMostSoldProducts"
				access = "public"
				returnformat = "json"
				returntype = "query">
					
			<cfargument name = "sellingCompanyId"
						required = "true" />
			<cfquery name = "popularProducts">
				SELECT TOP 10
					od.[ProductId],
					SUM(od.OrderQuantity) as TotalSale,
					CONVERT(DATE,od.[LastModifiedDate]) as SaleDate,
					p.[ProductName]
				  FROM [MyShoppingZone].[dbo].[Order] o
				  INNER JOIN 
						[MyShoppingZone].[dbo].[OrderDetail] od
				 ON
					o.[OrderId]  =  od.[OrderId]
				 INNER JOIN
					[MyShoppingZone].[dbo].[Product] p
				 ON
					p.[ProductId]  =  od.[ProductId]
				 WHERE 
					od.[SellingCompanyId]  =  
						<cfqueryparam cfsqltype="cf_sql_integer"
										value="#ARGUMENTS.sellingCompanyId#" />
				 GROUP BY 
					CONVERT(DATE,od.[LastModifiedDate]),
					od.[ProductId],p.[productName]
				ORDER BY
					TotalSale DESC
			</cfquery>

			<cfreturn popularProducts/>
	</cffunction>

</cfcomponent>





