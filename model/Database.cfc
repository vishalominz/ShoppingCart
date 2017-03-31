<!---
  --- database
  --- --------
  ---
  --- author: mindfire
  --- date:   3/10/17
  --->
<cfcomponent accessors="true" output="false" persistent="false">

<!--- registerUser() --->
	<cffunction name="registerUser"
				access="public"
				returntype="any">
		<cfargument name="name" required="true" type="string"/>
		<cfargument name="mobileNumber" required="true" type="numeric" />
		<cfargument name="password" required="true" type="string" />
		<cfargument name="email" required="true" type="string" />
		<cfargument name="profilePicture" required="false" default="./assets/image/profile/default.jpg" />
		<cfset datetime = now()/>
		<cfquery>
			INSERT INTO [dbo].[Customer]
	           ([CustomerName]
	           ,[Email]
	           ,[MobileNumber]
	           ,[Password]
	           ,[LastModifiedDate]
	           ,[ProfilePicture])
    		 VALUES
	           	( '#ARGUMENTS.name#'
	           ,'#ARGUMENTS.email#'
	           , #ARGUMENTS.mobileNumber#
	           ,'#ARGUMENTS.password#'
	           ,#datetime#
	           ,'#profilePicture#')
		</cfquery>
	</cffunction>


<!--- retrieveUserInfo() while login--->
	<cffunction name="retrieveUserInfo"
				access="public"
				return="Any"
				returnformat="json">
		<cfargument
			name="email"
			type="string"
			required="true" />
		<cfargument
			name="password"
			type="string"
			required="true" />

		<cfquery name="userInfo">
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
			  	[Email] = '#ARGUMENTS.email#' AND
			  	[Password] = '#ARGUMENTS.password#'
		</cfquery>
		<cfreturn userInfo />
	</cffunction>

<!--- retrieveSellerInfo()  while login--->
	<cffunction name="retrieveSellerInfo"
				access="public"
				returnformat="json"
				returntype="any">

			<cfargument
				name="email"
				type="string"
				required="true" />
			<cfargument
				name="password"
				type="string"
				required="true" />
			<cfargument
				name="company"
				type="string"
				required="true" />

			<cfquery name="userInfo" result="sqlinfo">
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
			  		c.[CustomerId] = s.[CustomerId]
			  INNER JOIN
			  		[dbo].[SellingCompany] as sc
			  ON
			  		sc.[SellingCompanyId] = s.[sellingCompanyId]
			  WHERE
			  	c.[Email] = '#ARGUMENTS.email#' AND
			  	c.[Password] = '#ARGUMENTS.password#' AND
			  	UPPER(sc.[SellingCompanyName]) = UPPER('#ARGUMENTS.company#')

			</cfquery>
			<cfreturn userInfo/>
	</cffunction>

<!--- retrieveUserInformation by Id --->
		<cffunction name="retrieveUserInformation"
				access="public"
				return="Any"
				returnformat="json">
		<cfargument
			name="userId"
			required="true" />

		<cfquery name="userInformation">
			SELECT [CustomerId]
			      ,[CustomerName]
			      ,[Email]
			      ,[MobileNumber]
			      ,[Password]
			      ,[ProfilePicture]
			  FROM
			  		[dbo].[Customer]
			  WHERE
			  	[CustomerId] = #userId#
		</cfquery>
		<cfreturn userInformation />
	</cffunction>

<!--- Fetch inventory items by productId and quantity form database --->
	<cffunction name="retrieveFromInventory"
				access="public"
				returntype="Any"
				returnformat="json">
		<cfargument name="productId" require="true" type="numeric" />
		<cfargument name="quantity" require="true" type="numeric" />
		<cfquery name="result">
			SELECT  [InventoryId]
					,[SellingCompanyId]
      				,[ProductId],
					[AvailableQuantity]
      				,[SellingPrice]
      				,[DiscountPercent]
					,[SellingPrice]-([SellingPrice]*[DiscountPercent]/100) as DiscountPrice
 			 FROM MyShoppingZone.[dbo].[Inventory]
			 WHERE
			 	AvailableQuantity >= #quantity# AND
			 	ProductId = #productId#
			 ORDER BY
			 	DiscountPrice ASC,AvailableQuantity DESC;
		</cfquery>
		<cfreturn result />
	</cffunction>

<!---- retrieveProductFromInventoryByCompany ---->
	<cffunction name="retrieveProductFromInventoryByCompany"
				access="public"
				returnformat="json"
				returntype="any">
			<cfargument name="sellingCompanyId"
						required="true" />

			<cfquery name="Products">
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
				p.ProductId = i.ProductId
			INNER JOIN
				[dbo].[ProductCategory] as pc
			ON
				p.[productCategoryId] = pc.[productCategoryId]
			INNER JOIN
				[dbo].[ProductSubCategory] as psc
			ON
				psc.[ProductSubCategoryId] =  p.[ProductSubCategoryId]
			WHERE
				i.[SellingCompanyId] = #sellingCompanyId#
			</cfquery>

			<cfreturn Products />
	</cffunction>

<!--- Retrieve Products from database --->
	<cffunction access="public" name="retrieveProducts" returntype="Any">
		<cfargument name="productId" require="true" type="numeric" />
		<cfargument name="quantity" require="true" type="numeric" />
		<cfquery name="result">
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
				p.ProductId = i.ProductId
			WHERE
				[AvailableQuantity] > 0
			 ORDER BY
			 	[ProductRating]
		</cfquery>
		<cfreturn result />
	</cffunction>

<!--- Retrieve Products category from database --->
	<cffunction access="public" name="retrieveProductCategory" retuntype="Any">
		<cfquery name="productCategory">
			SELECT
				ProductCategoryId,ProductCategory
			FROM
				dbo.ProductCategory
		</cfquery>

		<cfreturn productCategory/>
	</cffunction>

<!--- Retrieve Sub Products from Database --->
	<cffunction access="public" name="retrieveProductSubCategory" returntype="Any">
		<cfargument
			name="productCategoryId"
			required="true"
			type="numeric">

		<cfquery name="productSubCategory">
			SELECT
				ProductSubCategoryId,ProductSubCategoryName
			FROM
				dbo.ProductSubCategory
			WHERE
				 ProductCategoryId = #ProductCategoryId#
		</cfquery>

		<cfreturn productSubCategory/>
	</cffunction>

<!--- Retrieve Products by sub category --->
	<cffunction access="public" name="retrieveProductBySubCategory" returntype="Any">

		<cfargument
					name="productSubCategoryId"
					type="numeric"
					required="true" />

		<cfquery name='productBySubCategory'>
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
				p.ProductId = i.ProductId
			WHERE
				productSubCategoryId = #productSubCategoryId#

		</cfquery>
		<cfreturn productBySubCategory />
	</cffunction>

<!--- Product Detail --->
	<cffunction access="public" name="retrieveProductDetail" returntype="Any">
		<cfargument
				name="productId"
				type="numeric"
				required="true">

		<cfquery name="productDetail">
			SELECT
				p.ProductId,
				ProductName,
				ProductBrand,
				ProductImageLocation,
				ProductDescription
			FROM
				Product p
			INNER JOIN
				Inventory i
			ON
				p.ProductId = i.ProductId
			WHERE
				i.ProductId = #productId#
		</cfquery>

		<cfreturn productDetail/>
	</cffunction>

<!--- Insert Into Address --->
	<cffunction name="insertIntoAddress"
			access="public"
			returntype="Any">
		<cfargument
			name="customerId"
			required="true" />
		<cfargument
			name="addressLine1"
			required="true" />
		<cfargument
			name="addressLine2"
			required="false"
			default="" />
		<cfargument
			name="city"
			required="true" />
		<cfargument
			name="state"
			required="true" />
		<cfargument
			name="addressType"
			required="true"/>
		<cfargument
			name="pincode"
			required="true" />
		<cfset dateTime = now() />
		<cfquery result="address">
		 INSERT INTO [dbo].[Address]
           ([CustomerId]
           ,[AddressLine1]
           ,[AddressLine2]
           ,[City]
           ,[State]
           ,[AddressType]
           ,[LastModifiedDate]
           ,[pincode])
    	 VALUES (#customerId#
           , '#ARGUMENTS.addressLine1#'
           , '#ARGUMENTS.addressLine2#'
           ,'#ARGUMENTS.city#'
           , '#ARGUMENTS.state#'
           , '#ARGUMENTS.addressType#'
           , #dateTime#
           , #ARGUMENTS.pincode#)
		</cfquery>
		<cfreturn address.GENERATEDKEY />
	</cffunction>

<!--- update address --->
	<cffunction name="updateAddress"
				access="public"
			returntype="Any">
		<cfargument 
			name="addressId"
			required="true"/>
		<cfargument
			name="customerId"
			required="true" />
		<cfargument
			name="addressLine1"
			required="true" />
		<cfargument
			name="addressLine2"
			required="false"
			default="" />
		<cfargument
			name="city"
			required="true" />
		<cfargument
			name="state"
			required="true" />
		<cfargument
			name="addressType"
			required="true"/>
		<cfargument
			name="pincode"
			required="true" />
		<cfset dateTime = now() />
		<cfquery name="address">
		 UPDATE [dbo].[Address]
		   SET [CustomerId] = #arguments.customerId#
		      ,[AddressLine1] = '#arguments.addressLine1#'
		      ,[AddressLine2] = '#arguments.addressLine2#'
		      ,[City] = '#arguments.city#'
		      ,[State] = '#arguments.state#'
		      ,[AddressType] = '#arguments.addressType#'
		      ,[LastModifiedDate] = #dateTime#
		      ,[pincode] = #arguments.pincode#
		 WHERE 
		 		[AddressId] = #arguments.addressId#
		 </cfquery>

	</cffunction>


<!--- retrieve form address --->
	<cffunction name="retrieveAddress"
				access="public"
				returnType="any">
		<cfargument
				name="customerId"
				required="true">

		<cfquery name="address">
			SELECT TOP 5 [AddressId]
			      ,[CustomerId]
			      ,[AddressLine1]
			      ,[AddressLine2]
			      ,[City]
			      ,[State]
			      ,[AddressType]
			      ,[LastModifiedDate]
			      ,[pincode]
			  FROM [dbo].[Address]
			  WHERE
			  	[CustomerId] = customerId
			  ORDER BY
			  	[LastModifiedDate] DESC;
		</cfquery>
		<cfreturn address/>
	</cffunction>

<!--- removeAddress --->
	<cffunction name="removeAddress"
				access="public"
				returnformat="json"
				returntype="any">
			<cfargument name="addressId"
						required="true"/>

			<cfquery>

					DELETE FROM [dbo].[Address]
      				WHERE addressId = #ARGUMENTS.addressId#

			</cfquery>
	</cffunction>

<!--- Insert Order into Order Table --->
	<cffunction	name="insertOrder"
			access="public" >

			<cfargument
					name="customerId"
					required = "true" />
			<cfset todayDate = now() />
			<cfset currentDate = DateFormat(todayDate, "mm/dd/yyyy") />
			<cfset currentTime = TimeFormat(todayDate, "HH:nn") />

		<!--- insert order in database --->
			<cfquery result="order">
				INSERT INTO [dbo].[Order]
			           ([CustomerId]
			           ,[OrderDate]
			           ,[OrderTime]
			           ,[LastModifiedDate])
			     VALUES
			           ( #customerId#
			           , '#currentDate#'
			           , '#currentTime#'
			           , getdate())
			</cfquery>
			<cfreturn order.GENERATEDKEY />
	</cffunction>


<!--- Retrieve order id by customer id from Order Table --->
	<cffunction	name="retrieveOrderId"
			access="public"
			hint = "get order id for a customer" >

			<cfargument
					name="customerId"
					required="true" />

			<cfquery name="orderInfo">
				SELECT [OrderId]
				      ,[CustomerId]
				      ,[OrderDate]
				      ,[OrderTime]
				  FROM
				  	  [dbo].[Order]
				  WHERE
				  	  [CustomerId] = #customerId#
				  ORDER BY
				  	  [OrderDate] DESC, [OrderTime] DESC

			</cfquery>
			<cfreturn orderInfo />
	 </cffunction>


<!--- insertOrderDetail into database --->
	<cffunction name="insertOrderDetail"
			access="public">

			<cfargument
					name="orderId"
					required="true" />
			<cfargument
					name="productId"
					required="true" />
			<cfargument
					name="orderQuantity"
					required="true" />
			<cfargument
					name="shippingAddressId"
					required="true" />
			<cfargument
					name="sellingCompanyId"
					required="true" />
			<cfargument
					name="unitprice"
					required="true" />
			<cfargument
					name="discountPercent"
					required="true" />
			<cfset datetime = now() />
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
			           (#ARGUMENTS.orderId#
			           ,#ARGUMENTS.productId#
			           ,#datetime#
			           ,#ARGUMENTS.orderQuantity#
			           ,#ARGUMENTS.shippingAddressId#
			           ,#ARGUMENTs.sellingCompanyId#
			           ,#ARGUMENTS.unitprice#
			           ,#ARGUMENTS.discountPercent#)
			</cfquery>
	</cffunction>



<!--- retrieve order details (items) by order id --->
	<cffunction	name="retrieveOrderDetail"
			access="public"
			hint="get order detail by order id">

			<cfargument
				name="orderId"
				required="true" />

			<cfquery name="orderDetail">
				SELECT [OrderDetailId]
					      ,[OrderId]
					      ,[Product]
					      ,[OrderQuantity]
					      ,[ShippingAddressId]
					      ,[sellingCompanyId]
				FROM
					  	[dbo].[OrderDetail]
				WHERE
						[OrderId] = #ARGUMENTS.orderId#
			</cfquery>

			<cfreturn orderDetail />
	</cffunction>


<!--- update inventory table to set availableQuantity --->
	<cffunction name="updateAvailableQuantity"
			access="public"
			returntype="Any">
		<cfargument
				name="availableQuantity"
				required="true" />
		<cfargument
				name="sellingCompanyId"
				required="true" />
		<cfargument
				name="productId"
				required="true" />
		<cfquery name="itemQuantity">
				UPDATE
					[dbo].[Inventory]
			   	SET
			     	[AvailableQuantity] = #availableQuantity#
				WHERE
				 	[SellingCompanyId] = #sellingCompanyId#
			      	AND [ProductId] = #productId#
		</cfquery>
	</cffunction>


<!--- search by name --->
	<cffunction name="searchProduct"
				access="public"
				returntype="any" >
			<cfargument name="searchItem"
					required="true" />
			<cfargument name="brandList" 
					required="true"/>
			<cfargument name="minPrice" 
					required="true" />
			<cfargument name="maxPrice" 
					required="true" />
			<cfset session.database = brandList />
			<cfif ARGUMENTS.brandList eq "">
				<cfquery name="searchResult">
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
						p.ProductId = i.ProductId
					WHERE
						ProductName LIKE '%#searchItem#%'
						AND
						AvailableQuantity > 0
						AND
						[SellingPrice]-([SellingPrice]*ISNULL([DiscountPercent],0)/100) >= #arguments.minPrice#
						AND
						[SellingPrice]-([SellingPrice]*ISNULL([DiscountPercent],0)/100) <= #arguments.maxPrice#
				</cfquery>
			<cfelse>
				<cfquery name="searchResult">
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
						p.ProductId = i.ProductId
					WHERE
						ProductName LIKE '%#searchItem#%'
						AND
						AvailableQuantity > 0
						AND
						[SellingPrice]-([SellingPrice]*ISNULL([DiscountPercent],0)/100) >= #arguments.minPrice#
						AND
						[SellingPrice]-([SellingPrice]*ISNULL([DiscountPercent],0)/100) <= #arguments.maxPrice#
						AND
						ProductBrand in (#PreserveSingleQuotes(arguments.brandList)#)
				</cfquery>
			</cfif>
			<cfreturn searchResult />
	</cffunction>

<!--- insertCart --->
	<cffunction name="insertCart"
			access="public"
			returntype="any"
			returnformat="json">

			<cfargument name="customerId"
				required="true" />

			<cfquery name="cart">
				INSERT INTO [dbo].[Cart]
			           ([CustomerId])
			     VALUES
			           (#customerId#)
			</cfquery>
	</cffunction>

<!--- retrieveCart --->
	<cffunction name="retrieveCart"
			access="public"
			returntype="any"
			returnformat="JSON">

			<cfargument name="customerId"
					required="true" />

			<cfquery name="cart">
				  SELECT [CartId]
				      ,[CustomerId]
				  FROM [dbo].[Cart]
				  WHERE
				  		[CustomerId] = #customerId#
			</cfquery>
			<cfreturn cart />
	</cffunction>

<!--- delete from cart --->
	<cffunction name="removeCart"
			access="public"
			returntype="any"
			returnformat="json">

			<cfargument name="customerId"
					required="true" />

			<cfquery name="cart">
				DELETE
				FROM [dbo].[Cart]
      			WHERE
					[CustomerId] = #ARGUMENTS.customerId#
			</cfquery>
	</cffunction>

<!--- insertCartDetail --->
	<cffunction name="insertCardDetail"
			access="public"
			returntype="any"
			returnformat="json">

			<cfargument name="cartId"
					required="true" />
			<cfargument name="inventoryId"
					required="true" />
			<cfargument name="quantity"
					required="true" />
			<cfset datetime = now() />

			<cfquery name="cartItems">
				INSERT INTO [dbo].[CartItem]
			           ([CartId]
			           ,[InventoryId]
			           ,[Quantiy]
			           ,[LastModifiedDate])
			     VALUES
			           (#ARGUMENTS.cartId#
			           ,#ARGUMENTS.inventoryId#
			           ,#ARGUMENTS.quantity#
			           ,#datetime#)
			</cfquery>
	</cffunction>

<!--- retrieveCartDetail --->
	<cffunction name="retrieveCartDetail"
			access="public"
			returnformat="json"
			returntype="any">

			<cfargument name="cartId"
					required="true" />

			<cfquery name="cartItems">
					SELECT [CartItemId]
				      ,[CartId]
				      ,[InventoryId]
				      ,[Quantiy]
				      ,[LastModifiedDate]
				    FROM [dbo].[CartItem]
				    WHERE
				  		[CartId] = #ARGUMENTS.cartId#
			</cfquery>
			<cfreturn cartItems />
	</cffunction>

<!--- delete from cart Detail--->
	<cffunction name="removeCartDetail"
			access="public"
			returntype="any"
			returnformat="json">

			<cfargument name="cartId"
					required="true" />

			<cfquery name="cardDetail">
				DELETE
				FROM [dbo].[CartItem]
	      		WHERE
	      			[CartId] = #ARGUMENTS.cartId#
			</cfquery>
	</cffunction>

<!--- retrieveCartItemDetail --->
	<cffunction name="retrieveCartItemDetail"
				access="public"
				returnformat="json"
				returntype="any">

				<cfargument name="cartId"
						required="true" />

				<cfquery name="CartItemDetail">
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
						c.InventoryId = i.InventoryId
					  INNER JOIN
						[dbo].[Product] as p
					  ON
						p.ProductId = i.ProductId
					  WHERE
						c.CartId = #ARGUMENTS.cartId#
				</cfquery>

				<cfreturn CartItemDetail />
		</cffunction>


<!--- retrieveOrderDetails --->
	<cffunction name="retrieveOrderDetails"
			access="public"
			returnformat="json"
			returntype="Any">

			<cfargument name="userId"
					required="true" />
			<cfargument name="orderId"
					required="true" />
			<cfargument name="sellingCompanyId"
					required="true"/>

			<cfquery name="OrderDetails" result="order">

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
					o.orderId = od.OrderId
				  INNER JOIN
					[dbo].[Address] a
				  ON
					od.ShippingAddressId = a.AddressId
				  INNER JOIN
				    [dbo].[Product] p
				  ON
					p.ProductId = od.ProductId
				  INNER JOIN
					[dbo].[SellingCompany] sc
				  ON
					sc.SellingCompanyId = od.SellingCompanyId
				  where
					o.OrderId =  #orderId#
					AND
					od.SellingCompanyId = #sellingCompanyId#
					AND
					o.CustomerId = #userId#
				 ORDER BY
					OrderDate Desc,OrderTime Desc
			</cfquery>
			<cfset session.sql = order.sql />
			<cfset session.dataResult = orderDetails />
			<cfreturn OrderDetails />
	</cffunction>


<!--- retrieveSellingCompanyForOrder --->
	<cffunction name="retrieveSellingCompanyForOrder"
			access="public"
			returnformat="json"
			returntype="any">

			<cfargument name="orderId"
					required="true" />

			<cfquery name="sellingCompany">
				SELECT 
					DISTINCT [SellingCompanyId]
				  FROM [dbo].[OrderDetail]
				  WHERE
					OrderId = #orderId#
			</cfquery>

			<cfreturn sellingCompany />
	</cffunction>


<!--- retrieveOrderHistory --->
	<cffunction name="retrieveOrderHistory"
				access="public"
				returnformat="json"
				returntype="any">

			<cfargument name="userId"
						required="true" />

			<cfquery name="orderDetail">
				  SELECT [OrderId]
				      ,[CustomerId]
				      ,[OrderDate]
				      ,[OrderTime]
				      ,ISNULL([Total],0) as Total
				      ,[LastModifiedDate]
				  FROM [dbo].[Order]
			</cfquery>

			<cfreturn orderDetail />
	</cffunction>

<!--- retrieveOrderHistoryDetail --->
	<cffunction name="retrieveOrderHistoryDetail"
				access="public"
				returnformat="json"
				returntype="any">

		<cfargument name="orderId"
				required="true" />

		<cfquery name="orderDetail">
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
			   p.productId = od.productId
			  WHERE
			  	OrderId = #orderId#
		</cfquery>

		<cfreturn orderDetail />
	</cffunction>

<!--- updateUserProfilePicture --->
	<cffunction name="updateUserProfilePicture"
				access="public"
				returnformat="json"
				returntype="any">

			<cfargument name="pictureLocation"
					required="true"/>
			<cfargument name="userId"
					required="true"/>
			<cfquery name="profilePicture">
					 UPDATE [dbo].[Customer]
					 SET
					 	[ProfilePicture] = '#ARGUMENTS.pictureLocation#'
					 WHERE
						[CustomerId] = #ARGUMENTS.userId#
			</cfquery>
	</cffunction>


<!--- insertProduct --->
	<cffunction name="insertProduct"
				access="public"
				returnformat="json"
				returntype="any">
			<cfargument name="productName"
						required ="true"/>
			<cfargument name="productCategoryId"
						required = "true"/>
			<cfargument name="productSubCategoryId"
						required = "true"/>
			<cfargument name="productBrand"
						required="true"/>
			<cfargument name="productDescription"
						required="false"
						default="" />
			<cfargument name="productImageLocation"
						required="false"
						default="assets/images/product/default.jpg"/>
			<cfargument name="leastPrice"
						required="true"/>
			<cfset lastModifiedDate = now() />
		<cfquery result="product">
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
		           (#ARGUMENTS.leastPrice#
       	           ,#ARGUMENTS.productCategoryId#
		           ,'#ARGUMENTS.productName#'
		           ,'#ARGUMENTS.productBrand#'
		           ,#lastModifiedDate#
		           ,'#ARGUMENTS.productImageLocation#'
		           ,#ARGUMENTS.productSubCategoryId#
		           ,'#ARGUMENTS.productDescription#')
		</cfquery>
		<cfquery result="productId">
			UPDATE [dbo].[Product]
   			SET
				[ProductImageLocation] = '#ARGUMENTS.productImageLocation##product.GENERATEDKEY#'
			WHERE [ProductId] = #product.GENERATEDKEY#
		</cfquery>
		<cfreturn product.GENERATEDKEY />
	</cffunction>


<!--- deleteProductFromInventory --->
	<cffunction name="deleteProductFromInventory"
				access="public"
				returnformat="json"
				returntype="any">
			<cfargument name="inventoryId"
						required="true"/>
			<cfquery>
				DELETE 
				FROM [dbo].[Inventory]
      			WHERE
      				InventoryId = #inventoryId#
			</cfquery>				
	</cffunction>

<!---- updateProductInInventory --->
	<cffunction name="updateProductInInventory"
				access="public"
				returntype="any"
				returnformat="json">
					
			<cfargument name="sellingPrice"
						required="true" />
			<cfargument name="quantity"
						required="true" />
			<cfargument name="discount"
						required="true" />	
			<cfargument name="inventoryId"
						required="true" />	
			<cfset lastModifiedDate = now() />
			<cfquery name="updateInventory">
				UPDATE [dbo].[Inventory]
   				SET    [AvailableQuantity] = #arguments.quantity#
				      ,[SellingPrice] = #arguments.sellingPrice#
				      ,[DiscountPercent] = #arguments.discount#
				      ,[LastModifiedDate] =  #lastModifiedDate#
				 WHERE [inventoryId] = #arguments.inventoryId#
			</cfquery>

	</cffunction>

<!---- insertProductInInventory --->
	<cffunction name="insertProductInInventory"
				access="public"
				returntype="any"
				returnformat="json">
		
		<cfargument name="sellingCompanyId"
					required="true" />
		<cfargument name="productId"
					required="true" />
		<cfargument name="availableQuantity"
					required="true" />
		<cfargument name="sellingPrice"
					required="true" />
		<cfargument name="discount"
					required="true" />
		<cfset lastModifiedDate = now() />
		<cfquery result="inventoryItem">
			INSERT INTO [dbo].[Inventory]
		           ([SellingCompanyId]
		           ,[ProductId]
		           ,[AvailableQuantity]
		           ,[SellingPrice]
		           ,[DiscountPercent]
		           ,[LastModifiedDate])
		     VALUES
		           (#arguments.sellingCompanyId#
		           ,#arguments.productId#
		           ,#arguments.availableQuantity#
		           ,#arguments.sellingPrice#
		           ,#arguments.discount#
		           ,#lastModifiedDate#)
		</cfquery>
		<cfreturn inventoryItem.GENERATEDKEY />
	</cffunction>

<!---- insertProductCategory --->
	<cffunction name="insertProductCategory"
				access="public"
				returntype="any"
				returnformat="json">
		<cfargument name="categoryName"
					required="true" />	
		<cfquery result="category">
			INSERT INTO [dbo].[ProductCategory]
		           ([ProductCategory])
		     VALUES
		           ('#ARGUMENTS.categoryName#')
		</cfquery>
		<cfreturn category.GENERATEDKEY />		
	</cffunction>


<!---- sellerSearchProducts --->
	<cffunction name="sellerSearchProducts"
				access="public"
				returnformat="json"
				returntype="any">
			<cfargument name="searchValue"
					required="true" />
			
			<cfquery name="products">
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
				p.[ProductId] = i.[ProductId]
			  INNER JOIN
				[dbo].[ProductCategory] pc
			  ON
				pc.[ProductCategoryId] = p.[ProductCategoryId]
			  INNER JOIN
				[dbo].[ProductSubCategory] psc
			  ON
				psc.[ProductSubCategoryId] = p.[ProductSubCategoryId]
			  WHERE
				p.[ProductName] LIKE '%#ARGUMENTS.searchValue#%' 
			</cfquery>
			<cfreturn products />					

	</cffunction>

<!--- retrieveBrandNames --->
	<cffunction name="retrieveBrandNames"
				access="public"
				returnformat="json"
				returntype="any">
			
			<cfquery name="brands">
				SELECT DISTINCT [ProductBrand]
  				FROM [dbo].[Product]
			</cfquery>		
			<cfreturn brands />		
	</cffunction>
</cfcomponent>





