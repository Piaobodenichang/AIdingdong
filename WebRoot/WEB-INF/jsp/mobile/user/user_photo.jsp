<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<base href="<%=basePath%>">
<title>编辑用户头像</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no, minimal-ui" />
<meta name="apple-mobile-web-app-capable" content="yes" />
<meta name="format-detection" content="telephone=no, email=no" />
<!--[if IE]>
<script src="mobile/plugins/js/html5shiv.min.js"></script>
<![endif]-->

<link href="mobile/plugins/css/style.css" rel="stylesheet" type="text/css">

<style type="text/css">
	#logox img{width:98%; height:98%; border-radius:50%;-webkit-border-radius:50%;-moz-border-radius:50%;}
</style>
</head>
<body>
<header>
<img src="mobile/plugins/images/rpw_back_n.png" onclick="javascript:window.location.href='mobileindex/usercenter';">
<span onclick="javascript:window.location.href='mobileindex/usercenter';">用户头像</span>
<div class="clear"></div>
</header>
<section class="logo-license">
<div class="half" style="width:100%;">
	<a class="logo" id="logox">
		<img id="bgl" src="mobile/plugins/images/logo_n.png">
	</a>
	<p>用户头像</p>
</div>

<div class="clear"></div>
</section>

<article class="htmleaf-container">
<div id="clipArea"></div>
<div class="foot-use">
	<div class="uploader1 blue">
		<input type="button" name="file" class="button" value="照片">
		<input id="file" type="file" accept="image/*" multiple  />
	</div>
	<button id="clipBtn">截取</button>
	<button id="clipBtn" onclick="quxiao();" style="margin-right: 1px;background-color: #C0C0C0">取消</button>
</div>
<div id="view"></div>
</article>

<article class="info">

</article>
<article class="btn-1" onclick="save();">
<button>确认提交</button>
</article>

<script src="mobile/plugins/js/jquery.min.js" type="text/javascript"></script>
<script>window.jQuery || document.write('<script src="mobile/plugins/js/jquery-2.1.1.min.js"><\/script>')</script>
<script src="mobile/plugins/js/iscroll-zoom.js"></script>
<script src="mobile/plugins/js/hammer.js"></script>
<script src="mobile/plugins/js/jquery.photoClip.js"></script>
<script type="text/javascript" src="static/js/jquery.tips.js"></script>
<script>
	var obUrl = '';
	$("#clipArea").photoClip({
		width: 200,
		height: 200,
		file: "#file",
		view: "#view",
		ok: "#clipBtn",
		loadStart: function() {
			//console.log("照片读取中");
		},
		loadComplete: function() {
			//console.log("照片读取完成");
		},
		clipFinish: function(dataURL) {
			//console.log(dataURL);
			obUrl = dataURL;
		}
	});
	
	$(function(){
	$("#logox").click(function(){
	$(".htmleaf-container").show();
	});
		$("#clipBtn").click(function(){
			$("#logox").empty();
			$('#logox').append('<img src="' + imgsource + '" align="absmiddle">');
			$(".htmleaf-container").hide();
		});
	});
	
	function save(){
		if('' == obUrl){
			$("#bgl").tips({
				side:3,
	            msg:'还未选择照片!',
	            bg:'#AE81FF',
	            time:3
	     	});
		}else{
			$.ajax({
				type: "POST",
				url: '<%=basePath%>mobileuser/saveUserPhoto.do',
		    	data: {PHOTODATA:obUrl,tm:new Date().getTime()},
				dataType:'json',
				cache: false,
				success: function(data){
					window.location.href='mobileindex/usercenter';
				}
			});
		}
	}
	
	//取消
	function quxiao(){
		$(".htmleaf-container").hide();
	}
	
</script>

</body>
</html>