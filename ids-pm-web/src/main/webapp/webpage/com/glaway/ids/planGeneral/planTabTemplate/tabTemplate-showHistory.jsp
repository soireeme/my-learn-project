<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@include file="/context/mytags.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <title>模板详细信息</title>
    <t:base type="jquery,easyui_iframe,tools"></t:base>
    <!-- 页面时间格式化 -->
<body style="overflow-x: hidden;">
<fd:panel  border="false" title="版本详情" collapsible="false" fit="false" width="100%">
    <fd:datagrid url="tabTemplateController.do?getVersionHistory&bizId=${tabTemplate.bizId}" width="100%"
                 idField="id" id="procTmplListss" fitColumns="true" fit="false" checkbox="false">
        <fd:dgCol title="{com.glaway.ids.common.lable.operation}" field="operation" width="30"  formatterFunName="operation" />
        <fd:dgCol title="{com.glaway.ids.pm.project.plantemplate.bizVersion}" field="bizVersion" width="30" formatterFunName="operation2" />
        <fd:dgCol title="{com.glaway.ids.rdflow.plan.modifyPeople}" field="creator" width="48" formatterFunName="formatCreator" />
        <fd:dgCol title="{com.glaway.ids.rdflow.plan.modifyTime}" field="createTime" width="75" formatterFunName="dateFmtFulltime" />
        <fd:dgCol title="{com.glaway.ids.common.lable.status}" field="bizCurrent" width="36" formatterFunName="formatOp"/>
        <fd:dgCol title="{com.glaway.ids.common.lable.remark}" field="remake" width="75" />
    </fd:datagrid>
</fd:panel>
</body>
<script>
    function formatCreator(val, row, index) {
        var realName=row.createName;
        if (realName != undefined && realName != null && realName != '') {
            return row.createFullName + "-" + row.createName;
        } else {
            return "";
        }
    }

    function operation(val, row, index){
        var returnStr ='<span style="cursor:hand"><a onclick="showVersionDetail2(\''+row.id+'\',\''+row.bizVersion+'\')" class="basis ui-icon-eye" title="查看" style="display: inline-block;cursor:hand;"></a></span>';
        return returnStr;
    }

    function operation2(val, row, index){
        var returnStr ='<span style="cursor:hand"><a style="color:blue" onclick="showVersionDetail2(\''+row.id+'\',\''+val+'\')">'+val+'</a></span>';
        return returnStr;
    }

    function showVersionDetail2(id,val){
        var url="${webRoot}/tabTemplateController.do?goVersionDetailHistory&tabId="+id;
        createdetailwindow(val+'版本详情',url, 1200, 610);

    }

    function formatOp(value, row, index) {
        if(row.processInstanceId != '' && row.processInstanceId != null && row.processInstanceId != undefined){
            return '<a href=\'javascript:void(0)\' onclick="viewProcessDef(\''+row.processInstanceId +'\',\''+row.name+'\')" title=\'查看流程图\' ><font color=blue>'+value+'</font></a>';
        }else{
            return value;
        }
    }

    function viewProcessDef(procInstId,title)
    {
        createdetailwindow(title+'-项目模板工作流','generateFlowDiagramController.do?initDrowFlowActivitiDiagram&procInstId='+procInstId,800,600);
    }

</script>
