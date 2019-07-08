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
                    </div>
                    <div class="ibox-content">
                     	<div class="table-responsive">
	                     	<div class="search-filter clearfix" style="padding-bottom:10px;">
		                   		<form id="searchForm" class="form-inline pull-left">
		                            <div class="form-group">
		                              <input type="text" placeholder="渠道账号" class="input-sm form-control" name="chnlAcct" value="${chnlAcct }">
                                    </div>
		                            <div class="form-group">
                                    	<div class="input-daterange input-group" id="datepicker">
		                                    <input type="text" placeholder="开始时间" class="input-sm form-control" name="fromDate" value="${fromDate }">
		                                    <span class="input-group-addon">~</span>
		                                    <input type="text" placeholder="结束时间" class="input-sm form-control" name="toDate" value="${toDate }">
		                                </div>
		                                <button type="submit" class="btn btn-w-m btn-success querySearch"><i class="fa fa-search"></i> 统计</button>
		                            </div>
		                        </form>
	                   	</div>
                    	<table class="table table-striped table-bordered table-hover dataTables-example" >
		                    <thead>
			                    <tr>
			                    	<th>通道账户</th>
			                        <th>交易金额(元)</th>
			                        <th>日期</th>
			                    </tr>
		                    </thead>
		                    <tbody>
		                    	<c:forEach items="${dataList }" var="item">
		                    		<tr>
		                    			<td>${item.chnl_acct }</td>
		                    			<td>${item.total_amout }</td>
		                    			<td>${item.order_date }</td>
		                    		</tr>
		                    	</c:forEach>
		                    </tbody>
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