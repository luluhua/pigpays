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
                        <h5>商户日报</h5>
                    </div>
                    <div class="ibox-content">
                     	<div class="table-responsive">
	                     	<div class="search-filter clearfix" style="padding-bottom:10px;">
		                   		<form id="searchForm" class="form-inline pull-left">
		                            <div class="form-group">
		                                <input type="text" placeholder="商户名称" style="width:300px;" id="mchname" class="form-control">
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
			                        <th style="width:200px;">商户号</th>
			                        <th style="width:120px;">商户名称</th>
			                        <th style="width:80px;">日期</th>
			                        <th style="width:40px;">总交易金额</th>
			                        <th style="width:50px;">成功交易金额</th>
			                        <th style="width:50px;">总笔数</th>
			                        <th style="width:40px;">成功笔数</th>
			                        <th style="width:120px;">总手续费</th>
			                        <th style="width:120px;">成功手续费</th>
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
        			mchname: $("#mchname").val(),
        			startTime: $("input[name=startTime]").val(),
        			endTime: $("input[name=endTime]").val(),
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
                		"url":'${rootpath}admin/trans/dailyReportByMchList', "type": "POST", data: queryData
                },
                "columns":[
                	{"data": "mchNo"},
                	{"data": "mchName"},
                	{"data": "reportDate"},
                	{"data": "totalTransAmt"},
                	{"data": "succeedTransAmt"},
                	{"data": "totalTransCount"},
                	{"data": "succeedTransCount"},
                	{"data": "totalFee"},
                	{"data": "succeedFee"}
            	]
            });
            
            $(".querySearch").on("click", function(){
            	queryData = {
            			mchname: $("#mchname").val(),
            			startTime: $("input[name=startTime]").val(),
            			endTime: $("input[name=endTime]").val(),
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
            
        });

    </script>

</body>
</html>