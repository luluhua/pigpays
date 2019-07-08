<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include  file="../header.jsp"%>
<body>
    <div id="wrapper">
        <div class="gray-bg">
        <div class="wrapper wrapper-content animated fadeInRight">
            <div class="row">
                <div class="col-lg-12">
                <div class="ibox">
                    <div class="ibox-title">
                        <h5>用户管理</h5>
                    </div>
                    <div class="ibox-content">
                     	<div class="table-responsive">
	                     	<div class="search-filter clearfix" style="padding-bottom:10px;">
		                   		<form id="searchForm" class="form-inline pull-left">
		                            <div class="form-group">
		                                <input type="text" placeholder="登录账户" id="username" class="form-control">
		                                <button type="button" class="btn btn-w-m btn-success querySearch"><i class="fa fa-search"></i> 查询</button>
		                            </div>
		                        </form>
	                        <div class="pull-right">
	                        	<button id="addNew" type="button" class="btn btn-w-m btn-primary addNew"><i class="fa fa-plus"></i>添加</button>
	                        </div>
	                   	</div>
                    	<table class="table table-striped table-bordered table-hover dataTables-example" >
		                    <thead>
			                    <tr>
			                        <th>ID</th>
			                        <th>登录账号</th>
			                        <th>手机号码</th>
			                        <th>真实姓名</th>
			                        <th>用户类型</th>
			                        <th>注册时间</th>
			                        <th>注册IP</th>
			                        <th>最近登录时间</th>
			                        <th>最近登录IP</th>
			                        <th>状态</th>
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

    <!-- Page-Level Scripts -->
    <script>
        $(document).ready(function(){
        	var queryData = {};
            var table = $('.dataTables-example').DataTable({
            	language:dt_lang,
                responsive: true,
                processing:true,
                destroy:true,  
            	pageLength:16,
            	pagingType:'full_numbers',
            	dom: 'rtp',
                serverSide: false,
                ajax:{
                		"url":'${rootpath}admin/user/list', "type": "POST", data: queryData
                },
                
                "columns":[
                	{"data": "id"},
                	
                	{"data": "username"},
                	{"data": "mobile", 'render': function(data, type, full, meta ){
                		return data;
                	}},
                	{"data": "realname", 'render': function(data, type, full, meta ){
                		return data;
                	}},
                	{"data": "userType", 'render': function(data, type, full, meta ){
           				if(data == 1) {return "管理用户"}
           				else if(data == 0) {return "系统用户"}
           				else if(data == 2) {return "商户"}
            		}},
            		{"data": "createTime", 'render': function(data, type, full, meta ){
            			return data ? new Date(data).format('yy/MM/dd hh:mm:ss') : "";
                	}},
                	{"data": "createIp", 'render': function(data, type, full, meta ){
                		return data;
                	}},
                	{"data": "lastLoginTime", 'render': function(data, type, full, meta ){
                		return data ? new Date(data).format('yy/MM/dd hh:mm:ss') : "";
                	}},
                	{"data": "lastLoginIp", 'render': function(data, type, full, meta ){
                		return data;
                	}},
                	{"data": "status", 'render': function(data, type, full, meta ){
                			if(data == 0) {return "未激活"}
                			else if(data == 1) {return "正常"}
                			else if(data == -1) {return "已禁用"}
                		}
                	},
                	{"data": "id", 'render': function(data, type, full, meta ){
                		var status = full.status;
                		
                		var links = '<a title="编辑" class="btn-sm btn-warning edit" data-id="'+data+'"> <i class="fa fa-edit"></i></a> ';
                		    if(full.userType != 0) {
                		    	links += '<a title="删除" class="btn-sm btn-danger del" data-id="'+data+'"> <i class="fa fa-trash-o"></i></a> ';
                    		    if(status == 0) {
                    		    }else if(status == 1){
                    		    	links += '<a title="禁用该用户" class="btn-sm btn-info blockstatus" data-status="'+full.status+'" data-id="'+data+'">封禁</a> ';
                    		    }else if(status == -1){
                    		    	links += '<a title="解除封禁" class="btn-sm btn-info unblockstatus" data-status="'+full.status+'" data-id="'+data+'">解除封禁</a> ';
                    		    }
                		    }
                		    return links;
	                	}
                	}
            	],
            });
            
            $(".querySearch").on("click", function(){
            	queryData = {
            			username: $("#username").val(),
            			status: $("#status").val(),
            	};
            	table.settings()[0].ajax.data=queryData;  
                table.ajax.reload();
            });
            
            
            $(document).on("click", ".edit", function(){
            	var id = $(this).attr("data-id");
            	parent.layer.open({
					title : '修改用户',
					type : 2,
					area : [ '800px', '600px' ],
					fixed : false, //不固定
					maxmin : false,
					content : basePath + 'admin/user/update?id=' + id,
					success : function(index) {
					},
					end: function(){
						table.ajax.reload();
					}
				});
            });
            
            $(document).on("click", ".del", function(){
            	var id = $(this).attr("data-id");
				parent.layer.confirm('你确定要删除用户吗?', {icon: 2, title:'系统警告'}, function(index){
					$.post(basePath+"admin/user/delete", {id: id}, function(res){
						if (res.code == "00") {
							table.ajax.reload();
						}
						parent.layer.msg(res.msg);
						parent.layer.close(index);
						
					}, "json")
				});
            });
            
            $(document).on("click", ".blockstatus", function(){
            	var id = $(this).attr("data-id");
            	var status = $(this).attr("data-status");
            	var newStatus = -1;
            	var statusText = "你确定要禁用该用户吗";
            	changeStatus(id, statusText, newStatus);
            });
            
            $(document).on("click", ".unblockstatus", function(){
            	var id = $(this).attr("data-id");
            	var status = $(this).attr("data-status");
            	var newStatus = 1;
            	var statusText = "你确定解除封禁吗";
            	changeStatus(id, statusText, newStatus);
            });
            
            function changeStatus(id, text, newStatus) {
            	parent.layer.confirm(text, {icon: 2, title:'系统警告'}, function(index){
					$.post(basePath+"admin/user/updateStatus", {id: id, status: newStatus}, function(res){
						if (res.code == "00") {
							table.ajax.reload();
						}
						parent.layer.msg(res.msg);
						parent.layer.close(index);
						
					}, "json")
				});
            }
            
            
            $(".addNew").click(function(e){
				if (e && e.preventDefault) {
					e.preventDefault();
				} else {
					window.event.returnValue = false;
				}
				
				parent.layer.open({
					title : '新增用户',
					type : 2,
					area : [ '800px', '600px' ],
					fixed : false, //不固定
					maxmin : false,
					content : basePath + 'admin/user/add',
					success : function(index) {
						
					},
					end: function(){
						table.ajax.reload();
					}
				});
			});
            
        });

    </script>

</body>
</html>