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
			                        <th>账号</th>
			                        <th>邮箱</th>
			                        <th>手机号码</th>
			                        <th>推荐人</th>
			                        <th>二维码(已创建/上限)</th>
			                        <th>收款账号(已创建/上限)</th>
			                        <th>添加时间</th>
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
                		"url":'${rootpath}admin/user/list?userType=3', "type": "POST", data: queryData
                },
                
                "columns":[
                	{"data": "id"},
                	{"data": "username", 'render': function(data, type, full, meta){
                		return data;
                	}},
                	{"data": "email"},
                	{"data": "mobile"},
                	{"data": "agentName"},
                	{"data": "qrcodeCount", 'render': function(data, type, full, meta ){
                		var html = [];
                		html.push("<span style=\"font-weight:bold;\">" + data +"</span>");
                		html.push("<span style=\"font-weight:bold;\">/</span>");
                		html.push("<span style=\"font-weight:bold;\">" + full['qrcodeCountLimit']+"</span>");
                		return html.join('');
                	}},
                	{"data": "acctCount", 'render': function(data, type, full, meta ){
                		var html = [];
                		html.push("<span style=\"font-weight:bold;\">" + data +"</span>");
                		html.push("<span style=\"font-weight:bold;\">/</span>");
                		html.push("<span style=\"font-weight:bold;\">" + full['acctCountLimit']+"</span>");
                		return html.join('');
                	}},
                	{"data": "createTime", 'render': function(data, type, full, meta ){
                		return new Date(data).format('yyyy-MM-dd hh:mm:ss');
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
					title : '修改号商',
					type : 2,
					area : [ '800px', '600px' ],
					fixed : false, //不固定
					maxmin : false,
					content : basePath + 'admin/user/updateprovider?id=' + id,
					success : function(index) {
					},
					end: function(){
						table.ajax.reload();
					}
				});
            });
            
            $(document).on("click", ".del", function(){
            	var id = $(this).attr("data-id");
				parent.layer.confirm('你确定要删除号商吗?', {icon: 2, title:'系统警告'}, function(index){
					$.post(basePath+"admin/user/delete", {id: id}, function(res){
						if (res.code == "00") {
							table.ajax.reload();
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
					title : '新增用户',
					type : 2,
					area : [ '800px', '600px' ],
					fixed : false, //不固定
					maxmin : false,
					content : basePath + 'admin/merchant/addprovider',
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