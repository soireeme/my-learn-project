<%@ page language="java" import="java.util.*"
	contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/context/mytags.jsp"%>
<!DOCTYPE html>
<html>
<head>
<t:base type="jquery,easyui,tools,DatePicker"></t:base>
<link rel="stylesheet" type="text/css" href="plug-in/jquery-easyui/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="plug-in/jquery-easyui/themes/icon.css">

</head>
<body>
	<div class="easyui-panel" fit="true">
		<input id="useObjectId" name="useObjectId" type="hidden" value="${deliverablesInfo_.useObjectId}">
		<input id="useObjectType" name="useObjectType" type="hidden" value="${deliverablesInfo_.useObjectType}">
		<fd:datagrid checkbox="true"  fitColumns="true"  checked="true" checkOnSelect="true" idField="id" id="deliverablesList"  pagination="false"
			url="taskFlowResolveController.do?datagridInheritlist" fit="true"  >
			<fd:dgCol title="{com.glaway.ids.pm.project.plan.deliverables.deliverableName}"  field="name"  sortable="false"/>
		</fd:datagrid>
	</div>

<script src="webpage/com/glaway/ids/project/plan/planList.js"></script>
<script type="text/javascript">

	function submitSelectData(){
	    var names = [];
		var datas;
	    var rows = $("#deliverablesList").datagrid('getSelections');
	    if (rows.length > 0) {
			for ( var i = 0; i < rows.length; i++) {
				names.push(rows[i].name);
			}
			 datas= {
						names : names.join(',')
				};
			$.ajax({
				url : 'taskFlowResolveController.do?doAddInheritDocument',
				async : false,
				cache : false,
				type : 'post',
				data : datas,
				cache : false,
				success : function(data) {
					var d = $.parseJSON(data);
					if (d.success) {
						var win = $.fn.lhgdialog("getSelectParentWin") ;
						win.initOutputsFlowTask();
						setTimeout(
								function(){
									$.fn.lhgdialog("closeSelect");
								},500
						)
					}
					else{
						top.tip(d.msg);
					} 
				}
			});
		} else {
			top.tip('<spring:message code="com.glaway.ids.pm.project.task.selectAdd"/>');
			return false;
		}
	    return datas;
	}
</script>
</body>