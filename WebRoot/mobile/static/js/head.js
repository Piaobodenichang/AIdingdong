
var fwebsocket;			//websocket对象
var user = "FH";		//用于即时通讯（ 当前登录用户）
var NAME = "";			//姓名
var TFHsmsSound = '1';	//站内信提示音效
var fhsmsCount = 0;		//站内信未读数量
var oladress="";		//在线管理和站内信服务器IP和端口
var userPhoto="";		//用户头像

//基本信息
window.onload=function(){
    $.ajax({
    	type: "POST",
    	url: locat+'mobilehead/getNowUser.do?tm='+new Date().getTime(),
    	data: encodeURI(""),
    	dataType:'json',
    	cache: false,
    	success: function(data){
    			user = data.user.USERNAME;					//用户名
    			TFHsmsSound = data.FHsmsSound;				//站内信提示音效
    			fhsmsCount = data.fhsmsCount;				//站内信未读数量
    			oladress = data.oladress;					//在线管理和站内信服务器IP和端口
    			userPhoto = data.userPhoto;					//用户头像
    			NAME = data.user.NAME;						//姓名
    			online();
    			fhonload();
    	}
    });
};

//加入在线列表
function online(){
	if (window.WebSocket) {
		fwebsocket = new WebSocket(encodeURI('ws://'+oladress)); //oladress在main.jsp页面定义
		fwebsocket.onopen = function() {
			//连接成功
			fwebsocket.send('[join]mobile-'+user);
		};
		fwebsocket.onerror = function() {
			//连接失败
		};
		fwebsocket.onclose = function() {
			//连接断开
		};
		//消息接收
		fwebsocket.onmessage = function(message) {
			var message = JSON.parse(message.data);
			if(message.type == 'goOut'){
				$("body").html("");
				goOut("1");
			}else if(message.type == 'thegoout'){
				$("body").html("");
				goOut("2");
			}else if(message.type == 'senFhsms'){
				fhsmsCount = Number(fhsmsCount)+1;
				$("#fhsmsCount").html(Number(fhsmsCount));
				$("#fhsmsobj").html('<audio style="display: none;" id="fhsmstsy" src="static/sound/'+TFHsmsSound+'.mp3" autoplay controls></audio>');
				$("#fhsmstss").tips({
					side:1,
		            msg:'您有新消息',
		            bg:'#AE81FF',
		            time:3
		        });
				setTimeout("tofhsms()",3000);
			}else if(message.type == 'fhtask'){
				if(message.RNUMBER == 'no'){
					$("#fhsmsobj").html('<audio style="display: none;" id="fhsmstsy" src="static/sound/'+TFHsmsSound+'.mp3" autoplay controls></audio>');
					$("#taskCount").tips({
						side:1,
			            msg:'您有新任务',
			            bg:'#AE81FF',
			            time:3
			        });
					setTimeout("toTask()",3000);
				}else{
					$.ajax({
						type: "POST",
						url: locat+'mobilehead/isNowRole.do',
				    	data: {RNUMBER:message.RNUMBER,tm:new Date().getTime()},
						dataType:'json',
						cache: false,
						success: function(data){
							 if('yes' == data.msg){
								$("#fhsmsobj").html('<audio style="display: none;" id="fhsmstsy" src="static/sound/'+TFHsmsSound+'.mp3" autoplay controls></audio>');
								$("#taskCount").tips({
									side:1,
						            msg:'您有新任务',
						            bg:'#AE81FF',
						            time:3
						        });
								setTimeout("toTask()",3000);
							 }
						}
					});
				}
			}
		};
	}
}

//下线
function goOut(msg){
	alert("被迫下线!");
	window.location.href=locat+"mobile/logout";
}

//去通知收信人有站内信接收
function fhsmsmsg(USERNAME){
	var arrUSERNAME = USERNAME.split(';');
	for(var i=0;i<arrUSERNAME.length;i++){
		fwebsocket.send('[fhsms]'+arrUSERNAME[i]);//发送站内信通知
	}
}

//去通知任务待办人有新任务
function fhtaskmsg(USERNAME){
	fwebsocket.send('[fhtask]'+USERNAME);//发送新任务通知
}

//跳转到站内信收信箱
function tofhsms(){
	window.location.href=locat+"mobilefhsms/list.do?TYPE=1";
}

//跳转到待办任务页面
function toTask(){
	window.location.href=locat+"mobiletask/list";
}
