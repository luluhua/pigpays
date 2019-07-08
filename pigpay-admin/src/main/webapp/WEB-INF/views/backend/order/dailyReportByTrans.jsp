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
                        <h5>交易日报</h5>
                    </div>
                    <div class="ibox-content">
                     	<div class="table-responsive">
	                     	<div class="search-filter clearfix" style="padding-bottom:10px;">
		                   		<form id="searchForm" class="form-inline pull-left">
		                            <div class="form-group">
                                    	<div class="input-daterange input-group" id="datepicker">
		                                    <input type="text" placeholder="开始时间" class="input-sm form-control" name="startTime" value="${startTime }" style="width:100px;">
		                                    <span class="input-group-addon">~</span>
		                                    <input type="text" placeholder="结束时间" class="input-sm form-control" name="endTime" value="${endTime }" style="width:100px;">
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
			                        <th style="width:80px;">用户名</th>
			                        <th style="width:80px;">商户名</th>
			                        <th>总交易笔数</th>
			                        <th>成功交易笔数</th>
			                        <th>总交易金额</th>
			                      	<th>成功交易金额</th>
			                        <th>总交易手续费</th>
			                        <th>成功交易手续费</th>
			                        <th style="width:120px;">统计时间</th>
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
                		"url":'${rootpath}admin/trans/dailyReportByTransList', "type": "POST", data: queryData
                },
                "columns":[
                	{"data": "userName"},
                	{"data": "mchName"},
                	
                	{"data": "totalTransCount", "render": function(data, type, full, meta ){
                		var html = [];
                		html.push("<span style=\"font-weight:bold;\">总笔数</span>：" + data+"<br/>");
                		html.push("<span style=\"font-weight:bold;\">支付宝</span>：" + full['zfbTransCount']+"<br/>");
                		html.push("<span style=\"font-weight:bold;\">微信</span>：" + full['wxTransCount']+"<br/>");
                		return html.join('');
                	}},
                	
                	{"data": "succeedTransCount", 'render': function(data, type, full, meta ){
                		var html = [];
                		
                		html.push("<span style=\"font-weight:bold;\">总笔数</span>：" + data +"<br/>");
                		html.push("<span style=\"font-weight:bold;\">支付宝</span>：" + full['zfbSucceedTransCount']+"<br/>");
                		html.push("<span style=\"font-weight:bold;\">微信</span>：" + full['wxSucceedTransCount']+"<br/>");
                		return html.join('');
                	}},
                	
                 	{"data": "totalTransAmt", 'render': function(data, type, full, meta ){
                		var html = [];
                		html.push("<span style=\"font-weight:bold;\">总金额</span>：" + data +"<br/>");
                		html.push("<span style=\"font-weight:bold;\">支付宝</span>：" + full['zfbTransAmt']+"<br/>");
                		html.push("<span style=\"font-weight:bold;\">微信</span>：" + full['wxTransAmt']+"<br/>");
                		return html.join('');
                	}},
                	{"data": "succeedTransAmt", 'render': function(data, type, full, meta ){
                		var html = [];
                		html.push("<span style=\"font-weight:bold;\">总金额</span>：" + data +"<br/>");
                		html.push("<span style=\"font-weight:bold;\">支付宝</span>：" + full['zfbSucceedTransAmt']+"<br/>");
                		html.push("<span style=\"font-weight:bold;\">微信</span>：" + full['wxSucceedTransAmt']+"<br/>");
                		return html.join('');
                	}},
                 	{"data": "totalFee", 'render': function(data, type, full, meta ){
                		var html = [];
                		html.push("<span style=\"font-weight:bold;\">总手续费</span>：" + data +"<br/>");
                		html.push("<span style=\"font-weight:bold;\">支付宝</span>：" + full['zfbTotalFee'] +"<br/>");
                		html.push("<span style=\"font-weight:bold;\">微信</span>：" + full['wxTotalFee']+"<br/>");
                		return html.join('');
                	}},
                  	{"data": "succeedFee", 'render': function(data, type, full, meta ){
                		var html = [];
                		html.push("<span style=\"font-weight:bold;\">总手续费</span>：" + data +"<br/>");
                		html.push("<span style=\"font-weight:bold;\">支付宝</span>：" + full['zfbSucceedFee']+"<br/>");
                		html.push("<span style=\"font-weight:bold;\">微信</span>：" + full['wxSucceedFee']+"<br/>");
                		return html.join('');
                	}},
                	{"data": "reportTime", 'render': function(data, type, full, meta ){
                		return data ? new Date(data).format('yyyy-MM-dd hh:mm:ss') : "";
                	}},
                  	
            	]
            });
            
            $(".querySearch").on("click", function(){
            	queryData = {
            			userName: $("#userName").val(),
            			startTime: $("input[name=startTime]").val(),
            			endTime: $("input[name=endTime]").val()
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