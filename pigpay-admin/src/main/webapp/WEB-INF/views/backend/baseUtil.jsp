<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
 <%
 	String path = request.getContextPath();
	if(path != null && !path.endsWith("/")) {
		path += "/";
	}
	String basePath = "";
	int port = request.getServerPort();
	if(80==port){
		basePath = request.getScheme() + "://" + request.getServerName() + path;
	}
	else{
	  	basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path;
	}
	
	//String basePath = path;
	
	request.setAttribute("rootpath", path);
	request.setAttribute("basePath", basePath);
	
%>