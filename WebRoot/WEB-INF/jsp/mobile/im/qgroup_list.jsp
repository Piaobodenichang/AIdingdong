<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
    <title>群组管理</title>
    <meta charset="utf-8">
	<meta http-equiv="expires" content="0">
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta name="x5-orientation" content="portrait">
	<meta name="viewport" content="width=device-width,initial-scale=1.0,user-scalable=no,minimal-ui,maximum-scale=1.0">
	<meta name="format-detection" content="telephone=no">
	<meta name="apple-mobile-web-app-capable" content="yes">
	<meta name="apple-mobile-web-app-status-bar-style" content="black">
	<meta name="apple-touch-fullscreen" content="yes">
	
	<link rel="stylesheet" type="text/css" href="mobile/static/css/ws-reset.css">
	<link rel="stylesheet" type="text/css" href="mobile/static/font/iconfont.css">
	<link rel="stylesheet" type="text/css" href="mobile/static/css/ws-style.css">
	<link rel="stylesheet" type="text/css" href="mobile/static/css/ws-pop.css">
	<link rel="stylesheet" type="text/css" href="mobile/static/css/ws-content.css">
	<script type="text/javascript" src="mobile/static/js/Adaptive.js"></script>
	<script type="text/javascript" src="mobile/static/js/jquery-3.1.1.min.js"></script>

	<style type="text/css">
		img{width:29px; height:29px; border-radius:50%;-webkit-border-radius:50%;-moz-border-radius:50%;}
	</style>
	
	<script>
	$(function(){
		$("#guishu-bj-qx").click(function(){
			$(".modal-overlay").removeClass("modal-overlay-visible");
			$("#bj-tc").hide();
			});
		$("#guishu-bj-qx2").click(function(){
			$(".modal-overlay").removeClass("modal-overlay-visible");
			$("#bj-tc2").hide();
			});
	})
	</script>
	
</head>

<body>
<header class="top-title">
	<ul>
    	<li onclick="javascript:window.location.href='mobileindex/myim'"><i class="iconfont icon-zuosvg"></i><span>返回</span></li>
        <li>群组管理</li>
    </ul>
</header>

<div id="fhsmsobj"></div>
<div id="fhsmsCount" style="display: none;"></div>
<div id="fhsmstss"></div>
<div id="taskCount"></div>

<div class="sear-header">
  <div class="sear-wk">
    <div class="sear-search">
      <ul>
        <li>
        <form action="mobileqgroup/list.do" method="post" name="Form" id="Form">
        	<input type="text"  name="keywords" value="${pd.keywords }" placeholder="输入关键字">
		</form>
        </li>
        <li onclick="tosearch();"><i class="iconfont icon-chazhao"></i></li>
      </ul>
    </div>
    <div class="sear-tjk">
      <div class="sear-tj"> <i onclick="add();" class="iconfont icon-jiasvg"></i> </div>
    </div>
  </div>
</div>
<div class="splist-cont">

<c:choose>
<c:when test="${not empty varList}">
<c:forEach items="${varList}" var="var" varStatus="vs">
  <div class="splist-cont-wk">
    <ul>
      <li>
        <div class="splist-wz">
          <p><span class="color-hui1">群名：</span>${var.NAME}</p>
          <p><span class="color-hui1">群主：</span>${var.USERNAME==pd.USERNAME?"(<font color='red'>我创建的</font>)":var.USERNAME}</p>
        </div>
      </li>
      <li>
      	<a><img src="${var.PHOTO}" width="29" /></a>
      	<c:if test="${var.USERNAME!=pd.USERNAME }">
      		<a onclick="isdel('${var.QGROUP_ID}','${var.PHOTO}');"><i class="iconfont icon-shanchu ico-red"></i>退群</a>
      	</c:if>
      	<c:if test="${var.USERNAME==pd.USERNAME }">
      		<a onclick="edit('${var.QGROUP_ID}');"><i class="iconfont icon-bianji ico-blue"></i>修改</a>
      	</c:if>
      </li>
    </ul>
  </div>
 </c:forEach>
 </c:when>
	<c:otherwise>
	<div class="splist-cont-wk" style="padding-bottom: 10px;">
	         <p>没有相关数据</p>
	 	</div>
	</c:otherwise>
</c:choose>
<div class="splist-cont-wkpa">
   	 ${page.pageStrSimplify}
</div>
  
</div>

<!--删除弹窗开始-->
<div id="bj-tc" class="bj-modal">
  <div class="tj-modal-inner">
    <div class="tj-modal-text">确定要退群吗?</div>
  </div>
  <div class="bj-modal-buttons ">
  	<span onclick="del();" class="bj-modal-button">确定</span><span id="guishu-bj-qx" class="bj-modal-button">取消</span>
  </div>
</div>
<!--删除弹窗结束-->

<!--灰背景层-->
<div class="modal-overlay"></div>
<div id="zhongxin"></div>

<script>var locat="<%=basePath%>";</script>
<script type="text/javascript" src="mobile/static/js/head.js"></script>

<!--引入弹窗组件2start-->
<script type="text/javascript" src="plugins/attention/drag/drag.js"></script>
<script type="text/javascript" src="plugins/attention/drag/dialog.js"></script>
<link type="text/css" rel="stylesheet" href="plugins/attention/drag/style.css" />
<!--引入弹窗组件2end-->

<script type="text/javascript" src="static/js/jquery.tips.js"></script>
<script>

	//基本信息 (在mobile/static/js/head.js中调用)
	function fhonload(){};

	//刷新
	function tosearch(){
		$("#Form").submit();
	}

	var nid =  '';
	var PATH =  '';
	//是否退群
	function isdel(Id,value){
		nid = Id;
		PATH = value;
		$(".modal-overlay").addClass("modal-overlay-visible");
		$("#bj-tc").show();
	}
	
	//删除
	function del(){
		var url = "<%=basePath%>mobilefgroup/delete.do?FGROUP_ID="+nid+"&tm="+new Date().getTime();
		$.get(url,function(data){
			tosearch();
		});
	}
	
	//退出群
	function del(){
		var url = "<%=basePath%>mobileqgroup/delete.do?QGROUP_ID="+nid+"&PATH="+PATH+"&tm="+new Date().getTime();
		$.get(url,function(data){
			tosearch();
		});
	}
	
	//新增
	function add(){
		var QID = "${QID }";
		 var diag = new Dialog();
		 diag.Drag=true;
		 diag.Title ="新增";
		 diag.URL = '<%=basePath%>mobileqgroup/goAddFromlist.do?QID='+QID;
		 diag.Width = 450;
		 diag.Height = 200;
		 diag.Modal = true;				//有无遮罩窗口
		 diag.CancelEvent = function(){ //关闭事件
			 if(diag.innerFrame.contentWindow.document.getElementById('zhongxin').style.display == 'none'){
				 tosearch();
			}
			diag.close();
		 };
		 diag.show();
	}
	
	//修改
	function edit(Id){
		 var diag = new Dialog();
		 diag.Drag=true;
		 diag.Title ="编辑";
		 diag.URL = '<%=basePath%>mobileqgroup/goEdit.do?QGROUP_ID='+Id;
		 diag.Width = 450;
		 diag.Height = 200;
		 diag.Modal = true;				//有无遮罩窗口
		 diag.CancelEvent = function(){ //关闭事件
			 if(diag.innerFrame.contentWindow.document.getElementById('zhongxin').style.display == 'none'){
				 tosearch();
			}
			diag.close();
		 };
		 diag.show();
	}

</script>
</body>
</html>