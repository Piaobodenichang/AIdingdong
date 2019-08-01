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
    <title>我的通讯</title>
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
        <li>我的通讯</li>
    </ul>
</header>
<div class="list-cont" id="taskCount">
	<a onclick="javascript:window.location.href='mobilefriends/list'">
        <ul>
            <li><i class="iconfont icon-shanghuliebiao list-img-or"></i></li>
            <li>
            	<span>好友管理</span><i class="iconfont icon-yousvg"></i>
            </li>
        </ul>
    </a>
    <a onclick="javascript:window.location.href='mobilefgroup/list'">
        <ul>
            <li><i class="iconfont icon-fenlei list-img-zi"></i></li>
            <li>
            	<span>好友分组</span><i class="iconfont icon-yousvg"></i>
            </li>
        </ul>
    </a>
    <a onclick="javascript:window.location.href='mobileqgroup/list'">
        <ul>
            <li><i class="iconfont icon-kucunguanli list-img-sl"></i></li>
            <li>
            	<span>我的群组</span><i class="iconfont icon-yousvg"></i>
            </li>
        </ul>
    </a>
</div>

<footer class="index-footer">
	<ul>
    	<li>
        	<a onclick="javascript:window.location.href='mobileindex/index'">
        		<i class="iconfont icon-shouye"></i>
            	<p>首页</p>
            </a>
        </li>
        <li>
        	<a onclick="javascript:window.location.href='mobileindex/fhsms'">
        		<i class="iconfont icon-xin"></i><sapn id="fhsmsCount"></sapn>
            	<p id="fhsmstss">站内信件</p>
            </a>
        </li>
        <li>
        	<a class="footer-color">
        		<i class="iconfont icon-icon3"></i>
            	<p>我的通讯</p>
            </a>
        </li>
        <li>
        	<a onclick="javascript:window.location.href='mobileindex/usercenter'">
        		<i class="iconfont icon-icon09"></i>
            	<p>个人中心</p>
            </a>
        </li>
    </ul>
</footer>
<div id="fhsmsobj"></div>
<script>var locat="<%=basePath%>";</script>
<script type="text/javascript" src="mobile/static/js/head.js"></script>
<script type="text/javascript" src="static/js/jquery.tips.js"></script>
<script>
	//基本信息 (在mobile/static/js/head.js中调用)
	function fhonload(){
		$("#fhsmsCount").html(fhsmsCount);		//站内信未读数量
	};
</script>
</body>
</html>