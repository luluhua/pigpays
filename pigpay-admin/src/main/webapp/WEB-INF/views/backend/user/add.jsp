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
			<form id="form" method="post" class="form form-horizontal" action="${rootpath }admin/user/save">
				
				<div style="margin-top: 30px;">
					<h4>账号信息</h4>
				</div>
				<div class="form-group">
					<label class="col-sm-2 control-label">登录账号</label>
					<div class="col-sm-10">
						<input type="text" name="username" class="form-control"> <span
							class="help-block m-b-none"></span>
					</div>
				</div>
				<div class="form-group">
					<label class="col-sm-2 control-label">登录密码</label>
					<div class="col-sm-10">
						<input type="password" name="password" class="form-control"> <span
							class="help-block m-b-none"></span>
					</div>
				</div>
				<div class="form-group">
					<label class="col-sm-2 control-label">确认密码</label>
					<div class="col-sm-10">
						<input type="password" name="confirmpwd" class="form-control">
						<span class="help-block m-b-none"></span>
					</div>
				</div>
				
				
				
				<div class="hr-line-dashed"></div>
				<div style="margin-top: 30px;">
					<h4>个人信息</h4>
				</div>
				
				<div class="form-group">
					<label class="col-sm-2 control-label">真实姓名</label>
					<div class="col-sm-10">
						<input type="text" name="realname" class="form-control"> <span
							class="help-block m-b-none"></span>
					</div>
				</div>
				
				<div class="form-group">
					<label class="col-sm-2 control-label">手机号码</label>
					<div class="col-sm-10">
						<input type="text" name="mobile" class="form-control"> <span
							class="help-block m-b-none"></span>
					</div>
				</div>

				<div class="form-group">
					<label class="col-sm-2 control-label">常用邮箱</label>
					<div class="col-sm-10">
						<input type="text" name="email" class="form-control"> <span
							class="help-block m-b-none"></span>
					</div>
				</div>
				
				<div class="form-group" style="margin-top:30px;">
					<label class="col-sm-2 control-label"></label>
					<div class="col-sm-10">
						<input type="hidden" name="status" value="1">
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
