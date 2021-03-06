<%@ page language="java" import="java.util.*" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/context/mytags.jsp"%>
<!DOCTYPE html>
<html>
<head>
<title>项目计划变更选择审批人</title>
<t:base type="jquery,easyui,tools"></t:base>
<script src="webpage/com/glaway/ids/project/plan/planList.js"></script>
<script>
	$(document).ready(function() {
		$("#deliverablesInfoList").datagrid({
			onCheck : onCheck
		});
		begin();
		$('#reasonCancelBtn').focus();
	});

	function onCheck(index, row) {
		if (row.origin != undefined) {
			$("#deliverablesInfoList").datagrid('uncheckRow', index);
			return false;
		}
	}

	function viewDocumentDis(val, row, value) {
		if (row.origin != undefined) {
			return '<a style="color:gray">' + row.name + '</a>';
		} else {
			return '<a style="color:black">' + row.name + '</a>';
		}
	}

	function begin() {
		if('${temporaryPlan_.parentPlanId}' == ''|| '${temporaryPlan_.parentPlanId}' == null || '${temporaryPlan_.parentPlanId}' == undefined){
			$("#inheritParent").hide();
		}
		$('#changeReason').panel({
			closed : false
		});
		$('#changeInfo').panel({
			closed : true
		});
		$('#changeAnalysis').panel({
			closed : true
		});
		$('#changeTotal').panel({
			closed : true
		});
		$('#clear').hide();
	}

	function nextOne() {
		//var changeType = $('#changeType').combobox('getValue');
		var changeType = $('#changeType').combotree('getValue');
		var changeRemark = $('#changeRemark').val();
		var win = $.fn.lhgdialog("getSelectParentWin");
		if (changeType == "") {
			win.tip('<spring:message code="com.glaway.ids.pm.project.plan.emptyChangeType"/>');
			return false;
		}
		if (changeRemark.length > 200) {
			win.tip('<spring:message code="com.glaway.ids.common.remarkLength"/>')
			return false;
		}
		$('#changeReason').panel({closed : true});
		$('#changeInfo').panel({closed : false});
		$('#formCancelBtn').focus();
		$('#changeAnalysis').panel({closed : true});
		$('#changeTotal').panel({closed : true});
		start();
	}
	//单击修改的索引保存
	var editFormElementIndex = undefined;
	//双击修改的索引保存
	var editTwoClick = undefined;
	function endFormElementEditing() {
		if (editFormElementIndex == undefined) {
			return true
		}
		if ($('#resourceList').datagrid('validateRow', editFormElementIndex)) {
			$('#resourceList').datagrid('endEdit', editFormElementIndex);
			editFormElementIndex = undefined;
			return true;
		} else {
			return false;
		}
	}
	//单击修改事件
	function onClickPlanRow(index) 
	{	
		
		//单击选中每一行保存之前双击修改的数据  修改行默认不选中
		if ($('#resourceList').datagrid('validateRow', editTwoClick)) 
		{
			$('#resourceList').datagrid('endEdit', editTwoClick);
			$('#resourceList').datagrid('unselectRow', editTwoClick);
			editTwoClick = undefined;
		}
		
		
	}
	
	
	//双击修改事件
	function onClickPlanRowTwo(index)
	{
		
		if(editTwoClick!=index)
		{	
			if ($('#resourceList').datagrid('validateRow', editTwoClick)) 
			{
				$('#resourceList').datagrid('endEdit', editTwoClick);
				editTwoClick = undefined;
			}
			$('#resourceList').datagrid('selectRow', index).datagrid('beginEdit', index);
			editTwoClick=index;
		}else
		{
			$('#resourceList').datagrid('selectRow', editTwoClick);
		}
		
		
	}
	
	

	function nextTwo() {
		var parentStartTime = $('#parentStartTime').val();
		var parentEndTime = $('#parentEndTime').val();
		var preposeEndTime = $('#preposeEndTime').val();
		var win = $.fn.lhgdialog("getSelectParentWin");
		var planName = $('#planName').val();
		if (planName == "") {
			win.tip('<spring:message code="com.glaway.ids.pm.project.plan.emptyName"/>');
			return false;
		}
		if (planName.length > 30) {
			win.tip('<spring:message code="com.glaway.ids.pm.project.plan.basicLine.nameLength"/>')
			return false;
		}
		var owner = $('#owner').combobox('getValue');
		var userList = eval($('#userList').val());
		var ownerText = $('#owner').combobox('getText');
		var pdOwner = 0;
		for (var i = 0; i < userList.length; i++) {
			var a = ownerText.indexOf(userList[i].realName);
			if (a == 0) {
				pdOwner = 1;
				break;
			}
		}
		if(pdOwner == 0){
			top.tip('负责人不存在,请重新输入');
			return false;
		}
		
		if (owner == "") {
			win.tip('<spring:message code="com.glaway.ids.pm.project.plan.emptyManager"/>');
			return false;
		}

		

		var a = 0;
		for (var i = 0; i < userList.length; i++) {
			if (owner == userList[i].id) {
				a = 1;
			}
		}

		var planStartTime = $('#planStartTime').datebox('getValue');
		if (planStartTime == "") {
			win.tip('<spring:message code="com.glaway.ids.pm.project.plan.emptyStart"/>');
			return false;
		}

		var parentPlanName = $('#parentPlanName').val();
		if (parentPlanName != undefined && parentPlanName != '') {
			if ((planStartTime < parentStartTime) || (planStartTime > parentEndTime)) {
				//"计划开始时间必须收敛于父级的计划【"+ parentPlanName+"】的时间或项目时间 :"+parentStartTime+'~'+parentEndTime
				win.tip('<spring:message code="com.glaway.ids.pm.project.plan.startInParentOrProjectTime" arguments="'
						+ parentPlanName + ',' + parentStartTime + '~' + parentEndTime + '"/>');
				return false;
			}
		} else {
			if ((planStartTime < parentStartTime) || (planStartTime > parentEndTime)) {
				//"计划开始时间必须收敛于项目时间 :"+parentStartTime+'~'+parentEndTime
				win.tip('<spring:message code="com.glaway.ids.pm.project.plan.startInParentTime" arguments="'
						+ parentStartTime + '~' + parentEndTime + '"/>');
				return false;
			}
		}

		var planEndTime = $('#planEndTime').datebox('getValue');
		if (planEndTime == "") {
			win.tip('<spring:message code="com.glaway.ids.pm.project.plan.emptyEnd"/>');
			return false;
		}

		if (parentPlanName != undefined && parentPlanName != '') {
			if ((planEndTime < parentStartTime) || (planEndTime > parentEndTime)) {
				win.tip('<spring:message code="com.glaway.ids.pm.project.plan.startInParentOrProjectTime" arguments="' 
						+ parentPlanName + ',' + parentStartTime + '~' + parentEndTime + '"/>');
				return false;
			}
		} else {
			if ((planEndTime < parentStartTime) || (planEndTime > parentEndTime)) {
				win.tip('<spring:message code="com.glaway.ids.pm.project.plan.startInParentTime" arguments="'
						+ parentStartTime + '~' + parentEndTime + '"/>');
				return false;
			}
		}

		var preposeplanName = $('#preposeplanName').val();
		if (preposeEndTime != null && preposeEndTime != '' && preposeEndTime != undefined) {
			if (preposeEndTime >= planStartTime) {
				//"计划开始时间不能早于其前置计划【"+preposeplanName+"】的结束时间 :"+preposeEndTime
				win.tip('<spring:message code="com.glaway.ids.pm.project.plan.postpositionStartNoEarlierThan" arguments="' + preposeEndTime + '"/>');
				return false;
			}
		}

		if (planEndTime < planStartTime) {
			win.tip('<spring:message code="com.glaway.ids.pm.project.plan.endNoEarlierThanStart"/>');
			return false;
		}

		var workTime = $('#workTime').val();
		var reg = new RegExp("^[0-9]*$");
		if (workTime == "") {
			win.tip('<spring:message code="com.glaway.ids.pm.project.plan.emptyPeriod"/>');
			return false;
		}

		if (!reg.test(workTime)) {
			win.tip('<spring:message code="com.glaway.ids.pm.project.plan.periodMustNumber"/>');
			return false;
		}

		var remark = $('#remark').val();
		if (remark.length > 200) {
			win.tip('<spring:message code="com.glaway.ids.common.remarkLength"/>');
			return false;
		}

		var rows = $('#resourceList').datagrid('getRows');
		var planStartTime = $('#planStartTime').datebox('getValue');
		var planEndTime = $('#planEndTime').datebox('getValue');
		var t = $('#resourceList');
		for (var i = 0; i < rows.length; i++) {
			t.datagrid('endEdit', i);
		}
		editFormElementIndex = undefined;

		for (var i = 0; i < rows.length; i++) {
			var resourceName = rows[i].resourceName;
			if (rows[i].startTime == "") {
				tip('<spring:message code="com.glaway.ids.pm.project.plan.resource.emptyStartParam"  arguments="' + resourceName + '"/>');
				return false;
			}

			if (rows[i].endTime == "") {
				tip('<spring:message code="com.glaway.ids.pm.project.plan.resource.emptyStartParam"  arguments="' + resourceName + '"/>');
				return false;
			}

			if (rows[i].endTime < rows[i].startTime) {
				tip('<spring:message code="com.glaway.ids.pm.project.plan.resource.endNoEarlierThanStartParam"  arguments="' + resourceName + '"/>');
				return false;
			}

			if ((rows[i].startTime < planStartTime) || (rows[i].startTime > planEndTime)) {
				// "资源"+resourceName+"的开始时间必须收敛于计划时间 :"+planStartTime+'~'+planEndTime
				tip('<spring:message code="com.glaway.ids.pm.project.plan.resource.startInPlanTimeParam"  arguments="' 
						+ resourceName + ',' + planStartTime + '~' + planEndTime + '"/>');
				return false;
			}

			if ((rows[i].endTime < planStartTime)
					|| (rows[i].endTime > planEndTime)) {
				// "资源"+resourceName+"的结束时间必须收敛于计划时间 :"+planStartTime+'~'+planEndTime
				tip('<spring:message code="com.glaway.ids.pm.project.plan.resource.endInPlanTimeParam"  arguments="' 
						+ resourceName + ',' + planStartTime + '~' + planEndTime + '"/>');
				return false;
			}

			if (rows[i].useRate == '') {
				tip('<spring:message code="com.glaway.ids.pm.project.plan.resource.emptyPercentParam"  arguments="' + resourceName + '"/>');
				return false;
			}

			if (rows[i].useRate > 1000) {
				tip('<spring:message code="com.glaway.ids.pm.project.plan.resource.percentUpperLimitParam"  arguments="' + resourceName+ '"/>');
				return false;
			}

			if (rows[i].useRate < 0) {
				tip('<spring:message code="com.glaway.ids.pm.project.plan.resource.percentLowerLimitParam"  arguments="' + resourceName+ '"/>');
				return false;
			}
		}

		modifyResourceList();
		changeAnalysisInit();
		$('#analysisCancelBtn').focus();
	}

	function modifyResourceList() {
		var rows = $('#resourceList').datagrid('getRows');
		var resourceNames = [];
		var useRates = [];
		var startTimes = [];
		var endTimes = [];

		if (rows.length > 0) {
			for (var i = 0; i < rows.length; i++) {
				resourceNames.push(rows[i].resourceName);
				useRates.push(rows[i].useRate);
				startTimes.push(rows[i].startTime);
				endTimes.push(rows[i].endTime);
			}

			$.ajax({
				url : 'planChangeController.do?modifyResourceList',
				type : 'post',
				data : {
					resourceNames : resourceNames.join(','),
					useRates : useRates.join(','),
					startTimes : startTimes.join(','),
					endTimes : endTimes.join(','),
				},
				cache : false,
				success : function(data) {
				}
			});
		}
	}

	function nextThree() {
		$('#changeTotal').panel({closed : false});
		$('#changeInfo').panel({closed : true});
		$('#changeReason').panel({closed : true});
		$('#changeAnalysis').panel({closed : true});
		$('#totalCancelBtn').focus();
		//$("#startPlanchange").attr({disabled : false});
		initChangeVo();
	}

	function beforeTwo() {
		$('#changeReason').panel({closed : false});
		$('#changeInfo').panel({closed : true});
		$('#changeAnalysis').panel({closed : true});
		$('#changeTotal').panel({closed : true});
		$('#reasonCancelBtn').focus();
	}

	function beforeThree() {
		$('#changeInfo').panel({closed : false});
		$('#changeReason').panel({closed : true});
		$('#changeAnalysis').panel({closed : true});
		$('#changeTotal').panel({closed : true});
		$('#formCancelBtn').focus();
	}

	function beforeFour() {
		$('#changeAnalysis').panel({closed : false});
		$('#changeInfo').panel({closed : true});
		$('#changeReason').panel({closed : true});
		$('#changeTotal').panel({closed : true});
		$('#analysisCancelBtn').focus();
	}

	function viewPlan() {
		$('#one').panel({
			closed : false
		});
		$('#two').panel({
			closed : true
		});
		$('#three').panel({
			closed : true
		});
	}
	
	function viewDocument() {
		$('#one').panel({
			closed : true
		});
		$('#two').panel({
			closed : false
		});
		$('#three').panel({
			closed : true
		});
		initDocumentChange();
	}
	
	function viewResource() {
		$('#one').panel({
			closed : true
		});
		$('#two').panel({
			closed : true
		});
		$('#three').panel({
			closed : false
		});
		editFormElementIndex = undefined;
		initResourceChange();
	}
	
	function start() {
		//var changeType = $('#changeType').combobox('getValue');
		var changeType = $('#changeType').combotree('getValue');
		var planChangeCategoryList = eval($('#planChangeCategoryListStr').val());
		for (var i = 0; i < planChangeCategoryList.length; i++) {
			if (changeType == planChangeCategoryList[i].id) {
				$('#changeTypeAfter').textbox("setValue", planChangeCategoryList[i].name);
			}
		}
		var changeRemark = $('#changeRemark').val();
		$('#changeRemarkAfter').textbox("setValue", changeRemark);
		initInputChange();
		initDocumentChange();
		initResourceChange();
	}

	function addTempPlan() {
		if (checkPlanWithInput()) {
			//$("#startPlanchange").attr({disabled : "disabled"});
			var win = $.fn.lhgdialog("getSelectParentWin");
			var id = $('#id').val();
			var planNumber = $('#planNumber').val();
			var planId = $('#planId').val();
			var projectId = $('#projectId').val();
			var parentPlanId = $('#parentPlanId').val();
			var beforePlanId = $('#beforePlanId').val();
			var bizCurrent = $('#bizCurrent').val();
			var planName = $('#planName').val();
			var remark = $('#remark').val();
			var owner = $('#owner').combobox('getValue');
			var userList = eval($('#userList2').val());
			for (var i = 0; i < userList.length; i++) {
				var a = owner.indexOf(userList[i].realName);
				if (a == 0) {
					owner = userList[i].id;
				}
			}
			var planLevel = $('#planLevel').combobox('getValue');
			var planStartTime = $('#planStartTime').datebox('getValue');
			var workTime = $('#workTime').val();
			var planEndTime = $('#planEndTime').datebox('getValue');
			var milestone = $('#milestone').combobox('getValue');
			var taskNameType = $('#taskNameType').combobox('getValue');
			var taskType = $('#taskType').combobox('getValue');

			var preposeIds = $('#preposeIds').val();
			var changeRemark = $('#changeRemark').val();
			//var changeType = $('#changeType').combobox('getValue');
			var changeType = $('#changeType').combotree('getValue');
			var changeInfoDocPath = $('#changeInfoDocPath').val();
			var preposeIds = $('#preposeIds').val()

			var leader = $('#leader').val();
			var deptLeader = $('#deptLeader').val();
			if (leader == '') {
				win.tip('<spring:message code="com.glaway.ids.common.emptyOfficeLeader"/>');
				return false;
			} else if (deptLeader == '') {
				win.tip('<spring:message code="com.glaway.ids.common.emptyDepartLeader"/>');
				return false;
			} else {
				var fileSize = $('#file_upload').data('uploadify').queueData.queueLength;
		  		/* if (fileSize > 0) {
					$('#file_upload').fduploadify('upload');
		  		}
		  		else{ */
					$.post('planChangeController.do?doSave', {
						'id' : id,
						'planNumber' : planNumber,
						'projectId' : projectId,
						'planId' : planId,
						'parentPlanId' : parentPlanId,
						'beforePlanId' : beforePlanId,
						'planStartTime' : planStartTime,
						'planEndTime' : planEndTime,
						'bizCurrent' : bizCurrent,
						'remark' : remark,
						'planName' : planName,
						'owner' : owner,
						'planLevel' : planLevel,
						'taskNameType' : taskNameType,
						'taskType' : taskType,
						'workTime' : workTime,
						'milestone' : milestone,
						'preposeIds' : preposeIds,
						'changeRemark' : changeRemark,
						'changeType' : changeType,
						'changeInfoDocPath' : changeInfoDocPath,
						'preposeIds' : preposeIds
					}, function(data) {
						var d = $.parseJSON(data);
						if(d.success){
							startPlanChange();
						}
						else{
							top.tip(d.msg);
						}
					});
				//}
			}
		}
	}

	function viewResourceType(val, row, value) {
		var resoure = row.resourceInfo;
		if (resoure != undefined && resoure != null && resoure != '') {
			var parent = resoure.parent;
			if (parent != undefined && parent != null && parent != '') {
				return parent.name;
			}
		}
		return val;
	}

	function viewResourceName(val, row, value) {
		var resoure = row.resourceInfo;
		if (resoure != undefined && resoure != null && resoure != '') {
			return resoure.name;
		}
		return val;
	}

	// 维护资源
	function addResource() {
		gridname = 'resourceList';

		var rows = $('#resourceList').datagrid('getRows');
		var t = $('#resourceList');
		for (var i = 0; i < rows.length; i++) {
			t.datagrid('endEdit', i);
		}
		editFormElementIndex = undefined;
		modifyResourceList();
		var dialogUrl = 'planChangeController.do?goAddResourceTemp&useObjectId='
				+ $('#useObjectId').val()
				+ '&useObjectType='
				+ $('#useObjectType').val()
				+ '&planStartTime='
				+ $('#planStartTime').datebox('getValue')
				+ '&planEndTime='
				+ $('#planEndTime').datebox('getValue');
		createDialog('addResourceDialog', dialogUrl);
		
		
	}

	function addResourceDialog(iframe) {
		var flg = iframe.getLoadData();
		if (flg && initResource2(flg)) {
			return true;
		}
		return false;
	}

	// 新增交付项
	function addDeliverable() {
		gridname = 'deliverablesInfoList';
		var dialogUrl = 'planChangeController.do?goAddDocumentTemp&useObjectId='
				+ $('#useObjectId').val()
				+ '&useObjectType='
				+ $('#useObjectType').val();
		createDialog('addDeliverableDialog', dialogUrl);
	}

	// 新增交付项
	function addInput() {
		gridname = 'inputList';
		var dialogUrl = 'planChangeController.do?goAddInputTemp&useObjectId='
				+ $('#useObjectId').val() + '&useObjectType='
				+ $('#useObjectType').val() + '&preposeIds='
				+ $('#preposeIds').val();
		createDialog('addInputDialog', dialogUrl);
	}

	function addDeliverableDialog(iframe) {
		var flg = iframe.getLoadData();
		if (flg && initDocument2(flg)) {
			return true;
		}
		return false;
	}

	function addInputDialog(iframe) {
		var flg = iframe.getLoadData();
		if (flg && initInput2('')) {
			return true;
		}
		return false;
	}

	// 使用百分比
	function viewUseRate2(val, row, value) {
		return progressRateGreen2(val);
	}

	function progressRateGreen2(val) {
		if (val == undefined || val == null || val == '') {
			val = 0;
		}
		return val + '%';
	}

	var preposeIdActual = $('#preposeIds').val();
	/**
	 * 选择前置计划页面
	 */
	function selectPreposePlan(hiddenId, textId) {
		var url = 'planController.do?goPlanPreposeTree';
		if ($('#projectId').val() != "") {
			url = url + '&projectId=' + $('#projectId').val();
		}
		if ($('#parentPlanId').val() != "") {
			url = url + '&parentPlanId=' + $('#parentPlanId').val();
		}
		if ($('#planId').val() != "") {
			url = url + '&id=' + $('#planId').val();
		}
		if ($('#preposeIds').val() != "") {
			preposeIdActual = $('#preposeIds').val();
			url = url + '&preposeIds=' + $('#preposeIds').val();
		}
		createPopupwindow('项目计划', url, '', '', hiddenId, textId);
	}

	/**
	 * 查看时的弹出窗口
	 */
	function createPopupwindow(title, url, width, height, hiddenId, textId) {
		width = width ? width : 800;
		height = height ? height : 750;
		if (width == "100%" || height == "100%") {
			width = document.body.offsetWidth;
			height = document.body.offsetHeight - 100;
		}
		createDialog('preposePlanDialog', url);

	}

	function preposePlanDialog(iframe) {
		var preposeIds;
		var preposePlans;
		var preposeEndTime;
		var selectedId = iframe.planPreposeList.getSelectedRowId();
		if (selectedId != undefined && selectedId != null && selectedId != '') {
			var selectedIdArr = selectedId.split(",");
			if (selectedIdArr.length > 0) {
				for (var i = 0; i < selectedIdArr.length; i++) {
					var id = selectedIdArr[i];
					if (preposeIds != null && preposeIds != '' && preposeIds != undefined) {
						preposeIds = preposeIds + ',' + id;
					} else {
						preposeIds = id;
					}
					var planName = iframe.planPreposeList.getRowAttribute(id, 'displayName');
					if (preposePlans != null && preposePlans != '' && preposePlans != undefined) {
						preposePlans = preposePlans + ',' + planName;
					} else {
						preposePlans = planName;
					}
					var planEndTime = iframe.planPreposeList.getRowAttribute(id, 'planEndTime');
					if (preposeEndTime != null && preposeEndTime != '' && preposeEndTime != undefined) {
						if (preposeEndTime < planEndTime) {
							preposeEndTime = planEndTime;
						}
					} else {
						preposeEndTime = planEndTime;
					}
				}
			}
		}
		savePreposePlan(preposeIds, preposePlans, preposeEndTime);
	}

	/**
	 * 前置计划选择后，更新页面值（每次均覆盖）
	 */
	function savePreposePlan(preposeIds, preposePlans, preposeEndTime) {
		if (preposeIds != null && preposeIds != '' && preposeIds != undefined) {
			$('#preposeIds').val(preposeIds);
		} else {
			$('#preposeIds').val('');
		}
		if (preposePlans != null && preposePlans != '' && preposePlans != undefined) {
			$('#preposePlans').textbox("setValue", preposePlans);
		} else {
			$('#preposePlans').textbox("setValue", "");
		}
		// 前置计划的最晚完成时间
		if (preposeEndTime != null && preposeEndTime != '' && preposeEndTime != undefined) {
			$('#preposeEndTime').val(preposeEndTime);

			$.ajax({
				url : 'planController.do?getNextDay&projectId=' + $('#projectId').val(),
				type : 'post',
				data : {
					preposeEndTime : preposeEndTime
				},
				cache : false,
				success : function(data) {
					if (data != null) {
						var d = $.parseJSON(data);
						if (d.success == true) {
							preposeEndTime = d.obj;
							$('#planStartTime').datebox("setValue", preposeEndTime);
						} else {
						}
					} else {
					}
				}
			});

		} else {
			$('#preposeEndTime').val('');
			$('#planStartTime').datebox("setValue", $("#parentStartTime").val());
		}
	}

	function viewStartEndTime(val, row, value) {
		var start = row.startTime;
		var end = row.endTime;
		if ((start != undefined && start != null && start != '') && (end != undefined && end != null && end != '')) {
			return dateFmtYYYYMMDD(start) + "~" + dateFmtYYYYMMDD(end);
		}
		return "";
	}

	function initDocumentChange() {
		$.ajax({
			type : 'POST',
			url : 'planChangeController.do?documentList',
			async : false,
			data : {},
			success : function(data) {
				try {
					$("#deliverablesInfoList").datagrid("loadData",data);
				}
				catch(e) {
				}
				finally {
				}
			}
		});
	}

	function initResourceChange() {
		$.ajax({
			type : 'POST',
			url : 'planChangeController.do?resourceList',
			async : false,
			data : {},
			success : function(data) {
				try {
					$("#resourceList").datagrid("loadData", data);
				}
				catch(e) {
				}
				finally {
				}
			}
		});
	}

	function initInputChange() {
		/* if ($('#preposeIds').val() != undefined && $('#preposeIds').val() != '') {
			$('#haveNopre').css("display", "none");
			$('#havePre').css("display", "block"); */
			$.ajax({
				type : 'POST',
				url : 'planChangeController.do?inputList',
				async : false,
				data : {
					useObjectId : $('#useObjectId').val(),
					useObjectType : $('#useObjectType').val()
				},
				success : function(data) {
					try {
						$("#inputList").datagrid("loadData", data);
					}
					catch(e) {
					}
					finally {
					}
				}
			});
		/* } else {
			$('#havePre').css("display", "none");
			$('#haveNopre').css("display", "block");
		} */
	}

	function initChangeVo() {
		var id = $('#id').val();
		var planNumber = $('#planNumber').val();
		var planId = $('#planId').val();
		var projectId = $('#projectId').val();
		var parentPlanId = $('#parentPlanId').val();
		var beforePlanId = $('#beforePlanId').val();
		var bizCurrent = $('#bizCurrent').val();
		var planName = $('#planName').val();
		var remark = $('#remark').val();
		var owner = $('#owner').combobox('getValue');
		var userList = eval($('#userList2').val());
		for (var i = 0; i < userList.length; i++) {
			var a = owner.indexOf(userList[i].realName);
			if (a == 0) {
				owner = userList[i].id;
				break;
			}
		}
		var ownerRealName = $('#owner').combobox('getText');
		var planLevel = $('#planLevel').combobox('getValue');
		var planLevelName = $('#planLevel').combobox('getText');
		var planStartTime = $('#planStartTime').datebox('getValue');
		var planStartTimeView = $('#planStartTime').datebox('getText');
		var workTime = $('#workTime').val();
		var planEndTime = $('#planEndTime').datebox('getValue');
		var planEndTimeView = $('#planEndTime').datebox('getText');
		var milestone = $('#milestone').combobox('getValue');
		var preposeIds = $('#preposeIds').val();
		var changeRemark = $('#changeRemark').val();
		//var changeType = $('#changeType').combobox('getValue');
		var changeType = $('#changeType').combotree('getValue');
		var changeInfoDocPath = $('#changeInfoDocPath').val();
		var preposeIds = $('#preposeIds').val();
		var preposePlans = $('#preposePlans').val();
		var ownerDept = $('#ownerDept').val();
		var leader = $('#leader').val();
		var deptLeader = $('#deptLeader').val();
		$.ajax({
			type : 'POST',
			url : 'planChangeController.do?planChangeVo',
			async : false,
			data : {
				'id' : id,
				'planNumber' : planNumber,
				'projectId' : projectId,
				'planId' : planId,
				'parentPlanId' : parentPlanId,
				'beforePlanId' : beforePlanId,
				'planStartTime' : planStartTime,
				'planStartTimeView' : planStartTimeView,
				'planEndTime' : planEndTime,
				'planEndTimeView' : planEndTimeView,
				'bizCurrent' : bizCurrent,
				'remark' : remark,
				'planName' : planName,
				'owner' : owner,
				'ownerDept' : ownerDept,
				'ownerRealName' : ownerRealName,
				'planLevel' : planLevel,
				'planLevelName' : planLevelName,
				'workTime' : workTime,
				'milestone' : milestone,
				'preposeIds' : preposeIds,
				'preposePlans' : preposePlans,
				'changeRemark' : changeRemark,
				'changeType' : changeType,
				'changeInfoDocPath' : changeInfoDocPath,
				'preposeIds' : preposeIds
			},
			success : function(data) {
				$("#planChangeVo").datagrid("loadData", data);
			}
		});
	}

	function changeAnalysisInit() {
		$.post(
			'planChangeController.do?checkChildPostposeInfluenced',
			{
				planStartTime : $('#planStartTime').datebox('getValue'),
				planEndTime : $('#planEndTime').datebox('getValue')
			},
			function(data) {
				var d = $.parseJSON(data);
				if (d.success) {
					var msg = d.msg;
					var a = msg.indexOf("产生影响");
					var win = $.fn.lhgdialog("getSelectParentWin");
					if (msg == null || msg == '' || msg == undefined || msg == '<br/>') {
						var planChildTimeArea = '系统未检测到此次变更产生的影响';
						$('#planChildTimeArea').html(planChildTimeArea);
						$("#influencedNull").attr("style", "display:none;");
	
						$('#changeInfo').panel({
							closed : true
						});
						$('#changeReason').panel({
							closed : true
						});
						$('#changeAnalysis').panel({
							closed : false
						});
						$('#changeTotal').panel({
							closed : true
						});
					} else if (a == 0) {
						$("#influencedNull").attr("style", "display:block;");
						var planChildTimeArea = '子计划（时间需要收敛在'
								+ $('#planStartTime').datebox('getValue')
								+ '~'
								+ $('#planEndTime').datebox('getValue') + '）';
						var planPostposeTimeArea = '后置计划（开始时间不得早于' + d.obj + '）';
						$('#planChildTimeArea').html(planChildTimeArea);
						$('#planPostposeTimeArea').html(planPostposeTimeArea);
						var tableId1 = 'temporaryPlanChildList';
						var url1 = 'planChangeController.do?temporaryPlanChildList&planStartTime='
								+ $('#planStartTime').datebox('getValue')
								+ '&planEndTime='
								+ $('#planEndTime').datebox('getValue');
						loadTableData(tableId1, url1);
	
						var tableId2 = 'temporaryPlanPostposeList';
						var url2 = 'planChangeController.do?temporaryPlanPostposeList&planStartTime='
								+ $('#planStartTime').datebox('getValue')
								+ '&planEndTime='
								+ $('#planEndTime').datebox('getValue');
						loadTableData(tableId2, url2);
	
						$('#changeInfo').panel({
							closed : true
						});
						$('#changeReason').panel({
							closed : true
						});
						$('#changeAnalysis').panel({
							closed : false
						});
						$('#changeTotal').panel({
							closed : true
						});
					} else {
						win.tip(msg);
					}
				}
			});
	}

	function loadTableData(tableId, url) {
		$.ajax({
			url : url,
			type : 'post',
			data : {},
			cache : false,
			success : function(data) {
				$("#" + tableId).datagrid("loadData", data);
			}
		});
	}

	// 删除交付项
	function deleteSelections(gridname, url) {
		var rows = $("#" + gridname).datagrid('getSelections');
		var win = $.fn.lhgdialog("getSelectParentWin");
		for (var i = 0; i < rows.length; i++) {
			if (rows[i].origin != '' && rows[i].origin != null && rows[i].origin != undefined) {
				win.tip('<spring:message code="com.glaway.ids.pm.project.plan.deliveryDelLimit" arguments="' + rows[i].name + '"/>');
				return false;
			}
		}

		var ids = [];
		var names = [];
		if (rows.length > 0) {
			top.Alert.confirm(
				'<spring:message code="com.glaway.ids.common.confirmDel"/>',
				function(r) {
					if (r) {
						for (var i = 0; i < rows.length; i++) {
							ids.push(rows[i].deliverablesId);
							names.push(rows[i].name);
						}
						$.ajax({
							url : url,
							type : 'post',
							data : {
								ids : ids.join(','),
								names : names.join(',')
							},
							cache : false,
							success : function(data) {
								for (var i = rows.length - 1; i > -1; i--) {
									var a = $("#" + gridname).datagrid('getRowIndex', rows[i]);
									$("#" + gridname).datagrid('deleteRow',$("#" + gridname).datagrid('getRowIndex', rows[i]));
								}
								$("#" + gridname).datagrid('clearSelections');
								initDocument2();
							}
						});
					}
				});
		} else {
			win.tip('<spring:message code="com.glaway.ids.common.selectDel"/>');
		}
	}

	// 删除交付项
	function deleteSelections3(gridname, url) {
		var rows = $("#" + gridname).datagrid('getSelections');
		var win = $.fn.lhgdialog("getSelectParentWin");

		var ids = [];
		var names = [];
		if (rows.length > 0) {
			top.Alert.confirm(
				'<spring:message code="com.glaway.ids.common.confirmDel"/>',
				function(r) {
					if (r) {
						for (var i = 0; i < rows.length; i++) {
							ids.push(rows[i].inputId);
							names.push(rows[i].name);
						}
						$.ajax({
							url : url,
							type : 'post',
							data : {
								ids : ids.join(','),
								names : names.join(',')
							},
							cache : false,
							success : function(data) {
								for (var i = rows.length - 1; i > -1; i--) {
									var a = $("#" + gridname).datagrid('getRowIndex', rows[i]);
									$("#" + gridname).datagrid('deleteRow', $("#" + gridname).datagrid('getRowIndex', rows[i]));
								}
								$("#" + gridname).datagrid('clearSelections');
								initInput2();
							}
						});
					}
				});
		} else {
			win.tip('<spring:message code="com.glaway.ids.common.selectDel"/>');
		}
	}

	// 删除资源
	function deleteSelections2(gridname, url) {
		var rows = $("#" + gridname).datagrid('getSelections');

		var rows22 = $('#resourceList').datagrid('getRows');
		var t = $('#resourceList');
		for (var i = 0; i < rows22.length; i++) {
			t.datagrid('endEdit', i);
		}
		editFormElementIndex = undefined;
		modifyResourceList();
		var win = $.fn.lhgdialog("getSelectParentWin");
		var ids = [];
		if (rows.length > 0) {
			top.Alert.confirm(
				'<spring:message code="com.glaway.ids.common.confirmDel"/>',
				function(r) {
					if (r) {
						for (var i = 0; i < rows.length; i++) {
							ids.push(rows[i].resourceId);
						}
						$.ajax({
							url : url,
							type : 'post',
							data : {
								ids : ids.join(',')
							},
							cache : false,
							success : function(data) {
								for (var i = rows.length - 1; i > -1; i--) {
									var a = $("#" + gridname).datagrid('getRowIndex', rows[i]);
									$("#" + gridname).datagrid('deleteRow', $("#" + gridname).datagrid('getRowIndex', rows[i]));
								}
								$("#" + gridname).datagrid('clearSelections');
								initResource2();
							}
						});
					}
				});
		} else {
			win.tip('<spring:message code="com.glaway.ids.common.selectDel"/>');
		}
	}

	function afterCall() {
		tip('上传完成。');
	}
	
	function afterSubmitChangeInfo(file, data, response) {
		debugger;
		top.jeasyui.util.tagMask('close');
		var win = $.fn.lhgdialog("getSelectParentWin");
		var jsonObj = $.parseJSON(data);
		var fileStr = jsonObj.obj;
		var size = (file.size) / (1024 * 1024);
		if (size > 5) {
			top.tip('<spring:message code="com.glaway.ids.pm.project.plan.docSizeLimit"/>');
			$('#file_upload').uploadify('cancel', '*');
			return false;
		}
		else{
			//$("#startPlanchange").attr({disabled : "disabled"});
			$('changeInfoDocPath').val(fileStr.split(',')[1]);
			var id = $('#id').val();
			var planNumber = $('#planNumber').val();
			var planId = $('#planId').val();
			var projectId = $('#projectId').val();
			var parentPlanId = $('#parentPlanId').val();
			var beforePlanId = $('#beforePlanId').val();
			var bizCurrent = $('#bizCurrent').val();
			var planName = $('#planName').val();
			var remark = $('#remark').val();
			var owner = $('#owner').combobox('getValue');
			var userList = eval($('#userList2').val());
			for (var i = 0; i < userList.length; i++) {
				var a = owner.indexOf(userList[i].realName);
				if (a == 0) {
					owner = userList[i].id;
				}
			}
			var planLevel = $('#planLevel').combobox('getValue');
			var planStartTime = $('#planStartTime').datebox('getValue');
			var workTime = $('#workTime').val();
			var planEndTime = $('#planEndTime').datebox('getValue');
			var milestone = $('#milestone').combobox('getValue');
			var taskNameType = $('#taskNameType').combobox('getValue');
			var taskType = $('#taskType').combobox('getValue');

			var preposeIds = $('#preposeIds').val();
			var changeRemark = $('#changeRemark').val();
			var changeType = $('#changeType').combotree('getValue');
			//var changeType = $('#changeType').combobox('getValue');
			var changeInfoDocPath = $('#changeInfoDocPath').val();
			var preposeIds = $('#preposeIds').val()

			var leader = $('#leader').val();
			var deptLeader = $('#deptLeader').val();
			/* $.post('planChangeController.do?doSave', {
				'id' : id,
				'planNumber' : planNumber,
				'projectId' : projectId,
				'planId' : planId,
				'parentPlanId' : parentPlanId,
				'beforePlanId' : beforePlanId,
				'planStartTime' : planStartTime,
				'planEndTime' : planEndTime,
				'bizCurrent' : bizCurrent,
				'remark' : remark,
				'planName' : planName,
				'owner' : owner,
				'planLevel' : planLevel,
				'taskNameType' : taskNameType,
				'taskType' : taskType,
				'workTime' : workTime,
				'milestone' : milestone,
				'preposeIds' : preposeIds,
				'changeRemark' : changeRemark,
				'changeType' : changeType,
				'changeInfoDocPath' : changeInfoDocPath,
				'preposeIds' : preposeIds
			}, function(data) {
				startPlanChange();
			}); */
		}
	}
	
	
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

	// 资源名称链接事件
	function resourceNameLink(val, row, value) {
		return '<a href="#" onclick="viewResourceCharts(\'' + row.resourceId
				+ '\')" style="color:blue">' + val + '</a>';
	}

	// 资源名称链接事件
	function viewResourceCharts(resourceId) {
		var rows = $("#resourceList").datagrid('getRows');
		var row;
		for (var i = 0; i < rows.length; i++) {
			if (resourceId == rows[i].resourceId) {
				row = rows[i];
				break;
			}
		}
		if (row.useRate != null && row.useRate != '' && row.startTime != null
				&& row.startTime != '' && row.endTime != null && row.endTime != '') {
			var startTime = $('#planStartTime').datebox('getValue');
			var endTime = $('#planEndTime').datebox('getValue');
 			createDialog('resourceDialog', "resourceLinkInfoController.do?goToToBeUsedRateReport&resourceId=" + row.resourceId + "&resourceLinkId=" 
 					+ row.resourceLinkId + "&resourceUseRate=" + row.useRate + "&startTime=" + row.startTime + "&endTime=" + row.endTime 
 					+ "&useObjectId=${temporaryPlan_.planId}"); 
		} else {
			tip('<spring:message code="com.glaway.ids.pm.project.plan.resource.emptyUseInfo"/>');
		}
	}

	function startPlanChange() {
		var leader = $('#leader').val();
		var deptLeader = $('#deptLeader').val();
		$.ajax({
			url : 'planChangeController.do?startPlanChange&changeType=' + 'single'+'&leader='+leader+'&deptLeader='+deptLeader,
			type : 'post',
			data : {
				'leader' : leader,
				'deptLeader' : deptLeader
			},
			cache : false,
			success : function(data) {
				var d = $.parseJSON(data);
				top.tip(d.msg);
				if (d.success) {
					var win = $.fn.lhgdialog("getSelectParentWin");
					var planListSearch = win.planListSearch();
					$.fn.lhgdialog("closeAll");
				}
			}
		});
	}

	// 负责人变更联动
	function ownerChangeOnTree(newValue, oldValue) {
		var departList = eval($('#departList').val());
		var owner = $('#owner').combobox('getValue');
		for (var i = 0; i < departList.length; i++) {
			if (owner == '') {
				$('#ownerDept').textbox("setValue", "");
			} else if (owner == departList[i].userId) {
				$("#ownerDept").textbox("setValue", departList[i].departname);
			}
		}
	}

	function changeType() {
		//var changeType = $('#changeType').combobox('getValue');
		var changeType = $('#changeType').combotree('getValue');
		$('#changeTypeAfter').textbox("setValue", changeType);
	}

	function initDocument2(this_) {
		var datas = "";
		var flg = false;
		if (this_ != null && this_ != '' && this_ != undefined) {
			datas = this_;
		} else {
			datas = {
				useObjectId : $('#useObjectId').val(),
				useObjectType : $('#useObjectType').val()
			}
		}
		$.ajax({
			type : 'POST',
			url : 'planChangeController.do?documentList',
			async : false,
			data : datas,
			success : function(data) {
				try {
					$("#deliverablesInfoList").datagrid('unselectAll');
					$("#deliverablesInfoList").datagrid("loadData", data);
				}
				catch(e) {
					//alert('3e:'+e)
				}
				finally {
					flg= true;
				}
			}
		});
		return flg;
	}

	function initInput2(this_) {
		debugger;
		var datas = "";
		var flg = false;
		if (this_ != null && this_ != '' && this_ != undefined) {
			datas = this_;
		} else {
			datas = {
				useObjectId : $('#useObjectId').val(),
				useObjectType : $('#useObjectType').val()
			}
		}
		$.ajax({
			type : 'POST',
			url : 'planChangeController.do?inputList',
			async : false,
			data : datas,
			success : function(data) {
				try {
					$("#inputList").datagrid('unselectAll');
					$("#inputList").datagrid("loadData", data);
				}
				catch(e) {
					//alert('3e:'+e)
				}
				finally {
					flg= true;
				}
			}
		});
		return flg;
	}

	function initResource2(this_) {
		var datas = "";
		var flg = false;
		if (this_ != null && this_ != '' && this_ != undefined) {
			datas = this_;
		} else {
			datas = {
				useObjectId : $('#useObjectId').val(),
				useObjectType : $('#useObjectType').val()
			}
		}
		$.ajax({
			type : 'POST',
			url : 'planChangeController.do?resourceList',
			async : false,
			data : datas,
			success : function(data) {
				try {
					$("#resourceList").datagrid('unselectAll');
					$("#resourceList").datagrid("loadData", data);
				}
				catch(e) {
					//alert('3e:'+e)
				}
				finally {
					flg= true;
				}
			}
		});
		return flg;
	}

	function childPostposeTime(val, row, value) {
		var planStartTime = row.planStartTime;
		var startTimeOverflow = row.startTimeOverflow;
		var planEndTime = row.planEndTime;
		var endTimeOverflow = row.endTimeOverflow;
		var childPostposeTime = "";
		if (startTimeOverflow == true) {
			childPostposeTime = '<a href="#" style="color:red">' + planStartTime + '</a>';
		} else {
			childPostposeTime = planStartTime;
		}
		if (endTimeOverflow == true) {
			childPostposeTime = childPostposeTime + "~" + '<a href="#" style="color:red">' + planEndTime + '</a>';
		} else {
			childPostposeTime = childPostposeTime + "~" + planEndTime;
		}
		return childPostposeTime;
	}

	
	var inputTypeTotal = "1";
	function workTimeLinkage(inputType) {
		if (inputType == 'planStartTime') {
			inputTypeTotal = inputTypeTotal + "1";
		}
		if (inputType == 'planEndTime') {
			inputTypeTotal = inputTypeTotal + "2";
		}
		if (inputType == 'workTime') {
			inputTypeTotal = inputTypeTotal + "3";
		}
		var win = $.fn.lhgdialog("getSelectParentWin");
		var planStartTime = $('#planStartTime').datebox('getValue');
		var workTime = $('#workTime').val();
		var planEndTime = $('#planEndTime').datebox('getValue');
		var projectId = $('#projectId').val();
		var milestone = $('#milestone').combobox('getValue');
		if (milestone == "否") {
			milestone = "false";
		} else if (milestone == "是") {
			milestone = "true";
		}

		if (inputType == 'planEndTime') {
			inputType1 = inputType;
		}
		if (inputType == 'workTime') {
			inputType2 = inputType;
		}
		var inputTypeTotalIndex = inputTypeTotal.indexOf('123');
	if (inputType1 == 'planEndTime' && inputType2 == 'workTime'  && inputTypeTotalIndex < 0) {
			inputType1 = undefined;
			inputType2 = undefined
			return false;
		} 

		if (inputType == 'planStartTime') {
			if (planStartTime != null && planStartTime != '' && planStartTime != undefined) {
				if (workTime != null && workTime != '' && workTime != undefined) {
					if (workTime == 0 && milestone != "true") {
						$('#workTime').textbox("setValue", "1");
						win.tip('<spring:message code="com.glaway.ids.pm.project.plan.periodNotZero"/>');
					} else {
						$.ajax({
							url : 'planController.do?getEndTimeByStartTimeAndWorkTime',
							type : 'post',
							data : {
								projectId : projectId,
								planStartTime : planStartTime,
								planEndTime : planEndTime,
								workTime : workTime,
								milestone : milestone
							},
							cache : false,
							success : function(data) {
								if (data != null) {
									var d = $.parseJSON(data);
									if (d.success == true) {
										planEndTime = d.obj;
										$('#planEndTime').datebox("setValue", planEndTime);
									} else {
										$('#planStartTime').datebox("setValue", planEndTime);
										win.tip(d.msg);
									}
								} else {
									win.tip('<spring:message code="com.glaway.ids.pm.project.plan.endTimeError"/>');
								}
							}
						});
					}
				} else if (planEndTime != null && planEndTime != '' && planEndTime != undefined) {
					if (planEndTime < planStartTime) {
						$('#planEndTime').datebox("setValue", "");
					} else {
						$.ajax({
							url : 'planController.do?getWorkTimeByStartTimeAndEndTime',
							type : 'post',
							data : {
								projectId : projectId,
								planStartTime : planStartTime,
								planEndTime : planEndTime,
								workTime : workTime,
								milestone : milestone
							},
							cache : false,
							success : function(data) {
								if (data != null) {
									var d = $.parseJSON(data);
									if (d.success == true) {
										workTime = d.obj;
										$('#workTime').textbox("setValue", workTime);
									} else {
										win.tip(d.msg);
									}
								} else {
									win.tip('<spring:message code="com.glaway.ids.pm.project.plan.periodError"/>');
								}
							}
						});
					}
				}
			} else {
				win.tip('<spring:message code="com.glaway.ids.pm.project.plan.emptyStart"/>');
			}
		} else if (inputType == 'workTime') {
			if (workTime != null && workTime != '' && workTime != undefined) {
				if (planStartTime != null && planStartTime != '' && planStartTime != undefined) {
					if (workTime == 0 && milestone != "true") {
						$('#workTime').textbox("setValue", "1");
						win.tip('<spring:message code="com.glaway.ids.pm.project.plan.periodNotZero"/>');
					} else {
						$.ajax({
							url : 'planController.do?getEndTimeByStartTimeAndWorkTime',
							type : 'post',
							data : {
								projectId : projectId,
								planStartTime : planStartTime,
								planEndTime : planEndTime,
								workTime : workTime,
								milestone : milestone
							},
							cache : false,
							success : function(data) {
								if (data != null) {
									var d = $.parseJSON(data);
									if (d.success == true) {
										planEndTime = d.obj;
										$('#planEndTime').datebox("setValue", planEndTime);
									} else {
										win.tip(d.msg);
									}
								} else {
									win.tip('<spring:message code="com.glaway.ids.pm.project.plan.endTimeError"/>');
								}
							}
						});
					}
				} else {
					win.tip('<spring:message code="com.glaway.ids.pm.project.plan.emptyStart"/>');
				}
			}
		} else if (inputType == 'planEndTime') {
			if (planEndTime != null && planEndTime != '' && planEndTime != undefined) {
				if (planStartTime != null && planStartTime != '' && planStartTime != undefined) {
					if (planEndTime < planStartTime) {
						win.tip('<spring:message code="com.glaway.ids.pm.project.plan.startNoLaterThanEnd"/>');
					} else {
						$.ajax({
							url : 'planController.do?getWorkTimeByStartTimeAndEndTime',
							type : 'post',
							data : {
								projectId : projectId,
								planStartTime : planStartTime,
								planEndTime : planEndTime,
								workTime : workTime,
								milestone : milestone
							},
							cache : false,
							success : function(data) {
								if (data != null) {
									var d = $.parseJSON(data);
									if (d.success == true) {
										workTime = d.obj;
										if (workTime == 0 && milestone != "true") {
											$('#workTime').textbox("setValue", "1");
											win.tip('<spring:message code="com.glaway.ids.pm.project.plan.periodNotZero"/>');
										} else {
											$('#workTime').textbox("setValue", workTime);
										}
									} else {
										win.tip(d.msg);
									}
								} else {
									win.tip('<spring:message code="com.glaway.ids.pm.project.plan.periodError"/>');
								}
							}
						});
					}
				} else {
					win.tip('<spring:message code="com.glaway.ids.pm.project.plan.emptyStart"/>');
				}
			}
		}
	}

	/**国际化js转移过来的方法**/
	function workTimeLinkage2(inputType) {
		var win = $.fn.lhgdialog("getSelectParentWin");
		var planStartTime = $('#planStartTime').datebox('getValue');
		var workTime = $('#workTime').val();
		var planEndTime = $('#planEndTime').datebox('getValue');
		var projectId = $('#projectId').val();
		if (inputType == 'planEndTime') {
			inputType1 = inputType;
		}
		if (inputType == 'workTime') {
			inputType2 = inputType;
		}

		if (inputType1 == 'planEndTime' && inputType2 == 'workTime') {
			inputType1 = undefined;
			inputType2 = undefined
			return false;
		}

		if (inputType == 'planStartTime') {
			if (planStartTime != null && planStartTime != '' && planStartTime != undefined) {
				if (workTime != null && workTime != '' && workTime != undefined) {
					if (workTime == 0) {
						$('#workTime').textbox("setValue", "");
						win.tip("工期不能为0");
					} else {
						$.ajax({
							url : 'planController.do?getEndTimeByStartTimeAndWorkTime',
							type : 'post',
							data : {
								projectId : projectId,
								planStartTime : planStartTime,
								workTime : workTime
							},
							cache : false,
							success : function(data) {
								if (data != null) {
									var d = $.parseJSON(data);
									if (d.success == true) {
										planEndTime = d.obj;
										$('#planEndTime').datebox("setValue", planEndTime);
									} else {
										$('#planStartTime').datebox("setValue", planEndTime);
										win.tip(d.msg);
									}
								} else {
									win.tip('<spring:message code="com.glaway.ids.pm.project.plan.endTimeError"/>');
								}
							}
						});
					}
				} else if (planEndTime != null && planEndTime != '' && planEndTime != undefined) {
					if (planEndTime < planStartTime) {
						$('#planEndTime').datebox("setValue", "");
					} else {
						$.ajax({
							url : 'planController.do?getWorkTimeByStartTimeAndEndTime',
							type : 'post',
							data : {
								projectId : projectId,
								planStartTime : planStartTime,
								planEndTime : planEndTime
							},
							cache : false,
							success : function(data) {
								if (data != null) {
									var d = $.parseJSON(data);
									if (d.success == true) {
										workTime = d.obj;
										$('#workTime').textbox("setValue", workTime);
									} else {
										win.tip(d.msg);
									}
								} else {
									win.tip('<spring:message code="com.glaway.ids.pm.project.plan.periodError"/>');
								}
							}
						});
					}
				}
			} else {
				win.tip('<spring:message code="com.glaway.ids.pm.project.plan.emptyStart"/>');
			}
		} else if (inputType == 'workTime') {
			if (workTime != null && workTime != '' && workTime != undefined) {
				if (planStartTime != null && planStartTime != '' && planStartTime != undefined) {
					if (workTime == 0) {
						$('#workTime').textbox("setValue", "");
						win.tip('<spring:message code="com.glaway.ids.pm.project.plan.periodNotZero"/>');
					} else {
						$.ajax({
							url : 'planController.do?getEndTimeByStartTimeAndWorkTime',
							type : 'post',
							data : {
								projectId : projectId,
								planStartTime : planStartTime,
								workTime : workTime
							},
							cache : false,
							success : function(data) {
								if (data != null) {
									var d = $.parseJSON(data);
									if (d.success == true) {
										planEndTime = d.obj;
										$('#planEndTime').datebox("setValue", planEndTime);
									} else {
										win.tip(d.msg);
									}
								} else {
									win.tip('<spring:message code="com.glaway.ids.pm.project.plan.endTimeError"/>');
								}
							}
						});
					}
				} else {
					win.tip('<spring:message code="com.glaway.ids.pm.project.plan.emptyStart"/>');
				}
			}
		} else if (inputType == 'planEndTime') {
			if (planEndTime != null && planEndTime != '' && planEndTime != undefined) {
				if (planStartTime != null && planStartTime != '' && planStartTime != undefined) {
					if (planEndTime < planStartTime) {
						win.tip('<spring:message code="com.glaway.ids.pm.project.plan.startNoLaterThanEnd"/>');
					} else {
						$.ajax({
							url : 'planController.do?getWorkTimeByStartTimeAndEndTime',
							type : 'post',
							data : {
								projectId : projectId,
								planStartTime : planStartTime,
								planEndTime : planEndTime
							},
							cache : false,
							success : function(data) {
								if (data != null) {
									var d = $.parseJSON(data);
									if (d.success == true) {
										workTime = d.obj;
										if (workTime == 0) {
											$('#workTime').textbox("setValue", "");
											win.tip('<spring:message code="com.glaway.ids.pm.project.plan.periodNotZero"/>');
										} else {
											$('#workTime').textbox("setValue", workTime);
										}
									} else {
										win.tip(d.msg);
									}
								} else {
									win.tip('<spring:message code="com.glaway.ids.pm.project.plan.periodError"/>');
								}
							}
						});
					}
				} else {
					win.tip('<spring:message code="com.glaway.ids.pm.project.plan.emptyStart"/>');
				}
			}
		}
	}

	function checkPlanWithInput() {
		var parentStartTime = $('#parentStartTime').val();
		var parentEndTime = $('#parentEndTime').val();
		var preposeEndTime = $('#preposeEndTime').val();
		var win = $.fn.lhgdialog("getSelectParentWin");

		var planName = $('#planName').val();
		if (planName == undefined) {
			var planName = $('#planName2').combobox('getText');
		}
		if (planName == "") {
			top.tip('<spring:message code="com.glaway.ids.pm.project.plan.emptyName"/>');
			return false;
		}
		if (planName.length > 30) {
			top.tip('<spring:message code="com.glaway.ids.pm.project.plan.basicLine.nameLength"/>')
			return false;
		}
		var owner = $('#owner').combobox('getValue');
		if (owner == "") {
			top.tip('<spring:message code="com.glaway.ids.pm.project.plan.emptyManager"/>');
			return false;
		}

		var planStartTime = $('#planStartTime').datebox('getValue');
		if (planStartTime == "") {
			top.tip('<spring:message code="com.glaway.ids.pm.project.plan.emptyStart"/>');
			return false;
		}
		if ((planStartTime < parentStartTime) || (planStartTime > parentEndTime)) {
			top.tip('<spring:message code="com.glaway.ids.pm.project.plan.startInParentTime" arguments="' 
					+ parentStartTime + '~' + parentEndTime + '"/>');
			return false;
		}

		var planEndTime = $('#planEndTime').datebox('getValue');
		if (planEndTime == "") {
			top.tip('<spring:message code="com.glaway.ids.pm.project.plan.emptyEnd"/>');
			return false;
		}

		if (planEndTime < planStartTime) {
			top.tip('<spring:message code="com.glaway.ids.pm.project.plan.endNoEarlierThanStart"/>');
			return false;
		}

		if ((planEndTime < parentStartTime) || (planEndTime > parentEndTime)) {
			//"计划开始时间必须收敛于父级的计划时间或项目时间:"+parentStartTime+'~'+parentEndTime
			top.tip('<spring:message code="com.glaway.ids.pm.project.plan.startInParentTime" arguments="' 
					+ parentStartTime + '~' + parentEndTime + '"/>');
			return false;
		}

		if (preposeEndTime != null && preposeEndTime != '' && preposeEndTime != undefined) {
			if (preposeEndTime > planStartTime) {
				top.tip('<spring:message code="com.glaway.ids.pm.project.plan.startNoLaterThanPrepose" arguments="' + preposeEndTime + '"/>');
				return false;
			}
		}

		var workTime = $('#workTime').val();
		var reg = new RegExp("^[0-9]*$");
		if (workTime == "") {
			top.tip('<spring:message code="com.glaway.ids.pm.project.plan.emptyPeriod"/>');
			return false;
		}

		if (!reg.test(workTime)) {
			top.tip('<spring:message code="com.glaway.ids.pm.project.plan.periodLowerToUpper"/>');
			return false;
		}

		var remark = $('#remark').val();
		if (remark.length > 200) {
			top.tip('<spring:message code="com.glaway.ids.common.remarkLength"/>')
			return false;
		}
		return true;
	}

	/* function addLink(val, row, value) {
		if (val != null && val != '') {
			return '<a  href="#" onclick="showDocDetail(\'' + row.docId
					+ '\',this)" id="myDoc"  style="color:blue">' + val
					+ '</a>';
		} else
			return;

	} */
	
	function importDoc(filePath,fileName){
		debugger;
		window.location.href = encodeURI('jackrabbitFileController.do?fileDown&fileName='+fileName+'&filePath=' + filePath);
	}
	
	function openProjectDoc1(id, name,download,history) {
		if (download == false || download == 'false') {
			download = "false";
		}
		if (history == false || history == 'false') {
			history = "false";
		}
		var url = "projLibController.do?viewProjectDocDetail&id=" + id
				+ "&download=" + download + "&history=" + history;
		createdetailwindow("文档详情", url, "870", "580")
	}
	
	
	function addLink(val, row, value){
		debugger;
		if(val!=null&&val!=''&&row.originType == 'LOCAL'){
			return '<a  href="#" onclick="importDoc(\'' + row.docId + '\',\'' + row.docNameShow + '\')" id="myDoc"  style="color:blue">'+val+'</a>';
		}else if(row.originType == 'PROJECTLIBDOC'){
			var path = "<a  href='#' title='查看' style='color:blue' onclick='openProjectDoc1(\""+ row.docIdShow+ "\",\""+ row.docNameShow+ "\",\""+ row.ext1+"\",\""+ row.ext2+"\")'>"
				+ row.docNameShow
				+ "</a>"
			if (row.ext3 == false || row.ext3 == 'false') {
				path = row.docNameShow;
			}
			return path; 
		}else if(row.originType == 'PLAN'){
			var path = "<a  href='#' title='查看' style='color:blue' onclick='openProjectDoc1(\""+ row.docId+ "\",\""+ row.docNameShow+ "\",\""+ row.ext1+"\",\""+ row.ext2+"\")'>"
			+ row.docNameShow
			+ "</a>"
		if (row.ext3 == false || row.ext3 == 'false') {
			path = row.docNameShow;
		}
		return path; 
		}
		else return ;
		
	}

	function showDocDetail(id) {
		var url = "projLibController.do?viewProjectDocDetail&opFlag=1&id=" + id;
		createdetailwindow2("文档详情", url, "1000", "550");
	}

	function createdetailwindow2(title, url, width, height) {
		width = width ? width : 700;
		height = height ? height : 400;
		if (width == "100%" || height == "100%") {
			width = document.body.offsetWidth;
			height = document.body.offsetHeight - 100;
		}

		if (typeof (windowapi) == 'undefined') {
			createDialog('showDocDetailChangeFlowDialog', url);

		} else {
			createDialog('showDocDetailChangeFlowDialog', url);
		}
	}

	function changeInput() {
		$('#four').panel('collapse');
		var preposeIds = $('#preposeIds').val();
		var planId = $('#planId').val();
// 		$('#haveNopre').css("display", "none");
// 		$('#havePre').css("display", "block");
		if ($('#preposeIds').val() != undefined && $('#preposeIds').val() != '') {
			$.ajax({
				url : 'planChangeController.do?changeInputList',
				type : 'post',
				data : {
					tempPreposeIds : preposeIds,
					preposeIdActual : preposeIdActual,
					planId : planId
				},
				cache : false,
				success : function(data) {
					initInput2();
				}
			});
		} else {
// 			$('#havePre').css("display", "none");
// 			$('#haveNopre').css("display", "block");
			$.ajax({
				url : 'planChangeController.do?changeInputListBack',
				type : 'post',
				data : {
					tempPreposeIds : preposeIds,
					planId : planId
				},
				cache : false,
				success : function(data) {
					initInput2();
				}
			});
		}
	}

	function milestoneChange() {
		var workTime = $('#workTime').val();
		var milestone = $('#milestone').combobox('getValue');
		if (milestone == "否") {
			milestone = "false";
		} else if (milestone == "是") {
			milestone = "true";
		}
		if (workTime == 0 && milestone != "true") {
			$('#workTime').textbox("setValue", "1");
		}
	}
	
	// 继承父项
	function inheritParent() {
		var dialogUrl = 'planChangeController.do?goAddTempInherit&planId=${temporaryPlan_.planId}&parentPlanId=1';
		createDialog('inheritDialog', dialogUrl);
	}

	/* function addLink(val, row, value) {
		if (val != null && val != '') {
			return '<a  href="#" onclick="showDocDetail(\'' + row.docId
					+ '\',this)" id="myDoc"  style="color:blue">' + val
					+ '</a>';
		} else
			return;

	} */

	function showDocDetail(id) {
		var url = "projLibController.do?viewProjectDocDetail&opFlag=1&id=" + id;
		createDialog('openAndSubmitDialog', url);
	}
	
	function addInputsNew(){
		var dialogUrl = 'inputsController.do?goAddInputs&projectId='+$("#projectId").val()+'&useObjectId='
			+ $('#useObjectId').val()
			+ '&useObjectType='
			+ $('#useObjectType').val()
			+'&hideMoreShow=false';
		createDialog('openSelectInputsDialog', dialogUrl);
	}
	
	function openSelectConfigOkFunction(iframe){
   		var flg=iframe.getLoadDataForPlanChange();
   		if (flg ) {
   			initInputChange();
			return true;
		}
   	 	return false;
	} 
	
	function afterSuccessCall(file, data, response){
		debugger;
		top.jeasyui.util.tagMask('close');
		var jsonObj = $.parseJSON(data);
		var fileStr = jsonObj.obj;
		var size = (file.size)/(1024*1024);
		if(size > 50 ){
			top.tip('<spring:message code="com.glaway.ids.pm.project.projectmanager.library.doc.sizeLimit"/>');
			return false;
		}
		var attachmentShowName = fileStr.split(",")[3];
        var uuid = fileStr.split(",")[2];
		var dowmLoadUrl = fileStr.split(",")[1];
		var attachmentName = fileStr.split(",")[0];
		//隐藏字段，处理冗余数据
		var invalidIds = $('#invalidIds').val();
		if(invalidIds != null && invalidIds != '' && invalidIds != undefined){
			invalidIds = invalidIds +","+ dowmLoadUrl;
			 $('#invalidIds').val(invalidIds);
		}else{
			invalidIds = dowmLoadUrl;
			$('#invalidIds').val(invalidIds);
		}
		
		/* $('#projLibDocList').datagrid('appendRow',{
			dowmLoadUrl: dowmLoadUrl,
			attachmentName: attachmentName,
			attachmentShowName: attachmentShowName,
			uuid : uuid
		}); */
		$('#docattachmentName').val(attachmentName);
		$('#docattachmentURL').val(dowmLoadUrl);
		$('#docAttachmentShowName').val(attachmentShowName);
		
		$.ajax({
			type : "POST", 
			url : "projLibController.do?doAddForPlanChangeLocalDoc&attachmentNames="+ attachmentName+"&dowmLoadUrls="+ attachmentName,
			async : false,
			data :   $('#planChangeForm').serialize(),
			success : function(data) {
				debugger;
				var d = $.parseJSON(data);				
				if (d.success) {
					/* docId = d.obj;
					retOid=d.obj;
					result=true;
					var invalidIds = $('#invalidIds').val();
					var delUrl='projLibController.do?deleteProjLibJackrabbitFile&type='+'add';
					$.ajax({
						type : 'POST',
						url : delUrl,
						async : false,
						data : {
							invalidIds : invalidIds,
							docattachmentURL : dowmLoadUrl
						},
					success : function(data) {
					}
				}); */
					initInput2('');
					return true;		
				}else{
					return false;
				}
				
					 
			}
		});	
		return true;


	}
	
	function showOrigin(val, row, value){
		if(row.originType == "LOCAL"){
			return "本地文档";
		}else{
			return val;
		}
	}
	
	function projLibLinkOpt(r,s){
		if(r.originType == 'LOCAL'){
			return true;
		}else{
			return false;
		}
	}
	
	function planLinkOpt(r,s){
		if(r.originType == 'LOCAL'){
			return true;
		}else{
			return false;
		}
	}
	
	function goProjLibLink(id,index) {
		debugger;
		
		var row;
		$('#inputList').datagrid('selectRow',index);
		var all = $('#inputList').datagrid('getRows');
		for(var i=0;i<all.length;i++){
			var inx = $("#inputList").datagrid('getRowIndex', all[i]);
			if(inx == index){
				row = all[i];
			}
		}
		
		idRow=row.id;
		var dialogUrl = 'projLibController.do?goProjLibLayout0&id='+$("#projectId").val()+'&rowId='+idRow;
		$("#"+'taskDocCheckLineDialog').lhgdialog("open", "url:"+dialogUrl);
	}
	
	function taskDocCheckLineDialog(iframe) {
		debugger;
		//iframe = this.iframe.contentWindow;
		if (iframe.validateSelectedNum()) {
			var docId = iframe.getSelectionsId();
			var folderId = iframe.$("#folderId").val();
			var rowId = iframe.$("#rowId").val();
			var rows=$('#deliverablesInfoList').datagrid('getSelections');
			var row=rows[0];
			$.ajax({
				url : 'deliverablesInfoController.do?updateInputsForPlanChange',
				type : 'post',
				data : {
					fileId : docId,
					folderId : folderId,
					rowId : rowId,
					projectId : $('#projectId').val(),
					useObjectId : $('#useObjectId').val(),
					useObjectType : $('#useObjectType').val()
				},
				cache : false,
				success : function(data) {
					var d = $.parseJSON(data);
					if (d.success) {
						initInput2('');
					}
				}
			});
			return true;
		} else {
			return false;
		}
	}
	
	
	function goPlanLink(id,index){
		debugger;
		var row;
		$('#inputList').datagrid('selectRow',index);
		var all = $('#inputList').datagrid('getRows');
		for(var i=0;i<all.length;i++){
			var inx = $("#inputList").datagrid('getRowIndex', all[i]);
			if(inx == index){
				row = all[i];
			}
		}
		
		$.ajax({
			type:'POST',
			data:{inputsName : row.name},
			url:'planController.do?setInputsNameToSession',
			cache:false,
			success:function(data){
				var d = $.parseJSON(data);
				if(d.success){
					var url = 'planController.do?goSelectPlanInputs&projectId='+$("#projectId").val()+'&useObjectId='+$("#useObjectId").val()+'&useObjectType='+$("#useObjectType").val()+'&tempId='+row.id;
					//url = encodeURI(encodeURI(url))
					
					createDialog('planInputsDialog',url);
				}
			}
		});
	}
	
	function planInputsDialog(iframe){
		if (iframe.validateSelectedBeforeSave()) {
			debugger;
			var row = iframe.$('#planlist').datagrid('getSelections');
			var planId = row[0].id;
			var tempId = iframe.$("#tempId").val();
			var useObjectId = iframe.$("#useObjectId").val();
			var inputsName = iframe.$("#inputsName").val();
			
			$.ajax({
				type:'POST',
				data:{
					planId:planId,
					tempId : tempId,
					useObjectId : useObjectId,
					inputsName : inputsName
				},
				url : 'deliverablesInfoController.do?setPlanInputsForPlanChange',
				cache:false,
				success : function(data){
					initInput2('');
					$('#inputList').datagrid('clearSelections');
				}
			});
		}else{
			return false;
		}
	}
	
</script>
</head>

<body>
	<div border="false" class="easyui-panel div-msg" id="changeReason" fit="true">
		<%-- 增加一个div，用于调节页面大小，否则默认太小 --%>
		<div class="easyui-panel" fit="true">
			<input id="planChangeCategoryListStr" name="planChangeCategoryListStr" type="hidden" value="${planChangeCategoryListStr}" /> 
			<input id="planId" name="planId" type="hidden" value="${temporaryPlan_.planId}" />
			<%-- <fd:combobox id="changeType" textField="name" title="{com.glaway.ids.pm.project.plan.changeType}" selectedValue="${temporaryPlan_.changeType}" 
				editable="false" valueField="id" required="true" panelMaxHeight="200"
				url="planChangeMassController.do?planChangeCategorylList"></fd:combobox> --%>
				<fd:combotree title="{com.glaway.ids.pm.project.plan.changeType}" treeIdKey="id" name="changeType"
					url="planChangeMassController.do?planChangeCategorylList" id="changeType" treePidKey="parentId"
					editable="false" multiple="false" panelHeight="200" treeName="name" required="true"
					prompt="请选择"></fd:combotree> 
			<fd:uploadify name="files" id="file_upload" title="{com.glaway.ids.common.lable.uploadAttachment}" auto="true" multi="false" 
				uploader="planChangeController.do?saveFiles" showPanel="false" dialog="false" extend="*.*" >
				<fd:eventListener event="onUploadSuccess" listener="afterSubmitChangeInfo" />
			</fd:uploadify>
			<fd:inputTextArea id="changeRemark" title="{com.glaway.ids.common.lable.remark}" name="changeRemark"
				value="${temporaryPlan_.changeRemark}">
			</fd:inputTextArea>			
		</div>

		<div class="div-msg-btn">
			<div>
				<fd:linkbutton onclick="nextOne()" value="{com.glaway.ids.pm.project.plan.nextone}" classStyle="button_nor" />
				<fd:linkbutton id="reasonCancelBtn" onclick="closePlan()" value="{com.glaway.ids.common.btn.cancel}"  classStyle="button_nor" />
			</div>
		</div>
	</div>
	
	<!-- document begin -->
	<div border="false" id="changeInfo" class="easyui-panel div-msg div-msg-fit" fit="true" style="width:100%;height:100%;">
		<div class="easyui-panel div-msg-fit-panel" fit="true" style="width:100%;height:25%;">
			<input id="changeRemarkMid" name="changeRemarkMid" type="hidden">
			<fd:panel id="one" border="false" title="{com.glaway.ids.pm.project.plan.baseinfo}" collapsible="true" fit="false" width="100%" >
				<fd:form id="planChangeForm">
					<input id="planId" name="planId" type="hidden"
						value="${temporaryPlan_.planId}">
					<input id="useObjectId" name="useObjectId" type="hidden"
						value="${useObjectId}">
					<input id="useObjectType" name="useObjectType" type="hidden"
						value="${useObjectType}">
					<input id="planNumber" name="planNumber" type="hidden"
						value="${temporaryPlan_.planNumber}">
					<input id="projectId" name="projectId" type="hidden"
						value="${temporaryPlan_.projectId}">
					<input id="parentPlanId" name="parentPlanId" type="hidden"
						value="${temporaryPlan_.parentPlanId}">
					<input id="beforePlanId" name="beforePlanId" type="hidden"
						value="${temporaryPlan_.beforePlanId}">
					<input id="bizCurrent" name="bizCurrent" type="hidden"
						value="${temporaryPlan_.bizCurrent}">
					<input id="preposeList" name="preposeList" type="hidden"
						value="${temporaryPlan_.preposeList}">
					<input id="rescLinkInfoList" name="rescLinkInfoList" type="hidden"
						value="${temporaryPlan_.rescLinkInfoList}">
					<input id="parentStartTime" name="parentStartTime" type="hidden"
						value="${parentStartTime}">
	
					<input id="preposeplanName" name="preposeplanName" type="hidden"
						value="${preposeplanName}">
					<input id="parentPlanName" name="parentPlanName" type="hidden"
						value="${parentPlanName}">
	
					<input id="parentEndTime" name="parentEndTime" type="hidden"
						value="${parentEndTime}">
					<input id="preposeEndTime" name="preposeEndTime" type="hidden"
						value="${preposeEndTime}">
					<input id="departList" name="departList" type="hidden"
						value="${departList}">
					<input id="userList" name="userList" type="hidden"
						value="${userList}">
					<input id="userList2" name="userList2" type="hidden"
						value="${userList2}">
					<input id="ownerShow" name="ownerShow" type="hidden"
						value="${ownerShow}">
					<input name="invalidIds" id="invalidIds" type="hidden">
					<input id="docattachmentName" name="docattachmentName" type="hidden">
					<input id="docattachmentURL" name="docattachmentURL" type="hidden">
					<input id="docAttachmentShowName" name="docAttachmentShowName" type="hidden">
					<fd:inputText id="planName" name="planName" title="{com.glaway.ids.pm.project.plan.planName}"
						required="true" value="${temporaryPlan_.planName}"
						readonly="true"  />
					<fd:combobox id="owner" textField="realName" title="{com.glaway.ids.common.lable.owner}"
						selectedValue="${ownerShow}" onChange="ownerChange()"
						editable="true" valueField="id" required="true"
						panelMaxHeight="200" url="planController.do?userList2&projectId=${temporaryPlan_.projectId}">
					</fd:combobox>
					<fd:combobox id="planLevel" textField="name"
						title="{com.glaway.ids.pm.project.plan.planLevel}" selectedValue="${temporaryPlan_.planLevel}"
						editable="false" valueField="id"
						url="planController.do?useablePlanLevelList">
					</fd:combobox>
					<fd:inputText id="ownerDept" title="{com.glaway.ids.pm.project.plan.dept}"
						name="ownerDept" readonly="true"
						value="${temporaryPlan_.ownerDept}" />
					<fd:inputDate id="planStartTime"
						title="{com.glaway.ids.common.lable.starttime}" value='${temporaryPlan_.planStartTime}'
						onChange="workTimeLinkage('planStartTime')" editable="false"
						required="true">
					</fd:inputDate>
					<fd:inputDate id="planEndTime"
						title="{com.glaway.ids.common.lable.endtime}" value='${temporaryPlan_.planEndTime}'
						editable="false" onChange="workTimeLinkage('planEndTime')"
						required="true">
					</fd:inputDate>
					<fd:inputText id="workTime" title="{com.glaway.ids.pm.project.plan.workTime}" value='${temporaryPlan_.workTime}'
						onChange="workTimeLinkage('workTime')">
					</fd:inputText>
					<fd:combobox id="milestone" textField="name" title="{com.glaway.ids.pm.project.plan.milestone}"
						selectedValue="${temporaryPlan_.milestone}" editable="false"
						valueField="id" required="true" onChange="milestoneChange()"
						url="planController.do?milestoneList">
					</fd:combobox>
					<fd:combobox id="taskNameType" textField="typename"
						title="{com.glaway.ids.pm.project.plan.taskNameType}" selectedValue="${temporaryPlan_.taskNameType}"
						readonly="true" editable="false" valueField="typecode"
						required="true" url="taskFlowResolveController.do?getTaskNameTypes">
					</fd:combobox>
					<fd:combobox id="taskType" textField="name" title="{com.glaway.ids.pm.project.plan.taskType}"
						selectedValue="${temporaryPlan_.taskType}" readonly="true"
						editable="false" valueField="name" required="true"
						url="planController.do?getTaskTypes&parentPlanId=${temporaryPlan_.parentPlanId}&projectId=${temporaryPlan_.projectId}">
					</fd:combobox>
					<fd:inputSearch id="preposePlans"
						title="{com.glaway.ids.pm.project.plan.preposePlans}" value="${temporaryPlan_.preposePlans}"
						editable="false"
						searcher="selectPreposePlan('#preposeIds','#preposePlans')"
						onChange="changeInput()">
					</fd:inputSearch> 
					<input name="preposeIds" id="preposeIds" value="${temporaryPlan_.preposeIds}" type="hidden">
					<fd:inputText title="{com.glaway.ids.common.lable.status}" id="status" name="status" value="${temporaryPlan_.status}"  readonly="true"></fd:inputText>
					<fd:inputText title="{com.glaway.ids.pm.project.projecttemplate.creator}" id="createFullName" name="createFullName"
						value="${temporaryPlan_.createFullName}-${temporaryPlan_.createName}" readonly="true"></fd:inputText>
					<fd:inputDate title="{com.glaway.ids.pm.project.projecttemplate.createTime}" id="createTime" name="createTime"
						value="${temporaryPlan_.createTime}" readonly="true"></fd:inputDate>
					<c:if
						test="${temporaryPlan_.assignerInfo.realName != '' && temporaryPlan_.assignerInfo.realName != null}">
						<fd:inputText title="{com.glaway.ids.common.lable.assigner}" id="assignerName" name="assignerName"
							value="${temporaryPlan_.assignerInfo.realName}-${temporaryPlan_.assignerInfo.userName}"
							readonly="true"></fd:inputText>
					</c:if>
					<c:if
						test="${temporaryPlan_.assignerInfo.realName == '' || temporaryPlan_.assignerInfo.realName == null}">
						<fd:inputText title="{com.glaway.ids.common.lable.assigner}" id="assignerName" name="assignerName" 
							value="${temporaryPlan_.assignerInfo.realName}" readonly="true"></fd:inputText>
					</c:if>
					<fd:inputDate title="{com.glaway.ids.common.lable.assignTime}" id="assignTime" name="assignTime"
						value="${temporaryPlan_.assignTime}" readonly="true"></fd:inputDate>
					<fd:inputTextArea id="remark"
						title="{com.glaway.ids.pm.project.plan.remark}" name="remark" value="${temporaryPlan_.remark}">
					</fd:inputTextArea>
				</fd:form>
			</fd:panel>
	
			<fd:panel id="four" border="false" title="{com.glaway.ids.pm.project.plan.input}" collapsible="true" collapsed="true" fit="true" width="100%">
					<div id="tagListtb2" style="padding: 3px; margin 10px; height: auto;">
						<fd:toolbar id="a3">
							<fd:toolbarGroup align="left">
								<fd:linkbutton onclick="addInputsNew()" value="新增输入项" id="addInputButton" iconCls="basis ui-icon-plus" />
								<fd:uploadify iconCls="basis ui-icon-plus" buttonText="新增本地文档     " width="120"
									name="up_button_import" id="up_button_import" title="新增本地文档   "
									afterUploadSuccessMode="multi" 
									uploader="projLibController.do?addFileAttachments&projectId=${projectId}"
									extend="*.*" auto="true" showPanel="false" multi="false" 
									dialog="false" onlyButton="true">
								<fd:eventListener event="onUploadSuccess" listener="afterSuccessCall" />
								</fd:uploadify>
								<fd:linkbutton iconCls="basis ui-icon-minus"
									onclick="deleteSelections3('inputList', 'planChangeController.do?doDelInput')"
									value="{com.glaway.ids.common.btn.remove}" id="deleteInputButton" />
							</fd:toolbarGroup>
						</fd:toolbar>
					</div>
					<fd:datagrid id="inputList" checkbox="true" pagination="false" checkOnSelect="true" toolbar="" 
						fitColumns="true"  idField="id" fit="true">
						<fd:colOpt title="操作" width = "30">
							<fd:colOptBtn iconCls="basis ui-icon-pddata" tipTitle="项目库关联" onClick="goProjLibLink" hideOption="projLibLinkOpt"/>
							<fd:colOptBtn iconCls="basis ui-icon-search" tipTitle="计划关联" onClick = "goPlanLink" hideOption = "planLinkOpt"/>
						</fd:colOpt>
						<fd:dgCol title="{com.glaway.ids.common.lable.name}" field="name" width="100"  sortable="false"/>
						<fd:dgCol title="{com.glaway.ids.pm.project.plan.deliverables.docName}" field="docNameShow" width="120" formatterFunName="addLink"  sortable="false"></fd:dgCol>
						<fd:dgCol title="{com.glaway.ids.pm.project.plan.deliverables.orgin}" field="originPath" formatterFunName = "showOrigin" width="100"  sortable="false"/>
					</fd:datagrid>
			</fd:panel>
	
			<fd:panel id="two" border="false" title="{com.glaway.ids.pm.project.plan.output}" collapsible="true" collapsed="true" fit="true" width="100%">
				<input id="deliInfoList" name="deliInfoList" type="hidden">
				<input id="pdName" name="pdName" type="hidden" value="${pdName}">
				<div id="tagListtb" style="padding: 3px; margin 10px; height: auto;">
					<fd:toolbar id="a1">
						<fd:toolbarGroup align="left">
							<fd:linkbutton value="{com.glaway.ids.pm.project.plan.inheritParent}" onclick="inheritParent()"
								iconCls="basis ui-icon-copy"  id ="inheritParent"/>
							<fd:linkbutton onclick="addDeliverable()" value="{com.glaway.ids.common.btn.create}"
								id="addDeliverableButton" iconCls="basis ui-icon-plus" />
							<fd:linkbutton iconCls="basis ui-icon-minus"
								onclick="deleteSelections('deliverablesInfoList', 'planChangeController.do?doDelDocument')"
								value="{com.glaway.ids.common.btn.remove}" id="deleteDeliverableButton" />
						</fd:toolbarGroup>
					</fd:toolbar>
				</div>
				<fd:datagrid id="deliverablesInfoList" checkbox="true" pagination="false" toolbar="#tagListtb" 
					idField="deliverablesId" fit="false" width="100%" fitColumns="true" >
					<fd:dgCol title="{com.glaway.ids.pm.project.plan.deliverables.deliverableName}" field="name" width="120" formatterFunName="viewDocumentDis"  sortable="false"></fd:dgCol>
					<fd:dgCol title="{com.glaway.ids.pm.project.plan.deliverables.docName}" field="docName" width="120" formatterFunName="addLink"  sortable="false"></fd:dgCol>
				</fd:datagrid>
			</fd:panel>
			
			<fd:panel id="three" border="false" title="{com.glaway.ids.pm.project.plan.resource}" collapsible="true" collapsed="true" fit="true" width="100%">
				<div id="tagListResource" style="padding: 3px; margin 10px; height: auto">
					<fd:toolbar id="a2">
						<fd:toolbarGroup align="left">
							<fd:linkbutton onclick="addResource()" value="{com.glaway.ids.pm.project.plan.resource.addResource}" iconCls="basis ui-icon-plus" />
							<fd:linkbutton
								onclick="deleteSelections2('resourceList', 'planChangeController.do?doDelResource')"
								iconCls="basis ui-icon-minus" value="{com.glaway.ids.pm.project.plan.resource.removeResource}" />
						</fd:toolbarGroup>
					</fd:toolbar>
				</div>

				<fd:datagrid id="resourceList" checkbox="true" fit="false" width="100%" fitColumns="true" idField="resourceName" pagination="false" 
					onClickFunName="onClickPlanRow" checkOnSelect="true" toolbar="#tagListResource"  onDblClickRow="onClickPlanRowTwo">
					<fd:dgCol title="{com.glaway.ids.pm.project.plan.resource.resourceName}" field="resourceName" width="120" formatterFunName="resourceNameLink"  sortable="false"></fd:dgCol>
					<fd:dgCol title="{com.glaway.ids.pm.project.plan.resource.resourceType}" field="resourceType" width="150"  sortable="false"></fd:dgCol>
					<fd:dgCol title="{com.glaway.ids.common.lable.starttime}" field="startTime" width="120" editor="'datebox'"  sortable="false"></fd:dgCol>
					<fd:dgCol title="{com.glaway.ids.common.lable.endtime}" field="endTime" width="120" editor="'datebox'"  sortable="false"></fd:dgCol>
					<fd:dgCol title="{com.glaway.ids.pm.project.plan.resource.useRate}" field="useRate" width="120" formatterFunName="viewUseRate2" editor="'numberbox'"  sortable="false"></fd:dgCol>
				</fd:datagrid>
			</fd:panel>
		</div>
		
		<div class="div-msg-btn">
			<div>
				<fd:linkbutton onclick="beforeTwo()" value="{com.glaway.ids.pm.project.plan.beforeone}" classStyle="button_nor" />
				<fd:linkbutton onclick="nextTwo()"  value="{com.glaway.ids.pm.project.plan.nextone}" classStyle="button_nor" />
				<fd:linkbutton id="formCancelBtn" onclick="closePlan()" value="{com.glaway.ids.common.btn.cancel}" classStyle="button_nor" />
			</div>
		</div>
	</div>
	<!-- document end -->

	<div border="false" class="easyui-panel div-msg" id="changeAnalysis" fit="true">
		<div class="easyui-panel" fit="true">
			<div style="padding-top: 20px; padding-bottom: 5px;">
				<label id="planChildTimeArea"></label>
			</div>
			<div id="influencedNull">
				<div style="height:200px">
					<fd:datagrid id="temporaryPlanChildList" checkbox="false" pagination="false" 
							fitColumns="true" idField="planId" fit="true">
						<fd:dgCol title="{com.glaway.ids.pm.project.plan.planName}" field="planName" width="150"  sortable="false"></fd:dgCol>
						<fd:dgCol title="发布人" field="assignerName" width="120"  sortable="false"></fd:dgCol>
						<fd:dgCol title="{com.glaway.ids.common.lable.owner}" field="ownerName" width="120"  sortable="false"></fd:dgCol>
						<fd:dgCol title="{com.glaway.ids.pm.project.plan.planTime}" field="planStartTime" width="150" formatterFunName="childPostposeTime"  sortable="false"></fd:dgCol>
					</fd:datagrid>
				</div>

				<div style="padding-top: 20px; padding-bottom: 5px;">
					<label id="planPostposeTimeArea"></label>
				</div>
				<div style="height:200px">
					<fd:datagrid id="temporaryPlanPostposeList" checkbox="false" pagination="false" 
						fitColumns="true" idField="planId" fit="true">
						<fd:dgCol title="{com.glaway.ids.pm.project.plan.planName}" field="planName" width="150"  sortable="false"></fd:dgCol>
						<fd:dgCol title="发布人" field="assignerName" width="120"  sortable="false"></fd:dgCol>
						<fd:dgCol title="{com.glaway.ids.common.lable.owner}" field="ownerName" width="120"  sortable="false"></fd:dgCol>
						<fd:dgCol title="{com.glaway.ids.pm.project.plan.planTime}" field="planStartTime" width="150" formatterFunName="childPostposeTime"  sortable="false"></fd:dgCol>
					</fd:datagrid>
				</div>
			</div>
		</div>
		
		<div class="div-msg-btn">
			<div>
				<fd:linkbutton onclick="beforeThree()" value="{com.glaway.ids.pm.project.plan.beforeone}" classStyle="button_nor" />
				<fd:linkbutton onclick="nextThree()" value="{com.glaway.ids.pm.project.plan.nextone}" classStyle="button_nor" />
				<fd:linkbutton id="analysisCancelBtn" onclick="closePlan()" value="{com.glaway.ids.common.btn.cancel}" classStyle="button_nor" />
			</div>
		</div>
	</div>

	<div border="false" class="easyui-panel div-msg" id="changeTotal" fit="true">
		<div class="easyui-layout" fit="true">
			<div data-options="region:'north'" style="height: 210px;">
				<input id="changeInfoDocPath" name="changeInfoDocPath" type="hidden" value="${temporaryPlan_.changeInfoDocPath}">
				<fd:inputText id="changeTypeAfter" title="{com.glaway.ids.pm.project.plan.changeType}"
					name="changeTypeAfter" value="${temporaryPlan_.changeType}"
					readonly="true" />
				<fd:inputTextArea id="changeRemarkAfter" title="{com.glaway.ids.common.lable.remark}"
					name="changeRemarkAfter" value="${temporaryPlan_.changeRemark}"
					readonly="true" />
				<input type="hidden" id="leader" name="leader" />	
				<fd:inputSearchUser id="leaderId" name="leaderId" title="{com.glaway.ids.common.lable.leader}"  required="true">
					<fd:eventListener event="beforeAffirmClose" listener="setLeader" needReturn="true" />
				</fd:inputSearchUser>	
				<input type="hidden" id="deptLeader" name="deptLeader" />
				<fd:inputSearchUser id="deptLeaderId" name="deptLeaderId" title="{com.glaway.ids.common.lable.deptLeader}"  required="true">
					<fd:eventListener event="beforeAffirmClose" listener="setDeptLeader" needReturn="true" />
				</fd:inputSearchUser>
			</div>
			<div data-options="region:'center'">
				<fd:datagrid id="planChangeVo" checkbox="false" pagination="false" fitColumns="true" idField="planId" fit="true">
					<fd:dgCol title="{com.glaway.ids.pm.project.plan.field}" field="field" width="150"  sortable="false"></fd:dgCol>
					<fd:dgCol title="{com.glaway.ids.pm.project.plan.type}" field="type" width="120"  sortable="false"></fd:dgCol>
					<fd:dgCol title="{com.glaway.ids.pm.project.plan.changeBefore}" field="changeBefore" width="120"  sortable="false"></fd:dgCol>
					<fd:dgCol title="{com.glaway.ids.pm.project.plan.changeAfter}" field="changeAfter" width="150"  sortable="false"></fd:dgCol>
				</fd:datagrid>
			</div>
		</div>
		<div class="div-msg-btn">
			<div>
				<fd:linkbutton onclick="beforeFour()" value="{com.glaway.ids.pm.project.plan.beforeone}" classStyle="button_nor" />
				<fd:linkbutton onclick="addTempPlan()" value="{com.glaway.ids.common.btn.submit}" classStyle="button_nor" id="startPlanchange"/>
				<fd:linkbutton id="totalCancelBtn" onclick="closePlan()" value="{com.glaway.ids.common.btn.cancel}" classStyle="button_nor" />
			</div>
		</div>
	</div>
</body>

<fd:dialog id="addDeliverableDialog" width="830px" height="400px"
	modal="true" title="{com.glaway.ids.pm.project.plan.deliverables.addDeliverable}">
	<fd:dialogbutton name="{com.glaway.ids.common.btn.confirm}" callback="addDeliverableDialog"></fd:dialogbutton>
	<fd:dialogbutton name="{com.glaway.ids.common.btn.cancel}" callback="hideDiaLog"></fd:dialogbutton>
</fd:dialog>
<fd:dialog id="addInputDialog" width="800px" height="400px" modal="true"
	title="{com.glaway.ids.pm.project.plan.inputs.addInputs}">
	<fd:dialogbutton name="{com.glaway.ids.common.btn.confirm}" callback="addInputDialog"></fd:dialogbutton>
	<fd:dialogbutton name="{com.glaway.ids.common.btn.cancel}" callback="hideDiaLog"></fd:dialogbutton>
</fd:dialog>
<fd:dialog id="addResourceDialog" width="800px" height="350px"
	modal="true" title="{com.glaway.ids.pm.project.plan.resource.addResource}">
	<fd:dialogbutton name="{com.glaway.ids.common.btn.confirm}" callback="addResourceDialog"></fd:dialogbutton>
	<fd:dialogbutton name="{com.glaway.ids.common.btn.cancel}" callback="hideDiaLog"></fd:dialogbutton>
</fd:dialog>
<fd:dialog id="resourceDialog" width="900px" height="600px" modal="true"
	title="{com.glaway.ids.pm.project.plan.resourcePicture}" maxFun="true">
</fd:dialog>
<fd:dialog id="preposePlanDialog" width="800px" height="580px"
	modal="true" title="{com.glaway.ids.pm.project.plan.choseprepose}">
	<fd:dialogbutton name="{com.glaway.ids.common.btn.confirm}" callback="preposePlanDialog"></fd:dialogbutton>
	<fd:dialogbutton name="{com.glaway.ids.common.btn.cancel}" callback="hideDiaLog"></fd:dialogbutton>
</fd:dialog>
<fd:dialog id="showDocDetailChangeFlowDialog" modal="true" width="1000"
	height="550" title="{com.glaway.ids.pm.project.plan.basicLine.showDocDetail}">
	<fd:dialogbutton name="{com.glaway.ids.common.btn.close}" callback="hideDiaLog"></fd:dialogbutton>
</fd:dialog>
<fd:dialog id="openAndSubmitDialog" width="870px" height="600px"
	modal="true" title="{com.glaway.ids.pm.project.plan.basicLine.showDocDetail}">
	<fd:dialogbutton name="{com.glaway.ids.common.btn.close}" callback="hideDiaLog"></fd:dialogbutton>
</fd:dialog>
	<fd:dialog id="inheritDialog" width="400px" height="300px"
	modal="true" title="{com.glaway.ids.pm.project.plan.inheritParentDocument}">
</fd:dialog>	
<fd:dialog id="openSelectInputsDialog" width="800px" height="520px"
		modal="true" title="选择输入项">
	<fd:dialogbutton name="{com.glaway.ids.common.btn.confirm}"
		callback="openSelectConfigOkFunction"></fd:dialogbutton>
	<fd:dialogbutton name="{com.glaway.ids.common.btn.cancel}"
		callback="hideDiaLog"></fd:dialogbutton>
</fd:dialog>
<fd:dialog id="taskDocCheckLineDialog" width="1000px" height="500px" modal="true" title="项目库关联">
	<fd:dialogbutton name="{com.glaway.ids.common.btn.confirm}" callback="taskDocCheckLineDialog"></fd:dialogbutton>
	<fd:dialogbutton name="{com.glaway.ids.common.btn.cancel}" callback="hideDiaLog"></fd:dialogbutton>
</fd:dialog>

<fd:dialog id="planInputsDialog" width="800px" height="580px" modal="true" title="选择来源计划">
	<fd:dialogbutton name="{com.glaway.ids.common.btn.confirm}" callback="planInputsDialog"></fd:dialogbutton>
	<fd:dialogbutton name="{com.glaway.ids.common.btn.cancel}" callback="hideDiaLog"></fd:dialogbutton>
</fd:dialog>
