<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ include file="../header.jsp"%>
<style type="text/css">
	.wrap-content {
		padding:0 30px;
	}
	.form-horizontal .control-label {
		padding-top:0;
	}
	.form {
		margin:0;
	}
</style>
<body style="margin: 0;">
	<div class="wrap">
		<div class="wrap-content">
			<form id="form" method="post" class="form form-horizontal" style="padding:10px;">
				<div>
					<h4>账号信息</h4>
				</div>
				<div class="form-group">
					<label class="col-sm-4 control-label">登录账号</label>
					<div class="col-sm-8">
						${user.username }
					</div>
				</div>
				<div class="form-group">
					<label class="col-sm-4 control-label">真实姓名</label>
					<div class="col-sm-8">
						${user.realname }
					</div>
				</div>
				<div class="form-group">
					<label class="col-sm-4 control-label">手机号码</label>
					<div class="col-sm-8">
						${user.mobile }
					</div>
				</div>
				<div class="form-group">
					<label class="col-sm-4 control-label">注册时间</label>
					<div class="col-sm-8">
						<fmt:formatDate value="${user.createTime }" pattern="yyyy-MM-dd HH:mm:ss"/>
					</div>
				</div>
				<div class="form-group">
					<label class="col-sm-4 control-label">最近登录时间</label>
					<div class="col-sm-8">
						<fmt:formatDate value="${user.lastLoginTime }" pattern="yyyy-MM-dd HH:mm:ss"/>
					</div>
				</div>
				<div class="form-group">
					<label class="col-sm-4 control-label">最近登录IP</label>
					<div class="col-sm-8">
						${user.lastLoginIp }
					</div>
				</div>
				
				
				<div class="hr-line-dashed"></div>
				<div style="margin-top: 30px;">
					<h4>商户信息</h4>
				</div>
				
				<div class="form-group">
					<label class="col-sm-4 control-label">商户名称</label>
					<div class="col-sm-8">
						${merchant.mchName }
					</div>
				</div>
				<div class="form-group">
					<label class="col-sm-4 control-label">手续费率</label>
					<div class="col-sm-8">
						${merchant.feeRate == '0.00' ? "无" : merchant.feeRate  }
					</div>
				</div>
				
				<div class="form-group">
					<label class="col-sm-4 control-label">手机号码</label>
					<div class="col-sm-8">
						${merchant.mobile }
					</div>
				</div>
				<div class="form-group">
					<label class="col-sm-4 control-label">微信号</label>
					<div class="col-sm-8">
						${merchant.wechat }
					</div>
				</div>
				<div class="form-group">
					<label class="col-sm-4 control-label">QQ</label>
					<div class="col-sm-8">
						${merchant.qq }
					</div>
				</div>
				<div class="form-group">
					<label class="col-sm-4 control-label">常用邮箱</label>
					<div class="col-sm-8">
						${merchant.email }
					</div>
				</div>
				<div class="hr-line-dashed"></div>
				<div style="margin-top: 30px;">
					<h4>扣量设置</h4>
				</div>
				
				<div class="form-group">
					<label class="col-sm-4 control-label">启用扣量</label>
					<div class="col-sm-8">
						${merchant.deductEnable == 1 ? "是" : "否" }
					</div>
				</div>
				<c:if test="${merchant.deductEnable == 1 }">
				<div class="form-group deductBox">
					<label class="col-sm-4 control-label">扣量限额(元)</label>
					<div class="col-sm-8">
						${merchant.deductLimit }
					</div>
				</div>
				<div class="form-group deductBox">
					<label class="col-sm-4 control-label">扣量比例(%)</label>
					<div class="col-sm-8">
						${merchant.deductRate }
					</div>
				</div>
				<div class="form-group deductBox">
					<label class="col-sm-4 control-label">扣量交易量阈值(元)</label>
					<div class="col-sm-8">
						${merchant.deductThreshold }
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
			$("body").niceScroll({
				cursorcolor : "#ccc",
				cursorwidth : "10px"
			});
		});
	</script>
</body>
</html>
