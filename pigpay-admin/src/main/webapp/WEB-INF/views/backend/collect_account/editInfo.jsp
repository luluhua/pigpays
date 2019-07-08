<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include  file="../header.jsp"%>
<body style="margin:0;">
	<div class="wrap">
		<div class="wrap-content">
			<form id="form" style="margin:0;padding:30px;" method="post" class="form form-horizontal" action="${rootpath }admin/collect_account/editInfo">
               <div class="form-group">
               		<input type="hidden" name="id" value="${record.id }" />
                   	<input type="text" style="width:260px;float:left;" class="form-control" value="${record[field] }" name="${field }">
                   	<button style="float:left;margin-left:10px;" class="btn btn-sm btn-success btn-submit" type="submit">保存</button>
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
				$(".save").attr("disabled", true);
				var index1 = layer.load(2, {shade : 0.01,time : 0});
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
