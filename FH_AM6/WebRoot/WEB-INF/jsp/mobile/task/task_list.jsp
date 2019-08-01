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
    <title>任务管理</title>
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
	<script type="text/javascript" src="mobile/static/js/Adaptive.js"></script>
	<script type="text/javascript" src="mobile/static/js/jquery-3.1.1.min.js"></script>
	
</head>

<body>
<header class="top-title">
	<ul>
    	<li onclick="javascript:window.location.href='mobile/main'"><i class="iconfont icon-zuosvg"></i><span>返回</span></li>
        <li>任务管理</li>
    </ul>
</header>

<div id="fhsmsobj"></div>
<div id="fhsmsCount" style="display: none;"></div>
<div id="fhsmstss"></div>
<div id="taskCount"></div>

<div class="list-cont">
	<a onclick="javascript:window.location.href='mobiletask/list'">
        <ul>
            <li><i class="iconfont icon-bianjixs list-img-or"></i></li>
            <li>
            	<span>待办任务</span><i class="iconfont icon-yousvg"></i>
            </li>
        </ul>
    </a>
    	<a onclick="javascript:window.location.href='mobiletask/hislist'">
        <ul>
            <li><i class="iconfont icon-weifenxiaopcjiemianzhuanhuan list-img-bl"></i>
            <li>
            	<span>已办任务</span><i class="iconfont icon-yousvg"></i>
            </li>
        </ul>
    </a>
</div>

<script>var locat="<%=basePath%>";</script>
<script type="text/javascript" src="mobile/static/js/head.js"></script>
<script>
//基本信息 (在mobile/static/js/head.js中调用)
function fhonload(){};
</script>
</body>
</html>