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
					<label class="col-sm-2 control-label">交易流水号</label>
					<div class="col-sm-4">${order.tradeNo }</div>
					<label class="col-sm-2 control-label">商户订单号</label>
					<div class="col-sm-4">${order.orderNo }</div>
				</div>
				<div class="form-group">
					<label class="col-sm-2 control-label">下单时间</label>
					<div class="col-sm-4">
						<fmt:formatDate value="${order.createTime }"
							pattern="yyyy-MM-dd HH:mm:ss" />
					</div>
					<label class="col-sm-2 control-label">订单状态</label>
					<div class="col-sm-4">
						<c:if test="${order.status == '2' }">待付款</c:if>
						<c:if test="${order.status == '1' }">支付成功</c:if>
						<c:if test="${order.status == '3' }">支付失败</c:if>
						<c:if test="${order.status == '4' }">已关闭</c:if>
						<c:if test="${order.status == '5' }">已退款</c:if>
						<c:if test="${order.status == '9' }">已取消</c:if>
					</div>
				</div>
				<div class="form-group">
					<label class="col-sm-2 control-label">交易金额</label>
					<div class="col-sm-4">${order.transAmt }元</div>
					<label class="col-sm-2 control-label">订单状态</label>
					<div class="col-sm-4">
						<c:if test="${order.status == '2' }">待付款</c:if>
						<c:if test="${order.status == '1' }">支付成功</c:if>
						<c:if test="${order.status == '3' }">支付失败</c:if>
						<c:if test="${order.status == '4' }">已关闭</c:if>
						<c:if test="${order.status == '5' }">已退款</c:if>
						<c:if test="${order.status == '9' }">已取消</c:if>
					</div>
				</div>
				<div class="form-group">
					<label class="col-sm-2 control-label">商户号</label>
					<div class="col-sm-4">${order.mchNo }</div>
					<label class="col-sm-2 control-label">费率</label>
					<div class="col-sm-4">${order.transRate == '0.0000' ? '无': order.transRate+"%"}</div>
				</div>
				<div class="form-group">
					<label class="col-sm-2 control-label">商品信息</label>
					<div class="col-sm-4">${order.body }</div>
					<label class="col-sm-2 control-label">附加信息</label>
					<div class="col-sm-4">${order.attach }</div>
				</div>
				
				
				<div class="hr-line-dashed"></div>
				<div>
					<h4>支付信息</h4>
				</div>
				<div class="form-group">
					<label class="col-sm-2 control-label">支付方式</label>
					<div class="col-sm-4">
						<c:if test="${order.payType == '09' }">微信扫码支付</c:if>
						<c:if test="${order.payType == '10' }">微信扫码支付</c:if>
						<c:if test="${order.payType == '11' }">微信APP支付</c:if>
						<c:if test="${order.payType == '12' }">支付宝扫码支付</c:if>
						<c:if test="${order.payType == '13' }">支付宝WAP支付</c:if>
						<c:if test="${order.payType == '14' }">网关支付</c:if>
						<c:if test="${order.payType == '15' }">快捷支付</c:if>
						<c:if test="${order.payType == '16' }">微信H5支付</c:if>
					</div>
					<label class="col-sm-2 control-label">支付时间</label>
					<div class="col-sm-4">
						<fmt:formatDate value="${order.payTime }"
							pattern="yyyy-MM-dd HH:mm:ss" />
					</div>
					
				</div>
				<div class="form-group">
					<label class="col-sm-2 control-label">支付金额</label>
					<div class="col-sm-4">${order.transAmt  }元</div>
					<label class="col-sm-2 control-label">支付通道</label>
					<div class="col-sm-4">${order.acctName  }@${order.chnlAcct  }</div>
				</div>

				<div class="form-group">
					<label class="col-sm-2 control-label">支付单号</label>
					<div class="col-sm-4">${order.transactionId }</div>
					<label class="col-sm-2 control-label"></label>
					<div class="col-sm-4"></div>
				</div>
				<c:if test="${order.isManualCheck == 1 }">
					<div class="hr-line-dashed"></div>
					<div>
						<h4>补单信息</h4>
					</div>
					<div class="form-group">
						<label class="col-sm-2 control-label">补单操作员</label>
						<div class="col-sm-4">${order.manualCheckId  }</div>
						<label class="col-sm-2 control-label">补单时间</label>
						<div class="col-sm-4">
							<fmt:formatDate value="${order.manualCheckTime }"
							pattern="yyyy-MM-dd HH:mm:ss" />
						</div>
					</div>
				</c:if>
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
