<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include  file="header.jsp"%>
<!-- 页面加载进度条
<script src="${rootpath }assets/js/plugins/pace/pace.min.js"></script>
 -->
<body class="fixed-sidebar full-height-layout gray-bg" style="overflow:hidden">
<div id="wrapper">
  <!--左侧导航开始-->
  <nav class="navbar-default navbar-static-side" role="navigation">
  <div class="nav-close"><i class="fa fa-times-circle"></i> </div>
  <div class="sidebar-collapse">
  	<div class="sidebar-top">
	  	<a class="navbar-minimalize minimalize-styl-2 btn btn-primary " href="#"><i class="fa fa-bars"></i> </a>
	  	<a class="backstage-logo" onclick="location.replace(location)">
			<img src="${rootpath }resource/bootstrap/images/logo.png"/>
		</a>
	</div>
    <ul class="nav" id="side-menu">
      <li class="nav-header">
        <div class="dropdown profile-element">
        	<span>
                <img alt="image" class="img-circle" src="http://cn.inspinia.cn/html/inspiniaen/img/profile_small.jpg">
            </span>
        	<a data-toggle="dropdown" class="dropdown-toggle" href="#"> 
	        	<span class="clear"> 
	        		<span class="block m-t-xs">
	        			<strong class="font-bold">${user.username}</strong>
	        		</span> 
	        		<span class="text-muted text-xs block">
	                    <span>系统管理员</span><b class="caret"></b>
	                 </span> 
	             </span> 
             </a>
          <ul class="dropdown-menu animated fadeInRight m-t-xs">
            <li><a class="J_menuItem changePassword" href="javascript:void(0);">修改密码</a> </li>
            <li class="divider"></li>
            <li><a class="logout" href="javascript:void(0);">安全退出</a> </li>
          </ul>
        </div>
        <div class="logo-element"> </div>
      </li>
      
       
       <li> 
		    <a href="#"> <i class="fa fa-money"></i> <span class="nav-label">商户管理</span> <span class="fa arrow"></span> </a>
	        <ul class="nav nav-second-level">
	  			<li>  <a href="${rootpath }admin/merchant/list" class="J_menuItem"><strong>商户管理</strong></a></li>
	  			<li>  <a href="${rootpath }admin/merchant/providerlist" class="J_menuItem"><strong>号商管理</strong></a></li>
	  			<li>  <a href="${rootpath }admin/collect_account/list" class="J_menuItem"><strong>收款账户管理</strong></a></li>
	        </ul>
       </li>
	   <li> 
		    <a href="#"> <i class="fa fa-sellsy"></i> <span class="nav-label">交易管理</span> <span class="fa arrow"></span> </a>
	        <ul class="nav nav-second-level">
	  			<li>  <a href="${rootpath }admin/order/list" class="J_menuItem"><strong>交易订单</strong></a></li>
	  			<li>  <a href="${rootpath }admin/recharge/dealList" class="J_menuItem"><strong>充值记录</strong></a></li>
	        </ul>
       </li>
       <li> 
		    <a href="#"> <i class="fa fa-cube"></i> <span class="nav-label">运营数据</span> <span class="fa arrow"></span> </a>
	        <ul class="nav nav-second-level">
	  			<li>  <a href="${rootpath }admin/order/dailyReportByChannel" class="J_menuItem"><strong>渠道日报</strong></a></li>
	  			<li>  <a href="${rootpath }admin/order/totalReportByChannel" class="J_menuItem"><strong>渠道报表</strong></a></li>
	  			<li>  <a href="${rootpath }admin/order/dailyReportByMch" class="J_menuItem"><strong>商户日报</strong></a></li>
	  			<li>  <a href="${rootpath }admin/order/totalReportByMch" class="J_menuItem"><strong>商户报表</strong></a></li>
	        	<li>  <a href="${rootpath }admin/trans/dailyReportByTrans" class="J_menuItem"><strong>交易日报</strong></a></li>
	  			<li>  <a href="${rootpath }admin/trans/totalReportByTrans" class="J_menuItem"><strong>交易报表</strong></a></li>
	        	<li>  <a href="${rootpath }admin/trans/dailyReportByRecharge" class="J_menuItem"><strong>充值日报</strong></a></li>
	  			<li>  <a href="${rootpath }admin/trans/totalReportByRecharge" class="J_menuItem"><strong>充值报表</strong></a></li>
	        </ul>
       </li>
       <li> 
		    <a href="#"> <i class="fa fa-sellsy"></i> <span class="nav-label">客户端管理</span> <span class="fa arrow"></span> </a>
	        <ul class="nav nav-second-level">
	  			<li>  <a href="${rootpath }admin/app/index" class="J_menuItem"><strong>发布管理</strong></a></li>
	  			<li>  <a href="${rootpath }admin/app/download" class="J_menuItem"><strong>客户端下载</strong></a></li>
	        </ul>
       </li>
       <li>
		    <a href="#"> <i class="fa fa-gears"></i> <span class="nav-label">系统管理</span> <span class="fa arrow"></span> </a>
	        <ul class="nav nav-second-level">
	        	<li>  <a href="${rootpath }admin/user/list" class="J_menuItem"><strong>用户管理</strong></a></li>
	  			<li>  <a href="${rootpath }admin/sysconfig/settings" class="J_menuItem"><strong>系统设置</strong></a></li>
	        </ul>
       </li>
    </ul>
  </div>
</nav>

  <!--左侧导航结束-->
  <!--右侧部分开始-->
  <div id="page-wrapper" class="gray-bg dashbard-1">
    <div class="row border-bottom">
      <nav class="navbar navbar-static-top" role="navigation" style="margin-bottom: 0">
        <div class="navbar-header"><a class="navbar-minimalize minimalize-styl-2 btn btn-primary " href="#"><i class="fa fa-bars"></i> </a>
          
        </div>
        <ul class="nav navbar-top-links navbar-right">
            <li>
                <span class="m-r-sm text-muted welcome-message">欢迎使用.</span>
            </li>
            <li>
                <a class="logout" href="javascript:void(0);">
                  <i class="fa fa-sign-out"></i> 安全退出
                </a>
            </li>
        </ul>
      </nav>
    </div>
    <div class="row content-tabs">
      <button class="roll-nav roll-left J_tabLeft"><i class="fa fa-backward"></i> </button>
      <nav class="page-tabs J_menuTabs">
        <div class="page-tabs-content"> <a href="javascript:;" class="active J_menuTab" data-id="${rootpath }admin/index/index">首页</a> </div>
      </nav>
      <button class="roll-nav roll-right J_tabRight"><i class="fa fa-forward"></i> </button>
      <div class="btn-group roll-nav roll-right">
        <button class="dropdown J_tabClose" data-toggle="dropdown">关闭操作<span class="caret"></span> </button>
        <ul role="menu" class="dropdown-menu dropdown-menu-right">
          <li class="J_tabShowActive"><a>定位当前选项卡</a> </li>
          <li class="divider"></li>
          <li class="J_tabCloseAll"><a>关闭全部选项卡</a> </li>
          <li class="J_tabCloseOther"><a>关闭其他选项卡</a> </li>
        </ul>
      </div>
    </div>
    <div class="row J_mainContent" id="content-main">
      <iframe class="J_iframe" src="${rootpath }admin/index/index" name="iframe0" width="100%" height="100%" frameborder="0" data-id="${rootpath }admin/index/index" seamless></iframe>
    </div>
     <div class="footer" style="display: none;">
      <div class="pull-right">&copy; 2017- <a href="#" target="_blank"></a> </div>
    </div>
  </div>
  <!--右侧部分结束-->
</div>
<%@ include  file="scripts.jsp" %>
<script type="text/javascript">
//用户点击退出按钮事件
$(function(){
    $('.logout').click(function(){
         $.ajax({
             type: "POST",
             url: '${rootpath}admin/system/logout',
             dataType: "json",
             success: function(data){
                if(data == "1"){
               	 window.location.href = "${rootpath}";
                }
             }
         });
    });
    
    $(".changePassword").click(function(){
    	parent.layer.open({
			title : '修改密码',
			type : 2,
			area : [ '600px', '400px' ],
			fixed : false, //不固定
			maxmin : false,
			content : basePath + 'admin/system/changePassword',
			success : function(index) {
			}
		});
    });
    
    
});
</script>
</body>
</html>