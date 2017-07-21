<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<jsp:include page="version.jsp"></jsp:include>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Cache-Control" content="no-cache, no-store, max-age=0"/>
<meta http-equiv="Pragma" content="no-cache"/>
<meta http-equiv="Expires" content="0"/>
<title>安装向导</title>
<link rel="stylesheet" href="${ctx}/setup/images/style.css" type="text/css"/>
<script type="text/javascript">
	function $(id) {
		return document.getElementById(id);
	}
</script>
</head>
<div class="container">
	<div class="header">
		<h1>安装向导</h1>
		<span>v${version}</span>
	</div>
<div class="main" style="margin-top:-123px;">
	<div style="padding:20px 0;line-height:200%;">
	<h1 style="font-size:16px;line-height:200%;">安装完成，<span style="color:red;">请重启TOMCAT</span>。</h1>
	<p>前台首页：<a href="${ctx}/" target="_blank">${ctx}/</a></p>
	<p>后台首页：<a href="${ctx}/cmscp/index.do" target="_blank">${ctx}/cmscp/index.do</a></p>
	<p><input type="button" id="previousButton" onclick="$('prevousForm').submit();" value="返回"/></p>
	</div>
		<div class="footer">&copy;2010 - 2015 <a href="http://www.jspxcms.com/">Jspxcms</a></div>
	</div>
</div>
<form id="prevousForm" action="${ctx}/" method="post">
<input type="hidden" name="previous" value="true"/>
</form>

<form id="prevousForm" action="${ctx}/" method="post">
<input type="hidden" name="previous" value="true"/>
</form>

</body>
</html>
