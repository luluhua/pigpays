<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include  file="../header.jsp"%>
<body style="margin:0;">
	<div class="wrap">
		<div class="wrap-content" style="padding:30px 60px">
			<form id="form" class="form-horizontal" action="${basePath }admin/system/changePassword">
                                <div class="form-group">
                                	<label class="col-lg-2 control-label" style="display: inline-block;width:120px;">原密码</label>
                                    <div class="col-lg-10" style="display: inline-block;"><input type="password" autocomplete="off" name="opwd" class="form-control" style="width:260px;"> </div>
                                </div>
                                <div class="form-group">
                                	<label class="col-lg-2 control-label" style="display: inline-block;width:120px;">新密码</label>
                                    <div class="col-lg-10" style="display: inline-block;"><input type="password" autocomplete="off" name="npwd" class="form-control" style="width:260px;"></div>
                                </div>
                                <div class="form-group">
                                	<label class="col-lg-2 control-label" style="display: inline-block;width:120px;">确认密码</label>
                                    <div class="col-lg-10" style="display: inline-block;"><input type="password" autocomplete="off" name="cpwd" class="form-control" style="width:260px;"></div>
                                </div>
                                
                                <div class="form-group">
                                	<label class="col-lg-2 control-label" style="display: inline-block;width:120px;"></label>
                                    <div class="col-lg-10" style="display: inline-block;">
                                    	<button class="btn btn-primary save" type="submit">修改密码</button>
                                    </div>
                                </div>
                            </form>
		</div>
	</div>
	
<%@ include  file="../scripts.jsp"%>
	<script type="text/javascript">
		$(function() {
			var index = parent.layer.getFrameIndex(window.name);
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
				
				var opwd = $("input[name=opwd]").val();
				if(!opwd) {
					layer.msg("请输入原密码");
					return;
				}
				
				var npwd = $("input[name=npwd]").val();
				if(!npwd) {
					layer.msg("请输入新密码");
					return;
				}
				
				var cpwd = $("input[name=cpwd]").val();
				if(npwd != cpwd) {
					layer.msg("两次输入的密码不一致");
					return;
				}
				
				
				$(".save").attr("disabled", true);
				var index1 = layer.load(2, {shade : 0.01,time : 0});
				var action = $(form).attr("action");
				var data = $(form).serialize();
				$.post(action, data, function(res) {
					$(".save").attr("disabled", false);
					layer.close(index1);
					parent.layer.msg(res.msg);
					if (res.code == 1) {
						setTimeout(function(){
							parent.layer.close(index);
							validform.resetForm();
							parent.location.reload(true);
						}, 300);
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
