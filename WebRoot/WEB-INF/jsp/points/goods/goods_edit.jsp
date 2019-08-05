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
	<!-- 下拉框 -->
	<link rel="stylesheet" href="static/ace/css/chosen.css" />
	<!-- jsp文件头和头部 -->
	<%@ include file="../../system/index/top.jsp"%>
	<script type="text/javascript" src="static/ace/js/jquery.js"></script>
	<!-- 上传插件 -->
	<link href="plugins/uploadify/uploadify.css" rel="stylesheet" type="text/css">
	<script type="text/javascript" src="plugins/uploadify/swfobject.js"></script>
	<script type="text/javascript" src="plugins/uploadify/jquery.uploadify.v2.1.4.min.js"></script>
	<!-- 上传插件 -->
	<script type="text/javascript">
	var jsessionid = "<%=session.getId()%>";  //勿删，uploadify兼容火狐用到
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
					
					<form action="goods/${msg }.do" name="Form" id="Form" method="post">
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
								<td><select name="GOODS_STATE" id="GOODS_STATE" >
                					<option value="上架" >上架</option>
                					<option value="下架" >下架</option>
            					</select></td>
							</tr>
							<tr>
								<td style="width:75px;text-align: right;padding-top: 13px;" id="FILEPATHn">商品图片:</td>
								<td>
									<input type="file" name="File_name" id="uploadify1" keepDefaultStyle = "true"/>
									<input type="hidden" name="FILEPATH" id="FILEPATH" value=""/>
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
			if($("#hasTp1").val()=="no"){
				$("#FILEPATHn").tips({
					side:2,
			        msg:'请选择商品图片',
			        bg:'#AE81FF',
			        time:2
			    });
			return false;
			}
			$('#uploadify1').uploadifyUpload();
		}
		
		
		$(document).ready(function(){
			var str='';
			$("#uploadify1").uploadify({
				'buttonImg'	: 	"<%=basePath%>plugins/uploadify/uploadp.png",
				'uploader'	:	"<%=basePath%>plugins/uploadify/uploadify.swf",
				'script'    :	"<%=basePath%>plugins/uploadify/uploadFile.jsp;jsessionid="+jsessionid,
				'cancelImg' :	"<%=basePath%>plugins/uploadify/cancel.png",
				'folder'	:	"<%=path%>/img",//上传文件存放的路径,请保持与uploadFile.jsp中PATH的值相同
				'queueId'	:	"fileQueue",
				'queueSizeLimit'	:	1,//限制上传文件的数量 
				//'fileExt'	:	"*.rar,*.zip",
				//'fileDesc'	:	"RAR *.rar",//限制文件类型
				'fileExt'     : '*.*;*.*;*.*',
				'fileDesc'    : 'Please choose(.*, .*, .*)',
				'auto'		:	false,
				'multi'		:	false,//是否允许多文件上传
				'simUploadLimit':	2,//同时运行上传的进程数量
				'buttonText':	"files",
				'scriptData':	{'uploadPath':'/img/'},//这个参数用于传递用户自己的参数，此时'method' 必须设置为GET, 后台可以用request.getParameter('name')获取名字的值
				'method'	:	"GET",
				'onComplete':function(event,queueId,fileObj,response,data){
					str = response.trim();//单个上传完毕执行
				},
				'onAllComplete' : function(event,data) {
					//alert(str);	//全部上传完毕执行
					$("#FILEPATH").val(str);
					$("#Form").submit();
					$("#zhongxin").hide();
					$("#zhongxin2").show();
		    	},
		    	'onSelect' : function(event, queueId, fileObj){
		    		$("#hasTp1").val("ok");
		    	}
			});
					
		});
		String.prototype.trim=function(){
		     return this.replace(/(^\s*)|(\s*$)/g,'');
		};
		</script>
</body>
</html>