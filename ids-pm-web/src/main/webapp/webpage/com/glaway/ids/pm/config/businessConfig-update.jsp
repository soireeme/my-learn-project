<%@ page language="java" import="java.util.*"
	contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/context/mytags.jsp"%>
<!DOCTYPE html>
<html>
<head>
<title>业务配置</title>
<t:base type="jquery,easyui,tools,DatePicker"></t:base>
<script type="text/javascript">
	function ajaxRstAct(data) {
		var msg = data.msg;
		msg = msg.replace(/“/g, "\"");
		if (!data.success) {
			top.tip(msg);
			return false;
		}
		top.tip(msg);
		return true;
	}
	function formsubmit() {
		$('#modifyForm').form('submit', {
			onSubmit : function(param) {
				var isValid = $(this).form('validate');
				if (!isValid) {
					$.messager.progress('close'); // 如果表单是无效的则隐藏进度条
				}
				return isValid; // 返回false终止表单提交
			},
			success : function(data) {
				var json = $.evalJSON(data);
				var rst = ajaxRstAct(json);
				var win = $.fn.lhgdialog("getSelectParentWin");
				win.reloadBusinessConfigTable('${param.type}');
				if (json.success) {
					$.fn.lhgdialog("closeSelect");
				}
			}
		});
	}
</script>
</head>
<body>
	<fd:form id="modifyForm"
		url="planBusinessConfigController.do?doUpdateForPharse&type=${businessConfig_.configType }">
		<input id="id" name="id" type="hidden" value="${businessConfig_.id }">
		<input id="configType" name="configType" type="hidden"
			value="${businessConfig_.configType }">
		<input id="stopFlag" name="stopFlag" type="hidden"
			value="${businessConfig_.stopFlag }">
		<c:if test="${businessConfig_.configType eq 'PHARSE' }">
			<fd:inputText id="no" title="{com.glaway.ids.common.lable.code}"
				required="true" value='${businessConfig_.no}'></fd:inputText>
		</c:if>
		<c:if test="${!(businessConfig_.configType eq 'PHARSE') }">
			<fd:inputText id="no" title="{com.glaway.ids.common.lable.code}"
				required="true" value='${businessConfig_.no}' readonly="true"></fd:inputText>
		</c:if>
		<fd:inputText id="name" title="{com.glaway.ids.common.lable.name}"
			required="true" value='${businessConfig_.name}'></fd:inputText>
		<fd:inputTextArea id="configComment"
			title="{com.glaway.ids.common.lable.remark}"
			value='${businessConfig_.configComment}'></fd:inputTextArea>
		<input type="button" id="btn_sub" style="display: none;"
			onclick="formsubmit();">
	</fd:form>
</body>