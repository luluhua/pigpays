<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="../header.jsp"%>
<style type="text/css">
	.form-group {
		padding:0 30px;
	}
</style>
<body style="margin: 0;">
	<div class="wrap">
		<div class="wrap-content">
			<form id="form" method="post" class="form form-horizontal" action="${rootpath }admin/merchant/saveProvider">
				<div style="margin-top: 30px;">
					<h4>用户信息</h4>
				</div>
				<div class="form-group">
					<label class="col-sm-3 control-label">登录账号</label>
					<div class="col-sm-9">
						<input type="text" name="username" class="form-control" readonly="readonly" value="${user.username }"> <span
							class="help-block m-b-none"></span>
					</div>
				</div>
				<div class="form-group">
					<label class="col-sm-3 control-label">真实姓名</label>
					<div class="col-sm-9">
						<input type="text" name="realname" class="form-control" readonly="readonly" value="${user.realname }"> <span
							class="help-block m-b-none"></span>
					</div>
				</div>
				<div class="form-group">
					<label class="col-sm-3 control-label">推荐人</label>
					<div class="col-sm-9">
						<input type="text" name="agentName" class="form-control" readonly="readonly"  value="${user.agentName }"> <span
							class="help-block m-b-none"></span>
					</div>
				</div>
				<div class="form-group">
					<label class="col-sm-3 control-label">允许创建二维码个数</label>
					<div class="col-sm-9">
						<input type="text" name="qrcodeCountLimit" class="form-control"  value="${user.qrcodeCountLimit }"> <span
							class="help-block m-b-none"></span>
					</div>
				</div>
				<div class="form-group">
					<label class="col-sm-3 control-label">允许创建收款账号个数</label>
					<div class="col-sm-9">
						<input type="text" name="acctCountLimit" class="form-control"  value="${user.acctCountLimit}"> <span
							class="help-block m-b-none"></span>
					</div>
				</div>
				<div class="form-group" style="margin-top:30px;">
					<label class="col-sm-3 control-label"></label>
					<div class="col-sm-9">
						<input type="hidden" name="id" value="${user.id}">
						<button class="btn btn-white btn-cancel" type="button">取消</button>
						<button class="btn btn-w-m btn-success btn-submit" type="submit">确定</button>
					</div>
				</div>
			</form>
		</div>
	</div>

	<%@ include file="../scripts.jsp"%>
	<script type="text/javascript">
		$(function() {
			var index = parent.layer.getFrameIndex(window.name);
			$("body").niceScroll({
				cursorcolor : "#ccc",
				cursorwidth : "10px"
			});
			$("input[name=deductEnable]").on("click", function(){
				checkDeductEnable();
			});
			function checkDeductEnable() {
				var checkValue = $("input[name=deductEnable]:checked").val();
				if(checkValue == 1) {
					$(".deductBox").show();
				}else {
					$(".deductBox").hide();
				}
			}
			checkDeductEnable();
			// 表单验证和提交
			var validform = $("#form").Validform({
				tiptype : 3,
				datatype : {
					"z2-4" : /^[\u4E00-\u9FA5\uf900-\ufa2d]{2,8}$/,
				},
				onFormError : function(form) {
					var input = form.find(".Validform_error:first");
					input.focus();
				},
				callback : function(form) {
					subitForm(form);
					return false;
				}
			});

			function subitForm(form) {
				$(".save").attr("disabled", true);
				var index1 = layer.load(2, {
					shade : 0.01,
					time : 0
				});
				var action = $(form).attr("action");
				var data = $(form).serialize();
				$.post(action, data, function(res) {
					$(".save").attr("disabled", false);
					layer.close(index1);
					parent.layer.msg(res.msg);
					if (res.code == "00") {
						validform.resetForm();
						parent.refreshCurrentTab();
						parent.layer.close(index);
					}

				}, 'json');
			}

			$(".save").click(function() {
				$("#form").submit();
			});

			$(".btn-cancel").click(function() {
				parent.layer.close(index);
			});

		});
	</script>
</body>
</html>
