<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.jspxcms.core.domain.*,java.util.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fnx" uri="http://java.sun.com/jsp/jstl/functionsx"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
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
<style type="text/css">
</style>
<script type="text/javascript">
$(function() {
	$("input[name=control][checked!=checked]").each(function(){
		$(this).parent().parent().find("input,select").not(this).attr("disabled","disabled").addClass("disabled");
	});
	$("#pagedTable").tableHighlight();
	$("#fieldForm").validate();
	$("input[name='control']").change(function(){
		if(this.checked) {
			$(this).parent().parent().find("input,select").not(this).removeAttr("disabled").removeClass("disabled");
		} else {
			$(this).parent().parent().find("input,select").not(this).attr("disabled","disabled").addClass("disabled");
		}
	});
});
function checkControl(name,checked) {
	$("input[name='"+name+"']").each(function() {
		$(this).prop("checked",checked).change();
	});
}
</script>
</head>
<body class="c-body">
<jsp:include page="/WEB-INF/views/commons/show_message.jsp"/>
<div class="c-bar margin-top5">
  <div class="c-position"><s:message code="model.management"/> - <s:message code="model.type.${model.type}"/> - <s:message code="modelField.addPredefinedField"/> - ${model.name}</div>
</div>
<form id="fieldForm" action="batch_save.do" method="post">
<f:hidden name="modelId" value="${model.id}"/>
<tags:search_params/>
<div class="ls-bc-opt">
	<div class="ls-btn"><input type="submit" value="<s:message code="save"/>"/></div>
	<div class="ls-btn"></div>
	<div class="in-btn"><input type="button" value="<s:message code="return"/>" onclick="location.href='list.do?modelId=${model.id}&${searchstring}';"/></div>
	<div style="clear:both"></div>
</div>
<table id="pagedTable" border="0" border="0" cellpadding="0" cellspacing="0" class="ls-tb margin-top5">
  <thead>
  <tr class="ls_table_th">
    <th width="25"><input type="checkbox" checked="checked" onclick="checkControl('control',this.checked);"/></th>
    <th><s:message code="modelField.name"/></th>
    <th><s:message code="modelField.label"/></th>
    <th><s:message code="modelField.dblColumn"/></th>
  </tr>
  </thead>
  <tbody>
  <c:set var="names" value="${model.predefinedNames}"/>
  <c:if test="${!fnx:contains_co(names,'name')}">
  <tr>
    <td>&nbsp;</td>
    <td align="center">name
      <input type="hidden" name="name" value="name"/>
      <input type='hidden' name='property' value='{"type":1,"innerType":2,"required":true}'/>
      <input type='hidden' name='custom' value='{}'/>
    </td>
    <td align="center"><input type="text" name="label" value="<s:message code='node.name'/>"/></td>
    <td align="center"><f:checkbox name="dblColumn" value="true"/></td>
  </tr>
  </c:if>
  <c:if test="${!fnx:contains_co(names,'number')}">
  <tr>
    <td><input type="checkbox" name="control" checked="checked"/></td>
    <td align="center">number
      <input type="hidden" name="name" value="number"/>
      <input type='hidden' name='property' value='{"type":1,"innerType":2}'/>
      <input type='hidden' name='custom' value='{}'/>
    </td>
    <td align="center"><input type="text" name="label" value="<s:message code='node.number'/>"/></td>
    <td align="center"><f:checkbox name="dblColumn" value="true"/></td>
  </tr>
  </c:if>
  <c:if test="${!fnx:contains_co(names,'metaKeywords')}">
  <tr>
    <td><input type="checkbox" name="control" checked="checked"/></td>
    <td align="center">metaKeywords
      <input type="hidden" name="name" value="metaKeywords"/>
      <input type='hidden' name='property' value='{"type":1,"innerType":2}'/>
      <input type='hidden' name='custom' value='{}'/>
    </td>
    <td align="center"><input type="text" name="label" value="<s:message code='node.metaKeywords'/>"/></td>
    <td align="center"><f:checkbox name="dblColumn" value="false"/></td>
  </tr>
  </c:if>
  <c:if test="${!fnx:contains_co(names,'metaDescription')}">
  <tr>
    <td><input type="checkbox" name="control" checked="checked"/></td>
    <td align="center">metaDescription
      <input type="hidden" name="name" value="metaDescription"/>
      <input type='hidden' name='property' value='{"type":1,"innerType":2}'/>
      <input type='hidden' name='custom' value='{}'/>
    </td>
    <td align="center"><input type="text" name="label" value="<s:message code='node.metaDescription'/>"/></td>
    <td align="center"><f:checkbox name="dblColumn" value="false"/></td>
  </tr>
  </c:if>
  <c:if test="${!fnx:contains_co(names,'workflow')}">
  <tr>
    <td><input type="checkbox" name="control" checked="checked"/></td>
    <td align="center">workflow
      <input type="hidden" name="name" value="workflow"/>
      <input type='hidden' name='property' value='{"type":5,"innerType":2}'/>
      <input type='hidden' name='custom' value='{}'/>
    </td>
    <td align="center"><input type="text" name="label" value="<s:message code='node.workflow'/>"/></td>
    <td align="center"><f:checkbox name="dblColumn" value="false"/></td>
  </tr>
  </c:if>
  <c:if test="${!fnx:contains_co(names,'infoPerms')}">
  <tr>
    <td><input type="checkbox" name="control" checked="checked"/></td>
    <td align="center">infoPerms
      <input type="hidden" name="name" value="infoPerms"/>
      <input type='hidden' name='property' value='{"type":3,"innerType":2}'/>
      <input type='hidden' name='custom' value='{}'/>
    </td>
    <td align="center"><input type="text" name="label" value="<s:message code='node.infoPerms'/>"/></td>
    <td align="center"><f:checkbox name="dblColumn" value="false"/></td>
  </tr>
  </c:if>
  <c:if test="${!fnx:contains_co(names,'nodePerms')}">
  <tr>
    <td><input type="checkbox" name="control" checked="checked"/></td>
    <td align="center">nodePerms
      <input type="hidden" name="name" value="nodePerms"/>
      <input type='hidden' name='property' value='{"type":3,"innerType":2}'/>
      <input type='hidden' name='custom' value='{}'/>
    </td>
    <td align="center"><input type="text" name="label" value="<s:message code='node.nodePerms'/>"/></td>
    <td align="center"><f:checkbox name="dblColumn" value="false"/></td>
  </tr>
  </c:if>
  <c:if test="${!fnx:contains_co(names,'viewGroups')}">
  <tr>
    <td><input type="checkbox" name="control" checked="checked"/></td>
    <td align="center">viewGroups
      <input type="hidden" name="name" value="viewGroups"/>
      <input type='hidden' name='property' value='{"type":3,"innerType":2}'/>
      <input type='hidden' name='custom' value='{}'/>
    </td>
    <td align="center"><input type="text" name="label" value="<s:message code='node.viewGroups'/>"/></td>
    <td align="center"><f:checkbox name="dblColumn" value="false"/></td>
  </tr>
  </c:if>
  <c:if test="${!fnx:contains_co(names,'contriGroups')}">
  <tr>
    <td><input type="checkbox" name="control" checked="checked"/></td>
    <td align="center">contriGroups
      <input type="hidden" name="name" value="contriGroups"/>
      <input type='hidden' name='property' value='{"type":3,"innerType":2}'/>
      <input type='hidden' name='custom' value='{}'/>
    </td>
    <td align="center"><input type="text" name="label" value="<s:message code='node.contriGroups'/>"/></td>
    <td align="center"><f:checkbox name="dblColumn" value="false"/></td>
  </tr>
  </c:if>
  <c:if test="${!fnx:contains_co(names,'commentGroups')}">
  <tr>
    <td><input type="checkbox" name="control" checked="checked"/></td>
    <td align="center">commentGroups
      <input type="hidden" name="name" value="commentGroups"/>
      <input type='hidden' name='property' value='{"type":3,"innerType":2}'/>
      <input type='hidden' name='custom' value='{}'/>
    </td>
    <td align="center"><input type="text" name="label" value="<s:message code='node.commentGroups'/>"/></td>
    <td align="center"><f:checkbox name="dblColumn" value="false"/></td>
  </tr>
  </c:if>
  <c:if test="${!fnx:contains_co(names,'nodeModel')}">
  <tr>
    <td>&nbsp;</td>
    <td align="center">nodeModel
      <input type="hidden" name="name" value="nodeModel"/>
      <input type='hidden' name='property' value='{"type":5,"innerType":2,"required":true}'/>
      <input type='hidden' name='custom' value='{}'/>
    </td>
    <td align="center"><input type="text" name="label" value="<s:message code='node.nodeModel'/>"/></td>
    <td align="center"><f:checkbox name="dblColumn" value="true"/></td>
  </tr>
  </c:if>
  <c:if test="${!fnx:contains_co(names,'infoModel')}">
  <tr>
    <td><input type="checkbox" name="control" checked="checked"/></td>
    <td align="center">infoModel
      <input type="hidden" name="name" value="infoModel"/>
      <input type='hidden' name='property' value='{"type":5,"innerType":2}'/>
      <input type='hidden' name='custom' value='{}'/>
    </td>
    <td align="center"><input type="text" name="label" value="<s:message code='node.infoModel'/>"/></td>
    <td align="center"><f:checkbox name="dblColumn" value="true"/></td>
  </tr>
  </c:if>
  <c:if test="${!fnx:contains_co(names,'nodeTemplate')}">
  <tr>
    <td><input type="checkbox" name="control" checked="checked"/></td>
    <td align="center">nodeTemplate
      <input type="hidden" name="name" value="nodeTemplate"/>
      <input type='hidden' name='property' value='{"type":1,"innerType":2}'/>
      <input type='hidden' name='custom' value='{}'/>
    </td>
    <td align="center"><input type="text" name="label" value="<s:message code='node.nodeTemplate'/>"/></td>
    <td align="center"><f:checkbox name="dblColumn" value="true"/></td>
  </tr>
  </c:if>
  <c:if test="${!fnx:contains_co(names,'infoTemplate')}">
  <tr>
    <td><input type="checkbox" name="control" checked="checked"/></td>
    <td align="center">infoTemplate
      <input type="hidden" name="name" value="infoTemplate"/>
      <input type='hidden' name='property' value='{"type":1,"innerType":2}'/>
      <input type='hidden' name='custom' value='{}'/>
    </td>
    <td align="center"><input type="text" name="label" value="<s:message code='node.infoTemplate'/>"/></td>
    <td align="center"><f:checkbox name="dblColumn" value="true"/></td>
  </tr>
  </c:if>
  <c:if test="${!fnx:contains_co(names,'generateNode')}">
  <tr>
    <td><input type="checkbox" name="control" checked="checked"/></td>
    <td align="center">generateNode
      <input type="hidden" name="name" value="generateNode"/>
      <input type='hidden' name='property' value='{"type":1,"innerType":2}'/>
      <input type='hidden' name='custom' value='{}'/>
    </td>
    <td align="center"><input type="text" name="label" value="<s:message code='node.generateNode'/>"/></td>
    <td align="center"><f:checkbox name="dblColumn" value="false"/></td>
  </tr>
  </c:if>
  <c:if test="${!fnx:contains_co(names,'generateInfo')}">
  <tr>
    <td><input type="checkbox" name="control" checked="checked"/></td>
    <td align="center">generateInfo
      <input type="hidden" name="name" value="generateInfo"/>
      <input type='hidden' name='property' value='{"type":1,"innerType":2}'/>
      <input type='hidden' name='custom' value='{}'/>
    </td>
    <td align="center"><input type="text" name="label" value="<s:message code='node.generateInfo'/>"/></td>
    <td align="center"><f:checkbox name="dblColumn" value="false"/></td>
  </tr>
  </c:if>
  <c:if test="${!fnx:contains_co(names,'staticMethod')}">
  <tr>
    <td><input type="checkbox" name="control" checked="checked"/></td>
    <td align="center">staticMethod
      <input type="hidden" name="name" value="staticMethod"/>
      <input type='hidden' name='property' value='{"type":5,"innerType":2}'/>
      <input type='hidden' name='custom' value='{}'/>
    </td>
    <td align="center"><input type="text" name="label" value="<s:message code='node.staticMethod'/>"/></td>
    <td align="center"><f:checkbox name="dblColumn" value="true"/></td>
  </tr>
  </c:if>
  <c:if test="${!fnx:contains_co(names,'staticPage')}">
  <tr>
    <td><input type="checkbox" name="control" checked="checked"/></td>
    <td align="center">staticPage
      <input type="hidden" name="name" value="staticPage"/>
      <input type='hidden' name='property' value='{"type":1,"innerType":2,"defValue":1,"required":false}'/>
      <input type='hidden' name='custom' value='{}'/>
    </td>
    <td align="center"><input type="text" name="label" value="<s:message code='node.staticPage'/>"/></td>
    <td align="center"><f:checkbox name="dblColumn" value="true"/></td>
  </tr>
  </c:if>
  <c:if test="${!fnx:contains_co(names,'p1')}">
  <tr>
    <td><input type="checkbox" name="control"/></td>
    <td align="center">p1
      <input type="hidden" name="name" value="p1"/>
      <input type='hidden' name='property' value='{"type":101,"innerType":3}'/>
      <input type='hidden' name='custom' value='{}'/>
    </td>
    <td align="center"><input type="text" name="label" value="<s:message code='node.p1'/>"/></td>
    <td align="center"><f:checkbox name="dblColumn" value="false"/></td>
  </tr>
  </c:if>
  <c:if test="${!fnx:contains_co(names,'p2')}">
  <tr>
    <td><input type="checkbox" name="control"/></td>
    <td align="center">p2
      <input type="hidden" name="name" value="p2"/>
      <input type='hidden' name='property' value='{"type":101,"innerType":3}'/>
      <input type='hidden' name='custom' value='{}'/>
    </td>
    <td align="center"><input type="text" name="label" value="<s:message code='node.p2'/>"/></td>
    <td align="center"><f:checkbox name="dblColumn" value="false"/></td>
  </tr>
  </c:if>
  <c:if test="${!fnx:contains_co(names,'p3')}">
  <tr>
    <td><input type="checkbox" name="control"/></td>
    <td align="center">p3
      <input type="hidden" name="name" value="p3"/>
      <input type='hidden' name='property' value='{"type":101,"innerType":3}'/>
      <input type='hidden' name='custom' value='{}'/>
    </td>
    <td align="center"><input type="text" name="label" value="<s:message code='node.p3'/>"/></td>
    <td align="center"><f:checkbox name="dblColumn" value="false"/></td>
  </tr>
  </c:if>
  <c:if test="${!fnx:contains_co(names,'p4')}">
  <tr>
    <td><input type="checkbox" name="control"/></td>
    <td align="center">p4
      <input type="hidden" name="name" value="p4"/>
      <input type='hidden' name='property' value='{"type":101,"innerType":3}'/>
      <input type='hidden' name='custom' value='{}'/>
    </td>
    <td align="center"><input type="text" name="label" value="<s:message code='node.p4'/>"/></td>
    <td align="center"><f:checkbox name="dblColumn" value="false"/></td>
  </tr>
  </c:if>
  <c:if test="${!fnx:contains_co(names,'p5')}">
  <tr>
    <td><input type="checkbox" name="control"/></td>
    <td align="center">p5
      <input type="hidden" name="name" value="p5"/>
      <input type='hidden' name='property' value='{"type":101,"innerType":3}'/>
      <input type='hidden' name='custom' value='{}'/>
    </td>
    <td align="center"><input type="text" name="label" value="<s:message code='node.p5'/>"/></td>
    <td align="center"><f:checkbox name="dblColumn" value="false"/></td>
  </tr>
  </c:if>
  <c:if test="${!fnx:contains_co(names,'p6')}">
  <tr>
    <td><input type="checkbox" name="control"/></td>
    <td align="center">p6
      <input type="hidden" name="name" value="p6"/>
      <input type='hidden' name='property' value='{"type":101,"innerType":3}'/>
      <input type='hidden' name='custom' value='{}'/>
    </td>
    <td align="center"><input type="text" name="label" value="<s:message code='node.p6'/>"/></td>
    <td align="center"><f:checkbox name="dblColumn" value="false"/></td>
  </tr>
  </c:if>
  <c:if test="${!fnx:contains_co(names,'text')}">
  <tr>
    <td><input type="checkbox" name="control"/></td>
    <td align="center">text
      <input type="hidden" name="name" value="text"/>
      <input type='hidden' name='property' value='{"type":50,"innerType":2}'/>
      <input type='hidden' name='custom' value='{}'/>
    </td>
    <td align="center"><input type="text" name="label" value="<s:message code='node.text'/>"/></td>
    <td align="center"><f:checkbox name="dblColumn" value="false"/></td>
  </tr>
  </c:if>
  </tbody>
</table>
</form>
</body>
</html>
