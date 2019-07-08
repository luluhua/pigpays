<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
                        <h5>充值记录</h5>
                    </div>
                    <div class="ibox-content">
                     	<div class="table-responsive">
	                     	<div class="search-filter clearfix" style="padding-bottom:10px;">
		                   		<form id="searchForm" class="form-inline pull-left">
		                            <div class="form-group">
		                                <input type="text" placeholder="单号" style="width:300px;" id="serialNo" class="form-control">
                                    	<select id="status" name="status" class="form-control" style="width:120px;">
                                    		<option value="">全部状态</option>
                                    		<option value="1">充值成功</option>
                                    		<option value="3">充值失败</option>
                                    		<option value="3">充值取消</option>
                                    	</select>
                                    	<select id="rechargeType" name="rechargeType" class="form-control" style="width:120px;">
                                    		<option value="">全部方式</option>
                                    		<option value="1">现金充值</option>
                                    		<option value="3">转账充值</option>
                                    		<option value="3">在线充值</option>
                                    	</select>
                                <!--     	<div class="input-daterange input-group" id="datepicker">
		                                    <input type="text" placeholder="开始时间" class="input-sm form-control" name="startTime" value="" style="width:100px;">
		                                    <span class="input-group-addon">~</span>
		                                    <input type="text" placeholder="结束时间" class="input-sm form-control" name="endTime" value="" style="width:100px;">
		                                </div> -->
		                                <button type="button" class="btn btn-w-m btn-success querySearch"><i class="fa fa-search"></i> 查询</button>
		                            </div>
		                        </form>
	                        <div class="pull-right">
	                        </div>
	                   	</div>
                    	<table class="table table-striped table-bordered table-hover dataTables-example" >
		                    <thead>
			                    <tr>
			                        <th style="width:100px;">流水号</th>
			                        <th style="width:100px;">充值渠道</th>
			                        <th style="width:100px;">交易单号</th>
			                        <th style="width:60px;">充值方式</th>
			                        <th style="width:80px;">充值金额(元)</th>
			                        <th style="width:80px;">充值时间</th>
			                        <th style="width:80px;">支付时间</th>
			                        <th style="width:80px;">充值状态</th>
			                        <th style="width:60px;">操作</th>
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
    	var table;
        $(document).ready(function(){
        	var queryData = {
        			orderNo: $("#orderNo").val(),
        			mchNo: $("#mchNo").val(),
        			startTime: $("input[name=startTime]").val(),
        			endTime: $("input[name=endTime]").val(),
        			status: $("#status").val()
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
                ajax:{
                		"url":'${rootpath}admin/recharge/dealList', "type": "POST"//, data: queryData
                },
                "columns":[
                	{"data": "serialNo", 'render': function(data, type, full, meta ){
                		return data;
                	}},
                	{"data": "userId", 'render': function(data, type, full, meta ){
                		var html = [];
                		html.push("<span style=\"font-weight:bold;\">账户</span>：" + data +"<br/>");
                		html.push("<span style=\"font-weight:bold;\">通道</span>：" + full['payChannel']+"<br/>");
                		html.push("<span style=\"font-weight:bold;\">备注</span>：" + (full['remark']?full['remark']:'') +"<br/>");
                		return html.join('');
                	}},
                	{"data": "tradeNo"},
                	
                	{"data": "rechargeType", 'render': function(data, type, full, meta ){
            			if(data == '1') {return "现金"}
            			else if(data == '2') {return "转账"}
            			else if(data == '3') {return "在线支付"}
        			}},
                	{"data": "amount", 'render': function(data, type, full, meta ){
                		return data;
                	}},
                	{"data": "createTime", 'render': function(data, type, full, meta ){
                		return new Date(data).format('yyyy-MM-dd hh:mm:ss');
                	}},
                	{"data": "payTime", 'render': function(data, type, full, meta ){
                		return data ? new Date(data).format('yyyy-MM-dd hh:mm:ss') : "";
                	}},
                	{"data": "status", 'render': function(data, type, full, meta ){
	            			if(data == '0' ) {return "待充值"}
	            			else if(data == '1') {
	            				var manual = "";
	            				return "<span style=\"color:green;\">支付成功</span>" + manual;
	            			}
	            			else if(data == '2') {return "充值失败"}
	            			else if(data == '3') {return "已取消"}
	            			else{ return data}
            			}
            		},
                	
                 	{"data": "id", 'render': function(data, type, full, meta ){
                		var status = full.status;
                		var links = '<a title="详细信息" class="btn-sm btn-primary detail" data-id="'+data+'"> <i class="fa fa-file"></i></a> ';
                		    links += '<a title="删除" class="btn-sm btn-danger del" data-id="'+data+'"> <i class="fa fa-trash-o"></i></a> ';
                		
                		    
                		    return links;
	                	}
                	}
            	]
            });
            $(".querySearch").on("click", function(){
            	queryData = {
            			serialNo: $("#serialNo").val(),
            			status: $("#status").val(),
            			rechargeType: $("#rechargeType").val()
            	};
            	table.settings()[0].ajax.data=queryData;  
                table.ajax.reload();
            });
            
            $(document).on("click", ".detail", function(){
            	var id = $(this).attr("data-id");
            	parent.layer.open({
					title : false,
					type : 2,
					area : [ '800px', '400px' ],
					fixed : false, //不固定
					maxmin : false,
					content : basePath + 'admin/recharge/dealDetails?id=' + id,
					success : function(index) {
					}
				});
            });
            
            $(document).on("click", ".del", function(){
            	var id = $(this).attr("data-id");
				parent.layer.confirm('你确定要删除该版本吗?', {icon: 2, title:'系统警告'}, function(index){
					$.post(basePath+"admin/recharge/delete", {id: id}, function(res){
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