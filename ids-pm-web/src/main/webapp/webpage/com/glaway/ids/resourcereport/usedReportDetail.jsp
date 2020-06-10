 <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
 <%@include file="/context/mytags.jsp"%>
<!DOCTYPE html>
<html>
<head>
<title>资源使用率报表</title>
<t:base type="jquery,easyui,tools"></t:base>
<script src="${pageContext.request.contextPath }/plug-in/js/highcharts7.0.2/highcharts.js"></script>
<script type="text/javascript">
$(function(){
	$.ajax({
		type : "POST",
		url : 'resourceLinkInfoController.do?drawResourceUsedRate',
		data : {
			resourceId:"${resourceId}",
			startDate:"${startDate}",
			endDate:"${endDate}"
		},
		dataType : "json",
		success : function(data) {
			var jsonStr=JSON.stringify(data);
			//$("#myForm").attr("action","/brs/frameset?__report=idsreport/checkResource.rptdesign&__showtitle=false&__toolbar=false&usedRateJson="+jsonStr+"&resourceId=${resourceId}");
			/*$("#myForm").attr("action","${brsUrl}/brs/frameset?__report=idsreport/checkResource.rptdesign&__showtitle=false&__toolbar=false&startDate=${startDate}&endDate=${endDate}");
			$("#usedRateJson").val(jsonStr);
			$("#resourceId").val("${resourceId}");
			$("#myForm").submit(); */

			var xName = [];
			var yData = [];
			var yData2 = [];
			if(jsonStr!=null && jsonStr!=""){
				var curList = eval(jsonStr);
				for (var i = 0; i < curList.length; i++) {
					xName.push(curList[i].date);
					yData.push(parseInt(curList[i].usedRate));
					yData2.push(parseInt(curList[i].occupationWarn));
				}
			}

			Highcharts.chart('container', {
				title: {
					text: '资源使用情况',
					style :{fontSize:'30px', fontFamily:'微软雅黑'}
				},
				xAxis: [{
					type: 'datetime',
					categories: xName,
					/*crosshair: true,*/
					labels : {
						rotation : 45  //旋转角度
					}
				}],

				yAxis: {
					title: {
						text: ''
					},
				},

				tooltip: {
					formatter : function(){
						return '<b>' + this.series.name + '<br></br>'+
								Highcharts.dateFormat('%Y-%M-%D',this.x) + '</br>' +
								Highcharts.numberFormat(this.y,0);
					}
				},

				legend: {
					layout: 'vertical',
					align: 'right',
					verticalAlign: 'middle'
				},

				series: [{
					name: '已使用率',
					data: yData
				},{
					name: '预警使用率',
					data: yData2,
					color:'orange'
				}],
				credits: {
					enabled: false
				}

			});

			// var url = "resourceController.do?conditionSearchForCheckResource";
			var url = "resourceLinkInfoController.do?conditionSearchForCreatePlanAddResource";
			var params = "&resourceId=${resourceId}&startDate=${startDate}&endDate=${endDate}";
			url = url + params;

			//查询dataGrid:
			$('#checkResourceList').datagrid({
				url : url,
				pageNumber : 1
			});

		}
	});
	
});
</script>
</head>
<body>
<%--	<form id="myForm" method="post" action="">
		<input id="usedRateJson" name="usedRateJson" hidden="true" vlaue=""></input>
		<input id="resourceId" name="resourceId" hidden="true" vlaue=""></input>
	</form>--%>
	<div id="container" style="min-width: 310px; height: 360px;margin: 0 auto"></div>
	<fd:panel id="laborLoadPicPanel" border="false" collapsible="false"
			  width="100%" height="400px">
		<fd:datagrid fit="true" fitColumns="true" idField="id"
					 id="checkResourceList" checkbox="true">
			<fd:dgCol title="项目" field="projectName" align="left" sortable="true"/>
			<fd:dgCol title="计划名称" field="planName" align="left" sortable="true"/>
			<fd:dgCol title="资源占用时间" field="planStartTime" align="left" sortable="true"/>
			<fd:dgCol title="使用百分比（%）" field="usedRate" align="left" sortable="true"/>
			<fd:dgCol title="计划进度（%）" field="progressRate" align="left" sortable="true"/>
			<fd:dgCol title="计划负责人" field="launcher" align="left" sortable="true"/>
			<fd:dgCol title="项目经理" field="managerName" align="left" sortable="true"/>
		</fd:datagrid>
	</fd:panel>
</body>

</html>