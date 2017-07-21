<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fnx" uri="http://java.sun.com/jsp/jstl/functionsx"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="f" uri="http://www.jspxcms.com/tags/form"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<title>管理平台</title>
<jsp:include page="/WEB-INF/views/commons/head.jsp"></jsp:include>
<script type="text/javascript">
$(function() {
	$("#validForm").validate();
	$("input[name='name']").focus();
});
function confirmDelete() {
	return confirm("<s:message code='confirmDelete'/>");
}
</script>
</head>
<body class="c-body">
<jsp:include page="/WEB-INF/views/commons/show_message.jsp"/>
<div class="c-bar margin-top5">
  <span class="c-position"><s:message code="task.management"/> - <s:message code="${oprt}"/></span>
</div>
<form id="validForm" action="" method="post">
<tags:search_params/>
<f:hidden name="oid" value="${bean.id}"/>
<f:hidden name="position" value="${position}"/>
<input type="hidden" id="redirect" name="redirect" value="edit"/>
<table border="0" cellpadding="0" cellspacing="0" class="in-tb margin-top5">
  <tr>
    <td colspan="4" class="in-opt">
			<shiro:hasPermission name="core:task:stop">
			<div class="in-btn"><input type="button" value="<s:message code="stop"/>" onclick="location.href='stop.do?ids=${bean.id}&${searchstring}';"/></div>
			</shiro:hasPermission>
			<shiro:hasPermission name="core:task:delete">
			<div class="in-btn"><input type="button" value="<s:message code="delete"/>" onclick="if(confirmDelete()){location.href='delete.do?ids=${bean.id}&${searchstring}';}"/></div>
			</shiro:hasPermission>
			<div class="in-btn"></div>
			<div class="in-btn"><input type="button" value="<s:message code="prev"/>" onclick="location.href='view.do?id=${side.prev.id}&position=${position-1}&${searchstring}';"<c:if test="${empty side.prev}"> disabled="disabled"</c:if>/></div>
			<div class="in-btn"><input type="button" value="<s:message code="next"/>" onclick="location.href='view.do?id=${side.next.id}&position=${position+1}&${searchstring}';"<c:if test="${empty side.next}"> disabled="disabled"</c:if>/></div>
			<div class="in-btn"></div>
			<div class="in-btn"><input type="button" value="<s:message code="return"/>" onclick="location.href='list.do?${searchstring}';"/></div>
      <div style="clear:both;"></div>
    </td>
  </tr>
  <tr>
    <td class="in-lab" width="15%"><s:message code="task.name"/>:</td>
    <td class="in-ctt" width="35%"><c:out value="${bean.name}"/></td>
    <td class="in-lab" width="15%"><s:message code="task.type"/>:</td>
    <td class="in-ctt" width="35%"><s:message code="task.type.${bean.type}"/></td>
  </tr>
  <tr>
    <td class="in-lab" width="15%"><s:message code="task.description"/>:</td>
    <td class="in-ctt" width="85%" colspan="3"><f:textarea name="description" value="${bean.description}" readonly="readonly" style="width:500px;height:80px;"/></td>
  </tr>
  <tr>
    <td class="in-lab" width="15%"><s:message code="task.beginTime"/>:</td>
    <td class="in-ctt" width="35%"><fmt:formatDate value="${bean.beginTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
    <td class="in-lab" width="15%"><s:message code="task.endTime"/>:</td>
    <td class="in-ctt" width="35%"><fmt:formatDate value="${bean.endTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
  </tr>
  <tr>
    <td class="in-lab" width="15%"><s:message code="task.user"/>:</td>
    <td class="in-ctt" width="35%"><c:out value="${bean.user.username}"/></td>
    <td class="in-lab" width="15%"><s:message code="task.total"/>:</td>
    <td class="in-ctt" width="35%"><c:out value="${bean.total}"/></td>
  </tr>
  <tr>
    <td class="in-lab" width="15%"><s:message code="task.status"/>:</td>
    <td class="in-ctt" width="85%" colspan="3"><s:message code="task.status.${bean.status}"/></td>
  </tr>
</table>
</form>
</body>
</html>