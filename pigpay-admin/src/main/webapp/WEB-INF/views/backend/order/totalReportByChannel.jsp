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
                        <h5>渠道报表</h5>
                    </div>
                    <div class="ibox-content">
                     	<div class="table-responsive">
	                     	<div class="search-filter clearfix" style="padding-bottom:10px;">
		                   		<form id="searchForm" class="form-inline pull-left">
		                            <div class="form-group">
		                            </div>
		                        </form>
	                        <div class="pull-right">
	                        </div>
	                   	</div>
                    	<table class="table table-striped table-bordered table-hover dataTables-example" >
		                    <thead>
			                    <tr>
			                        <th style="width:120px;">支付渠道</th>
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
                		"url":'${rootpath}admin/trans/totalReportByChannelList', "type": "POST", data: queryData
                },
                "columns":[
                	{"data": "channelName"},
                	{"data": "totalTransAmt"},
                	{"data": "succeedTransAmt"},
                	{"data": "totalCount"},
                	{"data": "succeedCount"},
                	{"data": "totalFee"},
                	{"data": "succeedFee"}
            	]
            });
            
            $(".querySearch").on("click", function(){
            	queryData = {
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