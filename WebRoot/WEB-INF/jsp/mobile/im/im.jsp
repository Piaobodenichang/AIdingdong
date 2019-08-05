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
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, height=device-height, user-scalable=no, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0">
<meta name="format-detection" content="telephone=no">
<title>FH Admin移动端</title>
<link rel="stylesheet" href="mobile/fhim/dist/css/layui.mobile.css">
<script src="static/js/jquery-1.7.2.js"></script>
</head>
<body>
<script src="mobile/fhim/dist/layui.js"></script>
<script>

var websocket = null;	//websocket对象
var USER_ID;			//用户ID
var user = "FH";		//用于即时通讯（ 当前登录用户）
var uname = "";			//姓名

layui.config({
  version: true
}).use('mobile', function(){
	
		$.ajax({
			type: "POST",
			url: 'mobilehead/getNowUser.do?tm='+new Date().getTime(),
	    	data: encodeURI(""),
			dataType:'json',
			//beforeSend: validateData,
			cache: false,
			success: function(data){
					 user = data.user.USERNAME;			//用户名
					 uname = data.user.NAME;			//姓名
					 USER_ID = data.user.USER_ID;		//用户ID
				if (window.WebSocket) {
					websocket = new WebSocket(encodeURI('ws://'+data.wimadress)); 
					websocket.onopen = function() {
						layer.msg('即时通讯已连接成功');
						websocket.send(',mobilefh-join,'+user); //发送上线消息(把上线状态发送给好友，对方好友栏目本头像从黑白色变彩色)(前提条件：本身在线状态设置为在线状态，否则对方看到的依然是离线状态)
					};
					websocket.onerror = function() { 			//连接失败
						layer.msg('连接发生错误,刷新或者更换浏览器试试');
											};
					websocket.onclose = function() {			//连接断开
						websocket.send(',fhadmin-leave,');		//发送下线消息
						layer.msg('已经断开连接');
					};
					websocket.onmessage = function(message) {	//消息接收
						var message = JSON.parse(message.data);
						if('friend' == message.type || 'group' == message.type){ 	//接收好友或群发送的消息
							layim.getMessage(message);
						}else if('user_join' == message.type){
							layim.setFriendStatus(message.user, 'online'); 			//好友上线设置指定好友在线，即头像取消置灰
						}else if('user_leave' == message.type){
							layim.setFriendStatus(message.user, 'offline'); 		//好友下线设置指定好友下线，即头像置灰
						}else if('user_online' == message.type){
							layim.setFriendStatus(message.user, 'online');			//好友设置在线状态
						}else if('user_hide' == message.type){
							layim.setFriendStatus(message.user, 'offline');			//好友设置隐身状态
						}else if('user_emove' == message.type){						//删除好友(被动删，被拉黑)
							layim.removeList({
								  type: 'friend' 	//或者group
								  ,id: message.user //好友用户名
								});
						}else if('agreefriend' == message.type){					//对方同意添加好友
							layim.addList({
								  type: 'friend' 				//列表类型，只支持friend和group两种
								  ,avatar: message.avatar 		//好友头像
								  ,username: message.username	//好友昵称
								  ,groupid: message.groupid		//所在的分组id
								  ,id: message.id 				//好友id
								  ,status: message.status 		//在线状态
								  ,sign: message.sign		 	//好友签名
							  });
						}else if('agreeqgroup' == message.type){//对方同意群申请
							location.reload();			
						}else if('kickoutqgroup' == message.type){	//踢出群
							location.reload();	
						}else if('delqgroup' == message.type){		//群解散
							layer.msg(message.CONTENT);
							location.reload();	
						}
					};
				}else{
					layer.msg('此浏览器不支持websocket,请用支持HTML5的浏览器');
				}
			}
		});
	
  var mobile = layui.mobile
  ,layim = mobile.layim
  ,layer = mobile.layer;
  
  $.get('<%=basePath%>appiminterface/getList',  function(str){
	  layim.config({
		init:str,
	    uploadImage: {
	       url: 'appiminterface/updateImg'			//上传图片接口
	      ,type: '' //默认post
	    }
	    ,uploadFile: {
	       url: 'appiminterface/updateFile'			//上传文件接口
	      ,type: '' //默认post
	    }
	  	//扩展更多列表
	    ,moreList: [{
	      alias: 'index'
	      ,title: '返回首页'
	      ,iconUnicode: '&#xe68e;' 	//图标字体的unicode，可不填
	      ,iconClass: '' 			//图标字体的class类名
	    }]
	    ,isgroup: true 				//是否开启“群聊”
	    //,chatTitleColor: '#c00' 	//顶部Bar颜色
	    ,title: '我的通讯' 			//应用名
	  });
  });
  
  //监听点击“新的朋友”
  layim.on('newFriend', function(){
	  window.location.href='<%=basePath%>mobilefriends/goAdd.do';
  });
  
  //查看聊天信息
  layim.on('detail', function(data){
   	window.location.href='<%=basePath%>mobilehismsg/himsglist.do?id='+data.id+'&type='+data.type+'&title='+data.name;
  });
  
  //与好友的聊天记录
  layim.on('mchatlog', function(data){
	 window.location.href='<%=basePath%>mobilehismsg/himsglist.do?id='+data.id+'&type='+data.type+'&title='+data.name;
  });
  
  //监听查看更多记录
  layim.on('chatlog', function(data, ul){
	 window.location.href='<%=basePath%>mobilehismsg/himsglist.do?id='+data.id+'&type='+data.type+'&title='+data.name;
  });
  
  //监听点击更多列表
  layim.on('moreList', function(obj){
    switch(obj.alias){
      case 'index':
        window.location.href='mobileindex/index';//返回首页
        //模拟标记“发现新动态”为已读
        layim.showNew('More', false);
        layim.showNew('find', false);
      break;
      case 'share':
        layim.panel({
          title: '邀请好友' //标题
          ,tpl: '<div style="padding: 10px;">自定义模版，{{d.data.test}}</div>' //模版
          ,data: { //数据
            test: '么么哒'
          }
        });
      break;
    }
  });
  
  /*监听layim建立就绪*/
  layim.on('ready', function(res){
	$.ajax({
		type: "POST",
		url: 'appiminterface/getNoreadMsg.do',		//未读消息(离线消息)接口
    	data: {tm:new Date().getTime()},
		dataType:'json',
		cache: false,
		success: function(data){
			if('has' == data.result){
				$.each(data.list, function(i, list){
					layim.getMessage({
						  username: list.NAME 		//消息来源用户名
						  ,avatar: list.PHOTO 		//消息来源用户头像
						  ,id: list.USERNAME 		//消息的来源ID（如果是私聊，则是用户id，如果是群聊，则是群组id）
						  ,type: "friend" 			//聊天窗口来源类型，从发送消息传递的to里面获取
						  ,content: list.CONTENT 	//消息内容
						  ,timestamp:list.CTIME
					});
				 });
			}
		}
	});
	
  });
  
  //监听返回
  layim.on('back', function(){
    //如果你只是弹出一个会话界面（不显示主面板），那么可通过监听返回，跳转到上一页面，如：history.back();
  });
  
  //监听发送消息
  layim.on('sendMessage', function(data){
    var To = data.to;		//当前用户资料
    var mine = data.mine; 	//发送者数据(消息内容以及发送者资料)
    /** 
     *	user:发送者用户名
	 *	uname：发送者用户姓名
	 *	To.id：对方用户名
	 *	To.type：消息类型 group or friend
	 *	mine.avatar:发送者用户头像
	 *	mine.content：消息内容
	 */
	 websocket.send(",fhadmin-msg,"+user+",fh,"+uname+",fh,"+To.id+",fh,"+To.type+",fh,"+mine.avatar+",fh,"+mine.content);
  });
  
});
</script>
</body>
</html>
