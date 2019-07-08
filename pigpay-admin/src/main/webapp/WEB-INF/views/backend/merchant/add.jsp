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
			<form id="form" method="post" class="form form-horizontal" action="${rootpath }admin/merchant/save">
				
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
						<input type="password" name="pwd" class="form-control"> <span
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
				<div class="form-group">
					<label class="col-sm-2 control-label">真实姓名</label>
					<div class="col-sm-10">
						<input type="text" name="realname" class="form-control"> <span
							class="help-block m-b-none"></span>
					</div>
				</div>
				
				
				<div class="hr-line-dashed"></div>
				<div style="margin-top: 30px;">
					<h4>商户信息</h4>
				</div>
				<div class="form-group">
					<label class="col-sm-2 control-label">商户类型</label>
					<div class="col-sm-10">
						<div class="radio radio-success radio-inline">
							<input type="radio" id="mchType" value="1"
								checked name="mchType"> <label for="deductEnable1">
								普通商户</label>
						</div>
						<div class="radio radio-success radio-inline">
							<input type="radio" id="mchType" value="2" 
								name="mchType"> <label for="deductEnable2">
								特约商户</label>
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col-sm-2 control-label">商户名称</label>
					<div class="col-sm-10">
						<input type="text" name="mchName" class="form-control"> <span
							class="help-block m-b-none"></span>
					</div>
				</div>
				<div class="form-group">
					<label class="col-sm-2 control-label">手续费率</label>
					<div class="col-sm-10">
						<input type="text" name="feeRate" class="form-control"> <span
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
					<label class="col-sm-2 control-label">微信号</label>
					<div class="col-sm-10">
						<input type="text" name="wechat" class="form-control"> <span
							class="help-block m-b-none"></span>
					</div>
				</div>

				<div class="form-group">
					<label class="col-sm-2 control-label">QQ</label>
					<div class="col-sm-10">
						<input type="text" name="qq" class="form-control"> <span
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
				<div class="hr-line-dashed"></div>
				<div style="margin-top: 30px;">
					<h4>扣量设置</h4>
				</div>
				<div class="form-group">
					<label class="col-sm-2 control-label">启用扣量</label>
					<div class="col-sm-10">
						<div class="radio radio-success radio-inline">
							<input type="radio" id="deductEnable1" value="1"
								name="deductEnable"> <label for="deductEnable1">
								是</label>
						</div>
						<div class="radio radio-danger radio-inline">
							<input type="radio" id="deductEnable0" value="0" checked
								name="deductEnable"> <label for="deductEnable0">
								否</label>
						</div>
					</div>
				</div>
				<div class="form-group deductBox" style="display: none;">
					<label class="col-sm-2 control-label">扣量限额(元)</label>
					<div class="col-sm-10">
						<input type="text" name="deductLimit" class="form-control">
						<span class="help-block m-b-none">设置扣量的交易金额,低于该设置值则启用扣量</span>
					</div>
				</div>
				<div class="form-group deductBox" style="display: none;">
					<label class="col-sm-2 control-label">扣量比例(%)</label>
					<div class="col-sm-10">
						<input type="text" name="deductRate" class="form-control">
						<span class="help-block m-b-none">设置扣量额度占交易量的比例</span>
					</div>
				</div>
				<div class="form-group deductBox" style="display: none;">
					<label class="col-sm-2 control-label">扣量交易量阈值(元)</label>
					<div class="col-sm-10">
						<input type="text" name="deductThreshold" class="form-control">
						<span class="help-block m-b-none">设置交易量达到指定值开始扣量</span>
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
			$("input[name=deductEnable]").on("click", function(){
				var checkValue = $("input[name=deductEnable]:checked").val();
				if(checkValue == 1) {
					$(".deductBox").show();
				}else {
					$(".deductBox").hide();
				}
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
