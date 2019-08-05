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
    <title>收信箱</title>
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
	$("#guishu-tj-qx").click(function(){
		$(".modal-overlay").removeClass("modal-overlay-visible");
		$(".tj-modal").hide();
		});
	$("#guishu-tj-v").click(function(){
		$(".modal-overlay").removeClass("modal-overlay-visible");
		$(".tj-modal").hide();
		});
})
</script>
	
</head>

<body>
<header class="top-title">
	<ul>
    	<li onclick="javascript:window.location.href='mobileindex/fhsms'"><i class="iconfont icon-zuosvg"></i><span>返回</span></li>
        <li>收信箱<span id="fhsmsCount"></span></li>
    </ul>
</header>
<div class="sear-header">
  <div class="sear-wk">
    <div class="sear-search" id="taskCount">
      <ul>
        <li>
        <form action="mobilefhsms/list.do" method="post" name="Form" id="Form">
        	<input type="hidden"  name="TYPE" value="1">
        	<input type="text"  name="keywords" value="${pd.keywords }" placeholder="输入关键字">
		</form>
        </li>
        <li onclick="tosearch();"><i class="iconfont icon-chazhao"></i></li>
      </ul>
    </div>
    <div class="sear-tjk">
      <c:if test="${QX.FHSMS == 1 }"><div class="sear-tj" onclick="sendFhsms('');"> <i class="iconfont icon-jiasvg"></i></div></c:if>
    </div>
  </div>
</div>
<div class="splist-cont" id="fhsmstss">

<c:choose>
<c:when test="${not empty varList}">
<c:forEach items="${varList}" var="var" varStatus="vs">
  <div class="splist-cont-wk">
    <ul>
      <li>
        <div class="splist-wz">
          <p><span class="color-hui1">发信人：</span>${var.TO_USERNAME}</p>
          <p><span class="color-hui1">收信人：</span>${var.FROM_USERNAME}</p>
        </div>
        <div class="splist-wz">
          <p><span class="color-hui1">时间：</span>${fn:substring(var.SEND_TIME ,0,16)}</p>
          <p><span class="color-hui1">状态：</span>
          	<span id="STATUS${vs.index+1}">
			  	<c:if test="${var.STATUS == '2' }">未读</c:if>
			  	<c:if test="${var.STATUS == '1' }">已读</c:if>
		  	</span>
		  </p>
        </div>
      </li>
      <li>
      	<a onclick="viewx('STATUS${vs.index+1}','${var.STATUS}','${pd.TYPE == '2'?'2':'1' }','${var.FHSMS_ID}','${var.SANME_ID}');"><i class="iconfont icon-chakan ico-blue"></i>查看</a> 
      	<c:if test="${QX.FHSMS == 1 }"><a onclick="sendFhsms('${var.TO_USERNAME}');"><i class="iconfont icon-xin ico-orange"></i>回复</a></c:if>
        <a onclick="isdel('${var.FHSMS_ID}');"><i class="iconfont icon-shanchu ico-red"></i>删除</a>
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

<!--添加弹窗开始-->
<div class="tj-modal" id="addfhsms">
  <div class="tj-modal-inner">
    <div class="tj-modal-text">发信</div>
    <div class="ffrom">
    	<label>用户名：</label>
        <input type="text" name="USERNAME" id="USERNAME" maxlength="50" placeholder="多个请用(;)分号隔开">
    </div>
    <div class="ffrom">
    	<label>内容：</label>
        <textarea rows="4" cols="20" name="CONTENT" id="CONTENT" placeholder="这里输入内容"></textarea>
    </div>
  </div>
  <div class="tj-modal-buttons ">
  	<span onclick="save();" class="tj-modal-button">确定</span><span id="guishu-tj-qx" class="tj-modal-button">取消</span>
  </div>
</div>
<!--添加弹窗结束-->
<!--查看弹窗开始-->
<div id="v-tc" class="tj-modal">
  <div class="tj-modal-inner">
    <div class="tj-modal-text">信件内容</div>
    <div class="ffrom" id="neirong"></div>
  </div>
  <div class="tj-modal-buttons ">
  	<span onclick="save();" class="tj-modal-button"></span><span id="guishu-tj-v" class="tj-modal-button">关闭</span>
  </div>
</div>
<!--查看弹窗结束-->
<!--删除弹窗开始-->
<div id="bj-tc" class="bj-modal">
  <div class="tj-modal-inner">
    <div class="tj-modal-text">确定要删除吗?</div>
  </div>
  <div class="bj-modal-buttons ">
  	<span onclick="del();" class="bj-modal-button">确定</span><span id="guishu-bj-qx" class="bj-modal-button">取消</span>
  </div>
</div>
<!--删除弹窗结束-->
<!--灰背景层-->
<div class="modal-overlay"></div>
<div id="fhsmsobj"></div>
<script>var locat="<%=basePath%>";</script>
<script type="text/javascript" src="mobile/static/js/head.js"></script>
<script type="text/javascript" src="static/js/jquery.tips.js"></script>
<script>

	//基本信息 (在mobile/static/js/head.js中调用)
	function fhonload(){
		$("#fhsmstss").tips({
			side:1,
            msg:'您有'+fhsmsCount+'条未读消息',
            bg:'#AE81FF',
            time:3
        });
	};

	//检索
	function tosearch(){
		$("#Form").submit();
	}
	
	//查看信件
	function viewx(ztid,STATUS,type,Id,SANME_ID){
		$(".modal-overlay").addClass("modal-overlay-visible");
		$("#v-tc").show();
		if(type == "1" && STATUS == '2' && $("#"+ztid).html() == '未读'){
			$("#"+ztid).html('未读');
		}
		 $.ajax({
				type: "POST",
				url: '<%=basePath%>mobilefhsms/goView.do',
		    	data: {FHSMS_ID:Id,TYPE:type,SANME_ID:SANME_ID,STATUS:STATUS,tm:new Date().getTime()},
				dataType:'json',
				cache: false,
				success: function(data){
					$("#neirong").html(data.pd.CONTENT);
				}
			});
	}

	var nid =  '';
	//是否删除
	function isdel(Id){
		nid = Id;
		$(".modal-overlay").addClass("modal-overlay-visible");
		$("#bj-tc").show();
	}
	
	//删除
	function del(){
		var url = "<%=basePath%>mobilefhsms/delete.do?FHSMS_ID="+nid+"&tm="+new Date().getTime();
		$.get(url,function(data){
			tosearch();
		});
	}
	
	//保存
	function save(){
		var USERNAME = $("#USERNAME").val();
		if(USERNAME == ""){
			$("#USERNAME").tips({
				side:3,
	            msg:'请输入用户名',
	            bg:'#AE81FF',
	            time:2
	        });
			$("#USERNAME").focus();
		return false;
		}
		var CONTENT = $("#CONTENT").val();
		if(CONTENT == ""){
			$("#CONTENT").tips({
				side:3,
	            msg:'请输入内容',
	            bg:'#AE81FF',
	            time:2
	        });
			$("#CONTENT").focus();
		return false;
		}
		$.ajax({
			type: "POST",
			url: "<%=basePath%>mobilefhsms/save.do?tm="+new Date().getTime(),
	    	data: {USERNAME:USERNAME,CONTENT:CONTENT},
			dataType:'json',
			cache: false,
			success: function(data){
				 if(data.msg == 'ok'){
					 var count = data.count;
					 var ecount = data.ecount;
					 $("#taskCount").tips({
						side:3,
			            msg:'成功发出'+count+'条,失败'+ecount+'条',
			            bg:'#68B500',
			            time:3
				      });
				 }
				 $(".modal-overlay").removeClass("modal-overlay-visible");
				 $(".tj-modal").hide();
				 fhsmsmsg(USERNAME);
			}
		});
	}
	
	//发站内信
	function sendFhsms(username){
		$(".modal-overlay").addClass("modal-overlay-visible");
		$("#addfhsms").show();
		$("#USERNAME").val(username);
	}

</script>
</body>
</html>