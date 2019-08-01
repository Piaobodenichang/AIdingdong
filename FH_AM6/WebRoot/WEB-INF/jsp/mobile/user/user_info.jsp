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
    <title>修改资料</title>
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
		$(".bjshdz-right").click(function(){
			$(this).toggleClass("icon-fuxuankuang1 ico-blue");
			})
		})
	</script>
	
</head>

<body>
<header class="top-title">
	<ul>
    	<li onclick="javascript:window.location.href='mobileindex/usercenter';"><i class="iconfont icon-zuosvg"></i><span>返回</span></li>
        <li>修改资料</li>
    </ul>
</header>
<div class="bjshdz-cont">
<!--基本信息-->
	<form action="mobileuser/editU.do" name="userForm" id="userForm" method="post">
	<input type="hidden" name="USER_ID" id="user_id" value="${pd.USER_ID }"/>
	<input name="ROLE_ID" id="role_id" value="${pd.ROLE_ID }" type="hidden" />
	<input type="hidden" name="USERNAME" id="loginname" value="${pd.USERNAME }" />
	<input type="hidden" name="NUMBER" id="NUMBER" value="${pd.NUMBER }" />
	<textarea style="display: none;" name="ROLE_IDS" id="ROLE_IDS" >${pd.ROLE_IDS }</textarea>
    <div class="bjshdz-lb">
        <div class="ffrom">
            <label>姓名</label>
            <input type="text" name="NAME" id="name"  value="${pd.NAME }"  maxlength="32" placeholder="这里输入姓名" title="姓名" />
        </div>
        <div class="ffrom">
            <label>密码</label>
            <input type="password" name="PASSWORD" id="password"  maxlength="32" placeholder="输入密码" title="密码"/>
        </div>
        <div class="ffrom">
            <label>确认密码</label>
            <input type="password" name="chkpwd" id="chkpwd"  maxlength="32" placeholder="确认密码" title="确认密码"/>
        </div>
        <div class="ffrom">
            <label>手机</label>
            <input type="number" name="PHONE" id="PHONE"  value="${pd.PHONE }"  maxlength="32" placeholder="这里输入手机号" title="手机号" />
        </div>
        <div class="ffrom">
            <label>邮箱</label>
            <input type="email" name="EMAIL" id="EMAIL"  value="${pd.EMAIL }" maxlength="32" placeholder="这里输入邮箱" title="邮箱" onblur="hasE('${pd.USERNAME }')"/>
        </div>
        <div class="ffrom">
            <label>备注</label>
            <input type="text" name="BZ" id="BZ"value="${pd.BZ }" placeholder="这里输入备注" maxlength="64" title="备注" />
        </div>
    </div>
    </form>
</div>
<div class="bjshdz-butt" onclick="save();">
	<a>保存</a>
</div>
<script type="text/javascript" src="static/js/jquery.tips.js"></script>
<script>
//保存
function save(){
	
	if($("#name").val()==""){
		$("#name").tips({
			side:3,
            msg:'输入姓名',
            bg:'#AE81FF',
            time:3
        });
		$("#name").focus();
		return false;
	}
	if($("#user_id").val()=="" && $("#password").val()==""){
		$("#password").tips({
			side:3,
            msg:'输入密码',
            bg:'#AE81FF',
            time:2
        });
		$("#password").focus();
		return false;
	}
	if($("#password").val()!=$("#chkpwd").val()){
		$("#chkpwd").tips({
			side:3,
            msg:'两次密码不相同',
            bg:'#AE81FF',
            time:3
        });
		$("#chkpwd").focus();
		return false;
	}
	var myreg = /^(((13[0-9]{1})|159)+\d{8})$/;
	if($("#PHONE").val()==""){
		
		$("#PHONE").tips({
			side:3,
            msg:'输入手机号',
            bg:'#AE81FF',
            time:3
        });
		$("#PHONE").focus();
		return false;
	}else if($("#PHONE").val().length != 11 && !myreg.test($("#PHONE").val())){
		$("#PHONE").tips({
			side:3,
            msg:'手机号格式不正确',
            bg:'#AE81FF',
            time:3
        });
		$("#PHONE").focus();
		return false;
	}
	if($("#EMAIL").val()==""){
		$("#EMAIL").tips({
			side:3,
            msg:'输入邮箱',
            bg:'#AE81FF',
            time:3
        });
		$("#EMAIL").focus();
		return false;
	}else if(!ismail($("#EMAIL").val())){
		$("#EMAIL").tips({
			side:3,
            msg:'邮箱格式不正确',
            bg:'#AE81FF',
            time:3
        });
		$("#EMAIL").focus();
		return false;
	}
	$("#userForm").submit();
}
function ismail(mail){
	return(new RegExp(/^(?:[a-zA-Z0-9]+[_\-\+\.]?)*[a-zA-Z0-9]+@(?:([a-zA-Z0-9]+[_\-]?)*[a-zA-Z0-9]+\.)+([a-zA-Z]{2,})+$/).test(mail));
}

//判断邮箱是否存在
function hasE(USERNAME){
	var EMAIL = $.trim($("#EMAIL").val());
	$.ajax({
		type: "POST",
		url: '<%=basePath%>mobileuser/hasE.do',
    	data: {EMAIL:EMAIL,USERNAME:USERNAME,tm:new Date().getTime()},
		dataType:'json',
		cache: false,
		success: function(data){
			 if("success" != data.result){
				 $("#EMAIL").tips({
						side:3,
			            msg:'邮箱 '+EMAIL+' 已存在',
			            bg:'#AE81FF',
			            time:3
			        });
				 $("#EMAIL").val('');
			 }
		}
	});
}

</script>
</body>
</html>