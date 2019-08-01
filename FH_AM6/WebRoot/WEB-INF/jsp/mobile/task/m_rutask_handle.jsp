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
		$("#guishu-bj-qx2").click(function(){
			$(".modal-overlay").removeClass("modal-overlay-visible");
			$("#bj-tc2").hide();
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
    	<li onclick="javascript:window.location.href='mobiletask/list'"><i class="iconfont icon-zuosvg"></i><span>返回</span></li>
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
      <c:if test="${QX.NextASSIGNEE_ == 1 }">
      <li style="padding-top: 5px;">
        <a onclick="getUser();"><i class="iconfont icon-gerenzhongxin ico-blue"></i>指定办理人</a>
        <a onclick="getRole();"><i class="iconfont icon-icon09 ico-blue"></i>指定角色</a>
        <a><input type="text" name="ASSIGNEE_2" id="ASSIGNEE_2" placeholder="不指定则默认对象" value=""  title="指定下一办理对象" style="width:150px;border:1px solid #D4D4D4;background-color:transparent;" readonly="readonly"/></a>
      </li>
      </c:if>
	  <li>
        <a onclick="ispizhun('yes');"><i class="iconfont icon-bianji ico-blue"></i>批准</a>
        <c:if test="${QX.Reject == 1 }"><a onclick="isbohui('no');"><i class="iconfont icon-chakan ico-red"></i>驳回 </a></c:if>
        <c:if test="${QX.Abolish == 1 }"><a onclick="iszuofei('${pd.PROC_INST_ID_}');"><i class="iconfont icon-shanchu ico-red"></i>作废</a></c:if>
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
          <p><span class="color-hui1">结束：</span>
          	<c:if test="${var.END_TIME_ == NULL}">正在审批……</c:if>
			<c:if test="${var.END_TIME_ != NULL}">${fn:substring(var.END_TIME_ ,0,16)}</c:if>
          </p>
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

<!--弹窗-->
<div id="bj-tc" class="tj-modal">
  <div class="tj-modal-inner">
    <div class="tj-modal-text">确定要作废吗?</div>
      <div class="ffrom">
    	<label>理由：</label>
        <textarea rows="4" cols="20" name="reason" id="reason" placeholder="这里输入作废理由"></textarea>
  	  </div>
  </div>
  <div class="bj-modal-buttons ">
  	<span onclick="zuofei();" class="bj-modal-button">确定</span><span id="guishu-bj-qx" class="bj-modal-button">取消</span>
  </div>
</div>
<!--弹窗-->

<!--弹窗-->
<div id="bj-tc2" class="tj-modal">
  <div class="tj-modal-inner">
    <div class="tj-modal-text" id="sptitle"></div>
      <div class="ffrom">
    	<label>审批：</label>
        <textarea rows="4" cols="20" name="spreason" id="spreason" placeholder="这里输入审批操作"></textarea>
  	  </div>
  </div>
  <div class="bj-modal-buttons ">
  	<span onclick="handle();" class="bj-modal-button">确定</span><span id="guishu-bj-qx2" class="bj-modal-button">取消</span>
  </div>
</div>
<!--弹窗-->


<c:if test="${null == pd.msg or pd.msg != 'admin' }">
<form action="mobiletask/handle.do" name="Form" id="Form" method="post">
	<input type="hidden" name="ID_" id="ID_" value="${pd.ID_}"/>
	<input type="hidden" name="ASSIGNEE_" id="ASSIGNEE_" value=""/>
	<input type="hidden" name="PROC_INST_ID_" id="PROC_INST_ID_" value="${pd.PROC_INST_ID_}"/>
	<input type="hidden" name="msg" id="msg" value="yes"/>
	<textarea  name="OPINION" id="OPINION" maxlength="4000" style="display:none" ></textarea>
</form>
</c:if>

<!--灰背景层-->
<div class="modal-overlay"></div>

<!--引入弹窗组件2start-->
<script type="text/javascript" src="plugins/attention/drag/drag.js"></script>
<script type="text/javascript" src="plugins/attention/drag/dialog.js"></script>
<link type="text/css" rel="stylesheet" href="plugins/attention/drag/style.css" />
<!--引入弹窗组件2end-->

<script type="text/javascript" src="static/js/jquery.tips.js"></script>
<script>

	var nid =  '';
	//是否作废
	function iszuofei(Id){
		nid = Id;
		$(".modal-overlay").addClass("modal-overlay-visible");
		$("#bj-tc").show();
	}
	
	//作废
	function zuofei(){
		var reason = $("#reason").val();
		if('' == reason)reason = "未写作废缘由";
		var url = "<%=basePath%>mobiletask/delete.do?PROC_INST_ID_="+nid+"&reason="+encodeURI(encodeURI(reason))+"&tm="+new Date().getTime();
		$.get(url,function(data){
			window.location.href="<%=basePath%>mobiletask/list";
		});
	}
	
	//驳回
	function isbohui(msg){
		$("#msg").val(msg);
		$("#sptitle").html("驳回");
		$(".modal-overlay").addClass("modal-overlay-visible");
		$("#bj-tc2").show();
	}
	
	//批准
	function ispizhun(msg){
		$("#msg").val(msg);
		$("#sptitle").html("批准");
		$(".modal-overlay").addClass("modal-overlay-visible");
		$("#bj-tc2").show();
	}
	
	//办理任务
	function handle(){
		$("#OPINION").val($("#spreason").val());
		if($("#OPINION").val()==""){
			$("#spreason").tips({
				side:3,
	            msg:'请输入审批意见',
	            bg:'#AE81FF',
	            time:2
	        });
			$("#OPINION").focus();
		return false;
		}
		$("#Form").submit();
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
				 $("#ASSIGNEE_2").val(USERNAME);
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
				 $("#ASSIGNEE_2").val(RNUMBER);
			 }
			diag.close();
		 };
		 diag.show();
	}

</script>
</body>
</html>