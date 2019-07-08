<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include  file="../header.jsp"%>
<body>
    <div id="wrapper">
        <div class="gray-bg">
        <div class="wrapper wrapper-content animated fadeInRight">
            <div class="row">
                <div class="col-lg-12">
                <div class="ibox">
                    <div class="ibox-title">
                        <h5>账户管理</h5>
                    </div>
                    <div class="ibox-content">
                     	<div class="table-responsive">
	                     	<div class="search-filter clearfix" style="padding-bottom:10px;">
		                   		<form id="searchForm" class="form-inline pull-left">
		                            <div class="form-group">
		                                <input type="text" placeholder="账号、备注" id="name" class="form-control">
		                                <select id="status" class="form-control">
		                                	<option value="">状态(全部)</option>
		                                	<option value="1">正常收款</option>
		                                	<option value="2">暂停收款</option>
		                                	<option value="0">已停用</option>
		                                	<option value="-1">已下线</option>
		                                </select>
		                                <button type="button" class="btn btn-w-m btn-success querySearch"><i class="fa fa-search"></i> 查询</button>
		                            </div>
		                        </form>
	                        <div class="pull-right">
	                        	<button id="addNew" type="button" class="btn btn-w-m btn-primary addNew"><i class="fa fa-plus"></i>添加</button>
	                        </div>
	                   	</div>
	                   	
                    	<table class="table table-striped table-bordered table-hover dataTables-example" >
		                    <thead>
			                    <tr><!-- 
			                    	<th style="width:30px;"><input id="checkAll" type="checkbox"/></th> 
			                    	<th>编号</th> -->
			                        <th style="width:100px;">客户端账户</th>
			                        <th style="width:100px;">
			                        	最近分配时间
			                        </th>
			                        <th style="width:100px;">
			                        	最近收款时间
			                        </th>
			                        <th>收款账号</th>
			                        <th>备注</th>
			                        <th style="width:100px;">登录状态</th>
			                        <th style="width:40px;">状态</th>
			                        <th style="width:120px;">操作</th>
			                    </tr>
		                    </thead>
		                    <tbody></tbody>
		                </table>
                    </div>
                    </div>
                </div>
            </div>
            </div>
        </div>
        

        </div>
        </div>



<%@ include  file="../scripts.jsp"%>
<script type="text/javascript">
Date.prototype.pattern=function(fmt) {         
    var o = {         
    "M+" : this.getMonth()+1, //月份         
    "d+" : this.getDate(), //日         
    "h+" : this.getHours()%12 == 0 ? 12 : this.getHours()%12, //小时         
    "H+" : this.getHours(), //小时         
    "m+" : this.getMinutes(), //分         
    "s+" : this.getSeconds(), //秒         
    "q+" : Math.floor((this.getMonth()+3)/3), //季度         
    "S" : this.getMilliseconds() //毫秒         
    };         
    var week = {         
    "0" : "/u65e5",         
    "1" : "/u4e00",         
    "2" : "/u4e8c",         
    "3" : "/u4e09",         
    "4" : "/u56db",         
    "5" : "/u4e94",         
    "6" : "/u516d"        
    };
    if(/(y+)/.test(fmt)){         
        fmt=fmt.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length));         
    }         
    if(/(E+)/.test(fmt)){         
        fmt=fmt.replace(RegExp.$1, ((RegExp.$1.length>1) ? (RegExp.$1.length>2 ? "/u661f/u671f" : "/u5468") : "")+week[this.getDay()+""]);         
    }         
    for(var k in o){         
        if(new RegExp("("+ k +")").test(fmt)){         
            fmt = fmt.replace(RegExp.$1, (RegExp.$1.length==1) ? (o[k]) : (("00"+ o[k]).substr((""+ o[k]).length)));         
        }         
    }         
    return fmt;         
}  
</script>
    <!-- Page-Level Scripts -->
    <script>
    	var table;
        $(document).ready(function(){
        	var queryData = {
        			name: $("#name").val(),
        			status: $('#status').val(),
        		};
            table = $('.dataTables-example').DataTable({
            	language:dt_lang,
                responsive: true,
                processing:true,
                destroy:true,  
            	pageLength:30,
            	pagingType:'full_numbers',
            	dom: 'rtp',
            	serverSide: true,
                bStateSave: false,
                ajax:{
                		"url":'${rootpath}admin/collect_account/list', "type": "POST", data: queryData
                },
                "aoColumnDefs": [ { "bSortable": false, "aTargets": [ 0] }],
                "aaSorting": [[ 1, "desc" ]],
                "columns":[
                	/*
                	{"data": "id", 'render': function(data, type, full, meta ){
                		return '<input type="checkbox" name="chk" resId="'+data+'" />';
                	}},
                	{"data": "id"},*/
                	{"data": "name"},
                	//{"data": "totalAmount"},
                	{"data": "lastDipatchTime", "render": function(data, type, full, meta ){
                		return data != null && data > 0? new Date(data).format('yyyy-MM-dd hh:mm:ss') : '';
                	}},
                	{"data": "lastCollectTime", "render": function(data, type, full, meta ){
                		return data != null && data > 0? new Date(data).format('yyyy-MM-dd hh:mm:ss') : '';
                	}},
                	
                	{"data": "id", "render": function(data, type, full, meta ){
                		var html = [];
                		var wximg = '<img style="width:22px;border-radius:11px;" src="'+basePath+'assets/images/weipay.png"/> ';
                		var alimg = '<img style="width:22px;border-radius:11px;" src="'+basePath+'assets/images/alipay1.png" /> ';
                		var paymethodList = full['channels'];
                		for(var i = 0; i < paymethodList.length; i++) {
                			var paymethod = paymethodList[i];
                			var disableHtml = '<i onclick="enablePaymethod('+paymethod.id+')" title="开启" style="color:#f10215;position: relative;font-size:24px;top:6px;margin-right:6px;" class="fa fa-minus-circle"></i> ';
                    		var enabledHtml = '<i onclick="disablePaymethod('+paymethod.id+')" title="关闭" style="color:#00C800;position: relative;font-size:24px;top:6px;margin-right:6px;" class="fa fa-circle"></i> ';
                			
                			if(paymethod.payType == '10') {
                				html.push("<div class=\"account-wrap\">");
                				html.push((paymethod.status==1?enabledHtml:disableHtml));
                				html.push(wximg);
                				html.push(paymethod.channelAccount);
                				html.push(' <i style="margin-left:10px;" onclick="editWeixin('+paymethod.id+')" class="fa fa-edit"></i>');
                				html.push("</div>");
                			}else if(paymethod.payType == '12') {
                				html.push("<div class=\"account-wrap\">");
                				html.push((paymethod.status==1?enabledHtml:disableHtml));
                				html.push(alimg);
                				html.push(paymethod.channelAccount);
                				html.push(' <i style="margin-left:10px;" onclick="editAlipay('+paymethod.id+')" class="fa fa-edit"></i>');
                				html.push("</div>");
                			}
                		}
                		return html.join('');
                	}},
                	{"data": "remark", "render": function(data, type, full, meta){
                		var html = [];
                		if(full['remark']) {
                			html.push('<div class="remark-wrap">' + full['remark'] + ' <i onclick="editRemark('+full['id']+')" class="fa fa-edit"></i></div>');
                		}else {
                			html.push('<div>未设置<i onclick="editRemark('+full['id']+')" class="fa fa-edit"></i></div>');
                		}
                		return html.join('');
                	}},
                	{"data": "loginStatus", "render": function(data, type, full, meta){
                		var html = [];
                		var logintime = full['lastLoginTime'];
                		var activeTime  = full['lastHeartBeat'];
                		var offlineTime = full['offlineTime'];
                		html.push((data== 1 ? "在线" : "下线"));
                		html.push("<br/>");
                		if(data == 1) {
                			html.push(( logintime!= null && logintime > 0? new Date(logintime).format('yyyy-MM-dd hh:mm:ss') : ''));
                			html.push("<br/>");
                			html.push(( activeTime!= null && activeTime > 0? new Date(activeTime*1000).format('yyyy-MM-dd hh:mm:ss') : ''));
                			html.push("<br/>");
                			html.push("<a onclick='logout(" + full.id + ")'>强制退出</a>");
                		}else {
                			html.push(( offlineTime!= null && offlineTime > 0? new Date(offlineTime).format('yyyy-MM-dd hh:mm:ss') : ''));
                		}
                		
                		return html.join('');
                	}},
                	{"data": "status", "render": function(data, type, full, meta ){
                		if(data == '1') {
                			return "正常收款";
                		}else if(data == '0') {
                			return "暂停收款"
                		}else if(data == '-1'){
                			return "已禁用";
                		}
                	}},
                	{"data": "id", 'render': function(data, type, full, meta ){
                		var links = '';
                			links += '<a title="编辑" class="btn-sm btn-warning edit" data-id="'+data+'"> <i class="fa fa-edit"></i></a> ';
                		    links += '<a title="删除" class="btn-sm btn-danger del" data-id="'+data+'"> <i class="fa fa-trash-o"></i></a> ';
                		    links += '<a title="二维码管理" class="btn-sm btn-info qrcodeList" data-id="'+data+'"> <i class="fa fa-qrcode"></i></a> ';
                		    links += '<a title="通道设置" class="btn-sm btn-primary channelSetting" data-id="'+data+'"> <i class="fa fa-gear"></i></a> ';
                		    return links;
	                	}
                	}
            	],
            });
                        
           
            
            $(".querySearch").on("click", function(){
            	queryData = {
            			name: $("#name").val(),
            			status: $('#status').val(),
            	};
            	table.settings()[0].ajax.data=queryData;  
                table.ajax.reload();
            });
            
            $('#name').keydown(function(event){ 
				if(event.keyCode==13){ 
					$(".querySearch").click(); 
					return false;
				}
			});
            
            
            
            $(document).on("click", ".edit", function(){
            	var id = $(this).attr("data-id");
            	parent.layer.open({
					title : '修改账号',
					type : 2,
					area : [ '800px', '560px' ],
					fixed : false, //不固定
					maxmin : false,
					content : basePath + 'admin/collect_account/update?id=' + id,
					success : function(index) {
					},
					end: function () {
						table.ajax.reload(null, false);
		            }
				});
            });
            
            $(document).on("click", ".del", function(){
            	var id = $(this).attr("data-id");
				parent.layer.confirm('你确定要删除吗?', {icon: 2, title:'系统警告'}, function(index){
					$.post(basePath+"admin/collect_account/delete", {id: id}, function(res){
						if (res.code == "00") {
							table.ajax.reload(null, false);
						}
						parent.layer.msg(res.msg);
						parent.layer.close(index);
					}, "json")
				});
            });
            
            
            $(document).on("click", ".upstatus", function(){
            	var id = $(this).attr("data-id");
				parent.layer.confirm('你确定要启用吗?', {icon: 2, title:'系统警告'}, function(index){
					$.post(basePath+"admin/collect_account/updateStatus", {id: id, status: 1}, function(res){
						if (res.code == "00") {
							table.ajax.reload(null, false);
						}
						if (res.code == "999") {
							parent.layer.msg(res.msg);
						}
						parent.layer.msg(res.msg);
						parent.layer.close(index);
					}, "json")
				});
            });
            
            
            $(".addNew").click(function(e){
				if (e && e.preventDefault) {
					e.preventDefault();
				} else {
					window.event.returnValue = false;
				}
				
				
				parent.layer.open({
					title : '添加账号',
					type : 2,
					area : [ '800px', '500px' ],
					fixed : false, //不固定
					maxmin : false,
					content : basePath + 'admin/collect_account/add',
					success : function(index) {
						
					},
					end: function () {
						table.ajax.reload(null, false);
		            }
				});
			});
            
            
            $(document).on("click", ".qrcodeList",function(){
            	var accountId = $(this).attr("data-id");
            	window.location.href = basePath+"admin/collect_qrcode/list?accountId=" + accountId;
            });
            
            $(document).on("click", ".channelSetting", function(e){
            	if (e && e.preventDefault) {
					e.preventDefault();
				} else {
					window.event.returnValue = false;
				}
            	var accountId = $(this).attr("data-id");
            	parent.layer.open({
					title : '通道设置',
					type : 2,
					area : [ '800px', '360px' ],
					fixed : false, //不固定
					maxmin : false,
					content : basePath + 'admin/collect_account/channelSetting?id=' + accountId,
					success : function(index) {
						
					},
					end: function () {
						table.ajax.reload(null, false);
		            }
				});
            });
            
            
            var timer = setInterval(function(){
            	table.ajax.reload(null, false);
            }, 30000);
            
            
        });
        
        
        function editRemark (id) {
        	parent.layer.open({
				title : '',
				type : 2,
				area : [ '360px', '180px' ],
				fixed : false, //不固定
				maxmin : false,
				content : basePath + 'admin/collect_account/editInfo?field=remark&id='+id,
				success : function(index) {
					
				},
				end: function(){
					table.ajax.reload();
				}
			});
        }
        
        function editWeixin(id) {
        	parent.layer.open({
				title : '',
				type : 2,
				area : [ '360px', '180px' ],
				fixed : false, //不固定
				maxmin : false,
				content : basePath + 'admin/collect_account/editAccount?id='+id,
				success : function(index) {
					
				},
				end: function(){
					table.ajax.reload();
				}
			});
        }
        function editAlipay(id) {
        	parent.layer.open({
				title : '',
				type : 2,
				area : [ '360px', '180px' ],
				fixed : false, //不固定
				maxmin : false,
				content : basePath + 'admin/collect_account/editAccount?id='+id,
				success : function(index) {
					
				},
				end: function(){
					table.ajax.reload();
				}
			});
        }
        
        function enablePaymethod(id) {
        	$.post(basePath+"admin/collect_account/changePaymethodStatus", {id: id, status: 1}, function(res){
				if (res.code == "00") {
					table.ajax.reload();
				}
				if (res.code == "999") {
					parent.layer.msg(res.msg);
				}
			}, "json")
        }
        
        function disablePaymethod(id) {
        	$.post(basePath+"admin/collect_account/changePaymethodStatus", {id: id, status: 0}, function(res){
				if (res.code == "00") {
					table.ajax.reload();
				}
			}, "json")
        }
        
        function logout(id) {
        	$.post(basePath+"admin/collect_account/logout", {id: id}, function(res){
				if (res.code == "00") {
					parent.layer.msg(res.msg);
					table.ajax.reload();
				}
			}, "json")
        }

    </script>

	

</body>
</html>