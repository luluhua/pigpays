<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ include file="../header.jsp"%>
<style type="text/css">
.wrap-content {
	padding: 0 30px;
}

.form-horizontal .control-label {
	padding-top: 0;
}

.form {
	margin: 0;
}
</style>
<body style="margin: 0;">
	<div class="wrap">
		<div class="wrap-content">
			<form id="form" method="post" class="form form-horizontal"
				style="margin: 0; padding-top: 30px;">
				<div>
					<h4>订单信息</h4>
				</div>
				<div class="form-group">
					<label class="col-sm-2 control-label">用户</label>
					<div class="col-sm-4">${user.username}</div>
					<label class="col-sm-2 control-label">类型</label>
					<div class="col-sm-4">
					<c:if test="${recharge.type == '1' }">充值</c:if>
					</div>
				</div>
				<div class="form-group">
					<label class="col-sm-2 control-label">单号</label>
					<div class="col-sm-4">${recharge.serialNo }</div>
					<label class="col-sm-2 control-label">商户订单号</label>
					<div class="col-sm-4">${recharge.tradeNo }</div>
				</div>
				<div class="form-group">
					<label class="col-sm-2 control-label">下单时间</label>
					<div class="col-sm-4">
						<fmt:formatDate value="${recharge.createTime }"
							pattern="yyyy-MM-dd HH:mm:ss" />
					</div>
					<label class="col-sm-2 control-label">充值状态</label>
					<div class="col-sm-4">
						<c:if test="${recharge.status == '0' }">待充值</c:if>
						<c:if test="${recharge.status == '1' }">充值成功</c:if>
						<c:if test="${recharge.status == '2' }">充值失败</c:if>
						<c:if test="${recharge.status == '3' }">已取消</c:if>
					</div>
				</div>
				<div class="form-group">
					<label class="col-sm-2 control-label">充值金额</label>
					<div class="col-sm-4">${recharge.amount }元</div>
					<label class="col-sm-2 control-label">充值方式</label>
					<div class="col-sm-4"> 
						<c:if test="${recharge.rechargeType == '1' }">现金</c:if>
						<c:if test="${recharge.rechargeType == '2' }">转账</c:if>
						<c:if test="${recharge.rechargeType == '3' }">在线支付</c:if>
					</div>
				</div>

			</form>
		</div>
	</div>

	<%@ include file="../scripts.jsp"%>
	<script type="text/javascript">
		$(function() {
			var index = parent.layer.getFrameIndex(window.name);
			$(".btn-cancel").click(function() {
				parent.layer.close(index);
			});
		});
	</script>
</body>
</html>
