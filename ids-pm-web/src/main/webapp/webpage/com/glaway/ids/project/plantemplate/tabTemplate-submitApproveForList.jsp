<%@ page language="java" import="java.util.*" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/context/mytags.jsp"%>
<!DOCTYPE html>
<html>
<head>
<title>页签模板提交审批</title>
<t:base type="jquery,easyui_iframe,tools"></t:base>
<script src="webpage/com/glaway/ids/project/plantemplate/planTemplate.js"></script>
<script type="text/javascript">

</script>
</head>
<body>
	<div class="easyui-layout" fit="true">
		<div region="center" style="padding: 1px;">
			<fd:form id="submitApproveTable">
				<input id="leader" name="leader" type="hidden" /> 
				<fd:inputSearchUser id="leaderId" name="leaderId" title="{com.glaway.ids.pm.project.plan.basicLine.leader}" required="true">
					<fd:eventListener event="beforeAffirmClose" listener="setLeader" needReturn="true" />
				</fd:inputSearchUser>
				
				<input id="deptLeader" name="deptLeader" type="hidden" />
				<fd:inputSearchUser id="deptLeaderId" name="deptLeaderId" title="{com.glaway.ids.pm.project.plan.basicLine.deptLeader}" required="true">
					<fd:eventListener event="beforeAffirmClose" listener="setDeptLeader" needReturn="true" />
				</fd:inputSearchUser>			
			</fd:form>
		</div>
	</div>
	
<script>
	function setLeader(obj) {
		var username = ""; // 工号
		if (obj && obj.length > 0) {
			var singleUser = obj[0].split(':');
			username = singleUser[2];
		}
		$('#leader').val(username);
		
		return true;
	}
	
	function setDeptLeader(obj) {
		var username = ""; // 工号
		if (obj && obj.length > 0) {
			var singleUser = obj[0].split(':');
			username = singleUser[2];
		}
		$('#deptLeader').val(username);
		
		return true;
	}

	function startTabTemProcess() {
		var leader = $('#leader').val();
		var deptLeader = $('#deptLeader').val();

		$('#submitApproveTable') .form('submit', {
			url : 'tabTemplateController.do?doSubmitApprove&tabId=${tabId}',
			queryParams : {
				'leader' : leader,
				'deptLeader' : deptLeader
			}, 
			onSubmit : function() { // 提交
				var isValid = $(this).form('validate');
				return isValid; // 返回false终止表单提交
			},
			success : function(data) {
				var d = $.parseJSON(data);
				if (d.success) {
					var win = $.fn.lhgdialog('getSelectParentWin');
					top.tip(d.msg);
					win.$("#tabTemplateList").datagrid('reload');
					$.fn.lhgdialog("closeAll");
				}
			}
		}); 
	}
</script>
</body>
</html>