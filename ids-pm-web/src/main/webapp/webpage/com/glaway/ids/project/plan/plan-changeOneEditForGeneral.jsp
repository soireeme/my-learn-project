<%@ page language="java" import="java.util.*"
	contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/context/mytags.jsp"%>
<!DOCTYPE html>
<html>
<head>
<title>项目计划单条变更驳回修改</title>
<t:base type="jquery,easyui,tools,DatePicker"></t:base>

	<style>

		.gla_step{
			width: auto;}
		.gla_step .step_dot{
			width: auto; margin:0 auto;}
		.gla_step .step_dot tr td div{white-space: nowrap;
			display: inline-block;
			width: 90px;}
		.gla_step .step_dot .stepFirst{ text-align: center}
		.gla_step .step_dot .stepMiddle{text-align: center}
		.gla_step .step_dot tr td i{
			left: -33px;}
		.gla_step .step_dot .stepEnd{ text-align: center}
		.div-msg-btn{bottom:12px;}
		.lhgdialog_cancle{border: 1px solid #0C60AA;
			cursor: pointer;
			padding: 2px 16px;
			line-height: 22px;
			cursor: pointer;
			margin: 0px 8px 0 0;
			-moz-border-radius: 2px;
			-webkit-border-radius: 2px;
			border-radius: 2px;
			font-family: Microsoft Yahei,Arial,Tahoma;
			BACKGROUND-COLOR: #fff;}
		.lhgdialog_cancle:hover{ padding: 2px 16px;
			line-height: 22px;
			cursor: pointer;
			border: 1px solid #0C60AA;
			margin: 0px 8px 0 0;}
		.div-msg-btn div{right:16px}
	</style>
<script src="webpage/com/glaway/ids/project/plan/planList.js"></script>
<script>
		$(document).ready(function (){
			begin();
			$('#reasonCancelBtn').focus();
		});

		
		function begin() {
			debugger;


            if('${temporaryPlan_.parentPlanId}' == ''|| '${temporaryPlan_.parentPlanId}' == null || '${temporaryPlan_.parentPlanId}' == undefined){
                $("#inheritParent").hide();
            }
            $('#changeReason').panel({closed:false});
            $('#changeInfo').panel({closed:true});
            $('#changeAnalysis').panel({closed:true});
            $('#changeTotal').panel({closed:true});

            setTimeout(function() {
                var planChangeCategoryList = eval($('#planChangeCategoryListStr').val());
                var changeType = "${temporaryPlan_.changeType}";
                for (var i = 0; i < planChangeCategoryList.length; i++) {
                    if (changeType == planChangeCategoryList[i].id) {
                        $('#changeType').comboztree('setText', planChangeCategoryList[i].name);
                        $('#changeTypeAfter').textbox('setText',planChangeCategoryList[i].name);
                    }
                }

                initPages();
                initData();
                setDefaultItem();

            }, 500);

		}

        function initPages(){
            debugger
            <c:if test="${! empty objectPathList}">
            <c:forEach var="pathList" items="${objectPathList}">
            loadjs('${pathList}');
            //   document.write("<script src='${pathList}'><\/script>");
            </c:forEach>
            </c:if>


            var tabTemplateList = ${tabTemplateList};
            for(var i in tabTemplateList){
                if(i != "0" || i != 0){
                    $('#'+tabTemplateList[i].id).css('display','none')
                }
            }
        }


        var map ={};

        function initData(){
            var operation = ${operation};
            for(var i in operation){
                try{
                    for(var j in operation[i]){
                        if($("#"+i).hasClass("glaway-combo  combobox-f combo-f textbox-f")){
                            if(j == 'onChange'){
                                map[i] = operation[i][j];
                                $("#"+i).combobox({ onChange:function(newVal, oldVal){
                                        eval(map[$(this).attr("id")]);
                                    }});
                            }
                        }else if($("#"+i).hasClass("glaway-input    textbox-f")){   //样式中间多余的空格勿删
                            if(j == 'onChange'){
                                map[i] = operation[i][j];
                                $("#"+i).textbox({ onChange:function(newVal, oldVal){
                                        eval(map[$(this).attr("id")]);
                                    }});
                            }
                        }else if($("#"+i).hasClass("glaway-input_datebox   datebox-f combo-f textbox-f")){  //样式中间多余的空格勿删
                            if(j == 'onChange'){
                                map[i] = operation[i][j];
                                $("#"+i).datebox({ onChange:function(newVal, oldVal){
                                        eval(map[$(this).attr("id")]);
                                    }});
                            }
                        }
                    }

                }catch(e){

                }
            }

        }


        function setDefaultItem() {
            debugger
            var planDefalut = '${planDefault}';
            planDefalut = $.parseJSON(planDefalut);
            for(var p in planDefalut){
                try{
                    $("#Plan-"+p).combobox('setText',planDefalut[p]);
                }catch(e){

                }
                try{
                    $("#Plan-"+p).textbox('setValue',planDefalut[p]);
                }catch(e){

                }
                try{
                    $("#Plan-"+p).datebox('setText',planDefalut[p]);
                }catch(e){

                }
            }
        }


        var loadjs = function (path){
            $.getScript(""+path+"",function(){
                //alert("加载js成功！");
            })
        }

        function nextOnePage(curIndexId,curIndex){

            var nextPageIndex ;
            var tabTemplateList = ${tabTemplateList};
            var currentNameSpace;
            var nextNameSpace;
            for(var i in tabTemplateList){
                if(i ==parseInt(curIndex)+1 ){
                    debugger;
                    nextPageIndex = tabTemplateList[parseInt(curIndex)+1].id;
                    currentNameSpace = tabTemplateList[parseInt(curIndex)].ext2;
                    currentNameSpace = window[currentNameSpace];
                    nextNameSpace = tabTemplateList[parseInt(curIndex)+1].ext2;
                    nextNameSpace = window[nextNameSpace];
                    break;
                }
            }

            //    var aa=  currentNameSpace.goNextPage.bind( currentNameSpace,curIndexId ,nextPageIndex,parseInt(curIndex)+1);
            var flg = currentNameSpace.goNextPage(curIndexId ,nextPageIndex,parseInt(curIndex)+1);
            // var flg = aa();
            if(flg){
                $("#"+curIndexId).css('display','none');
                $("#"+nextPageIndex).css('display','');
                evalLoadDatagrid(parseInt(curIndex)+1);
                setTimeout(function(){
                    nextNameSpace.loadData('');
                    /* var bb=  nextNameSpace.loadData.bind( nextNameSpace,'');
                     bb();*/
                },50);

            }

        }

        function beforeOne(curIndexId,curIndex){
            if(curIndex == 0 || curIndex == "0"){

                $('#changeInfo').panel({closed : true});
                $('#changeReason').panel({closed : false});
                $('#changeAnalysis').panel({closed : true});
                $('#changeTotal').panel({closed : true});
                $('#formCancelBtn').focus();

                /*	$('#page1').css('display','');
                    $('#page2').css('display','none');
        */
            }else{
                var beforePageIndex ;
                var tabTemplateList = ${tabTemplateList};
                for(var i in tabTemplateList){
                    if(i ==parseInt(curIndex)-1 ){
                        beforePageIndex = tabTemplateList[parseInt(curIndex)-1].id;
                        break;
                    }
                }
                $("#"+curIndexId).css('display','none');
                $("#"+beforePageIndex).css('display','');
            }

        }


        // 下载导入模板
        function downloadAttachment() {
            //window.location.href='planChangeController.do?fileDown22&filePath=${temporaryPlan_.changeInfoDocPath}';
            window.location.href='jackrabbitFileController.do?fileDown&filePath=${temporaryPlan_.changeInfoDocPath}&fileName=${temporaryPlan_.changeInfoDocName}';
        }

        function evalLoadDatagrid(curIndex){
            try{
                eval("loadDatagrid_"+curIndex+"();");
                this["loadDatagrid_"+curIndex+""] = function(){};
            }catch(e){

            }
        }

        function nextOne() {
            //var changeType = $('#changeType').combobox('getValue');
            var changeType = $('#changeType').combotree('getValue');
            var changeRemark = $('#changeRemark').val();
            if(changeType == ""){
                tip('<spring:message code="com.glaway.ids.pm.project.plan.emptyChangeType"/>');
                return false;
            }
            if(changeRemark.length>200){
                tip('<spring:message code="com.glaway.ids.common.remarkLength"/>')
                return false;
            }
            $('#changeReason').panel({closed:true});
            $('#changeInfo').panel({closed:false});
            $('#formCancelBtn').focus();
            $('#changeAnalysis').panel({closed:true});
            $('#changeTotal').panel({closed:true});
            start();
        }


        var editFormElementIndex = undefined;
        function endFormElementEditing(){
            if (editFormElementIndex == undefined){return true}
            if ($('#resourceList').datagrid('validateRow', editFormElementIndex)){

                $('#resourceList').datagrid('endEdit', editFormElementIndex);
                editFormElementIndex = undefined;
                return true;
            } else {
                return false;
            }
        }

        function onClickPlanRow(index) {
            if (editFormElementIndex != index){
                if (endFormElementEditing()){
                    $('#resourceList').datagrid('selectRow', index).datagrid('beginEdit', index);
                    editFormElementIndex = index;
                } else {
                    $('#resourceList').datagrid('selectRow', editFormElementIndex);
                }
            }
        }

        function nextTwo() {
            try{
                var parentStartTime = $('#parentStartTime').val();
                var parentEndTime = $('#parentEndTime').val();
                var preposeEndTime = $('#preposeEndTime').val();
                var win = $.fn.lhgdialog("getSelectParentWin");
                var planName = $('#Plan-planName').val();
                if (planName == "") {
                    win.tip('<spring:message code="com.glaway.ids.pm.project.plan.emptyName"/>');
                    return false;
                }
                if (planName.length > 30) {
                    win.tip('<spring:message code="com.glaway.ids.pm.project.plan.basicLine.nameLength"/>')
                    return false;
                }
                var owner = $('#Plan-owner').combobox('getValue');
                if (owner == "") {
                    win.tip('<spring:message code="com.glaway.ids.pm.project.plan.emptyManager"/>');
                    return false;
                }

                var userList = eval($('#userList').val());

                var a = 0;
                for (var i = 0; i < userList.length; i++) {
                    if (owner == userList[i].id) {
                        a = 1;
                    }
                }

                var planStartTime = $('#Plan-planStartTime').datebox('getValue');
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
                        win.tip('<spring:message code="com.glaway.ids.pm.project.plan.startInProjectTime" arguments="'
							+ parentStartTime + '~' + parentEndTime + '"/>');
                        return false;
                    }
                }

                var planEndTime = $('#Plan-planEndTime').datebox('getValue');
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
                        win.tip('<spring:message code="com.glaway.ids.pm.project.plan.startInProjectTime" arguments="'
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

                var workTime = $('#Plan-workTime').val();
                var reg = new RegExp("^[0-9]*$");
                if (workTime == "") {
                    win.tip('<spring:message code="com.glaway.ids.pm.project.plan.emptyPeriod"/>');
                    return false;
                }

                if (!reg.test(workTime)) {
                    win.tip('<spring:message code="com.glaway.ids.pm.project.plan.periodMustNumber"/>');
                    return false;
                }

                var remark = $('#Plan-remark').val();
                if (remark.length > 200) {
                    win.tip('<spring:message code="com.glaway.ids.common.remarkLength"/>');
                    return false;
                }

                var rows = $('#resourceList').datagrid('getRows');
                var planStartTime = $('#Plan-planStartTime').datebox('getValue');
                var planEndTime = $('#Plan-planEndTime').datebox('getValue');
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
            }catch (e) {

            }

            changeAnalysisInit();
            $('#analysisCancelBtn').focus();
        }


        function modifyResourceList(){
            var rows = $('#resourceList').datagrid('getRows');
            var resourceNames = [];
            var useRates = [];
            var startTimes = [];
            var endTimes = [];

            if(rows.length > 0){
                for(var i = 0; i < rows.length; i++){
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
            $('#changeTotal').panel({closed:false});
            $('#changeInfo').panel({closed:true});
            $('#changeReason').panel({closed:true});
            $('#changeAnalysis').panel({closed:true});
            $('#totalCancelBtn').focus();
            //$("#startPlanchange").attr({disabled : false});
            initChangeVo();
        }

        function beforeTwo() {
            $('#changeReason').panel({closed:false});
            $('#changeInfo').panel({closed:true});
            $('#changeAnalysis').panel({closed:true});
            $('#changeTotal').panel({closed:true});
            $('#reasonCancelBtn').focus();
        }

        function beforeThree() {
            $('#changeInfo').panel({closed:false});
            $('#changeReason').panel({closed:true});
            $('#changeAnalysis').panel({closed:true});
            $('#changeTotal').panel({closed:true});
            $('#formCancelBtn').focus();
        }

        function beforeFour() {
            $('#changeAnalysis').panel({closed:false});
            $('#changeInfo').panel({closed:true});
            $('#changeReason').panel({closed:true});
            $('#changeTotal').panel({closed:true});
            $('#analysisCancelBtn').focus();
        }

        function viewPlan() {
            $('#one').show();
            $('#two').hide();
            $('#three').hide();
        }
        function viewDocument() {
            $('#one').hide();
            $('#two').show();
            $('#three').hide();
            initDocumentChange();
        }
        function viewResource() {
            $('#one').hide();
            $('#two').hide();
            $('#three').show();
            editFormElementIndex = undefined;
            initResourceChange();
        }
        function start() {

            var owner = $('#owner').combobox('getValue');
            var userList = eval($('#userList').val());
            for (var i = 0; i < userList.length; i++) {
                if (owner == userList[i].id) {
                    $('#owner').combobox('setValue',userList[i].realName);
                    break;
                }
            }
            initInputChange2();
            initDocumentChange();
            initResourceChange();

            var changeType = $('#changeType').combotree('getValue');
            //var changeType = $('#changeType').combobox('getValue');
            var planChangeCategoryList = eval($('#planChangeCategoryListStr').val());
            for(var i=0;i<planChangeCategoryList.length;i++){
                if( changeType == planChangeCategoryList[i].id){
                    $('#changeTypeAfter').textbox("setValue",planChangeCategoryList[i].name);
                }
            }
            var changeRemark = $('#changeRemark').val();
            $('#changeRemarkAfter').textbox("setValue",changeRemark);
			var length = changeRemark.length;
			$("#tAreaNum_changeRemarkAfter").text(length);

        }

        function initInputChange2() {
            /* if($('#preposeIds').val()!=undefined && $('#preposeIds').val()!=''){
                $('#haveNopre').css("display", "none");
                $('#havePre').css("display", "block"); */
            $.ajax({
                type : 'POST',
                url : 'planChangeController.do?inputListView',
                async : false,
                data : {
                    planId : $("#planId").val()
                },
                success : function(data) {
                    $("#inputList").datagrid("loadData",data);
                }
            });
            /* }else{
                $('#havePre').css("display", "none");
                $('#haveNopre').css("display", "block");
            } */

        }

        function initInputChange() {
            /* if($('#preposeIds').val()!=undefined && $('#preposeIds').val()!=''){
                $('#haveNopre').css("display", "none");
                $('#havePre').css("display", "block"); */
            $.ajax({
                type : 'POST',
                url : 'planChangeController.do?inputList',
                async : false,
                data : {},
                success : function(data) {
                    $("#inputList").datagrid("loadData",data);
                }
            });
            /* }else{
                $('#havePre').css("display", "none");
                $('#haveNopre').css("display", "block");
            } */
        }


        function changeAnalysisInit() {

            $.post('planChangeController.do?checkChildPostposeInfluenced', {
                planStartTime : $('#Plan-planStartTime').datebox('getValue'),
                planEndTime : $('#Plan-planEndTime').datebox('getValue')
            }, function(data) {
                var d = $.parseJSON(data);
                if (d.success) {
                    var msg = d.msg;
                    var a = msg.indexOf("产生影响");
                    if(msg == null || msg == '' || msg == undefined|| msg == '<br/>'){
                        var planChildTimeArea =	'系统未检测到此次变更产生的影响';
                        $('#planChildTimeArea').html(planChildTimeArea);
                        $("#influencedNull").attr("style","display:none;");

                        $('#changeInfo').panel({closed:true});
                        $('#changeReason').panel({closed:true});
                        $('#changeAnalysis').panel({closed:false});
                        $('#changeTotal').panel({closed:true});
                    }
                    else if(a == 0){
                        $("#influencedNull").attr("style","display:block;");
                        var planChildTimeArea =	'子计划（时间需要收敛在' + $('#Plan-planStartTime').datebox('getValue') + '~' + $('#Plan-planEndTime').datebox('getValue') + '）';
                        var planPostposeTimeArea = '后置计划（开始时间不得早于' + $('#Plan-planEndTime').datebox('getValue') + '）';
                        $('#planChildTimeArea').html(planChildTimeArea);
                        $('#planPostposeTimeArea').html(planPostposeTimeArea);
                        var tableId1 = 'temporaryPlanChildList';
                        var url1 = 'planChangeController.do?temporaryPlanChildList&planStartTime='
                            +$('#Plan-planStartTime').datebox('getValue')
                            +'&planEndTime='+$('#Plan-planEndTime').datebox('getValue');
                        loadTableData(tableId1, url1);

                        var tableId2 = 'temporaryPlanPostposeList';
                        var url2 = 'planChangeController.do?temporaryPlanPostposeList&planStartTime='
                            +$('#Plan-planStartTime').datebox('getValue')
                            +'&planEndTime='+$('#Plan-planEndTime').datebox('getValue');
                        loadTableData(tableId2, url2);

                        $('#changeInfo').panel({closed:true});
                        $('#changeReason').panel({closed:true});
                        $('#changeAnalysis').panel({closed:false});
                        $('#changeTotal').panel({closed:true});
                    }
                    else{
                        top.tip(msg);
                    }
                }
            })
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

        // 继承父项
        function inheritParent() {
            var dialogUrl = 'planChangeController.do?goAddTempInherit&planId=${temporaryPlan_.planId}&parentPlanId=1';
            createDialog('inheritDialog', dialogUrl);
        }

        function loadTableData(tableId, url){
            $.ajax({
                url : url,
                type : 'post',
                data : {},
                cache : false,
                success : function(data) {
                    $("#"+tableId).datagrid("loadData",data);
                }
            });
        }


        function addTempPlan() {
        	debugger;
            //$("#startPlanchange").attr({disabled : "disabled"});
            var id = $('#temporaryPlanId').val();
            var planNumber = $('#planNumber').val();
            var planId = $('#planId').val();
            var projectId = $('#projectId').val();
            var parentPlanId = $('#parentPlanId').val();
            var beforePlanId = $('#beforePlanId').val();
            var bizCurrent = $('#bizCurrent').val();
            var planName = $('#Plan-planName').val();
            var remark = $('#Plan-remark').val();
            //var owner = $('#owner').combobox('getValue');
            var owner = $('#Plan-owner').combobox('getValue');
            var userList = eval($('#userList2').val());
            /* for (var i = 0; i < userList.length; i++) {
                if (owner == userList[i].realName) {
                    owner = userList[i].id;
                }
            } */
            if(owner == $('#ownerShow').val()){
                owner = $('#ownerReal').val();
            }
            var taskNameType = $('#Plan-taskNameType').combobox('getValue');
            var taskType = $('#Plan-taskType').combobox('getValue');
            var planLevel = $('#Plan-planLevel').combobox('getValue');
            var planLevelList = eval($('#planLevelList').val());
            for (var i = 0; i < planLevelList.length; i++) {
                if (planLevel == planLevelList[i].name) {
                    planLevel = planLevelList[i].id;
                    break;
                }
            }
            var planStartTime = $('#Plan-planStartTime').datebox('getValue');
            var workTime = $('#Plan-workTime').val();
            var planEndTime = $('#Plan-planEndTime').datebox('getValue');
            var milestone = $('#Plan-milestone').combobox('getValue');
            var preposeIds = $('#preposeIds').val();
            var changeRemark = $('#changeRemark').val();
            var changeType = $('#changeType').combotree('getValue');
            //var changeType = $('#changeType').combobox('getValue');
            var changeInfoDocPath = $('#changeInfoDocPath').val();
            var changeInfoDocName = $('#changeInfoDocName').val();

            var fileSize = $('#file_upload').data('uploadify').queueData.queueLength;
            if (fileSize > 0) {
                $('#file_upload').fduploadify('upload');
            }
            else{
				$.ajax({
					type: 'POST',
					data: {
						ids: id,
						useObjectType: "PLAN"
					},
					url: "planChangeController.do?checkOriginIsNullBeforeSub",
					cache: false,
					success: function (data) {
						var d = $.parseJSON(data);
						if (d.success) {
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
								'taskNameType' : taskNameType,
								'taskType' : taskType,
								'owner' : owner,
								'planLevel' : planLevel,
								'workTime' : workTime,
								'milestone'	: milestone,
								'preposeIds' : preposeIds,
								'changeRemark' : changeRemark,
								'changeType' : changeType,
								'changeInfoDocPath' : changeInfoDocPath,
								'changeInfoDocName' : changeInfoDocName,
								'preposeIds' : preposeIds
							}, function(data) {
								var d = $.parseJSON(data);
								if(d.success){
									startPlanChangeFlow();
								}
								else{
									top.tip(d.msg);
								}
							});
						}else{
							top.tip("存在没有挂载的输入，不可提交");
							return false;
						}
					}
				});
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
            var rows22 = $('#resourceList').datagrid('getRows');
            var t = $('#resourceList');
            for (var i = 0; i < rows22.length; i++) {
                t.datagrid('endEdit', i);
            }
            editFormElementIndex = undefined;
            modifyResourceList();
            gridname = 'resourceList';
            var dialogUrl = 'planChangeController.do?goAddResourceTemp&useObjectId='+ $('#useObjectId').val()
                + '&useObjectType='	+ $('#useObjectType').val()
                + '&planStartTime='	+ $('#planStartTime').datebox('getValue')
                + '&planEndTime='	+ $('#planEndTime').datebox('getValue');
            createDialog('addResourceDialog',dialogUrl);


        }

        function addResourceDialog(iframe){
            var flg=iframe.getLoadData();
            if(flg && initResource2(flg) ){
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
            createDialog('addDeliverableDialog',dialogUrl);
        }

        function addDeliverableDialog(iframe){
            var flg=iframe.getLoadData();
            if(flg && initDocument2(flg)){
                return true;
            }
            return false;
        }

        /**
         * 选择前置计划页面
         */
        var preposeIdActual  = $('#preposeIds').val();
        function selectPreposePlan(hiddenId, textId) {
            var url = 'planController.do?goPlanPreposeTree';
            if ($('#projectId').val() != "") {
                url = url + '&projectId=' + $('#projectId').val();
            }
            if ($('#parentPlanId').val() != "") {
                url = url + '&parentPlanId=' + $('#parentPlanId').val();
            }
            if ($('#id').val() != "") {
                url = url + '&id=' + $('#id').val();
            }
            if($('#preposeIds').val() != "") {
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
            createDialog('preposePlanDialog',url);

        }

        function preposePlanDialog(iframe){
            var preposeIds;
            var preposePlans;
            var preposeEndTime;
            var selectedId = iframe.mygrid_planPreposeList.getSelectedRowId();
            if(selectedId != undefined && selectedId != null && selectedId != '' ){
                var selectedIdArr = selectedId.split(",");
                if(selectedIdArr.length > 0){
                    for(var i=0;i<selectedIdArr.length;i++){
                        var id = selectedIdArr[i];
                        if(preposeIds != null && preposeIds != '' && preposeIds != undefined){
                            preposeIds = preposeIds + ',' + id;
                        }else{
                            preposeIds = id;
                        }
                        var planName = iframe.mygrid_planPreposeList.getRowAttribute(id,'displayName');
                        if(preposePlans != null && preposePlans != '' && preposePlans != undefined){
                            preposePlans = preposePlans + ',' + planName;
                        }else{
                            preposePlans = planName;
                        }
                        var planEndTime = iframe.mygrid_planPreposeList.getRowAttribute(id,'planEndTime');
                        if(preposeEndTime != null && preposeEndTime != '' && preposeEndTime != undefined){
                            if(preposeEndTime < planEndTime){
                                preposeEndTime = planEndTime;
                            }
                        }else{
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
            if (preposeIds != null && preposeIds != ''
                && preposeIds != undefined) {
                $('#preposeIds').val(preposeIds);
            } else {
                $('#preposeIds').val('');
            }
            if (preposePlans != null && preposePlans != ''
                && preposePlans != undefined) {
                $('#Plan-preposeIds').textbox("setValue",preposePlans);
            } else {
                $('#Plan-preposeIds').textbox("setValue","");
            }
            // 前置计划的最晚完成时间
            if (preposeEndTime != null && preposeEndTime != ''
                && preposeEndTime != undefined) {
                $('#preposeEndTime').val(preposeEndTime);
            } else {
                $('#preposeEndTime').val('');
            }
        }

        function viewStartEndTime(val, row, value) {
            var start = row.startTime;
            var end = row.endTime;
            if((start != undefined && start !=null && start != '')
                && (end != undefined && end !=null && end != '')){
                return dateFmtYYYYMMDD(start) + "~" + dateFmtYYYYMMDD(end);
            }
            return "";
        }

        function initDocumentChange() {
            $.ajax({
                type : 'POST',
                url : 'planChangeController.do?documentListView',
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
                url : 'planChangeController.do?resourceListView',
                async : false,
                data : {},
                success : function(data) {
                    try {
                        $("#resourceList").datagrid("loadData",data);
                    }
                    catch(e) {
                    }
                    finally {
                    }
                }
            });
        }


        // 删除交付项
        function deleteSelections(gridname, url) {
            var rows = $("#"+gridname).datagrid('getSelections');
            var ids = [];
            var names = [];
            if (rows.length > 0) {
                top.Alert.confirm('<spring:message code="com.glaway.ids.common.confirmDel"/>',
                    function(r) {
                        if (r) {
                            for ( var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].id);
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
                                    for(var i=rows.length-1;i>-1;i--){
                                        var a = $("#"+gridname).datagrid('getRowIndex',rows[i]);
                                        $("#"+gridname).datagrid('deleteRow',$("#"+gridname).datagrid('getRowIndex',rows[i]));

                                    }
                                    $("#"+gridname).datagrid('clearSelections');
                                    initDocument2();
                                }
                            });
                        }
                    });
            } else {
                tip('<spring:message code="com.glaway.ids.common.selectDel"/>');
            }
        }


        // 删除资源
        function deleteSelections2(gridname, url) {
            var rows22 = $('#resourceList').datagrid('getRows');
            var t = $('#resourceList');
            for (var i = 0; i < rows22.length; i++) {
                t.datagrid('endEdit', i);
            }
            editFormElementIndex = undefined;
            modifyResourceList();
            var rows = $("#"+gridname).datagrid('getSelections');
            var ids = [];
            if (rows.length > 0) {
                top.Alert.confirm('<spring:message code="com.glaway.ids.common.confirmDel"/>',
                    function(r) {
                        if (r) {
                            for ( var i = 0; i < rows.length; i++) {
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
                                    for(var i=rows.length-1;i>-1;i--){
                                        var a = $("#"+gridname).datagrid('getRowIndex',rows[i]);
                                        $("#"+gridname).datagrid('deleteRow',$("#"+gridname).datagrid('getRowIndex',rows[i]));

                                    }
                                    $("#"+gridname).datagrid('clearSelections');
                                    initResource2();
                                }
                            });
                        }
                    });
            } else {
                tip('<spring:message code="com.glaway.ids.common.selectDel"/>');
            }
        }


        function afterCall(){
            tip('上传完成。');
        }
        var changeInfoDocPathPd;
        var changeInfoDocNamePd;
        function afterSubmitChangeInfo(file, data, response){
            top.jeasyui.util.tagMask('close');
            var jsonObj = $.parseJSON(data);
            var fileStr = jsonObj.obj;
            var size = (file.size)/(1024*1024);
            if(size > 5 ){
                tip('<spring:message code="com.glaway.ids.pm.project.plan.docSizeLimit"/>');
                $('#file_upload').uploadify('cancel', '*');
                return false;
            }
            else{
                /* changeInfoDocPathPd = fileStr.split(',')[1];
                changeInfoDocNamePd = fileStr.split(',')[0]; */
                $('changeInfoDocPath').val(fileStr.split(',')[1]);
                var id = $('#temporaryPlanId').val();
                var planNumber = $('#Plan-planNumber').val();
                var planId = $('#planId').val();
                var projectId = $('#projectId').val();
                var parentPlanId = $('#parentPlanId').val();
                var beforePlanId = $('#beforePlanId').val();
                var bizCurrent = $('#bizCurrent').val();
                var planName = $('#Plan-planName').val();
                var remark = $('#Plan-remark').val();
                var owner = $('#Plan-owner').combobox('getValue');
                var userList = eval($('#userList2').val());
                if(owner == $('#ownerShow').val()){
                    owner = $('#ownerReal').val();
                }
                var taskNameType = $('#Plan-taskNameType').combobox('getValue');
                var taskType = $('#Plan-taskType').combobox('getValue');
                var planLevel = $('#Plan-planLevel').combobox('getValue');
                var planLevelList = eval($('#planLevelList').val());
                for (var i = 0; i < planLevelList.length; i++) {
                    if (planLevel == planLevelList[i].name) {
                        planLevel = planLevelList[i].id;
                    }
                }
                var planStartTime = $('#Plan-planStartTime').datebox('getValue');
                var workTime = $('#Plan-workTime').val();
                var planEndTime = $('#Plan-planEndTime').datebox('getValue');
                var milestone = $('#Plan-milestone').combobox('getValue');
                var preposeIds = $('#preposeIds').val();
                var changeRemark = $('#changeRemark').val();
                var changeType = $('#changeType').combotree('getValue');
                //var changeType = $('#changeType').combobox('getValue');
                var leader = $('#leader').val();
                var deptLeader = $('#deptLeader').val();
                if (leader == '') {
                    tip('<spring:message code="com.glaway.ids.common.emptyOfficeLeader"/>');
                    return false;
                }
                if (deptLeader == '') {
                    tip('<spring:message code="com.glaway.ids.common.emptyDepartLeader"/>');
                    return false;
                }
                /* 	$.post('planChangeController.do?doSave', {
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
                        'taskNameType' : taskNameType,
                        'taskType' : taskType,
                        'owner' : owner,
                        'planLevel' : planLevel,
                        'workTime' : workTime,
                        'milestone'	: milestone,
                        'preposeIds' : preposeIds,
                        'changeRemark' : changeRemark,
                        'changeType' : changeType,
                        'changeInfoDocPath' : changeInfoDocPathPd,
                        'changeInfoDocName' : changeInfoDocNamePd,
                        'preposeIds' : preposeIds
                    }, function(data) {
                        var d = $.parseJSON(data);
                        if(d.success){
                            var oldAttachmentPath = '${temporaryPlan_.changeInfoDocPath}';
						$.ajax({
							url : 'planChangeController.do?startPlanChangeFlow&changeType='+"single",
							type : 'post',
							data : {
								oldAttachmentPath : oldAttachmentPath,
								'leader' : leader,
								'deptLeader' : deptLeader
							},
							cache : false,
							success : function(data) {
								var d = $.parseJSON(data);
								if(d.success){
									var msg = d.msg;
									top.tip(msg);
									if('${fromPath}' == 'tree'){
										var win = $.fn.lhgdialog("getSelectParentWin");
										var planListSearch = win.planListSearch();
									}else{
										W.getData();
									}
									$.fn.lhgdialog("closeAll");
								}
							}
						});
					}
					else{
						top.tip(d.msg);
					}
				}); */
            }

        }

        // 使用百分比
        function viewUseRate2(val, row, value){
            return progressRateGreen2(val);
        }

        function progressRateGreen2(val){
            if(val == undefined || val == null || val == ''){
                val = 0;
            }
            return val + '%' ;
        }


        function initDocument2(this_) {
            var datas="";
            var flg=false;
            if(this_ != null && this_ != '' && this_ != undefined){
                datas=this_;
            }else{
                datas={useObjectId : $('#useObjectId').val(),useObjectType : $('#useObjectType').val()}
            }
            $.ajax({
                type : 'POST',
                url : 'planChangeController.do?documentList',
                async : false,
                data : datas,
                success : function(data) {
                    try {
                        $("#deliverablesInfoList").datagrid('unselectAll');
                        $("#deliverablesInfoList").datagrid("loadData",data);
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
            var datas="";
            var flg=false;
            if(this_ != null && this_ != '' && this_ != undefined){
                datas=this_;
            }else{
                datas={useObjectId : $('#useObjectId').val(),useObjectType : $('#useObjectType').val()}
            }
            $.ajax({
                type : 'POST',
                url : 'planChangeController.do?resourceList',
                async : false,
                data : datas,
                success : function(data) {
                    try {
                        $("#resourceList").datagrid('unselectAll');
                        $("#resourceList").datagrid("loadData",data);
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

        function startPlanChangeFlow() {
            var leader = $('#leader').val();
            var deptLeader = $('#deptLeader').val();
            if (leader == '') {
                tip('<spring:message code="com.glaway.ids.common.emptyOfficeLeader"/>');
                return false;
            }
            if (deptLeader == '') {
                tip('<spring:message code="com.glaway.ids.common.emptyDepartLeader"/>');
                return false;
            }
            $.ajax({
                url : 'planChangeController.do?startPlanChangeFlow&changeType='+"single",
                type : 'post',
                data : {
                    oldAttachmentPath : '',
                    'leader' : leader,
                    'deptLeader' : deptLeader
                },
                cache : false,
                success : function(data) {
                    var d = $.parseJSON(data);
                    if (d.success) {
                        var msg = d.msg;
                        tip(msg);
                    }
                    if(d.success){
                        if('${fromPath}' == 'tree'){
                            var win = $.fn.lhgdialog("getSelectParentWin");
                            var planListSearch = win.planListSearch();
                        }else{
// 								W.getData();
                            try{
                                $.fn.lhgdialog("getSelectParentWin").parent.flashTaskShow();
                            }catch(e){

                            }

                            try{
                                $.fn.lhgdialog("getSelectParentWin").parent.$("#startTaskListMore_wait").datagrid('reload');
                            }catch(e){

                            }
                        }
                        $.fn.lhgdialog("closeAll");
                    }
                }
            });
        }


        function childPostposeTime(val, row, value) {
            var planStartTime = row.planStartTime;
            var startTimeOverflow = row.startTimeOverflow;
            var planEndTime = row.planEndTime;
            var endTimeOverflow = row.endTimeOverflow;
            var childPostposeTime = "";
            if(startTimeOverflow == true){
                childPostposeTime = '<a href="#" style="color:red">' + planStartTime	+ '</a>';
            }
            else{
                childPostposeTime = planStartTime;
            }
            if(endTimeOverflow == true){
                childPostposeTime = childPostposeTime + "~" + '<a href="#" style="color:red">' + planEndTime	+ '</a>';
            }
            else{
                childPostposeTime = childPostposeTime + "~" + planEndTime;
            }
            return childPostposeTime;
        }

        // 资源名称链接事件
        function resourceNameLink(val, row, value) {
            return '<a href="#" onclick="viewResourceCharts(\'' + row.resourceId + '\')" style="color:blue">' + val + '</a>';
        }

        // 资源名称链接事件
        function viewResourceCharts(resourceId){
            var rows = $("#resourceList").datagrid('getRows');
            var row;
            for(var i = 0; i < rows.length; i++) {
                if(resourceId == rows[i].resourceId){
                    row = rows[i];
                    break;
                }
            }
            if(row.useRate != null && row.useRate != '' && row.startTime != null && row.startTime != '' && row.endTime != null && row.endTime != ''){

                var startTime = $('#planStartTime').datebox('getValue');
                var endTime = $('#planEndTime').datebox('getValue');
                createDialog('resourceDialog',
                    "resourceLinkInfoController.do?goToUsedRateReport&resourceId="
                    + row.resourceId + "&startTime=" + startTime + "&endTime=" + endTime);
            }
            else{
                tip('<spring:message code="com.glaway.ids.pm.project.plan.resource.emptyUseInfo"/>');
            }
        }

        /**国际化转移方法**/
        function workTimeLinkage(inputType) {
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

            /* 	if (inputType1 == 'planEndTime' && inputType2 == 'workTime') {
                    inputType1 = undefined;
                    inputType2 = undefined
                    return false;
                } */

            if (inputType == 'planStartTime') {
                if (planStartTime != null && planStartTime != ''
                    && planStartTime != undefined) {
                    if (workTime != null && workTime != '' && workTime != undefined) {
                        if (workTime == 0) {
                            $('#workTime').textbox("setValue", "");
                            win.tip("工期不能为0");
                        } else {
                            $
                                .ajax({
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
                                                $('#planEndTime')
                                                    .datebox("setValue",
                                                        planEndTime);
                                            } else {
                                                $('#planStartTime')
                                                    .datebox("setValue",
                                                        planEndTime);
                                                win.tip(d.msg);
                                            }
                                        } else {
                                            win
                                                .tip('<spring:message code="com.glaway.ids.pm.project.plan.endTimeError"/>');
                                        }
                                    }
                                });
                        }
                    } else if (planEndTime != null && planEndTime != ''
                        && planEndTime != undefined) {
                        if (planEndTime < planStartTime) {
                            $('#planEndTime').datebox("setValue", "");
                        } else {

                            $
                                .ajax({
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
                                                $('#workTime').textbox(
                                                    "setValue", workTime);
                                            } else {
                                                win.tip(d.msg);
                                            }
                                        } else {
                                            win
                                                .tip('<spring:message code="com.glaway.ids.pm.project.plan.periodError"/>');
                                        }
                                    }
                                });
                        }
                    }
                } else {
                    win
                        .tip('<spring:message code="com.glaway.ids.pm.project.plan.emptyStart"/>');
                }
            } else if (inputType == 'workTime') {
                if (workTime != null && workTime != '' && workTime != undefined) {
                    if (planStartTime != null && planStartTime != ''
                        && planStartTime != undefined) {
                        if (workTime == 0) {
                            $('#workTime').textbox("setValue", "");
                            win
                                .tip('<spring:message code="com.glaway.ids.pm.project.plan.periodNotZero"/>');
                        } else {
                            $
                                .ajax({
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
                                                $('#planEndTime')
                                                    .datebox("setValue",
                                                        planEndTime);
                                            } else {
                                                win.tip(d.msg);
                                            }
                                        } else {
                                            win
                                                .tip('<spring:message code="com.glaway.ids.pm.project.plan.endTimeError"/>');
                                        }
                                    }
                                });
                        }
                    } else {
                        win
                            .tip('<spring:message code="com.glaway.ids.pm.project.plan.emptyStart"/>');
                    }
                }
            } else if (inputType == 'planEndTime') {
                if (planEndTime != null && planEndTime != ''
                    && planEndTime != undefined) {
                    if (planStartTime != null && planStartTime != ''
                        && planStartTime != undefined) {
                        if (planEndTime < planStartTime) {
                            win
                                .tip('<spring:message code="com.glaway.ids.pm.project.plan.startNoLaterThanEnd"/>');
                        } else {
                            $
                                .ajax({
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
                                                    $('#workTime').textbox(
                                                        "setValue", "");
                                                    win
                                                        .tip('<spring:message code="com.glaway.ids.pm.project.plan.periodNotZero"/>');
                                                } else {
                                                    $('#workTime').textbox(
                                                        "setValue",
                                                        workTime);
                                                }
                                            } else {
                                                win.tip(d.msg);
                                            }
                                        } else {
                                            win
                                                .tip('<spring:message code="com.glaway.ids.pm.project.plan.periodError"/>');
                                        }
                                    }
                                });
                        }
                    } else {
                        win
                            .tip('<spring:message code="com.glaway.ids.pm.project.plan.emptyStart"/>');
                    }
                }
            }
        }


        function initChangeVo() {
            debugger;
            var id = $('#id').val();
            var planNumber = $('#Plan-planNumber').val();
            var planId = $('#planId').val();
            var projectId = $('#projectId').val();
            var parentPlanId = $('#parentPlanId').val();
            var beforePlanId = $('#beforePlanId').val();
            var bizCurrent = $('#bizCurrent').val();
            var planName = $('#Plan-planName').val();
            var remark = $('#Plan-remark').val();
            var owner = $('#Plan-owner').combobox('getValue');
            /* var userList = eval($('#userList2').val());
            for (var i = 0; i < userList.length; i++) {
                var a = owner.indexOf(userList[i].realName);
                if (a == 0) {
                    owner = userList[i].id;
                }
            } */
            if(owner == $('#ownerShow').val()){
                owner = $('#ownerReal').val();
            }
            var ownerRealName = $('#Plan-owner').combobox('getText');
            var planLevel = $('#Plan-planLevel').combobox('getValue');
            var planLevelList = eval($('#planLevelList').val());
            for (var i = 0; i < planLevelList.length; i++) {
                if (planLevel == planLevelList[i].name) {
                    planLevel = planLevelList[i].id;
                }
            }
            var planLevelName = $('#Plan-planLevel').combobox('getText');
            var planStartTime = $('#Plan-planStartTime').datebox('getValue');
            var planStartTimeView = $('#Plan-planStartTime').datebox('getText');
            var workTime = $('#Plan-workTime').val();
            var planEndTime = $('#Plan-planEndTime').datebox('getValue');
            var planEndTimeView = $('#Plan-planEndTime').datebox('getText');
            var milestone = $('#Plan-milestone').combobox('getValue');
            if(milestone == "是"){
                milestone = "true";
            }else if(milestone == "否"){
                milestone = "false";
            }
            var preposeIds = $('#preposeIds').val();
            var changeRemark = $('#changeRemark').val();
            var changeType = $('#changeType').combotree('getValue');
            //var changeType = $('#changeType').combobox('getValue');
            var changeInfoDocPath = $('#changeInfoDocPath').val();
            var preposePlans = $('#preposePlans').val();
            var ownerDept = $('#Plan-ownerDept').val();
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
                    'milestone'	: milestone,
                    'preposeIds' : preposeIds,
                    'preposePlans' : preposePlans,
                    'changeRemark' : changeRemark,
                    'changeType' : changeType,
                    'changeInfoDocPath' : changeInfoDocPath,
                    'preposeIds' : preposeIds
                },
                success : function(data) {
                    $("#planChangeVo").datagrid("loadData",data);
                }
            });
        }


        // 新增交付项
        function addInput() {
            gridname = 'inputList';
            var dialogUrl = 'planChangeController.do?goAddInputTemp&useObjectId='
                + $('#useObjectId').val()
                + '&useObjectType='
                + $('#useObjectType').val()
                + '&preposeIds='+ $('#preposeIds').val();
            createDialog('addInputDialog',dialogUrl);

        }

        function addInputDialog(iframe){
            var flg=iframe.getLoadData();
            if(flg){
                TC002.loadData(flg);
                return true;
            }
            return false;
        }


        // 删除交付项
        function deleteSelections3(gridname, url) {
            var rows = $("#"+gridname).datagrid('getSelections');
            var win = $.fn.lhgdialog("getSelectParentWin");
            /* for(var i =0;i<rows.length;i++){
                if(rows[i].origin != ''&&rows[i].origin !=null&&rows[i].origin !=undefined){
                    win.tip('<spring:message code="com.glaway.ids.pm.project.plan.deliveryDelLimit" arguments="' + rows[i].name + '"/>');
	    		return false;
	    	}
	    } */

            var ids = [];
            var names = [];
            if (rows.length > 0) {
                top.Alert.confirm('<spring:message code="com.glaway.ids.common.confirmDel"/>',
                    function(r) {
                        if (r) {
                            for ( var i = 0; i < rows.length; i++) {
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
                                    for(var i=rows.length-1;i>-1;i--){
                                        var a = $("#"+gridname).datagrid('getRowIndex',rows[i]);
                                        $("#"+gridname).datagrid('deleteRow',$("#"+gridname).datagrid('getRowIndex',rows[i]));

                                    }
                                    $("#"+gridname).datagrid('clearSelections');
                                    initInput2();
                                }
                            });
                        }
                    });
            } else {
                win.tip('<spring:message code="com.glaway.ids.common.selectDel"/>');
            }
        }

        function initInput2(this_) {
            var datas="";
            var flg=false;
            if(this_ != null && this_ != '' && this_ != undefined){
                datas=this_;
            }else{
                datas={useObjectId : $('#useObjectId').val(),useObjectType : $('#useObjectType').val()}
            }
            $.ajax({
                type : 'POST',
                url : 'planChangeController.do?inputList',
                async : false,
                data : datas,
                success : function(data) {
                    try {
                        $("#inputsList").datagrid('unselectAll');
                        $("#inputsList").datagrid("loadData",data);
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

        /* function addLink(val, row, value){
            if(val!=null&&val!=''){
                return '<a  href="#" onclick="showDocDetail(\'' + row.docId + '\',this)" id="myDoc"  style="color:blue">'+val+'</a>';
            }else return ;

        } */

        function showDocDetail(id){
            var url="projLibController.do?viewProjectDocDetail&opFlag=1&id="+id;
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
                createDialog('showDocDetailChangeFlowDialog',url);

            } else {
                createDialog('showDocDetailChangeFlowDialog',url);
            }
        }


        function changeInput(){
            $('#four').panel('collapse');
            var preposeIds = $('#preposeIds').val();
            var planId = $('#planId').val();
// 		$('#haveNopre').css("display", "none");
// 		$('#havePre').css("display", "block");
            if($('#preposeIds').val()!=undefined && $('#preposeIds').val()!=''){
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
            }else{
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
        /* function addLink(val, row, value){
            if(val!=null&&val!=''){
                return '<a  href="#" onclick="showDocDetail(\'' + row.docId + '\',this)" id="myDoc"  style="color:blue">'+val+'</a>';
            }else return ;

        } */

        function showDocDetail(id){
            var url="projLibController.do?viewProjectDocDetail&opFlag=1&id="+id;
            createDialog('openAndSubmitDialog',url);
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
            if (flg && initInput2(flg)) {
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
                        $('#inputsList').datagrid('clearSelections');
                    }
                });
            }else{
                return false;
            }
        }


        function addLocalFileDialog(iframe){
            var attachmentName = iframe.$("#docattachmentName1").val();
            var dowmLoadUrl = iframe.$("#docattachmentURL1").val();
            var attachmentShowName = iframe.$("#docAttachmentShowName1").val();
            var invalidIds = iframe.$("#invalidIds1").val();

            $("#docattachmentName").val(attachmentName);
            $("#docattachmentURL").val(dowmLoadUrl);
            $("#docAttachmentShowName").val(attachmentShowName);
            $("#invalidIds").val(invalidIds);

            $.ajax({
                type : "POST",
                url : "projLibController.do?doAddForPlanChangeLocalDoc&attachmentNames="+ attachmentName+"&dowmLoadUrls="+ attachmentName,
                async : false,
                data :   $('#planChangeForm').serialize(),
                success : function(data) {
                    var d = $.parseJSON(data);
                    if (d.success) {
                        initInput2('');
                        return true;
                    }else{
                        return false;
                    }


                }
            });
            return true;
        }

</script>
</head>
<body>
	<div border="false" class="easyui-panel div-msg" id="changeReason" fit="true">
		<div class="easyui-panel" fit="true">
			<%-- <fd:combobox id="changeType" textField="name" title="{com.glaway.ids.pm.project.plan.changeType}" selectedValue="${temporaryPlan_.changeType}" editable="false" valueField="id" 
							url="planChangeMassController.do?planChangeCategorylList" ></fd:combobox> --%>
				<fd:combotree title="{com.glaway.ids.pm.project.plan.changeType}" treeIdKey="id" name="changeType" value="${temporaryPlan_.changeType}"
					url="planChangeMassController.do?planChangeCategorylList" id="changeType" treePidKey="parentId"
					editable="false" multiple="false" panelHeight="200" treeName="name" required="true"
					prompt="请选择"></fd:combotree> 
			<fd:uploadify name="files" id="file_upload" title="{com.glaway.ids.common.lable.uploadAttachment}" uploader="planChangeController.do?saveFiles" 
				auto="true" multi="false" showPanel="false" dialog="false" extend="*.*" >
				<fd:eventListener event="onUploadSuccess" listener="afterSubmitChangeInfo" />
			</fd:uploadify><!-- <input type="button" value="zjFunc" onclick="zjFunc()"><input type="button" value="qllFunc" onclick="qllFunc()"> -->
			<!-- <script>
			function zjFunc(){
				$('#file_upload').uploadify('cancel', '*');
			}
			function qllFunc(){
				$('#textbox_file_upload').textbox('setText','')
			}
			</script> -->
			<c:if test="${temporaryPlan_.changeInfoDocName != '' && temporaryPlan_.changeInfoDocName != null}">
				<fd:label title="附件" id="file_upload_label" jsFunc="downloadAttachment()" content="${temporaryPlan_.changeInfoDocName}"/>
			</c:if>
			<fd:inputTextArea id="changeRemark" title="{com.glaway.ids.common.lable.remark}" name="changeRemark" value="${temporaryPlan_.changeRemark}">
			</fd:inputTextArea>
		</div>		
			
		<div class="div-msg-btn">
            <div class="ui_buttons">
                <fd:linkbutton onclick="nextOne()" value="{com.glaway.ids.pm.project.plan.nextone}" classStyle="button_nor" />
                <fd:linkbutton id="reasonCancelBtn" onclick="closePlan()" value="{com.glaway.ids.common.btn.cancel}" classStyle="ui_state_highlight lhgdialog_cancle" />
            </div>
		</div>
	</div>
	
	<!-- document begin -->
	<div border="false" id="changeInfo" class="easyui-panel div-msg div-msg-fit" fit="true" style="width:100%;height:100%">

		<fd:form id="planChangeForm">
			<input id="changeRemarkMid" name="changeRemarkMid" type="hidden" />
			<input id="planChangeCategoryListStr" name="planChangeCategoryListStr" type="hidden" value="${planChangeCategoryListStr}"/>
			<input id="planId" name="planId" type="hidden" value="${temporaryPlan_.planId}" />
			<input id="temporaryPlanId" name="temporaryPlanId" type="hidden" value="${temporaryPlan_.id}" />
			<input id="planId" name="planId" type="hidden" value="${temporaryPlan_.planId}" />
			<input id="useObjectId" name="useObjectId" type="hidden" value="${useObjectId}" />
			<input id="useObjectType" name="useObjectType" type="hidden" value="${useObjectType}" />
			<input id="planNumber" name="planNumber" type="hidden" value="${temporaryPlan_.planNumber}" />
			<input id="projectId" name="projectId" type="hidden" value="${temporaryPlan_.projectId}" />
			<input id="parentPlanId" name="parentPlanId" type="hidden" value="${temporaryPlan_.parentPlanId}" />
			<input id="beforePlanId" name="beforePlanId" type="hidden" value="${temporaryPlan_.beforePlanId}" />
			<input id="bizCurrent" name="bizCurrent" type="hidden" value="${temporaryPlan_.bizCurrent}" />
			<input id="preposeList" name="preposeList" type="hidden" value="${temporaryPlan_.preposeList}" />
			<input id="rescLinkInfoList" name="rescLinkInfoList" type="hidden" value="${temporaryPlan_.rescLinkInfoList}" />
			<input id="parentStartTime" name="parentStartTime" type="hidden" value="${parentStartTime}" />
			<input id="parentEndTime" name="parentEndTime" type="hidden" value="${parentEndTime}" />
			<input id="preposeEndTime" name="preposeEndTime" type="hidden" value="${preposeEndTime}" />
			<input id="departList" name="departList" type="hidden" value="${departList}" />
			<input id="userList"  name="userList" type="hidden" value="${userList}" />
			<input id="userList2"  name="userList2" type="hidden" value="${userList2}" />
			<input id="ownerShow"  name="ownerShow" type="hidden" value="${ownerShow}" />
			<input id="ownerReal"  name="ownerReal" type="hidden"value="${temporaryPlan_.owner}" />
			<input name="invalidIds" id="invalidIds" type="hidden" />
			<input id="docattachmentName" name="docattachmentName" type="hidden" />
			<input id="docattachmentURL" name="docattachmentURL" type="hidden" />
			<input id="docAttachmentShowName" name="docAttachmentShowName" type="hidden" />
			<input id="useObjectId" name="useObjectId" type="hidden" value="${useObjectId}" />
			<input id="useObjectType" name="useObjectType" type="hidden" value="${useObjectType}" />
			<input id="planLevelList" name="planLevelList" type="hidden" value="${planLevelList_}" />
			<input name="preposeIds" id="preposeIds" value="${temporaryPlan_.preposeIds}" type="hidden" />
            <input id="assigner" name="assigner" type="hidden"
                   value="${temporaryPlan_.assigner}">
            <input id="assignTime" name="assignTime" type="hidden"
                   value="${temporaryPlan_.assignTime}">
            <input name="isPlanChange" id="isPlanChange" value="${isPlanChange}" type="hidden" />
			<input id="isModifyPage" name="isModifyPage" type="hidden" value="true" />
		</fd:form>
		<div class="easyui-layout">
			<c:forEach var="lists" items="${listss}" varStatus="cnt">
				<div id="${lists.get(0).get(0).get(0).ext2}"  style="height: 100%;">
					<div  style="height:80px;">
						<div class="gla_div" style="position:inherit;margin-bottom: 80px;">
							<ul>
								<li>
									<div class="gla_step">
										<table class="step_dot">
											<tr>
												<c:if test="${! empty tabTempList}">
													<c:forEach var="ttList" items="${tabTempList}" varStatus="ttCnt">
														<c:choose>
															<c:when test="${ttList.ext1 == '1'}">
																<td class="stepFirst"><i></i><div><span>1</span><div class="cont">${ttList.name}</div></div></td>
															</c:when>

															<c:when test="${cnt.index >= ttCnt.index && ttList.ext1 != '1' }">
																<td class="stepMiddle"><i></i><div><span>${ttList.ext1}</span><div class="cont">${ttList.name}</div></div></td>
															</c:when>
															<c:otherwise>
																<td class="stepEnd"><i></i><div><span>${ttList.ext1}</span><div class="cont">${ttList.name}</div></div></td>
															</c:otherwise>
														</c:choose>

													</c:forEach>
												</c:if>
													<%-- <td class="stepFirst"><i></i><div><span>1</span><div class="cont"><spring:message code="com.glaway.ids.pm.project.plan.baseinfo"/></div></div></td>
                                                     <td class="stepEnd"><i></i><div><span>2</span><div class="cont"><spring:message code="com.glaway.ids.pm.project.plan.input"/></div></div></td>
                                                     <td class="stepEnd"><i></i><div><span>3</span><div class="cont"><spring:message code="com.glaway.ids.pm.project.plan.output"/></div></div></td>
                                                     <td class="stepEnd"><i></i><div><span>4</span><div class="cont"><spring:message code="com.glaway.ids.pm.project.plan.resource"/></div></div></td>--%>
											</tr>
										</table>
									</div>
								</li>
							</ul>
						</div>
					</div>
					<div style="height:494px;">
						<c:forEach var="list" items="${lists}">
							<c:if test="${!empty list.get(0)}">
								<c:if test="${!empty list.get(0).get(0)}">
									<c:choose>
										<c:when test="${list.get(0).get(0).displayUsage == '1'}">
											<c:if test="${list.size() == 1 && list.get(0).get(0).control!='8'}">
												<c:if test="${list.get(0).get(0).control=='0'}"> <!-- 单行文本 -->

													<%-- <c:if test="${list.get(0).get(0).display==enterType || list.get(0).get(0).display=='1'}">--%>
													<div id="${list.get(0).get(0).propertyValue}Div">
														<c:choose>
															<c:when test="${list.get(0).get(0).readWriteAccess==enterType || list.get(0).get(0).readWriteAccess=='1'}">
																<fd:inputText id="${list.get(0).get(0).id}" title="${list.get(0).get(0).propertyName}"
																			  required="${list.get(0).get(0).required}" value="${list.get(0).get(0).valueInfo}" ></fd:inputText>
															</c:when>
															<c:otherwise>
																<fd:inputText id="${list.get(0).get(0).id}" title="${list.get(0).get(0).propertyName}" readonly="true"
																			  required="${list.get(0).get(0).required}" value="${list.get(0).get(0).valueInfo}" ></fd:inputText>
															</c:otherwise>
														</c:choose>
													</div>
													<%-- </c:if>--%>

												</c:if>
												<c:if test="${list.get(0).get(0).control=='1'}"> <!-- 多行文本 -->
													<div id="${list.get(0).get(0).propertyValue}Div">
															<%-- <c:if test="${list.get(0).get(0).display==enterType || list.get(0).get(0).display=='1'}">--%>
														<c:choose>
															<c:when test="${list.get(0).get(0).readWriteAccess==enterType || list.get(0).get(0).readWriteAccess=='1'}">
																<fd:inputTextArea id="${list.get(0).get(0).id}"
																				  required="${list.get(0).get(0).required}" title="${list.get(0).get(0).propertyName}" value="${list.get(0).get(0).valueInfo}" ></fd:inputTextArea>
															</c:when>
															<c:otherwise>
																<fd:inputTextArea id="${list.get(0).get(0).id}" readonly="true"
																				  required="${list.get(0).get(0).required}" title="${list.get(0).get(0).propertyName}" value="${list.get(0).get(0).valueInfo}" ></fd:inputTextArea>
															</c:otherwise>
														</c:choose>
															<%-- </c:if>--%>
													</div>
												</c:if>
												<c:if test="${list.get(0).get(0).control=='2'}"> <!-- 单选 -->
													<div id="${list.get(0).get(0).propertyValue}Div">
															<%-- <c:if test="${list.get(0).get(0).display==enterType || list.get(0).get(0).display=='1'}">--%>
														<c:choose>
															<c:when test="${list.get(0).get(0).readWriteAccess==enterType || list.get(0).get(0).readWriteAccess=='1'}">
																<input type="radio" name="${list.get(0).get(0).propertyName}" value="${list.get(0).get(0).propertyName}" >${list.get(0).get(0).propertyName}</input>
															</c:when>
															<c:otherwise>
																<input type="radio" name="${list.get(0).get(0).propertyName}" value="${list.get(0).get(0).propertyName}" readonly="true" >${list.get(0).get(0).propertyName}</input>
															</c:otherwise>
														</c:choose>
															<%--</c:if>--%>
													</div>

												</c:if>
												<c:if test="${list.get(0).get(0).control=='3'}"> <!-- 公共选人 -->
													<div id="${list.get(0).get(0).propertyValue}Div">
															<%-- <c:if test="${list.get(0).get(0).display==enterType || list.get(0).get(0).display=='1'}">--%>
														<c:choose>
															<c:when test="${list.get(0).get(0).readWriteAccess==enterType || list.get(0).get(0).readWriteAccess=='1'}">
																<fd:inputSearchUser id="${list.get(0).get(0).id}" queryMode="in"
																					required="${list.get(0).get(0).required}"
																					title="${list.get(0).get(0).propertyName}" value="${list.get(0).get(0).valueInfo}"></fd:inputSearchUser>
															</c:when>
															<c:otherwise>
																<fd:inputSearchUser id="${list.get(0).get(0).id}" queryMode="in"
																					required="${list.get(0).get(0).required}" readonly="true"
																					title="${list.get(0).get(0).propertyName}" value="${list.get(0).get(0).valueInfo}"></fd:inputSearchUser>
															</c:otherwise>
														</c:choose>
															<%--</c:if>--%>
													</div>

												</c:if>
												<c:if test="${list.get(0).get(0).control=='4'}"> <!-- 日期文本框 -->
													<div id="${list.get(0).get(0).propertyValue}Div">
															<%-- <c:if test="${list.get(0).get(0).display==enterType || list.get(0).get(0).display=='1'}">--%>
														<c:choose>
															<c:when test="${list.get(0).get(0).readWriteAccess==enterType || list.get(0).get(0).readWriteAccess=='1'}">
																<fd:inputDate id="${list.get(0).get(0).id}" editable="false"
																			  required="${list.get(0).get(0).required}" title="${list.get(0).get(0).propertyName}" value="${list.get(0).get(0).defaultValue}" ></fd:inputDate>
															</c:when>
															<c:otherwise>
																<fd:inputDate id="${list.get(0).get(0).id}" readonly="true" editable="false"
																			  required="${list.get(0).get(0).required}" title="${list.get(0).get(0).propertyName}" value="${list.get(0).get(0).defaultValue}" ></fd:inputDate>
															</c:otherwise>
														</c:choose>
															<%--</c:if>--%>
													</div>

												</c:if>

												<c:if test="${list.get(0).get(0).control=='9'}"> <!-- 选择框 -->
													<div id="${list.get(0).get(0).propertyValue}Div">

															<%-- <c:if test="${list.get(0).get(0).display==enterType || list.get(0).get(0).display=='1'}">--%>
														<c:choose>
															<c:when test="${list.get(0).get(0).readWriteAccess==enterType || list.get(0).get(0).readWriteAccess=='1'}">
																<fd:inputSearch id="${list.get(0).get(0).id}" title="${list.get(0).get(0).propertyName}" value="${list.get(0).get(0).valueInfo}" editable="false" searcher="${list.get(0).get(0).operationEvent}" />
															</c:when>
															<c:otherwise>
																<fd:inputSearch id="${list.get(0).get(0).id}" title="${list.get(0).get(0).propertyName}" value="${list.get(0).get(0).valueInfo}" readonly="true"
																				editable="false" searcher="${list.get(0).get(0).operationEvent}" />
															</c:otherwise>
														</c:choose>
															<%--</c:if>--%>
													</div>
												</c:if>

												<c:if test="${list.get(0).get(0).control=='10'}"> <!-- 下拉框(文本可编辑) -->
													<div id="${list.get(0).get(0).propertyValue}Div">
															<%-- <c:if test="${list.get(0).get(0).display==enterType || list.get(0).get(0).display=='1'}">--%>
														<c:choose>
															<c:when test="${list.get(0).get(0).readWriteAccess==enterType || list.get(0).get(0).readWriteAccess=='1'}">
																<fd:combobox id="${list.get(0).get(0).id}" title="${list.get(0).get(0).propertyName}"  name="${list.get(0).get(0).propertyName}" required="${list.get(0).get(0).required}" url="${list.get(0).get(0).loadUrl}" panelMaxHeight="200"
																			 readonly="${list.get(0).get(0).readOnly}" valueField="${list.get(0).get(0).valueField}" textField="${list.get(0).get(0).textField}" prompt="" selectedValue="${list.get(0).get(0).valueInfo}" value="${list.get(0).get(0).valueInfo}">
																</fd:combobox>
															</c:when>
															<c:otherwise>
																<fd:combobox id="${list.get(0).get(0).id}" title="${list.get(0).get(0).propertyName}"  name="${list.get(0).get(0).propertyName}" readonly="true"  url="${list.get(0).get(0).loadUrl}" panelMaxHeight="200"
																			 valueField="${list.get(0).get(0).valueField}"  textField="${list.get(0).get(0).textField}" value="${list.get(0).get(0).valueInfo}" prompt="" selectedValue="${list.get(0).get(0).valueInfo}">
																</fd:combobox>
															</c:otherwise>
														</c:choose>
															<%--</c:if>--%>
													</div>
												</c:if>

												<c:if test="${list.get(0).get(0).control=='5'}"> <!-- 下拉框 -->
													<div id="${list.get(0).get(0).propertyValue}Div">
															<%-- <c:if test="${list.get(0).get(0).display==enterType || list.get(0).get(0).display=='1'}">--%>
														<c:choose>
															<c:when test="${list.get(0).get(0).readWriteAccess==enterType || list.get(0).get(0).readWriteAccess=='1'}">
																<fd:combobox id="${list.get(0).get(0).id}" title="${list.get(0).get(0).propertyName}"  name="${list.get(0).get(0).propertyName}" required="${list.get(0).get(0).required}" url="${list.get(0).get(0).loadUrl}" panelMaxHeight="200"
																			 editable="false" readonly="${list.get(0).get(0).readOnly}" valueField="${list.get(0).get(0).valueField}" textField="${list.get(0).get(0).textField}" prompt="" selectedValue="${list.get(0).get(0).valueInfo}" value="${list.get(0).get(0).valueInfo}">
																</fd:combobox>
															</c:when>
															<c:otherwise>
																<fd:combobox id="${list.get(0).get(0).id}" title="${list.get(0).get(0).propertyName}"  name="${list.get(0).get(0).propertyName}" readonly="true"  url="${list.get(0).get(0).loadUrl}" panelMaxHeight="200"
																			 editable="false" valueField="${list.get(0).get(0).valueField}"  textField="${list.get(0).get(0).textField}" value="${list.get(0).get(0).valueInfo}" prompt="" selectedValue="${list.get(0).get(0).valueInfo}">
																</fd:combobox>
															</c:otherwise>
														</c:choose>
															<%--</c:if>--%>
													</div>
												</c:if>
											</c:if>



											<c:if test="${list.size() >= 1 && list.get(0).get(0).control=='8'}">
												<c:forEach var="jyj" items="${list}">
													<div id="${jyj.get(0).propertyName}Div" style="float:left">
														<!-- 新增加是否显示按钮判断isShowButton-->
														<fd:linkbutton iconCls="${jyj.get(0).format}" value="${jyj.get(0).propertyName}" onclick="${jyj.get(0).operationEvent}"></fd:linkbutton>
													</div>
												</c:forEach>
											</c:if>

											<%--                   <c:if test="${list.size() >= 1 && list.get(0).get(0).control=='8'}">
                                                                   <div class="jk"></div>
                                                               </c:if>--%>

											<c:if test="${list.size() > 1 && list.get(0).get(0).control!='8'}">
												<div class="oLine" >
													<fd:datagrid id="${list.get(0).get(0).id}" checkbox="true" checked="true"
																 checkOnSelect="true" idField="id" fit="false" width="98%" height="380px" url=""
																 fitColumns="true" pagination="false">
													</fd:datagrid>
														<%--<fd:panel  border="false" title="${list.get(0).get(0).propertyName}" fit="true" collapsed="false" width="100%" height="85%" >
                                                            <div>
                                                                <table id="${list.get(0).get(0).id}"></table>
                                                            </div>
                                                        </fd:panel>--%>

												</div>
												<script>

													function loadDatagrid_${cnt.index}(){
														$('#${list.get(0).get(0).id}').datagrid({
															url: '',
															width: 880,
															height: 380,
															pagination : false,
															//fit:true,
															//fitColumns:true,
															columns: [[
																<c:forEach var="col" items="${list.get(1)}" varStatus="status">
																{
																	<%--   <c:choose>
                                                                        <c:when test="${empty col.format}">
                                                                           field: '${col.propertyValue}',
                                                                           title: '${col.propertyName}',
                                                                           width: 760/${list.get(1).size()}
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                           field: '${col.propertyValue}',
                                                                           title: '${col.propertyName}',
                                                                           width: 760/${list.get(1).size()},
                                                                           formatter:function(value,row,index){
                                                                               ${col.format}
                                                                           }
                                                                       </c:otherwise>
                                                                    </c:choose>--%>

																	<c:choose>
																	<c:when test="${empty col.format}">
																	field: '${col.propertyValue}',
																	title: '${col.propertyName}',
																	width: 880/${list.get(1).size()}
																			</c:when>
																			<c:otherwise>
																			field: '${col.propertyValue}',
																title: '${col.propertyName}',
																width: 880/${list.get(1).size()},
																formatter:${col.format}
														</c:otherwise>
														</c:choose>

													}<c:if test="${list.get(1)!=null && fn:length(list.get(1))-1 > status.index}">, </c:if>
														</c:forEach>
													]]
													});
													}
												</script>

											</c:if>
										</c:when>
										<c:otherwise>
											<%--<c:if test="${list.get(0).get(0).display==enterType || list.get(0).get(0).display=='1'}">--%>
											<iframe id="${list.get(0).get(0).id}" src="${list.get(0).get(0).loadUrl}" width="750" height="380" style="border:medium none"></iframe>
											<%-- </c:if>--%>

										</c:otherwise>
									</c:choose>
								</c:if>
							</c:if>

						</c:forEach>
					</div>
					<div>
						<div class="div-msg-btn">
							<div class="ui_buttons">
								<c:choose>
									<c:when test="${cnt.first && (! empty fromType && fromType == 'update') }">
										<c:if test="${!cnt.last}">
											<fd:linkbutton onclick="nextOnePage('${lists.get(0).get(0).get(0).ext2}','${cnt.index}')" value="{com.glaway.ids.pm.project.plan.nextone}" classStyle="button_nor" />
										</c:if>
										<fd:linkbutton  onclick="closePlan()" value="{com.glaway.ids.common.btn.cancel}" classStyle="ui_state_highlight lhgdialog_cancle" />
									</c:when>
									<c:otherwise>
										<fd:linkbutton onclick="beforeOne('${lists.get(0).get(0).get(0).ext2}','${cnt.index}')" value="{com.glaway.ids.pm.project.plan.beforeone}" classStyle="button_nor" />
										<c:if test="${!cnt.last}">
											<fd:linkbutton onclick="nextOnePage('${lists.get(0).get(0).get(0).ext2}','${cnt.index}')" value="{com.glaway.ids.pm.project.plan.nextone}" classStyle="button_nor" />
										</c:if>
										<c:if test="${cnt.last}">
											<fd:linkbutton onclick="nextTwo()" value="{com.glaway.ids.pm.project.plan.nextone}" classStyle="button_nor" />
										</c:if>
										<fd:linkbutton  onclick="closePlan()" value="{com.glaway.ids.common.btn.cancel}" classStyle="ui_state_highlight lhgdialog_cancle"  />
										<%--<fd:dialogbutton name="{com.glaway.ids.common.btn.cancel}"
                                                         callback="hideDiaLog"></fd:dialogbutton>--%>
									</c:otherwise>
								</c:choose>

							</div>
						</div>
					</div>
				</div>
			</c:forEach>
		</div>
	</div>	
	<!-- document end -->

	<div border="false" class="easyui-panel div-msg" id="changeAnalysis" fit="true">
		<div class="easyui-panel" fit="true">
			<div style="padding-top:20px;padding-bottom:5px;">
				<label id="planChildTimeArea"></label>
			</div>
			<div id="influencedNull" fit="true">
				<div style="height:200px">
					<fd:datagrid id="temporaryPlanChildList" checkbox="false" pagination="false" 
						fitColumns="true" idField="planId" fit="true">
						<fd:dgCol title="{com.glaway.ids.pm.project.plan.planName}" field="planName" width="150"  sortable="false"></fd:dgCol>
						<fd:dgCol title="发布人" field="assignerName" width="120"  sortable="false"></fd:dgCol>
						<fd:dgCol title="{com.glaway.ids.common.lable.owner}" field="ownerName" width="120"  sortable="false"></fd:dgCol>
						<fd:dgCol title="{com.glaway.ids.pm.project.plan.planTime}" field="planStartTime" width="150" formatterFunName="childPostposeTime"  sortable="false"></fd:dgCol>
					</fd:datagrid>
				</div>
				
				<div style="padding-top:20px;padding-bottom:5px;">
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
            <div class="ui_buttons">
                <fd:linkbutton onclick="beforeThree()" value="{com.glaway.ids.pm.project.plan.beforeone}" classStyle="button_nor" />
                <fd:linkbutton onclick="nextThree()" value="{com.glaway.ids.pm.project.plan.nextone}" classStyle="button_nor" />
                <fd:linkbutton id="analysisCancelBtn" onclick="closePlan()" value="{com.glaway.ids.common.btn.cancel}" classStyle="ui_state_highlight lhgdialog_cancle" />
            </div>
		</div>
	</div>
	
	<div border="false" class="easyui-panel div-msg" id="changeTotal" fit="true">
		<div class="easyui-layout" fit="true">
			<div data-options="region:'north'" style="height: 230px;">
			 	<input id="changeInfoDocPath" name="changeInfoDocPath" type="hidden" value="${temporaryPlan_.changeInfoDocPath}">
			 	<input id="changeInfoDocName" name="changeInfoDocName" type="hidden" value="${temporaryPlan_.changeInfoDocName}">
				<fd:inputText id="changeTypeAfter" title="{com.glaway.ids.pm.project.plan.changeType}" name="changeTypeAfter"
						value="${temporaryPlan_.changeType}" readonly="true" />
				<fd:inputTextArea id="changeRemarkAfter" title="{com.glaway.ids.common.lable.remark}" name="changeRemarkAfter" 
						value="${temporaryPlan_.changeRemark}" readonly="true" />
				<input type="hidden" id="leader" name="leader" value="${leader}"/>	
				<fd:inputSearchUser id="leaderId" name="leaderId" title="{com.glaway.ids.common.lable.leader}"  required="true" value="${leaderId}">
						<fd:eventListener event="beforeAffirmClose" listener="setLeader" needReturn="true" />
				</fd:inputSearchUser>
				<input type="hidden" id="deptLeader" name="deptLeader" value="${deptLeader}"/>
				<fd:inputSearchUser id="deptLeaderId" name="deptLeaderId" title="{com.glaway.ids.common.lable.deptLeader}"  required="true" value="${deptLeaderId}">
						<fd:eventListener event="beforeAffirmClose" listener="setDeptLeader" needReturn="true" />
				</fd:inputSearchUser>
			</div>
			<div data-options="region:'center'">
				<fd:datagrid id="planChangeVo" checkbox="false" pagination="false" fitColumns="true" idField="planId" fit="true">
					<fd:dgCol title="{com.glaway.ids.pm.project.plan.field}" field="field" width="150"></fd:dgCol>
					<fd:dgCol title="{com.glaway.ids.pm.project.plan.type}" field="type" width="120"></fd:dgCol>
					<fd:dgCol title="{com.glaway.ids.pm.project.plan.changeBefore}" field="changeBefore" width="120"></fd:dgCol>
					<fd:dgCol title="{com.glaway.ids.pm.project.plan.changeAfter}" field="changeAfter" width="150" ></fd:dgCol>
				</fd:datagrid>
			</div>
		</div>
		
		<div class="div-msg-btn">
            <div class="ui_buttons">
                <fd:linkbutton onclick="beforeFour()" value="{com.glaway.ids.pm.project.plan.beforeone}" classStyle="button_nor" />
                <fd:linkbutton onclick="addTempPlan()" value="{com.glaway.ids.common.btn.submit}" classStyle="button_nor" id="startPlanchange"/>
                <fd:linkbutton id="totalCancelBtn" onclick="closePlan()" value="{com.glaway.ids.common.btn.cancel}" classStyle="ui_state_highlight lhgdialog_cancle" />
            </div>
		</div>
	</div>
</body>

	<fd:dialog id="addDeliverableDialog" width="830px" height="400px" modal="true" title="{com.glaway.ids.pm.project.plan.deliverables.addDeliverable}">
	    <fd:dialogbutton name="{com.glaway.ids.common.btn.confirm}" callback="addDeliverableDialog"></fd:dialogbutton>
		<fd:dialogbutton name="{com.glaway.ids.common.btn.cancel}" callback="hideDiaLog"></fd:dialogbutton>
	</fd:dialog>
			<fd:dialog id="addInputDialog" width="800px" height="400px" modal="true" title="{com.glaway.ids.pm.project.plan.inputs.addInputs}">
	    <fd:dialogbutton name="{com.glaway.ids.common.btn.confirm}" callback="addInputDialog"></fd:dialogbutton>
		<fd:dialogbutton name="{com.glaway.ids.common.btn.cancel}" callback="hideDiaLog"></fd:dialogbutton>
	</fd:dialog>
		<fd:dialog id="addResourceDialog" width="800px" height="350px" modal="true" title="{com.glaway.ids.pm.project.plan.resource.addResource}">
	    <fd:dialogbutton name="{com.glaway.ids.common.btn.confirm}" callback="addResourceDialog"></fd:dialogbutton>
		<fd:dialogbutton name="{com.glaway.ids.common.btn.cancel}" callback="hideDiaLog"></fd:dialogbutton>
	</fd:dialog>
	<fd:dialog id="resourceDialog" width="900px" height="800px" modal="true" title="{com.glaway.ids.pm.project.plan.resourcePicture}"  maxFun="true">
    </fd:dialog>
	<fd:dialog id="preposePlanDialog" width="800px" height="580px" modal="true" title="{com.glaway.ids.pm.project.plan.choseprepose}">
		<fd:dialogbutton name="{com.glaway.ids.common.btn.confirm}" callback="preposePlanDialog"></fd:dialogbutton>
	<fd:dialogbutton name="{com.glaway.ids.common.btn.cancel}" callback="hideDiaLog"></fd:dialogbutton>
	</fd:dialog>
		<fd:dialog id="leaderDialog" width="1040px" height="550px" modal="true" title="{com.glaway.ids.pm.project.plan.basicLine.chosePeople}">
	    <fd:dialogbutton name="{com.glaway.ids.common.btn.confirm}" callback="leaderDialog"></fd:dialogbutton>
		<fd:dialogbutton name="{com.glaway.ids.common.btn.cancel}" callback="hideDiaLog"></fd:dialogbutton>
	</fd:dialog>
	<fd:dialog id="deptLeaderDialog" width="1040px" height="550px" modal="true" title="{com.glaway.ids.pm.project.plan.basicLine.chosePeople}">
	    <fd:dialogbutton name="{com.glaway.ids.common.btn.confirm}" callback="deptLeaderDialog"></fd:dialogbutton>
		<fd:dialogbutton name="{com.glaway.ids.common.btn.cancel}" callback="hideDiaLog"></fd:dialogbutton>
	</fd:dialog>
	<fd:dialog id="showDocDetailChangeFlowDialog" modal="true" width="1000" height="550" title="{com.glaway.ids.pm.project.plan.basicLine.showDocDetail}">
		<fd:dialogbutton name="{com.glaway.ids.common.btn.close}" callback="hideDiaLog" ></fd:dialogbutton>
	</fd:dialog>
	<fd:dialog id="openAndSubmitDialog" width="870px" height="680px" modal="true" title="{com.glaway.ids.pm.project.plan.basicLine.showDocDetail}">
		<fd:dialogbutton name="{com.glaway.ids.common.btn.close}" callback="hideDiaLog"></fd:dialogbutton>
	</fd:dialog>	
	<fd:dialog id="inheritDialog" width="400px" height="300px" modal="true" title="{com.glaway.ids.pm.project.plan.inheritParentDocument}">
	</fd:dialog>
	<fd:dialog id="openSelectInputsDialog" width="800px" height="300px"
		modal="true" title="选择输入项">
	<fd:dialogbutton name="{com.glaway.ids.common.btn.confirm}"
		callback="openSelectConfigOkFunction"></fd:dialogbutton>
	<fd:dialogbutton name="{com.glaway.ids.common.btn.cancel}"
		callback="hideDiaLog"></fd:dialogbutton>
</fd:dialog>
<fd:dialog id="addLocalFileDialog" width="400px" height="180px" modal="true" title="新增本地文档">
    <fd:dialogbutton name="{com.glaway.ids.common.btn.confirm}" callback="addLocalFileDialog"></fd:dialogbutton>
    <fd:dialogbutton name="{com.glaway.ids.common.btn.cancel}" callback="hideDiaLog"></fd:dialogbutton>
</fd:dialog>

<fd:dialog id="taskDocCheckLineDialog" width="1000px" height="500px" modal="true" title="项目库关联">
	<fd:dialogbutton name="{com.glaway.ids.common.btn.confirm}" callback="taskDocCheckLineDialog"></fd:dialogbutton>
	<fd:dialogbutton name="{com.glaway.ids.common.btn.cancel}" callback="hideDiaLog"></fd:dialogbutton>
</fd:dialog>

<fd:dialog id="planInputsDialog" width="800px" height="580px" modal="true" title="选择来源计划">
	<fd:dialogbutton name="{com.glaway.ids.common.btn.confirm}" callback="planInputsDialog"></fd:dialogbutton>
	<fd:dialogbutton name="{com.glaway.ids.common.btn.cancel}" callback="hideDiaLog"></fd:dialogbutton>
</fd:dialog>