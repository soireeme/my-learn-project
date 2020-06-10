<%@ page language="java" import="java.util.*"
	contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/context/mytags.jsp"%>
<!DOCTYPE html>
<html>
<head>
<title>项目分类</title>
<t:base type="jquery,easyui,tools,DatePicker"></t:base>
<script type="text/javascript">
	$(function() {
		
	//		$('#nodeType').css('display', 'none');
	
	});

	function formsubmit() {
		$('#addForm').form(
						'submit',
						{
							onSubmit : function(param) {
								var isValid = $(this).form('validate');
								if (!isValid) {
									$.messager.progress('close'); // 如果表单是无效的则隐藏进度条
								} else {
									var stopFlag = $('#stopFlag').val();
									var parentId = $('#parentId').val();
									var nodeType = $('#path').combobox(
											'getValue');
									if (parentId.length > 0
											&& stopFlag == 'stop'
											&& nodeType == '1') {
										$.messager.progress('close'); // 如果表单是无效的则隐藏进度条
										isValid = false;
										tip('<spring:message code="com.glaway.ids.pm.config.eps.createChildLimit"/>');
									}
								}
								return isValid; // 返回false终止表单提交
							},
							success : function(data) {
								/* 				var json=$.evalJSON(data);
								 var rst = ajaxRstAct(json);
								 if(json.success){
								 $.fn.lhgdialog("closeSelect");
								 } */
								var d = $.parseJSON(data);
								var win = $.fn.lhgdialog("getSelectParentWin");
								top.tip(d.msg);
								if (d.success) {
									win.reloadEpsTable();
									$.fn.lhgdialog("closeSelect");
								} else {
									return false;
								}
							}
						});
	}
</script>
</head>
<body>
	<fd:form id="addForm" url="epsConfigController.do?doAdd">
		<input id="parentId" name="parentId" type="hidden"
			value="${param.parentId}">
		<input id="stopFlag" name="stopFlag" type="hidden"
			value="${param.stopFlag}">
		<input id="rankQuality" name="rankQuality" type="hidden"
			value="${rankQuality}">
		<div id="nodeType">
			<c:if test="${param.type=='after'}">
				<fd:combobox id="path" title="{com.glaway.ids.common.lable.nodeType}" data="2_兄弟节点"
							 value="2" textField="text" editable="false" valueField="value">
				</fd:combobox>
			</c:if>
			<c:if test="${param.type=='child'}">
				<fd:combobox id="path" title="{com.glaway.ids.common.lable.nodeType}" data="1_子节点"
							 value="1" textField="text" editable="false" valueField="value">
				</fd:combobox>
			</c:if>
		</div>
		<fd:inputText id="name" title="{com.glaway.ids.common.lable.name}"
			required="true"></fd:inputText>
		<fd:inputTextArea id="configComment"
			title="{com.glaway.ids.common.lable.remark}"></fd:inputTextArea>
		<input type="button" id="btn_sub" style="display: none;"
			onclick="formsubmit();">
	</fd:form>
</body>