<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include  file="../header.jsp"%>
<body class="gray-bg full-height-layout ">
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
                     	<div id="search-filter" class="search-filter clearfix" style="padding-bottom:10px;">
		                   		<form id="searchForm" class="form-inline pull-right">
		                            <div class="form-group">
		                                <input type="text" placeholder="商户名称" id="name" class="form-control">
		                                <button type="button" class="btn btn-w-m btn-success querySearch"><i class="fa fa-search"></i> 查询</button>
		                            </div>
		                        </form>
	                   	</div>
	                   	
                    	<table id="bttable" class="table table-striped table-bordered table-hover dataTables-example">
		                </table>
                    </div>
                </div>
            </div>
            </div>
        </div>
        

        </div>
        </div>



<%@ include  file="../scripts.jsp"%>
	<script>
		$(document).ready(function() {
			var $table = $('#bttable');
			$table.bootstrapTable('destroy').bootstrapTable({
				columns : [ {
					field : 'mchName',
					title : '商户名称',
					sortable : true,
				}, {
					field : 'mchNo',
					title : '商户号',
					sortable : true
				}, {
					field : 'balance',
					title : '账户余额',
					sortable : true,
					formatter: function(data) {
						return data/100.0;
					}
				}, {
					field : 'createTime',
					title : '注册时间',
					sortable : true,
					formatter: function(data, row) {
						return new Date(data).format('yyyy-MM-dd hh:mm:ss');
					}
				}, {
					field : 'status',
					title : '状态',
					sortable : true,
					formatter: function(data) {
						if(data == 1) {return "正常"}
            			else if(data == 0) {return "审核中"}
            			else if(data == -1) {return "已封禁"}
            			else if(data == 2) {return "已拒绝"}
					}
				}, {
					field : 'id',
					title : '操作',
					width:'120px',
					cellStyle: function (value, row, index, field) {
						  return {
						    classes: 'text-nowrap',
						  };
					},
					formatter: function(data, row) {
						var status = row.status;
                		var links = '<a title="编辑" class="btn-sm btn-warning edit" data-id="'+data+'"> <i class="fa fa-edit"></i></a> ';
                		    links += '<a title="删除" class="btn-sm btn-danger del" data-id="'+data+'"> <i class="fa fa-trash-o"></i></a> ';
                		    links += '<a title="详细信息" class="btn-sm btn-primary detail" data-id="'+data+'"> <i class="fa fa-file"></i></a> ';
                		    if(status == 0) {
                		    	links += '<a title="审核通过" class="btn-sm btn-info passstatus" data-status="'+status+'" data-id="'+data+'"> 通过</a> ';
                		    	links += '<a title="审核不通过" class="btn-sm btn-info notpassstatus" data-status="'+status+'" data-id="'+data+'">拒绝</a> ';
                		    }else if(status == 1){
                		    	links += '<a title="封禁该商户" class="btn-sm btn-info blockstatus" data-status="'+status+'" data-id="'+data+'">封禁</a> ';
                		    }else if(status == 2){
                		    	
                		    }else if(status == -1){
                		    	links += '<a title="解除封禁" class="btn-sm btn-info unblockstatus" data-status="'+status+'" data-id="'+data+'">解除封禁</a> ';
                		    }
                		    return links;
                		    
					}
				} ],
				toolbar : "#search-filter",
				//search:true,
				striped: true, 
				showColumns: true,
				minimumCountColumns: 2,
				//showFullscreen:true,
				showRefresh: true, 
				pagination: true,
				sidePagination: "server",
				pageNumber: 1,
				pageSize: 15,  
		        pageNumber: 1,  
		        pageList: "[10, 25, 50, 100, All]", 
		        url : '${rootpath}admin/merchant/list',
		        method: 'POST',
		        contentType: 'application/x-www-form-urlencoded',
				data : {},
				queryParamsType: 'limit',
				/*
				 请求服务器数据时，你可以通过重写参数的方式添加一些额外的参数，例如 toolbar 中的参数 
				 如果 queryParamsType = 'limit' ,返回参数必须包含
				limit, offset, search, sort, order.
				否则, 需要包含: 
				pageSize, pageNumber, searchText, sortName, sortOrder. 
				返回false将会终止请求。
				*/
				queryParams: function (params) {//设置查询参数  
					
		              var param = {    
						  limit: params.limit,    
						  offset: params.offset,  
						  order: params.order,
						  sort: params.sort,
		                  name : $("#name").val()  // 自定义查询参数
		              };
		              return param;   
		              
		              /*
					return {
		            	  pageSize: params.pageSize,
		            	  pageNumber: params.pageNumber,
		            	  searchText: params.searchText,
		            	  sortName: params.sortName,
		            	  sortOrder: params.sortOrder,
		            	  name: $("#name").val(), // 自定义查询参数
		              }*/
		              
		       },  
			});
			
			$(document).on("click", ".querySearch", function(){
				// 点击查询按钮，触发表单刷新
				$table.bootstrapTable("refresh");
			});
			
			$(".fixed-table-toolbar .columns-right ").prepend('<button id="addNew" type="button" class="btn btn-w-m btn-primary addNew"><i class="fa fa-plus"></i>添加</button>');
			
		});
	</script>
</body>
</html>