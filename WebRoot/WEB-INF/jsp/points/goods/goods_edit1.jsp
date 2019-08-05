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
	<meta http-equiv="Content-Type" content="multipart/form-data;charset=utf-8" />
	<base href="<%=basePath%>">
	<!-- 下拉框 -->
	<link rel="stylesheet" href="static/ace/css/chosen.css" />
	<!-- jsp文件头和头部 -->
	<%@ include file="../../system/index/top.jsp"%>
	<script type="text/javascript" src="static/ace/js/jquery.js"></script>
	
	<script type="text/javascript">
	var jsessionid = "<%=session.getId()%>";  //勿删，uploadify兼容火狐用到
	/* window.onload=function(){
		var GOODS_STATE1=document.getElementById("GOODS_STATE");
		var options=GOODS_STATE1.getElementsByTagName("option");
		var GOODS_STATE=${pd.GOODS_STATE};
		if(GOODS_STATE.equals(""))
	} */
	</script>
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
					
					<form action="goods/${msg }.do" name="Form" id="Form" method="post" enctype="multipart/form-data">
					<input type="hidden" value="no" id="hasTp1" />
						<input type="hidden" name="GOODS_ID" id="GOODS_ID" value="${pd.GOODS_ID}"/>
						<div id="zhongxin" style="padding-top: 13px;">
						<table id="table_report" class="table table-striped table-bordered table-hover">
							<tr>
								<td style="width:75px;text-align: right;padding-top: 13px;">商品名称:</td>
								<td><input type="text" name="GOODS_NAME" id="GOODS_NAME" value="${pd.GOODS_NAME}" maxlength="255" placeholder="这里输入商品名称" title="商品名称" style="width:98%;"/></td>
							</tr>
							<tr>
								<td style="width:75px;text-align: right;padding-top: 13px;">商品价格:</td>
								<td><input type="text" name="GOODS_PRICE" id="GOODS_PRICE" value="${pd.GOODS_PRICE}" maxlength="255" placeholder="这里输入商品价格" title="商品价格" style="width:98%;"/></td>
							</tr>
							<tr>
								<td style="width:75px;text-align: right;padding-top: 13px;">商品数量:</td>
								<td><input type="number" name="GOODS_NUMBER" id="GOODS_NUMBER" value="${pd.GOODS_NUMBER}" maxlength="32" placeholder="这里输入商品数量" title="商品数量" style="width:98%;"/></td>
							</tr>
							<tr>
								<td style="width:75px;text-align: right;padding-top: 13px;">商品描述:</td>
								<td><input type="text" name="GOODS_DESCRIBE" id="GOODS_DESCRIBE" value="${pd.GOODS_DESCRIBE}" maxlength="255" placeholder="这里输入商品描述" title="商品描述" style="width:98%;"/></td>
							</tr>
							<tr>
								<td style="width:75px;text-align: right;padding-top: 13px;">商品状态:</td>
								<td><select name="GOODS_STATE" id="GOODS_STATE" style="width:100px">
                					<option  value="上架"  <c:if test="${pd.GOODS_STATE =='上架'}">selected</c:if>>上架</option>
                					<option value="下架" <c:if test="${pd.GOODS_STATE =='下架'}">selected</c:if>>下架</option>
            					</select></td>
							</tr>
							<tr>
								<td style="width:75px;text-align: right;padding-top: 13px;" id="FILEPATHn">商品图片:</td>
								<td>
									<input type="file" name="File_name" id="uploadify1" keepDefaultStyle = "true" onchange="changeP();"/>
									<input type="hidden" name="oldFileName" value="${pd.GOODS_PICTURE}">
									<img id="img" style="margin-top: -3px;" src="img/${pd.GOODS_PICTURE}" height="100px" width="75px">
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
	<!-- 下拉框 -->
	<script src="static/ace/js/chosen.jquery.js"></script>
	<!-- 日期框 -->
	<script src="static/ace/js/date-time/bootstrap-datepicker.js"></script>
	<!--提示框-->
	<script type="text/javascript" src="static/js/jquery.tips.js"></script>
	
		<script type="text/javascript">
		$(top.hangge());
		//保存
		function changeP(){
			var docObj = document.getElementById("uploadify1");
            var imgObjPreview = document.getElementById("img");
            console.log("aaaaaaaaaaa"+window.URL.createObjectURL(docObj.files[0]));
            var imgUrl =window.URL.createObjectURL(docObj.files[0]);
            imgObjPreview.setAttribute('src',imgUrl); // 修改img标签src属性值
            return true;
		}
		function save(){
			if($("#GOODS_NAME").val()==""){
				$("#GOODS_NAME").tips({
					side:3,
		            msg:'请输入商品名称',
		            bg:'#AE81FF',
		            time:2
		        });
				$("#GOODS_NAME").focus();
			return false;
			}
			if($("#GOODS_PRICE").val()==""){
				$("#GOODS_PRICE").tips({
					side:3,
		            msg:'请输入商品价格',
		            bg:'#AE81FF',
		            time:2
		        });
				$("#GOODS_PRICE").focus();
			return false;
			}
			if($("#GOODS_NUMBER").val()==""){
				$("#GOODS_NUMBER").tips({
					side:3,
		            msg:'请输入商品数量',
		            bg:'#AE81FF',
		            time:2
		        });
				$("#GOODS_NUMBER").focus();
			return false;
			}
			if($("#GOODS_DESCRIBE").val()==""){
				$("#GOODS_DESCRIBE").tips({
					side:3,
		            msg:'请输入商品描述',
		            bg:'#AE81FF',
		            time:2
		        });
				$("#GOODS_DESCRIBE").focus();
			return false;
			}
			if($("#GOODS_STATE").val()==""){
				$("#GOODS_STATE").tips({
					side:3,
		            msg:'请输入商品状态',
		            bg:'#AE81FF',
		            time:2
		        });
				$("#GOODS_STATE").focus();
			return false;
			}
			
			$("#Form").submit();
			$("#zhongxin").hide();
			$("#zhongxin2").show();
		}
		
		

		</script>
</body>
</html>