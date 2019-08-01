<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
    <title>已办任务</title>
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

<script>
$(function(){
	$("#guishu-bj-qx").click(function(){
		$(".modal-overlay").removeClass("modal-overlay-visible");
		$("#bj-tc").hide();
		});
	$("#guishu-tj-butt").click(function(){
		$(".modal-overlay").addClass("modal-overlay-visible");
		$(".tj-modal").show();
		});
	$("#guishu-tj-qx").click(function(){
		$(".modal-overlay").removeClass("modal-overlay-visible");
		$(".tj-modal").hide();
		});
})
</script>
	
</head>

<body>
<header class="top-title">
	<ul>
    	<li onclick="javascript:window.location.href='mobileindex/tasklist'"><i class="iconfont icon-zuosvg"></i><span>返回</span></li>
        <li>已办任务</li>
    </ul>
</header>

<div id="fhsmsobj"></div>
<div id="fhsmsCount" style="display: none;"></div>
<div id="fhsmstss"></div>
<div id="taskCount"></div>

<div class="sear-header">
  <div class="sear-wk">
    <div class="sear-search" style="width:100%;">
      <ul>
        <li>
        <form action="mobiletask/hislist.do" method="post" name="Form" id="Form">
        	<input type="text"  name="keywords" value="${pd.keywords }" placeholder="输入关键字">
		</form>
        </li>
        <li onclick="tosearch();"><i class="iconfont icon-chazhao"></i></li>
      </ul>
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
          <p><span class="color-hui1">流程：</span>${var.PNAME_}</p>
          <p><span class="color-hui1">节点：</span>${var.NAME_}</p>
        </div>
        <div class="splist-wz">
          <p><span class="color-hui1">申请人：</span>${var.INITATOR}</p>
          <p><span class="color-hui1">办理人：</span>${var.ASSIGNEE_}</p>
        </div>
        <div class="splist-wz">
          <p><span class="color-hui1">开始：</span>${fn:substring(var.START_TIME_ ,0,16)}</p>
          <p><span class="color-hui1">完结：</span>${fn:substring(var.END_TIME_ ,0,16)}</p>
        </div>
        <div class="splist-wz">
          <p><span class="color-hui1">用时：</span>${var.ZTIME}</p>
          <p><span class="color-hui1"></span></p>
        </div>
      </li>
      <li>
         <a id="guishu-bj" onclick="view('${var.PROC_INST_ID_}','${var.DEPLOYMENT_ID_ }','${var.DGRM_RESOURCE_NAME_}');"><i class="iconfont icon-bianji ico-blue"></i>流程信息</a>
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

<script>var locat="<%=basePath%>";</script>
<script type="text/javascript" src="mobile/static/js/head.js"></script>

<script type="text/javascript" src="static/js/jquery.tips.js"></script>
<script>

	//基本信息 (在mobile/static/js/head.js中调用)
	function fhonload(){};

	//流程信息
	function view(PROC_INST_ID_,DEPLOYMENT_ID_,FILENAME){
		window.location.href='<%=basePath%>mobiletask/view.do?PROC_INST_ID_='+PROC_INST_ID_+"&DEPLOYMENT_ID_="+DEPLOYMENT_ID_+'&FILENAME='+encodeURI(encodeURI(FILENAME));
	}

</script>
</body>
</html>