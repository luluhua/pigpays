<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include  file="../header.jsp"%>
<body style="margin:0;">
	<div class="wrap"  style="margin:0 auto;">
		<div class="wrap-content" style="padding:30px;">
			<form id="form" method="post" class="form form-horizontal" action="${rootpath }admin/sysconfig/save">
                                
                                <div class="form-group">
                                	<label class="col-sm-4 control-label">提现手续费率</label>
                                    <div class="col-sm-8">
                                    	<input type="text" name="withdraw-feerate" value="${conf['withdraw-feerate']}" autocomplete="off" class="form-control" style="display: inline-block; width:200px;"><span>%</span>
                                    	<span class="help-block m-b-none">
                                    	提现手续费率,用于设置提现时费率的计算方式,0为无手续费。
                                    	</span>
                                    </div>
                                </div>
                                <div class="hr-line-dashed" style="margin:30px 10px"></div>
                                <div class="form-group">
                                	<label class="col-sm-4 control-label">支付通道分配方式</label>
                                    <div class="col-sm-8">
                                    	<select name="pay_dispatch_type" class="form-control">
                                    		<option value="0" ${conf['pay_dispatch_type'] == '0' ? 'selected':'' }>最少金额</option>
                                    		<option value="1" ${conf['pay_dispatch_type'] == '1' ? 'selected':'' }>随机分配</option>
                                    		<option value="2" ${conf['pay_dispatch_type'] == '2' ? 'selected':'' }>轮询分配</option>
                                    	</select>
                                    	<span class="help-block m-b-none">
                                    	</span>
                                    </div>
                                </div>
                                <div class="hr-line-dashed" style="margin:30px 10px"></div>
                                 <div class="form-group">
                                	<label class="col-sm-4 control-label">商户充值金额额度</label>
                                    <div class="col-sm-8">
                                    	<input type="text" name="prepaid_phone_lines" value="${conf['prepaid_phone_lines']}" autocomplete="off" class="form-control" style="display: inline-block; width:600px;">
                                    	<span class="help-block m-b-none">
                                    	商户充值页面充值金额选项，多个金额时用英文 “,” 隔开。
                                    	</span>
                                    </div>
                                </div>
                                
                                
                                <div class="hr-line-dashed" style="margin:30px 10px"></div>
                                <div class="form-group">
                                    <div class="col-sm-4 col-sm-offset-2">
                                        <button class="btn btn-w-m btn-success btn-submit" type="submit">保存配置</button>
                                    </div>
                                </div> 
            </form>
		</div>
	</div>
	
<%@ include  file="../scripts.jsp"%>
	<script type="text/javascript">
		$(function() {
			var index = parent.layer.getFrameIndex(window.name);
			$("body").niceScroll({cursorcolor:"#ccc",cursorwidth:"10px"});
			
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
