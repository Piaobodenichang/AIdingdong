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
    <title>待办任务</title>
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
	})
	</script>

</head>

<body>
<header class="top-title">
	<ul>
    	<li onclick="javascript:window.location.href='mobileindex/tasklist'"><i class="iconfont icon-zuosvg"></i><span>返回</span></li>
        <li>待办任务</li>
    </ul>
</header>

<div id="fhsmsobj"></div>
<div id="fhsmsCount" style="display: none;"></div>
<div id="fhsmstss"></div>
<div id="taskCount"></div>

<div class="sear-header" id="msg">
  <div class="sear-wk">
    <div class="sear-search" style="width:100%;">
      <ul>
        <li>
        <form action="mobiletask/list.do" method="post" name="Form" id="Form">
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
          <p><span class="color-hui1">流程任务：</span>${var.PNAME_}</p>
          <p><span class="color-hui1">时间：</span>${fn:substring(var.CREATE_TIME_ ,0,16)}</p>
        </div>
        <div class="splist-wz">
          <p><span class="color-hui1">申请人：</span>${var.INITATOR}</p>
          <p><span class="color-hui1">待办人：</span>${var.ASSIGNEE_}</p>
        </div>
		<div class="kcglrk-wzb">
          <p><span class="color-hui1">节点：</span>${var.NAME_}</p>
        </div>
      </li>
      <li>
        <c:if test="${QX.Delegate == 1 }"><a onclick="delegate('${var.ID_}');"><i class="iconfont icon-chakan ico-red"></i>委派</a></c:if>
        <a onclick="handle('${var.PROC_INST_ID_}','${var.ID_}','${var.DGRM_RESOURCE_NAME_}');"><i class="iconfont icon-bianji ico-blue"></i>办理</a>
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

<!--操作弹窗开始-->
<div id="bj-tc" class="modal">
<form action="mobiletask/delegate.do" name="form1" id="form1"  method="post">
<input type="hidden" name="ID_" id="ID_" value=""/>
  <div class="modal-inner">
    <div class="modal-text">委派</div>
    <div class="ffrom" style="margin-top: 3px;">
    	<label>选择指定对象：</label>
        <input type="text" name="ASSIGNEE_" id="ASSIGNEE_" placeholder="委派对象" value=""  title="委派对象" readonly="readonly" style="width:60%;border:1px solid #D4D4D4;background-color:transparent;"/>
  	</div>
    <ul>
        <li onclick="getUser();">
        	<i class="iconfont icon-gerenzhongxin ico-blue"></i>
            <p>指定办理人</p>
        </li>
        <li onclick="getRole();">
        	<i class="iconfont icon-icon09 ico-blue"></i>
            <p>指定角色</p>
        </li>
    </ul>
  </div>
  <div class="modal-buttons">
  	<span id="order-cz-qd" class="modal-button" onclick="save();">确定</span><span id="guishu-bj-qx" class="modal-button">取消</span>
  </div>
</form>
</div>
<!--操作弹窗结束-->

<!--灰背景层-->
<div class="modal-overlay"></div>

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

	//检索
	function tosearch(){
		$("#Form").submit();
	}
	
	var msg = "${pd.taskmsg}";
	//消息
	function taskmsg(){
		if('leave' == msg){
			$("#msg").tips({
				side:3,
	            msg:'保存成功，请办理任务',
	            bg:'#AE81FF',
	            time:5
	        });
		}
	}
	taskmsg();
	
	//办理
	function  handle(PROC_INST_ID_,ID_,FILENAME){
		window.location.href='<%=basePath%>mobiletask/goHandle.do?PROC_INST_ID_='+PROC_INST_ID_+"&ID_="+ID_+'&FILENAME='+encodeURI(encodeURI(FILENAME));
	}
	
	//保存
	function save(){
		if($("#ASSIGNEE_").val()==""){
			$("#ASSIGNEE_").tips({
				side:3,
	            msg:'请选择委派对象',
	            bg:'#AE81FF',
	            time:2
	        });
			$("#ASSIGNEE_").focus();
			return false;
		}
		$("#form1").submit();
	}
	
	//委派
	function delegate(ID_){
		$("#ID_").val(ID_);
		$(".modal-overlay").addClass("modal-overlay-visible");
		$("#bj-tc").show();
	}

	//选择办理人
	function getUser(){
		 var diag = new Dialog();
		 diag.Drag=true;
		 diag.Title ="选择办理人";
		 diag.URL = '<%=basePath%>mobileuser/listUsersForWindow.do';
		 diag.Width = 700;
		 diag.Height = 545;
		 diag.Modal = true;				//有无遮罩窗口
		 diag.CancelEvent = function(){ //关闭事件
			 var USERNAME = diag.innerFrame.contentWindow.document.getElementById('USERNAME').value;
			 if("" != USERNAME){
				 $("#ASSIGNEE_").val(USERNAME);
			 }
			diag.close();
		 };
		 diag.show();
	}
	
	//选择角色
	function getRole(){
		 var diag = new Dialog();
		 diag.Drag=true;
		 diag.Title ="选择角色";
		 diag.URL = '<%=basePath%>mobileuser/roleListWindow.do?ROLE_ID=1';
		 diag.Width = 700;
		 diag.Height = 545;
		 diag.Modal = true;				//有无遮罩窗口
		 diag.CancelEvent = function(){ //关闭事件
			 var RNUMBER = diag.innerFrame.contentWindow.document.getElementById('RNUMBER').value;
			 if("" != RNUMBER){
				 $("#ASSIGNEE_").val(RNUMBER);
			 }
			diag.close();
		 };
		 diag.show();
	}
	
</script>
</body>
</html>