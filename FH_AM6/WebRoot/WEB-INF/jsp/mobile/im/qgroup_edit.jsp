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
					
					<form action="mobileqgroup/${msg }.do" name="Form" id="Form" method="post" enctype="multipart/form-data">
						<input type="hidden" name="QGROUP_ID" id="QGROUP_ID" value="${pd.QGROUP_ID}"/>
						<input type="hidden" name="QID" id="QID" value="${pd.QID}"/>
						<div id="zhongxin" style="padding-top: 13px;">
						<table id="table_report" class="table table-striped table-bordered table-hover">
							<tr>
								<td style="width:75px;text-align: right;padding-top: 13px;">群名称:</td>
								<td><input type="text" name="NAME" id="NAME" value="${pd.NAME}" maxlength="255" placeholder="这里输入群名称" title="群名称" style="width:98%;"/></td>
							</tr>
							<tr>
								<td style="width:50px;text-align: right;padding-top: 13px;">群头像:</td>
								<td>
									<c:if test="${pd == null || pd.PHOTO == '' || pd.PHOTO == null }">
									<input type="file" id="tp" name="tp" onchange="fileType(this)"/>
									</c:if>
									<c:if test="${pd != null && pd.PHOTO != '' && pd.PHOTO != null }">
										<a href="${pd.PHOTO}" target="_blank"><img src="${pd.PHOTO}" width="50"/></a>
										<input type="button" class="btn btn-mini btn-danger" value="删除" onclick="delP('${pd.PHOTO}','${pd.QGROUP_ID }');" />
										<input type="hidden" name="tpz" id="tpz" value="${pd.PHOTO }"/>
									</c:if>
								</td>
							</tr>
							<tr>
								<td style="text-align: center;" colspan="10">
									<a class="btn btn-mini btn-primary" onclick="save();">保存</a>
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
	<!-- ace scripts -->
	<script src="static/ace/js/ace/ace.js"></script>
	<!-- 上传控件 -->
	<script src="static/ace/js/ace/elements.fileinput.js"></script>
	<!--提示框-->
	<script type="text/javascript" src="static/js/jquery.tips.js"></script>
		<script type="text/javascript">
		
		$(function() {
			//上传
			$('#tp').ace_file_input({
				no_file:'请选择图片 ...',
				btn_choose:'选择',
				btn_change:'更改',
				droppable:false,
				onchange:null,
				thumbnail:false, //| true | large
				whitelist:'gif|png|jpg|jpeg',
				//blacklist:'gif|png|jpg|jpeg'
				//onchange:''
				//
			});
		});
		
		//保存
		function save(){
			if($("#NAME").val()==""){
				$("#NAME").tips({
					side:3,
		            msg:'请输入群名称',
		            bg:'#AE81FF',
		            time:2
		        });
				$("#NAME").focus();
			return false;
			}
			if(typeof($("#tpz").val()) == "undefined"){
				if($("#tp").val()=="" || document.getElementById("tp").files[0] =='请选择图片'){
					
					$("#tp").tips({
						side:3,
			            msg:'请选图片',
			            bg:'#AE81FF',
			            time:3
			        });
					return false;
				}
			}
			$("#Form").submit();
			$("#zhongxin").hide();
			$("#zhongxin2").show();
		}
		
		//过滤类型
		function fileType(obj){
			var fileType=obj.value.substr(obj.value.lastIndexOf(".")).toLowerCase();//获得文件后缀名
		    if(fileType != '.gif' && fileType != '.png' && fileType != '.jpg' && fileType != '.jpeg'){
		    	$("#tp").tips({
					side:3,
		            msg:'请上传图片格式的文件',
		            bg:'#AE81FF',
		            time:3
		        });
		    	$("#tp").val('');
		    	document.getElementById("tp").files[0] = '请选择图片';
		    }
		}
		
		//删除图片
		function delP(PATH,QGROUP_ID){
			 if(confirm("确定要删除图片？")){
				var url = "mobileqgroup/deltp.do?PATH="+PATH+"&QGROUP_ID="+QGROUP_ID+"&guid="+new Date().getTime();
				$.get(url,function(data){
					if(data=="success"){
						alert("删除成功!");
						document.location.reload();
					}
				});
			} 
		}
		</script>
</body>
</html>