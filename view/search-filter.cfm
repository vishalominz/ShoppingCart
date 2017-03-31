<cfinvoke component="controller.Controller"
			method="retrieveBrandNames"
			returnvariable="brands">
</cfinvoke>

<div class="search-filters">
	<div class="row">
		<div class="header search-brand">
			<label for="brand">Select Brand</label></br>
		</div>
		<div class="content search-brand">
			<div id="brand-search">
			<cfloop query="brands">
				<cfoutput>
					<input type="checkbox" name="brand" value="#ProductBrand#">#ProductBrand#</br>
				</cfoutput>
			</cfloop>
			</div>
		</div>
		<div class="header search-brand">
			<label for="price">Price range:</label>
		</div>
		<div class="content search-price">
			<input type="text" id="price" readonly>
			<input type="hidden" id="minPrice" name="minPrice" value="0"/>
			<input type="hidden" id="maxPrice" name="maxPrice" value="100000"/>
			<div id="search-slider"></div>
		</div>
	</div>
</div>