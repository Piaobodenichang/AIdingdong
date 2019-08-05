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
    <title>请假申请</title>
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
    	<li onclick="javascript:window.location.href='mobileindex/oalist'"><i class="iconfont icon-zuosvg"></i><span>返回</span></li>
        <li>请假申请</li>
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
        <form action="mobilemyleave/list.do" method="post" name="Form" id="Form">
        	<input type="text"  name="keywords" value="${pd.keywords }" placeholder="输入关键字">
		</form>
        </li>
        <li onclick="tosearch();"><i class="iconfont icon-chazhao"></i></li>
      </ul>
    </div>
    <div class="sear-tjk">
      <div class="sear-tj"> <i id="guishu-tj-butt" class="iconfont icon-jiasvg"></i> </div>
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
          <p><span class="color-hui1">申请人：</span>${var.USERNAME}</p>
          <p><span class="color-hui1">类型：</span>${var.TYPE}(${var.WHENLONG})</p>
        </div>
        <div class="splist-wz">
          <p><span class="color-hui1">开始：</span>${var.STARTTIME}</p>
          <p><span class="color-hui1">结束：</span>${var.ENDTIME}</p>
        </div>
      </li>
      <li>
        <a onclick="isdel('${var.MYLEAVE_ID}');"><i class="iconfont icon-shanchu ico-red"></i>删除</a>
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
<form action="mobilemyleave/save.do" name="SForm" id="SForm" method="post">
<div class="tj-modal">
  <div class="tj-modal-inner">
    <div class="tj-modal-text">添加</div>
    <div class="ffrom">
    	<label>开始日期：</label>
        <input type="date" name="STARTTIME" id="STARTTIME">
    </div>
    <div class="ffrom">
    	<label>结束日期：</label>
        <input type="date" name="ENDTIME" id="ENDTIME">
    </div>
    <div class="ffrom">
    	<label>类型：</label>
        <select style="width:200px;"  name="TYPE" id="TYPE"  title="请假类型" style="width:100%;"></select>	
    </div>
    <div class="ffrom">
    	<label>时长：</label>
        <input type="text" name="WHENLONG" id="WHENLONG" maxlength="50" placeholder="这里输入时长">
    </div>
    <div class="ffrom">
    	<label>事由：</label>
        <textarea rows="4" cols="20" name="REASON" id="REASON" placeholder="这里输入事由"></textarea>
    </div>
  </div>
  <div class="tj-modal-buttons ">
  	<span onclick="save();" class="tj-modal-button">确定</span><span id="guishu-tj-qx" class="tj-modal-button">取消</span>
  </div>
</div>
</form>
<!--添加弹窗结束-->
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

<script>var locat="<%=basePath%>";</script>
<script type="text/javascript" src="mobile/static/js/head.js"></script>
<script>
	//基本信息 (在mobile/static/js/head.js中调用)
	function fhonload(){};
</script>

<script type="text/javascript" src="static/js/jquery.tips.js"></script>
<script>

	//检索
	function tosearch(){
		$("#Form").submit();
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
		var url = "<%=basePath%>mobilemyleave/delete.do?MYLEAVE_ID="+nid+"&tm="+new Date().getTime();
		$.get(url,function(data){
			tosearch();
		});
	}
	
	//初始分类,调用数据字典
	$(function() {
		var TYPE = "${pd.TYPE}";
		$.ajax({
			type: "POST",
			url: '<%=basePath%>mobileindex/getLevels.do?tm='+new Date().getTime(),
	    	data: {DICTIONARIES_ID:'ce174640544549f1b31c8f66e01c111b'},//ce174640544549f1b31c8f66e01c111b 为请假类型ID
			dataType:'json',
			cache: false,
			success: function(data){
				 $.each(data.list, function(i, dvar){
					 if(TYPE == dvar.BIANMA){
						 $("#TYPE").append("<option value="+dvar.NAME+" selected='selected'>"+dvar.NAME+"</option>");
					 }else{
						 $("#TYPE").append("<option value="+dvar.NAME+">"+dvar.NAME+"</option>");
					 }
				 });
			}
		});
	});
	
	//保存
	function save(){
		if($("#STARTTIME").val()==""){
			$("#STARTTIME").tips({
				side:3,
	            msg:'请输入开始时间',
	            bg:'#AE81FF',
	            time:2
	        });
			$("#STARTTIME").focus();
		return false;
		}
		if($("#ENDTIME").val()==""){
			$("#ENDTIME").tips({
				side:3,
	            msg:'请输入结束时间',
	            bg:'#AE81FF',
	            time:2
	        });
			$("#ENDTIME").focus();
		return false;
		}
		if($("#TYPE").val()==""){
			$("#TYPE").tips({
				side:3,
	            msg:'请选择请假类型',
	            bg:'#AE81FF',
	            time:2
	        });
			$("#TYPE").focus();
		return false;
		}
		if($("#WHENLONG").val()==""){
			$("#WHENLONG").tips({
				side:3,
	            msg:'请输入时长',
	            bg:'#AE81FF',
	            time:2
	        });
			$("#WHENLONG").focus();
		return false;
		}
		if($("#REASON").val()==""){
			$("#REASON").tips({
				side:3,
	            msg:'请输入事由',
	            bg:'#AE81FF',
	            time:2
	        });
			$("#REASON").focus();
		return false;
		}
		$("#SForm").submit();
	}

</script>
</body>
</html>