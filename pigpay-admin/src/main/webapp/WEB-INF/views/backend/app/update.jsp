<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include  file="../header.jsp"%>
<html>
<head>

</head>
<body>
<body style="margin: 0;">
	<div class="wrap">
		<div class="wrap-content">
			<form id="form" method="post" class="form form-horizontal" action="${rootpath }admin/app/save">
				<div style="margin-top: 30px;">
					<h4>新增版本</h4>
				</div>
				<div class="form-group">
					<label class="col-sm-2 control-label">标题</label>
					<div class="col-sm-10">
						<input type="text" name="title" class="form-control" value="${appIssue.title}"> <span
							class="help-block m-b-none"></span>
					</div>
				</div>
				<div class="form-group">
					<label class="col-sm-2 control-label">版本号</label>
					<div class="col-sm-10">
						<input type="text" name="version" class="form-control" value="${appIssue.version}"> <span
							class="help-block m-b-none"></span>
					</div>
				</div>
				<div class="form-group">
					<label class="col-sm-2 control-label">下载地址</label>
					<div class="col-sm-10">
						<input type="text" name="url" class="form-control" value="${appIssue.url}">
						<span class="help-block m-b-none"></span>
					</div>
				</div>
				<div class="form-group">
					<label class="col-sm-2 control-label">升级说明</label>
					<div class="col-sm-10">
						<textarea type="text" name="info" class="form-control" value="">${appIssue.info}</textarea> <span
							class="help-block m-b-none"></span>
					</div>
				</div>

				<div class="form-group">
					<label class="col-sm-2 control-label">发布人</label>
					<div class="col-sm-10">
						<input type="text" name="pubUser" class="form-control" readonly="readonly" value="${user.username}"> <span
							class="help-block m-b-none"></span>
					</div>
				</div>
		
				<div class="hr-line-dashed"></div>
						<div class ="status" style="margin-top: 30px; display: flex; ">
					<h4 style="padding-left: 20px;">是否强制安装</h4>
						<div class="form-group statusxuz" style="width:200px; display: flex; padding-left: 30px;">
							<div class="col-sm-10">
								<div class="radio radio-success radio-inline">
									<input type="radio" id="deductEnable1" value="1" ${appIssue.forceInstall ==true ? "checked":'' }
										name=forceInstall> <label for="deductEnable1">
										是</label>
								</div>
								<div class="radio radio-danger radio-inline">
									<input type="radio" id="deductEnable0" value="0"  ${appIssue.forceInstall ==false ? "checked":'' }
										name="forceInstall"> <label for="deductEnable0">
										否</label>
								</div>
							</div>
						</div>
				</div>
	
				
				<div class="form-group" style="margin-top:30px;">
					<label class="col-sm-2 control-label"></label>
					<div class="col-sm-10">
						<input type="hidden" name="id" value="${appIssue.id}">
						<button class="btn btn-white btn-cancel" type="button">取消</button>
						<button class="btn btn-w-m btn-success btn-submit" type="submit">确定</button>
					</div>
				</div>
			</form>
		</div>
	</div>

<%@ include  file="../scripts.jsp"%>


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
					if (res.code == "001") {
						validform.resetForm();
						parent.refreshCurrentTab();
						parent.layer.close(index);
					}else if (res.code == "00") {
					
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