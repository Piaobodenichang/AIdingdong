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
<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0"/>
<head>
	<title>添加好友</title>
	<base href="<%=basePath%>">
	<!-- jsp文件头和头部 -->
	<%@ include file="../../system/index/top.jsp"%>
	<link rel="stylesheet" href="mobile/fhim/dist/css/layui.css?v=1">
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
					
					<form action="mobilefriends/search.do" name="Form" id="Form" method="post">
						<div id="zhongxin" style="padding-top: 13px;">
						<table id="table_report" class="table table-striped table-bordered table-hover">
							<tr>
								<td onclick="javascript:window.location.href='mobilefriends/goIm'">
									&lt;&nbsp;返回
								</td>
							</tr>
							<tr>
								<td>
									<div class="nav-search">
										<input type="text" placeholder="请输入用户名或者姓名"  style="width: 200px;" id="nav-search-input" autocomplete="off" name="keywords" value="${pd.keywords}" placeholder="请输入用户名或者姓名"/>
										<a class="btn btn-light btn-xs" onclick="tosearch();" title="检索" style="height: 30px;" >查找</a>&nbsp;&nbsp;
										<a class="btn btn-light btn-xs" href="mobileqgroup/goAdd" title="找群" style="height: 30px;" >找群</a>
									</div>
								</td>
							</tr>
							<tr>
								<td colspan="2">
									<table>
										<tr>
											<!-- 开始循环 -->	
											<c:choose>
												<c:when test="${not empty varList}">
													<c:forEach items="${varList}" var="var" varStatus="vs">
														<td>
															<div style="padding-left:23px;padding-top:15px;padding-bottom:15px" class="center">
															    <li data-uid="${var.USERNAME}" data-fromGroup="0" data-username="${var.NAME}" data-avatar="${(null == var.PHOTO1 or '' == var.PHOTO1)?'static/ace/avatars/userb.jpg':var.PHOTO1}" >
															      <a data-type="agree" class="layui-fh" style="cursor:pointer;" onclick="add('${var.USERNAME}');">
															        <img src="${(null == var.PHOTO2 or '' == var.PHOTO2)?'static/ace/avatars/user.jpg':var.PHOTO2}" class="layui-circle layim-msgbox-avatar">
															      </a>
															      <p class="layim-msgbox-user">
															        <a data-type="agree" class="layui-fh1" >${var.NAME}</a>
															      </p>
															    </li>
															</div>
															${vs.index % 3 == 0 && vs.index > 0?"</tr><tr>":"" }
														</td>
													</c:forEach>
												</c:when>
												<c:otherwise>
													<tr class="main_info">
														<td colspan="100">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${null == pd.keywords?"请先搜索":'没有相关好友'}</td>
													</tr>
												</c:otherwise>
											</c:choose>
										</tr>
									</table>
								</td>
							</tr>
						</table>
						</div>
						<div id="zhongxin2" class="center" style="display:none"><br/><br/><br/><br/><br/><img src="static/images/jiazai.gif" /><br/><h4 class="lighter block green">搜索中...</h4></div>
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
	<script src="mobile/fhim/dist/layui.js?v=1"></script>
	<!--提示框-->
	<script type="text/javascript" src="static/js/jquery.tips.js"></script>
	<script type="text/javascript">
	
		$(function(){
			$("#nav-search-input").tips({
				side:3,
	            msg:'用户名或姓名',
	            bg:'#AE81FF',
	            time:1
	        });
		});
	
		//检索
		function tosearch(){
			$("#Form").submit();
			$("#zhongxin2").show();
		}
		
		function add(uid){
			//询问框
			layer.confirm('您是要加他(她)好友吗?', {
			  btn: ['申请','取消'] //按钮
			}, function(){
			  $.ajax({
					type: "POST",
					url: 'appiminterface/addFriends.do',	//添加好友接口
			    	data: {FUSERNAME:uid,FGROUP_ID:'9999',BZ:'申请加好友',tm:new Date().getTime()},
					dataType:'json',
					cache: false,
					success: function(data){
						if('01' == data.result){
							layer.msg('添加成功,等待对方同意', {icon: 1});
						}else{
							layer.msg('您已经添加过他(她)了,无需再添加了', {icon: 2});
						}
					}
				});
			}, function(){
			  
			});
		}
				
		layui.use(['layim', 'flow'], function(){
		});
	</script>
</body>
</html>