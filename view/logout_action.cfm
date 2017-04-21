<cfset session.lastpage="#CGI.HTTP_REFERER#" />
<cfinvoke component="controller.controller" method="logOut">
</cfinvoke>