<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
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
						<!-- 检索  -->
						<form action="mobileuser/listUsersForWindow.do" method="post" name="userForm" id="userForm">
						<table style="margin-top:5px;">
							<tr>
								<td>
										<input autocomplete="off" id="nav-search-input" type="text" name="keywords" value="${pd.keywords }" placeholder="这里输入关键词" />
								</td>
								<td style="vertical-align:top;padding-left:2px;"><a class="btn btn-light btn-xs" onclick="searchs();"  title="检索"><i id="nav-search-icon" class="ace-icon fa fa-search bigger-110 nav-search-icon blue"></i></a></td>
							</tr>
						</table>
						<!-- 检索  -->
						<table id="simple-table" class="table table-striped table-bordered table-hover"  style="margin-top:5px;">
							<thead>
								<tr>
									<th class="center" style="width:35px;" id="fhadminth"></th>
									<th class="center">用户名</th>
									<th class="center">姓名</th>
								</tr>
							</thead>
							<tbody>
							<!-- 开始循环 -->	
							<c:choose>
								<c:when test="${not empty userList}">
									<c:forEach items="${userList}" var="user" varStatus="vs">
										<tr>
											<td class='center' style="width: 30px;">
												<label><input type='radio' name="fhadmin" value="${user.USERNAME }" onclick="setUser(this.value)" class="ace"/><span class="lbl"></span></label>
											</td>
											<td class="center">${user.USERNAME }</td>
											<td class="center">${user.NAME }</td>
										</tr>
									</c:forEach>
								</c:when>
								<c:otherwise>
									<tr class="main_info">
										<td colspan="10" class="center">没有相关数据</td>
									</tr>
								</c:otherwise>
							</c:choose>
							</tbody>
						</table>
						<table style="width:100%;">
							<tr>
								<td style="vertical-align:top;"><div class="pagination" style="float: right;padding-top: 0px;margin-top: 0px;">${page.pageStrSimplify}</div></td>
							</tr>
							<tr>
								<td style="vertical-align:top;">
									<a class="btn btn-mini btn-primary" onclick="userBinding();">选中</a>
									<a class="btn btn-mini btn-danger" onclick="wclose();">取消</a>
								</td>
							</tr>
							
						</table>
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
		<input type="hidden" name="USERNAME" id="USERNAME" />
		<!-- 返回顶部 -->
		<a href="#" id="btn-scroll-up" class="btn-scroll-up btn btn-sm btn-inverse">
			<i class="ace-icon fa fa-angle-double-up icon-only bigger-110"></i>
		</a>

	</div>
	<!-- /.main-container -->

	<!-- basic scripts -->
	<!-- 页面底部js¨ -->
	<%@ include file="../../system/index/foot.jsp"%>
	<!-- ace scripts -->
	<script src="static/ace/js/ace/ace.js"></script>
	<!--提示框-->
	<script type="text/javascript" src="static/js/jquery.tips.js"></script>
	</body>

<script type="text/javascript">

//检索
function searchs(){
	$("#userForm").submit();
}


//选定用户
function setUser(USERNAME){
	$("#USERNAME").val(USERNAME);
}

//绑定用户
function userBinding(){
	var USERNAME = $("#USERNAME").val();
	if("" == USERNAME){
		$("#fhadminth").tips({
			side:3,
            msg:'没有选择任何用户',
            bg:'#AE81FF',
            time:2
        });
	}else{
		top.Dialog.close();
	}
}

//关闭窗口
function wclose(){
	$("#USERNAME").val("");
	top.Dialog.close();
}
		
</script>
</html>
