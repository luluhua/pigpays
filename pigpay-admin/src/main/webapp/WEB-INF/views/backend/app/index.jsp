<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include  file="../header.jsp"%>
<head>	
<style>
        .table th{
            text-align:center;
        }
  
    </style>
</head>
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
		                                <input type="text" placeholder="版本号" id="version" class="form-control">
		                                <button type="button" class="btn btn-w-m btn-success querySearch"><i class="fa fa-search"></i> 查询</button>
		                            </div>
		                        </form>
	                        <div class="pull-right">
	                        	<button id="addNew" type="button" class="btn btn-w-m btn-primary addedition"><i class="fa fa-plus"></i>添加</button>
	                        </div>
	                   	</div>
                    	<table class="table table-striped table-bordered table-hover dataTables-example" >
		                    <thead>
			                    <tr>
			                        <th style="width:10px;">ID</th>
			                        <th>标题</th>
			                        <th>版本号</th>
			                        <th>下载地址</th>
			                        <th>升级说明</th>
			                        <th>下载次数</th>
			                        <th>安装次数</th>
			                        <th>是否强制安装</th>
			                        <th>创建时间</th>
			                        <th>发布状态</th>
			                        <th style="width:120px;">发布时间</th>
			                        <th >发布人</th>
			                        <th style="width:120px;">操作</th>
			                    </tr>
			                    </tr>
		                    </thead>
		                    <tbody ></tbody>
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
                		"url":'${rootpath}admin/app/list', "type": "POST", data: queryData
                },
                
                "columns":[
                	{"data": "id"},
                  	{"data": "title", 'render': function(data, type, full, meta ){
                		return data;
                	}},
                  	{"data": "version", 'render': function(data, type, full, meta ){
                		return data;
                	}},
                  	{"data": "url", 'render': function(data, type, full, meta ){
                		return data;
                	}},
                 	{"data": "info", 'render': function(data, type, full, meta ){
                		return data;
                	}},
                 	{"data": "downCount", 'render': function(data, type, full, meta ){
                		return data;
                	}},
                	{"data": "installCount", 'render': function(data, type, full, meta ){
                		return data;
                	}},
                	{"data": "forceInstall", 'render': function(data, type, full, meta ){
                		if(data == false) {return "否"}
           				else if(data == true) {return "是"}
                	}},
                	{"data": "createTime", 'render': function(data, type, full, meta ){
                		return new Date(data).format('yyyy-MM-dd hh:mm:ss');
                	}},
                	{"data": "pubStatus", 'render': function(data, type, full, meta ){
                		
                		if(data == false) {return "未发布"}
           				else if(data == true) {return "已发布"
           				}
                		
                	}},
                	{"data": "pubTime", 'render': function(data, type, full, meta ){
                		if(data == null || data == ""){
                			return data;
                		
                		}else{
                			return new Date(data).format('yyyy-MM-dd hh:mm:ss');
                		}
                	}},
                	{"data": "pubUser", 'render': function(data, type, full, meta ){
                		return data;
                	}},

                	{"data": "id", 'render': function(data, type, full, meta ){
                		var status = full.status;
                		var links = '<a title="编辑" class="btn-sm btn-warning edit" data-id="'+data+'"> <i class="fa fa-edit"></i></a> ';
                		    links += '<a title="删除" class="btn-sm btn-danger del" data-id="'+data+'"> <i class="fa fa-trash-o"></i></a> ';
                		   /*  links += '<a title="详细信息" class="btn-sm btn-primary detail" data-id="'+data+'"> <i class="fa fa-file"></i></a> '; */
                		    links += '<a title="发布版本" class="btn-sm btn-info issue" data-status="'+full.status+'" data-id="'+data+'">发布</a> ';
                		
                		    
                		    return links;
	                	}
                	}
            	],
            });
            $(".querySearch").on("click", function(){
            	queryData = { 
            			version:$("#version").val(),
            	 }; 
            	table.settings()[0].ajax.data=queryData;  
                table.ajax.reload();
               
               
            });
            
            $(".addedition").click(function(e){
				if (e && e.preventDefault) {
					e.preventDefault();
				} else {
					window.event.returnValue = false;
				}
				
				parent.layer.open({
					title : '新增版本',
					type : 2,
					area : [ '800px', '600px' ],
					fixed : false, //不固定
					maxmin : false,
					content : basePath + 'admin/app/add',
					success : function(index) {
						
					},
					end: function(){
						table.ajax.reload();
					}
				});
			});
            $(document).on("click", ".edit", function(){
            	var id = $(this).attr("data-id");
            	parent.layer.open({
					title : '修改信息',
					type : 2,
					area : [ '800px', '600px' ],
					fixed : false, //不固定
					maxmin : false,
					content : basePath + 'admin/app/update?id=' + id,
					success : function(index) {
					},
					end: function(){
						table.ajax.reload();
					}
				});
            });
            $(document).on("click", ".del", function(){
            	var id = $(this).attr("data-id");
				parent.layer.confirm('你确定要删除该版本吗?', {icon: 2, title:'系统警告'}, function(index){
					$.post(basePath+"admin/app/delete", {id: id}, function(res){
						if (res.code == "00") {
							/* parent.refreshCurrentTab(); */
								table.ajax.reload();
							
						}
						parent.layer.msg(res.msg);
						parent.layer.close(index);
						
					}, "json")
				});
            });

            $(document).on("click", ".issue", function(){
            	var id = $(this).attr("data-id");
				parent.layer.confirm('你确定发布该版本吗吗?', {icon: 2, title:'系统警告'}, function(index){
					$.post(basePath+"admin/app/issue", {id: id}, function(res){
						if (res.code == "00") {
							/* parent.refreshCurrentTab(); */
							table.ajax.reload();
						}
						parent.layer.msg(res.msg);
						parent.layer.close(index);
						
					}, "json")
				});
            });

        });
        

            </script>  

</body>
</html>