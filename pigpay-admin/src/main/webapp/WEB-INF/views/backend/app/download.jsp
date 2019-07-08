<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include  file="../header.jsp"%>
<style type="text/css">
	.qq-upload-button {
		width: 110px;
    	padding: 8px 0;
	}
</style>
<body style="margin:0;padding:10px 30px;">
	<div class="wrap">
		<div class="wrap-content">
			<div class="qrcode" style="width:600px; margin:0 auto;text-align: center;">
				<c:if test="${empty appIssue }">
					<img alt="" src="http://qr.liantu.com/api.php?el=h&m=10&text=http://mch.125plan.cn/uploads/app/app.apk">
					<br/>
					<a href="http://mch.125plan.cn/uploads/app/app.apk">下载</a>
				</c:if>
				<c:if test="${not empty appIssue }">
					<img alt="" src="http://qr.liantu.com/api.php?el=h&m=10&text=${appIssue.url }">
					<br/>
					<a href="${appIssue.url }">下载</a>
				</c:if>
			</div>
		</div>
	</div>
	
<%@ include  file="../scripts.jsp"%>
	<script type="text/javascript">
		
		$(function() {
			
		});
	</script>
	
</body>
</html>
