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

</head>

<body>
<header class="top-title">
	<ul>
    	<li onclick="javascript:window.location.href='mobiletask/hislist'"><i class="iconfont icon-zuosvg"></i><span>返回</span></li>
        <li>流程信息</li>
    </ul>
</header>
<div class="csgl-zssp-cont">
  <div class="csgl-zssp-cont-wk">
    <ul>
      <li>
      	<c:forEach items="${varList}" var="var" varStatus="vs">
			<c:if test="${var.NAME_ != 'RESULT'}">
			<div class="csgl-zssp-wz">
          		<p><span class="color-hui1">${var.NAME_ == 'USERNAME'?'登录用户':var.NAME_}：</span>${var.TEXT_}</p>
       		</div>
       		</c:if>
		</c:forEach>
      </li>
    </ul>
  </div>
</div>

<div class="splist-cont" style="margin-top: -50px;">
<c:forEach items="${hitaskList}" var="var" varStatus="vs">
  <div class="splist-cont-wk">
    <ul>
      <li>
        <div class="splist-wz">
          <p><span class="color-hui1">步骤[${vs.index+1}]：</span>${var.ACT_NAME_}</p>
          <p><span class="color-hui1">办理人：</span>${var.ASSIGNEE_}</p>
        </div>
        <div class="splist-wz">
          <p><span class="color-hui1">开始：</span>${fn:substring(var.START_TIME_ ,0,16)}</p>
          <p><span class="color-hui1">结束：</span>${fn:substring(var.END_TIME_ ,0,16)}</p>
        </div>
        <div class="splist-wz">
          <p><span class="color-hui1">用时：</span>${var.ZTIME}</p>
          <p><span class="color-hui1"></span></p>
        </div>
        <div>
          	<p>审批意见:
	          	<c:if test="${vs.index > 0 && var.TEXT_ == null}">
	               ${var.DELETE_REASON_}
	            </c:if>
	 			<c:forEach items="${fn:split(var.TEXT_,',fh,')}"   var="val" varStatus="dvs"  >
                     <c:if test="${dvs.index == 0 }">${val}</c:if>
                     <c:if test="${dvs.index == 1 }">${val}</c:if>
	             </c:forEach>
			</p>
        </div>
      </li>
    </ul>
  </div>
 </c:forEach>
</div>
<div class="cpgl-spxx-cont" style="margin-top: -46px;">
	<div class="cpgl-spxx-tp">
    	<div class="cpgl-spxx-bt">流程图</div>
        <div class="cpgl-spxx-nr">
			<img alt="${pd.FILENAME }" src="${pd.imgSrc }">
		</div>
    </div>
</div>


</body>
</html>