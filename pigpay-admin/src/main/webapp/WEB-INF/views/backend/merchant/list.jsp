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
                        <h5>商户管理</h5>
                    </div>
                    <div class="ibox-content">
                     	<div class="table-responsive">
	                     	<div class="search-filter clearfix" style="padding-bottom:10px;">
		                   		<form id="searchForm" class="form-inline pull-left">
		                            <div class="form-group">
		                                <input type="text" placeholder="商户名称" id="name" class="form-control">
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
			                        <th>商户名称</th>
			                        <th>商户类型</th>
			                        <th>商户号</th>
			                        <th>账户余额</th>
			                        <th>冻结余额</th>
			                        <th>注册时间</th>
			                        <th>状态</th>
			                        <th style="width:200px;">操作</th>
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
                serverSide: true,
                ajax:{
                		"url":'${rootpath}admin/merchant/list', "type": "POST", data: queryData
                },
                
                "columns":[
                	{"data": "mch_name"},
                	{"data": "mch_type", 'render': function(data, type, full, meta ){
                		return data == 1 ? '普通商户' : "特约商户";
                	}},
                	{"data": "mch_no"},
                	{"data": "balance", 'render': function(data, type, full, meta ){
                		return data;
                	}},
                	{"data": "frozen_balance", 'render': function(data, type, full, meta ){
                		return data;
                	}},
                	{"data": "create_time", 'render': function(data, type, full, meta ){
                		return new Date(data).format('yyyy-MM-dd hh:mm:ss');
                	}},
                	
                	{"data": "status", 'render': function(data, type, full, meta ){
                			if(data == 1) {return "正常"}
                			else if(data == 0) {return "审核中"}
                			else if(data == -1) {return "已封禁"}
                			else if(data == 2) {return "已拒绝"}
                		}
                	},
                	{"data": "id", 'render': function(data, type, full, meta ){
                		var status = full.status;
                		var links = '<a title="编辑" class="btn-sm btn-warning edit" data-id="'+data+'"> <i class="fa fa-edit"></i></a> ';
                		    links += '<a title="删除" class="btn-sm btn-danger del" data-id="'+data+'"> <i class="fa fa-trash-o"></i></a> ';
                		    links += '<a title="详细信息" class="btn-sm btn-primary detail" data-id="'+data+'"> <i class="fa fa-file"></i></a> ';
                		    if(status == 0) {
                		    	links += '<a title="审核通过" class="btn-sm btn-info passstatus" data-status="'+full.status+'" data-id="'+data+'"> 通过</a> ';
                		    	links += '<a title="审核不通过" class="btn-sm btn-info notpassstatus" data-status="'+full.status+'" data-id="'+data+'">拒绝</a> ';
                		    }else if(status == 1){
                		    	links += '<a title="封禁该商户" class="btn-sm btn-info blockstatus" data-status="'+full.status+'" data-id="'+data+'">封禁</a> ';
                		    }else if(status == 2){
                		    	
                		    }else if(status == -1){
                		    	links += '<a title="解除封禁" class="btn-sm btn-info unblockstatus" data-status="'+full.status+'" data-id="'+data+'">解除封禁</a> ';
                		    }
                		    return links;
	                	}
                	}
            	],
            });
            
            $(".querySearch").on("click", function(){
            	queryData = {
            			name: $("#name").val(),
            			status: $("#status").val(),
            	};
            	table.settings()[0].ajax.data=queryData;  
                table.ajax.reload();
            });
            
            
            $(document).on("click", ".edit", function(){
            	var id = $(this).attr("data-id");
            	parent.layer.open({
					title : '修改商户',
					type : 2,
					area : [ '800px', '600px' ],
					fixed : false, //不固定
					maxmin : false,
					content : basePath + 'admin/merchant/update?id=' + id,
					success : function(index) {
					}
				});
            });
            
            $(document).on("click", ".del", function(){
            	var id = $(this).attr("data-id");
				parent.layer.confirm('你确定要删除商户吗?', {icon: 2, title:'系统警告'}, function(index){
					$.post(basePath+"admin/merchant/delete", {id: id}, function(res){
						if (res.code == "00") {
							parent.refreshCurrentTab();
						}
						parent.layer.msg(res.msg);
						parent.layer.close(index);
						
					}, "json")
				});
            });
            
            $(document).on("click", ".detail", function(){
            	var id = $(this).attr("data-id");
            	parent.layer.open({
            		title : false,
					type : 2,
					area : [ '800px', '600px' ],
					fixed : false, //不固定
					maxmin : false,
					content : basePath + 'admin/merchant/detail?id=' + id,
					success : function(index) {
					}
				});
            });
            
            $(document).on("click", ".blockstatus", function(){
            	var id = $(this).attr("data-id");
            	var status = $(this).attr("data-status");
            	var newStatus = -1;
            	var statusText = "你确定要禁用商户吗";
            	changeStatus(id, statusText, newStatus);
            });
            
            $(document).on("click", ".passstatus", function(){
            	var id = $(this).attr("data-id");
            	var status = $(this).attr("data-status");
            	var newStatus = 1;
            	var statusText = "你确定审核通过商户吗";
            	changeStatus(id, statusText, newStatus);
            });
            
            $(document).on("click", ".notpassstatus", function(){
            	var id = $(this).attr("data-id");
            	var status = $(this).attr("data-status");
            	var newStatus = 2;
            	var statusText = "你确定审核拒绝商户吗";
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
					$.post(basePath+"admin/merchant/updateStatus", {id: id, status: newStatus}, function(res){
						if (res.code == "00") {
							parent.refreshCurrentTab();
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
					title : '新增商户',
					type : 2,
					area : [ '800px', '600px' ],
					fixed : false, //不固定
					maxmin : false,
					content : basePath + 'admin/merchant/add',
					success : function(index) {
						
					}
				});
			});
            
        });

    </script>

</body>
</html>