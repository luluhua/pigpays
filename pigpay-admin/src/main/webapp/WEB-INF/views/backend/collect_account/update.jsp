<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include  file="../header.jsp"%>
<style type="text/css">
	.qq-upload-button {
		width: 110px;
    	padding: 8px 0;
	}
</style>
<body style="margin:0;padding:10px 30px;">
	<div class="wrap">
		<div class="wrap-content">
			<form id="form" style="margin:0;" method="post" class="form form-horizontal" action="${rootpath }admin/collect_account/save">
			                     
                                <div class="form-group filebox">
			                     	<label class="col-sm-2 control-label">客户端账户</label>
                                    <div class="col-sm-10">
			                         	<input type="text" class="form-control" name="name" value="${account.name}"/>
                                    </div>
                                </div>
                                
                                <div class="form-group filebox">
			                     	<label class="col-sm-2 control-label">登陆密码</label>
                                    <div class="col-sm-10">
			                         	<input type="password" class="form-control" name="pwd" />
                                    </div>
                                </div>
                                <div class="form-group filebox">
			                     	<label class="col-sm-2 control-label">确认密码</label>
                                    <div class="col-sm-10">
			                         	<input type="password" class="form-control" name="confirmpwd" />
                                    </div>
                                </div>
                                
                                <div class="form-group filebox">
			                     	<label class="col-sm-2 control-label">备注</label>
                                    <div class="col-sm-10">
			                         	<textarea type="text" class="form-control" name="remark">${account.remark }</textarea>
                                    </div>
                                </div>
                                
                                <c:forEach items="${channels }" var="channel">
                                	<div class="form-group filebox">
			                     	<label class="col-sm-2 control-label">${channel.channelName }</label>
                                    <div class="col-sm-10">
                                    	<input type="hidden" name="chnlid" value="${channel.id }">
                                    	<input type="hidden" name="status" id="status${channel.payType }" value="${channel.status }">
                                    	<div class="checkbox checkbox-inline checkbox-success">
                                            <input id="paymethod${channel.payType }" ${channel.status eq 1 ? 'checked':'' } value="${channel.payType }" name="paymethod" type="checkbox">
                                            <label for="paymethod${channel.payType }">${channel.payTypeName }</label>
                                    	</div>
                                    	<div style="display: inline-block;padding-left:30px;">
	                                    	收款金额范围
	                                    	<input name="collectMinLimit" value="${channel.collectMinLimit }" type="text" class="form-control" style="width:80px; display: inline-block;"> 至 <input name="collectMaxLimit" value="${channel.collectMaxLimit }" type="text" class="form-control" style="width:80px; display: inline-block;">
	                                    </div>
	                                    <div style="display: inline-block;padding-left:30px;">
	                                    	收款总限额
	                                    	<input value="${channel.collectTotalLimit }" name="collectTotalLimit" type="text" class="form-control" style="width:80px; display: inline-block;">
	                                    </div>
	                                    <span class="help-block m-b-none" style="color:red;">如果设置收款金额范围,则该通道只能接受指定金额内的订单,0表示不限制。</span>
                                    </div>
                                </div>
                                </c:forEach>
                                
                                <div class="form-group filebox">
			                     	<label class="col-sm-2 control-label">状态</label>
                                    <div class="col-sm-10">
			                         	<select name="status" class="form-control">
	                                    	<option value="1" ${account.status == '1' ? "selected" : "" }>正常收款</option>
	                                    	<option value="0" ${account.status == '0' ? "selected" : "" }>暂停收款</option>
	                                    	<option value="-1" ${account.status == '-1' ? "selected" : "" }>已禁用</option>
			                         	</select>
                                    </div>
                                </div>
                                
                                <div class="form-group">
                                    <div class="col-sm-10" style="margin-top:30px;padding-left:140px;">
                                    	<input type="hidden" name="id" value="${account.id }" />
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
				$("input[name=paymethod]").each(function(){
					var val = this.value;
					if(this.checked) {
						$("#status"+val).val(1);
					}else{
						$("#status"+val).val(0);
					}
				});
				var data = $(form).serialize();
				$.post(action, data, function(res) {
					$(".save").attr("disabled", false);
					layer.close(index1);
					parent.layer.msg(res.msg);
					if (res.code == "00") {
						validform.resetForm();
						//parent.refreshCurrentTab();
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
