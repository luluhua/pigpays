<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

 <%
 	String path = request.getContextPath();

 	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
 			+ path + "/";
 	Object version = application.getAttribute("version");
 	if (version == null || "".equals(version)) {
 		application.setAttribute("version", System.currentTimeMillis());
 		version = application.getAttribute("version");
 	}
 	
 	if(path != null && !path.endsWith("/")) {
		path += "/";
	}
	request.setAttribute("rootpath", path);

 	
 %>
<meta http-equiv=content-type content="text/html; charset=UTF-8">
<meta name="renderer" content="webkit">
<meta http-equiv="X-UA-Compatible" content="IE=Edge,chrome=1">
<html>
  <head>
    <title>一闪支付商家管理平台登录</title>
    <meta name="baidu-site-verification" content="51IxM39zI6" />
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="一闪支付后台管理平台登录">
   	<!-- css框架和公共样式 -->
	<link rel="stylesheet" type="text/css" href="${rootpath }resource/bootstrap/css/bootstrap.min.css" />
	<link rel="stylesheet" type="text/css" href="${rootpath }resource/bootstrap/css/bootstrap-responsive.css" />
	<link rel="stylesheet" type="text/css" href="${rootpath }resource/bootstrap/css/style.css?version=<%=version %>" />
	<!-- js框架和公共效果 -->
	<script type="text/javascript" src="${rootpath }resource/bootstrap/js/jquery.min.js"></script>
	<script type="text/javascript" src="${rootpath }resource/bootstrap/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="${rootpath }resource/bootstrap/js/jquery.placeholder.min.js"></script>
	<!-- cookie插件-->
	<script type="text/javascript" src="${rootpath }resource/plug-in/jquery.cookie.js"></script>
	<!-- 注意style必须在菜单拼装完成后导入才会生效 -->
	<script type="text/javascript" src="${rootpath }resource/bootstrap/js/style.js?version=<%=version %>"></script>
	<script type="text/javascript" src="${rootpath }resource/plug-in/MD5.js"></script>

<script type="text/javascript">
if (window != top) top.location.href = location.href;
var basePath = "${rootpath }";
function myReload() {  
	$("#verifyCode").val("");
    document.getElementById("CreateCheckCode").src = document.getElementById("CreateCheckCode").src + "?nocache=" + new Date().getTime();  
} 
function checkUserName(){
	if($("#login_username").val()=='') {
	   $("#userNameInfo").text("请输入帐号");
	   $("#userNameInfo").css("display","block");
	   return false;
	}else{
		 $("#userNameInfo").css("display","none");
	} 
}
function checkPassword(){
	 if($("#password").val()=='') {
		  $("#passwordInfo").text("请输入密码");
		  $("#passwordInfo").css("display","block");
		   return false;
	}else{
		 $("#passwordInfo").css("display","none");
	} 
}
function checkVerifyCode(){
	if($("#verifyCode").val()=='') {
		$("#verifyCodeInfo").text("请输入验证码");
		$("#verifyCodeInfo").css("display","block");
	   return false;
	}else{
		 $("#verifyCodeInfo").css("display","none");
	} 
}
function loadCookie(){
	if($.cookie('account')!=null&&$.cookie('password')!=null){
		$("#login_username").val($.cookie('account'));   
        $("#password").val($.cookie('password'));
	}
}
  //商户登录
  function loginCheck(){
	 // 判断;
	  if($("#login_username").val()=='') {
		   $("#userNameInfo").text("请输入帐号");
		   $("#userNameInfo").css("display","block");
		   return false;
		}else{
			  $("#userNameInfo").css("display","none");
		}
	  if($("#password").val()=='') {
		  $("#passwordInfo").text("请输入密码");
		  $("#passwordInfo").css("display","block");
		   return false;
		}else{
			 $("#passwordInfo").css("display","none");
		}
	   var inputCode = document.getElementById("verifyCode").value.toUpperCase();
		if($("#verifyCode").val()=='') {
			$("#verifyCodeInfo").text("请输入验证码");
			$("#verifyCodeInfo").css("display","block");
		   return false;
		}else{
			$("#verifyCodeInfo").css("display","none");
		}
		var pwd = ""
		if($("#password").val().length==32){
			pwd=$("#password").val();
		}else{
			pwd=hex_md5($("#password").val());
		}
		
		var system = $("select[name=system]").val();
		var loginUrl = "admin/system/login";
		
			   $.ajax({     
			   url:basePath + loginUrl,   
			   data:{    
			           'account':$("#login_username").val(),    
			           'password':pwd,
			           'code':$("#verifyCode").val()
			    },
			    type:'post',    
			    cache:false,    
			    dataType:'json',    
			    success:function(data) {
			    	//登录成功，跳转到主页面
			        if(data.code > 0 ){  
			        	if($("#rememberPassword").prop("checked")){
			        			$.cookie('account', $("#login_username").val(), { expires: 90 }); 
				        		$.cookie('password', pwd, { expires: 90 }); 
			        	}
			        	 window.location="${rootpath }admin/system/main"; 
			        	 
			        }	
			        else{
			        	
			        		if(data.verifyCode == 0){
			        			 $("#verifyCodeInfo").text("验证码错误");
			        			$("#verifyCodeInfo").css("display","block"); 
			        			myReload();
			        		 	return false;
			        		}else{
			        			 $("#userNameInfo").text("账号或密码错误");
			        			 $("#userNameInfo").css("display","block");
			        			 myReload();
				            	return false;
			        		}
				           
			            
			        }    
			     },    
			     error : function() {
			    	 getAlert(1,'系统异常！','');     
					 $("#loginkeng").attr("value","1");
			     }    
		}); 
		
	  
  }

$(function(){
	loadCookie();
	//回车键触发提交帐号登录
	$("#loginForm").keydown(function (event) {  
	    var keycode = event.which;  
	    if (keycode == 13) {  
	    	if( $("#loginkeng").val() == 0){
	    		loginCheck();
	    	}	    	
	    }
	 }); 
	$(document).on("click","#popupMain a",function(){
		$("#loginkeng").attr("value","0");
	});
});

</script>
</head>
<body class="min-w1280" >

<!-- 头部 header -->
<div class="header">
		<!-- 头部logo head-logo -->
		<a href="#" class="head-left"><img src="${rootpath }resource/bootstrap/images/logo.png" class="head-logo img-responsive"/></a>
</div>

<!-- 主体 main -->
<div class="main login carousel slide" id="myCarousel" data-ride="carousel">
	<!-- 轮播（Carousel）指标 -->
	<ol class="carousel-indicators">
		<li data-target="#myCarousel" data-slide-to="0" class="active"></li>
		<li data-target="#myCarousel" data-slide-to="1"></li>
	</ol>   
	<!-- 轮播（Carousel）项目 -->
	<div class="carousel-inner" role="listbox">
		<div class="item active">
			<img src="${rootpath }resource/bootstrap/images/login_banner1.png"/>
		</div>
		<div class="item">
			<img src="${rootpath }resource/bootstrap/images/login_banner2.png"/>
		</div>
	</div>
	<div class="login-w1200">
		<div class="login-dl">	
				
			<!-- 登录页面tad切换效果 -->
			<ul id="myTab" class="nav login-tad">
				<li class="active">
					<a href="#login_tad1" data-toggle="pill">账号登录</a>
				</li>
				<!-- 
				<li>
					<a href="#login_tad2" data-toggle="pill">动态密码登录</a>
				</li>
				 -->
			</ul>
		
		
			
			<div class="tab-content login-main">
				
				<!-- 账号登录 -->
				<div class="tab-pane  fade in active login-gg" id="login_tad1">
					<form id="loginForm" class="form-inline">
						<div class="form-group login-margin">
						    <label class="sr-only" for="login_username">帐号</label>
						    <input type="text" name="" value="" onblur="javascript:checkUserName();" placeholder="帐号" class="form-control login-username gg-input gg-input382" id="login_username" />
						    <div class="login-gs" id="userNameInfo">
			    	
			    			</div>
			    			<div class="login-shadow">
								<img src="${rootpath }resource/bootstrap/images/username.png" alt="">
							</div>
						</div>
						
						<div class="form-group login-margin">
						    <label class="sr-only" for="password">密码</label>
						    <input type="password" name="" value="" onblur="javascript:checkPassword();" onpaste="return false" placeholder="密码" class="form-control login-password gg-input gg-input382" id="password" />
							<div class="login-gs" id="passwordInfo">
			    	
			    			</div>
			    			<div class="login-shadow">
								<img src="${rootpath }resource/bootstrap/images/password.png" alt="">
							</div>
						</div>
		
						<div class="login-margin login-w100 form-group">
							<input type="text" maxlength="4" name="" placeholder="验证码" onblur="javascript:checkVerifyCode();" id="verifyCode" class="form-control gg-input gg-input203"/>
							<a href="javascript:myReload();"><img src="${rootpath }admin/system/verifyCode" class="login-yzm" id="CreateCheckCode"/></a>
							<div class="login-gs" id="verifyCodeInfo">
			    	
			    			</div>
						</div>
		
						<div class="login-w100 clearfix" style="margin-top:20px;">
							<input type="checkbox" class="checkbox" checked="checked" value="0" id="rememberPassword"/>
							<span class="gg-span">记住密码</span>
						</div>
						
						<div class="login-w100">
							<input type="button" name="" onclick="javascript:loginCheck();" value="登 录" class="gg-submit login-tijiao" />
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>
<input type="hidden" value="0" id="loginkeng"/>
<script type="text/javascript">
//bootstrap(Carousel)轮播选项
$(document).ready(function(){ 
	$("#myCarousel").carousel({
		interval: 4000   //时间
	});
});
</script>

<!-- 底部 footer -->
<div class="foot">
	<div class="footer" style="margin-top:30px;">
	<div class="foot-tixshi">为了达到最佳的浏览效果，推荐使用360浏览器，至少采用（1024X768）分辨率<a href="http://chrome.360.cn/" target="_blank" title="点击下载360浏览器">（点击下载）</a></div>
	<!-- 底部版权 foot-copyright -->
	<div class="foot-copyright">&copy;copyright 2017 | 小猪支付 All right reserved .</div>

</div>
</div>
</body>
</html>
