<%@ page language="java" import="java.util.*"
         contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/context/mytags.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <title>新增计划</title>
    <t:base type="jquery,easyui,tools"></t:base>
    <%--    <script src="webpage/com/glaway/ids/common/operationTab.js"></script>--%>
    <style>
        .div-msg-btn{bottom:20px;float: right;
            right: 8px;

            position: fixed;}
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
    <script type="text/javascript">

        function closePlan() {
            $.ajax({
                type : 'POST',
                data : {useObjectId : $('#useObjectId').val()},
                url : 'inputsController.do?clearRedis',
                cache : false,
                success:function(data){

                }
            });
            $.fn.lhgdialog("closeSelect");
        }

        function planNameTaskTypeChange(isStandard){
            var planName = $('#planName').combobox('getText');
            if('true' == isStandard && planName != ''){

                $.ajax({
                    url : 'planController.do?getTaskNameType',
                    type : 'post',
                    data : {
                        planName : planName
                    },
                    cache : false,
                    success : function(data) {
                        if (data != null) {
                            var d = $.parseJSON(data);
                            if (d.success == true) {
                                var taskNameType = $('#taskNameType')
                                    .combobox("getValue");
                                if(d.obj != "" && d.obj != null && d.obj != 'null'){
                                    if(d.obj != taskNameType){
                                        $("#fromType").val("planNameChange");
                                        $('#taskNameType')
                                            .combobox("setValue",
                                                d.obj);
                                    }
                                }

                            } else {
                                /*$('#taskNameType')
                                        .combobox("setValue",
                                                d.obj);
                                win.tip(d.msg);*/
                            }
                        } else {
                            win.tip(d.msg);
                        }
                    }
                });
            }
        }


        function taskNameTypeChange(isStandard){
            //启用活动名称库，计划类型的值改变才需要清空计划名称的值，否则不需要
            if('true' == isStandard){
                var taskNameType = $("#taskNameType").combobox('getValue');
                var fromType = $("#fromType").val();
                if(fromType == '' || fromType == ""){
                    $("#planName").combobox('setText','');
                    $("#planName").combobox('setValue','');
                    $('#planName').combobox({
                        url : encodeURI(encodeURI('planController.do?standardValueExceptDesign&activeCategory='+taskNameType)),
                        onLoadSuccess : function() {

                        }
                    });
                }


                $("#fromType").val('');
            }

        }


        function nextStep(){
            debugger
            var activityId = $("#taskNameType").combobox('getValue');
            var planName;
            var planNameText;
            try{
                planName = $("#planName").combobox('getValue');
                planNameText = $("#planName").combobox('getText');
            }catch (e) {

            }
            if(planName == "" || planName == undefined){
                planName = $("#planName").textbox('getValue');
                planNameText = $("#planName").textbox('getValue');
            }
            //    activityId = '4028f00c6cefbdc9016cefcd30c00007';   //研发类，暂时先写死
            var taskNameType = $("#taskNameType").combobox('getText');
            if(planName == '' || planName == null){
                top.tip("计划名称为空");
                return false;
            }
            if(activityId == '' || activityId == null){
                top.tip("计划类型为空");
                return false;
            }
            $.ajax({
                type : 'POST',
                url : 'planController.do?checkTabCombinationTemplateIsExist&activityId='+activityId,
                data : {
                    activityId : activityId
                },
                cache : false,
                success : function (data) {
                    var d = $.parseJSON(data);
                    if(d.success){
                        $('#page1').css('display','none');

                        var tabCbTemplateId = d.obj;

                        var url = "planTemplateController.do?goAdd&planTemplateId=${planTemplateId}&id=${projectTemplateId}&parentPlanId=${parentPlanId}&beforePlanId=${beforePlanId}"
                            +"&type=add&planName="+encodeURI(planNameText)+"&activityId="+activityId+"&tabCbTemplateId="+tabCbTemplateId;
                        $("#page2").load( url ,{},function(){
                            $("#page2").css('display','');
                        });
                    }else{
                        top.tip("当前计划类型不存在启用的页签组合模板");
                    }
                }
            });
        }

    </script>

<body>
<div id="planAddPage" border="false" class="easyui-panel div-msg" fit="true">
    <div class="easyui-panel" fit="true" id="page1">
        <input type="hidden" id="projectId"  name="projectId" value = "${projectId}"/>
        <input type="hidden" id="isPmo" name="isPmo"  value = "${isPmo}"/>
        <input type="hidden" id="isProjectManger" name="isProjectManger"  value = "${isProjectManger}"/>
        <input type="hidden" id="teamId" name="teamId"  value = "${teamId}"/>
        <input type="hidden" id="fromType" name="fromType"  value = ""/>
        <input type="hidden" id="taskNameTypeHid" name="taskNameTypeHid"  value = ""/>
        <input type="hidden" id="planNameHid" name="planNameHid"  value = ""/>

        <fd:combobox id="taskNameType" textField="name" title="{com.glaway.ids.pm.project.plan.taskNameType}" selectedValue=""
                     editable="false" valueField="id" onChange="taskNameTypeChange('${isStandard}')" panelMaxHeight="200"
                     required="true" url="planController.do?getTaskNameTypes" />


        <c:choose>
            <c:when test="${isStandard && isForce}">
                <fd:combobox id="planName" textField="name" title="{com.glaway.ids.pm.project.plan.planName}" required="true" selectedValue=""
                             editable="false" valueField="id" panelMaxHeight="200" maxLength="50" name="planName"
                             url="planController.do?standardValueExceptDesign" onChange="planNameTaskTypeChange('true')"></fd:combobox>
            </c:when>
            <c:when test="${isStandard || isForce}">
                <fd:combobox id="planName" textField="name" title="{com.glaway.ids.pm.project.plan.planName}" required="true" selectedValue=""
                             editable="true" valueField="id" panelMaxHeight="200" maxLength="50" name="planName"
                             url="planController.do?standardValueExceptDesign" onChange="planNameTaskTypeChange('true')"></fd:combobox>
            </c:when>
            <c:otherwise>
                <fd:inputText id="planName" name="planName" title="{com.glaway.ids.pm.project.plan.planName}" required="true" value="" />
            </c:otherwise>
        </c:choose>


        <div class="div-msg-btn">
            <div class="ui_buttons">
                <fd:linkbutton onclick="nextStep()" value="{com.glaway.ids.pm.project.plan.nextone}" classStyle="button_nor" />
                <fd:linkbutton id="cancelAdd" onclick="closePlan()" value="{com.glaway.ids.common.btn.cancel}" classStyle="ui_state_highlight lhgdialog_cancle" />
            </div>
        </div>
    </div>

    <div class="easyui-panel"  id="page2" fit="true" >

    </div>
</div>
</body>
</head>
</html>