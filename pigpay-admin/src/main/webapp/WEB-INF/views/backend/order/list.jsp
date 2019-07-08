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
                        <h5>交易记录</h5>
                    </div>
                    <div class="ibox-content">
                     	<div class="table-responsive">
	                     	<div class="search-filter clearfix" style="padding-bottom:10px;">
		                   		<form id="searchForm" class="form-inline pull-left">
		                            <div class="form-group">
		                                <input type="text" placeholder="交易流水号、客户单号、商户号" style="width:300px;" id="orderNo" class="form-control">
                                    	<select id="status" name="status" class="form-control" style="width:120px;">
                                    		<option value="">全部状态</option>
                                    		<option value="1">支付成功</option>
                                    		<option value="2">待付款</option>
                                    		<option value="3">支付失败</option>
                                    		<option value="4">已关闭</option>
                                    		<option value="5">已退款</option>
                                    		<option value="9">取消支付</option>
                                    		<option value="10">支付中</option>
                                    		<option value="11">超时取消</option>
                                    	</select>
                                    	<div class="input-daterange input-group" id="datepicker">
		                                    <input type="text" placeholder="开始时间" class="input-sm form-control" name="startTime" value="" style="width:100px;">
		                                    <span class="input-group-addon">~</span>
		                                    <input type="text" placeholder="结束时间" class="input-sm form-control" name="endTime" value="" style="width:100px;">
		                                </div>
		                                <button type="button" class="btn btn-w-m btn-success querySearch"><i class="fa fa-search"></i> 查询</button>
		                            </div>
		                        </form>
	                        <div class="pull-right">
	                        </div>
	                   	</div>
                    	<table class="table table-striped table-bordered table-hover dataTables-example" >
		                    <thead>
			                    <tr>
			                        <th style="width:200px;">单号</th>
			                        <th style="width:120px;">收款账号</th>
			                        <th>商户号</th>
			                        <th style="width:80px;">支付方式</th>
			                        <th style="width:40px;">交易金额(元)</th>
			                        <th style="width:50px;">下单时间</th>
			                        <th style="width:50px;">支付时间</th>
			                        <th style="width:40px;">订单状态</th>
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
                		"url":'${rootpath}admin/order/list', "type": "POST"//, data: queryData
                },
                "columns":[
                	{"data": "tradeNo", "render": function(data, type, full, meta ){
                		var html = [];
                		html.push("<span style=\"font-weight:bold;\">交易单号</span>：" + data+"<br/>");
                		html.push("<span style=\"font-weight:bold;\">客户单号</span>：" + full['orderNo']+"<br/>");
                		html.push("<span style=\"font-weight:bold;\">支付单号</span>：" + (full['transactionId']?full['transactionId'] : "")+"<br/>");
                		return html.join('');
                	}},
                	{"data": "acctName", 'render': function(data, type, full, meta ){
                		var html = [];
                		
                		html.push("<span style=\"font-weight:bold;\">账户</span>：" + data +"<br/>");
                		html.push("<span style=\"font-weight:bold;\">通道</span>：" + full['chnlAcct']+"<br/>");
                		html.push("<span style=\"font-weight:bold;\">备注</span>：" + (full['acctNo']?full['acctNo']:'') +"<br/>");
                		return html.join('');
                	}},
                	{"data": "mchNo"},
                	
                	{"data": "payType", 'render': function(data, type, full, meta ){
            			if(data == '09') {return "微信公众号支付"}
            			else if(data == '10') {return "微信扫码支付"}
            			else if(data == '11') {return "微信APP支付"}
            			else if(data == '12') {return "支付宝扫码支付"}
            			else if(data == '13') {return "支付宝WAP支付"}
            			else if(data == '14') {return "网关支付"}
            			else if(data == '15') {return "快捷支付"}
            			else if(data == '16') {return "微信H5支付"}
        			}},
                	{"data": "transAmt", 'render': function(data, type, full, meta ){
                		return data;
                	}},
                	{"data": "createTime", 'render': function(data, type, full, meta ){
                		return new Date(data).format('yyyy-MM-dd hh:mm:ss');
                	}},
                	{"data": "payTime", 'render': function(data, type, full, meta ){
                		return data ? new Date(data).format('yyyy-MM-dd hh:mm:ss') : "";
                	}},
                	{"data": "status", 'render': function(data, type, full, meta ){
	            			if(data == '2' ) {return "待付款"}
	            			else if(data == '1') {
	            				var manual = "";
	            				if(full.isManualCheck==1){
	            					manual = "<br/><span style=\"color:red;\">[补单]</span>"
	            				}
	            				return "<span style=\"color:green;\">支付成功</span>" + manual;
	            			}
	            			else if(data == '3') {return "支付失败"}
	            			else if(data == '4') {return "已关闭"}
	            			else if(data == '5') {return "已退款"}
	            			else if(data == '9') {return "取消支付"}
	            			else if(data == '10') {return "支付中"}
	            			else if(data == '11') {
	            				return "<span style=\"color:red;\">超时取消</span>"
	            				}
	            			else{ return data}
            			}
            		},
                	
                	{"data": "id", 'render': function(data, type, full, meta ){
                			var status = full['status'] * 1;
                			var links = '<a title="交易详情" style="display:inline-block;" class="btn-sm btn-warning detail" data-id="'+data+'">详情</a> ';
	                		if(status == 2 || status == 11){
	                			links += '<a title="我已经收款" style="margin-top:10px;display:inline-block;" class="btn-sm btn-success checkpay" data-id="'+data+'">我已收款</a> ';
	                		}
	                		if(status == 1){
	                			links += '<a title="重发通知" style="margin-top:10px;display:inline-block;" class="btn-sm btn-success reSendNotify" data-id="'+data+'">补发通知</a> ';
	                		}
                		
                		    return links;
	                	}
                	}
            	]
            });
            
            $(".querySearch").on("click", function(){
            	queryData = {
            			orderNo: $("#orderNo").val(),
            			mchNo: $("#mchNo").val(),
            			startTime: $("input[name=startTime]").val(),
            			endTime: $("input[name=endTime]").val(),
            			status: $("#status").val()
            	};
            	table.settings()[0].ajax.data=queryData;  
                table.ajax.reload();
            });
            
            $('.input-daterange').datepicker({
			    keyboardNavigation: false,
			    forceParse: false,
			    autoclose: true,
			    format: 'yyyy-mm-dd',
			});
            
            
            $(document).on("click", ".detail", function(){
            	var id = $(this).attr("data-id");
            	parent.layer.open({
					title : false,
					type : 2,
					area : [ '800px', '400px' ],
					fixed : false, //不固定
					maxmin : false,
					content : basePath + 'admin/order/detail?id=' + id,
					success : function(index) {
					}
				});
            });
            
            $(document).on("click", ".checkpay", function(){
            	var id = $(this).attr("data-id");
            	layer.confirm("您确定已经完成收款吗?", function(){
                	var index = layer.msg("正在提交...");
                	$.post(rootpath + "admin/order/confirmpay", {id: id}, function(res){
                		layer.close(index);
    					layer.alert(res.msg);
    					if(res.code == '00') {
    						table.ajax.reload();
    					}
    				}, "json");
            	});
            });
            $(document).on("click", ".reSendNotify", function(){
            	var id = $(this).attr("data-id");
            	layer.confirm("您确定重发通知吗?", function(){
                	var index = layer.msg("正在提交...");
                	$.post(rootpath + "admin/order/resendnotify", {id: id}, function(res){
                		layer.close(index);
    					layer.alert(res.msg);
    					if(res.code == '00') {
    						table.ajax.reload();
    					}
    				}, "json");
            	});
            });
        });

    </script>

</body>
</html>