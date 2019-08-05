<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html lang="en">
	<head>
	<base href="<%=basePath%>">
	<!-- jsp文件头和头部 -->
	<%@ include file="../../system/index/top.jsp"%>
	<!-- 日期框 (带小时分钟)-->
	<link rel="stylesheet" href="static/ace/css/bootstrap-datetimepicker.css" />
</head>
<body class="no-skin">
<!-- /section:basics/navbar.layout -->
<div class="main-container" id="main-container">
	<!-- /section:basics/sidebar -->
	<div class="main-content">
		<div class="main-content-inner">
			<div class="page-content">
				<div class="row">
					<div class="col-xs-12">
					
					<form action="myleave/${msg }.do" name="Form" id="Form" method="post">
						<input type="hidden" name="MYLEAVE_ID" id="MYLEAVE_ID" value="${pd.MYLEAVE_ID}"/>
						<div id="zhongxin" style="padding-top: 13px;">
						<table id="table_report" class="table table-striped table-bordered table-hover">
							<tr>
								<td style="width:75px;text-align: right;padding-top: 13px;">开始时间:</td>
								<td>
									<div class="input-group bootstrap-timepicker">
									<input readonly="readonly" class="form-control" type="text" name="STARTTIME" id="STARTTIME" value="${pd.STARTTIME}" maxlength="100" placeholder="这里输入开始时间" title="开始时间" style="width:100%;"/>
									<span class="input-group-addon"><i class="fa fa-clock-o bigger-110"></i></span>
									</div>
								</td>
								<td style="width:75px;text-align: right;padding-top: 13px;">结束时间:</td>
								<td>
									<div class="input-group bootstrap-timepicker">
									<input readonly="readonly" class="form-control" type="text" name="ENDTIME" id="ENDTIME" value="${pd.ENDTIME}" maxlength="100" placeholder="这里输入结束时间" title="结束时间" style="width:100%;"/>
									<span class="input-group-addon"><i class="fa fa-clock-o bigger-110"></i></span>
									</div>
								</td>
							</tr>
							<tr>
								<td style="width:75px;text-align: right;padding-top: 13px;">请假类型:</td>
								<td>
									<select name="TYPE" id="TYPE"  title="请假类型" style="width:100%;">
		                          	</select>	
								</td>
								<td style="width:75px;text-align: right;padding-top: 13px;">请假时长:</td>
								<td><input type="text" name="WHENLONG" id="WHENLONG" value="${pd.WHENLONG}" maxlength="50" placeholder="这里输入时长" title="时长" style="width:76%;"/>&nbsp;天/时</td>
							</tr>
							<tr>
								<td style="width:75px;text-align: right;padding-top: 13px;">请假事由:</td>
								<td colspan="10">
									<textarea  name="REASON" id="REASON" maxlength="1000" placeholder="这里输入事由" title="事由" style="width:100%;height:160px;" >${pd.REASON}</textarea>
								</td>
							</tr>
							<tr>
								<td style="text-align: center;" colspan="10">
									<a class="btn btn-mini btn-primary" onclick="save();">保存请假单</a>
									<a class="btn btn-mini btn-danger" onclick="top.Dialog.close();">取消</a>
								</td>
							</tr>
						</table>
						</div>
						<div id="zhongxin2" class="center" style="display:none"><br/><br/><br/><br/><br/><img src="static/images/jiazai.gif" /><br/><h4 class="lighter block green">提交中...</h4></div>
					</form>
					</div>
					<!-- /.col -->
				</div>
				<!-- /.row -->
			</div>
			<!-- /.page-content -->
		</div>
	</div>
	<!-- /.main-content -->
</div>
<!-- /.main-container -->


	<!-- 页面底部js¨ -->
	<%@ include file="../../system/index/foot.jsp"%>
	<!-- 日期框(带小时分钟) -->
	<script src="static/ace/js/date-time/moment.js"></script>
	<script src="static/ace/js/date-time/locales.js"></script>
	<script src="static/ace/js/date-time/bootstrap-datetimepicker.js"></script>
	<!--提示框-->
	<script type="text/javascript" src="static/js/jquery.tips.js"></script>
		<script type="text/javascript">
		$(top.hangge());
		
		$(function() {
			//日期框(带时间)
			$('.form-control').datetimepicker().next().on(ace.click_event, function(){
				$(this).prev().focus();
			});
		});
		
		//初始分类,调用数据字典
		$(function() {
			var TYPE = "${pd.TYPE}";
			$.ajax({
				type: "POST",
				url: '<%=basePath%>dictionaries/getLevels.do?tm='+new Date().getTime(),
		    	data: {DICTIONARIES_ID:'ce174640544549f1b31c8f66e01c111b'},//ce174640544549f1b31c8f66e01c111b 为请假类型ID
				dataType:'json',
				cache: false,
				success: function(data){
					 $.each(data.list, function(i, dvar){
						 if(TYPE == dvar.BIANMA){
							 $("#TYPE").append("<option value="+dvar.NAME+" selected='selected'>"+dvar.NAME+"</option>");
						 }else{
							 $("#TYPE").append("<option value="+dvar.NAME+">"+dvar.NAME+"</option>");
						 }
					 });
				}
			});
		});
		
		//保存
		function save(){
			if($("#STARTTIME").val()==""){
				$("#STARTTIME").tips({
					side:3,
		            msg:'请输入开始时间',
		            bg:'#AE81FF',
		            time:2
		        });
				$("#STARTTIME").focus();
			return false;
			}
			if($("#ENDTIME").val()==""){
				$("#ENDTIME").tips({
					side:3,
		            msg:'请输入结束时间',
		            bg:'#AE81FF',
		            time:2
		        });
				$("#ENDTIME").focus();
			return false;
			}
			if($("#TYPE").val()==""){
				$("#TYPE").tips({
					side:3,
		            msg:'请选择请假类型',
		            bg:'#AE81FF',
		            time:2
		        });
				$("#TYPE").focus();
			return false;
			}
			if($("#WHENLONG").val()==""){
				$("#WHENLONG").tips({
					side:3,
		            msg:'请输入时长',
		            bg:'#AE81FF',
		            time:2
		        });
				$("#WHENLONG").focus();
			return false;
			}
			if($("#REASON").val()==""){
				$("#REASON").tips({
					side:3,
		            msg:'请输入事由',
		            bg:'#AE81FF',
		            time:2
		        });
				$("#REASON").focus();
			return false;
			}
			$("#Form").submit();
			$("#zhongxin").hide();
			$("#zhongxin2").show();
		}
		
		$(function() {
			//日期框
			$('.date-picker').datepicker({autoclose: true,todayHighlight: true});
		});
		</script>
</body>
</html>