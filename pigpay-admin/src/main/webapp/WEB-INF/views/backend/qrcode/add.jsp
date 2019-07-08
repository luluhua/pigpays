<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include  file="../header.jsp"%>
<style type="text/css">
	.qq-upload-button {
		width: 110px;
    	padding: 8px 0;
	}
</style>
<body style="margin:0;padding:10px 30px;position: relative;">
	<div class="wrap">
		<div class="wrap-content">
			<form id="form" style="margin:0;" method="post" class="form form-horizontal" action="${rootpath }admin/p2_qrcode/save">
				<div class="table-responsive" style="padding-bottom:60px;">
					<div>
						<span style="float:left;color:red;">请上传${channel.channelName}, 账户【${channel.channelAccount}】的二维码.</span><a style="float:right;margin-bottom:10px;" id="fileUpload">上传</a>
					</div>
					<table class="table table-bordered table-stripped">
						<thead>
							<tr>
								<th>二维码</th>
								<th>面值</th>
								<th>备注</th>
								<th>操作</th>
							</tr>
						</thead>
						<tbody class="qrlist">
						</tbody>
					</table>
				</div>
			</form>

			<div class="form-group" style="position: fixed; bottom: 0; margin:0;width:100%;background: #fff">
				<div class="col-sm-12" style="margin-top: 30px;margin-bottom: 10px; padding-right:100px;text-align: right;">
					<button class="btn btn-white btn-cancel" type="button">取消</button>
					<button class="btn btn-w-m btn-success btn-submit" type="submit">确定</button>
				</div>
			</div>

		</div>
	</div>
	
<%@ include  file="../scripts.jsp"%>
	<script type="text/javascript">
		$(function() {
			var index = parent.layer.getFrameIndex(window.name);
			var channelId = ${channel.id};
			var payType = ${channel.payType};
			$("body").niceScroll({
				cursorcolor : "#ccc",
				cursorwidth : "10px"
			});
			
			// 文件上传
			function fileUploader(o) {
				new qq.FileUploader(
						{
							element : o[0],
							action : basePath + 'admin/collect_qrcode/upload',
							params : {channelId: channelId, payType:payType},
							uploadButtonText : '上传文件',
							listElement : false,
							forceMultipart : true,
							multiple : true,
							//sizeLimit:104857*20,
							allowedExtensions: ['jpg', 'png', 'gif'],
							onSubmit : function(id, fileName) {
							},
							onComplete : function(id, fileName, res) {
								console.log(res);
								if (res.success) {
									if(res.data && res.data.length > 0) {
										var html = [];
										for (var i = 0; i < res.data.length; i++) {
											var item = res.data[i];
											var qrcode = item.qrcode;
											if(qrcode && qrcode.qrtext){
												html.push('<tr>');
												html.push('<td>');
												html.push('<img style=\"width:300px;\" src=\"' + basePath +item.path+'\"/>');
												html.push('<input type=\"hidden\" class=\"form-control\" value=\"'+item.path+'\">');
												html.push('<input type=\"hidden\" class=\"form-control\" value=\"'+(qrcode.qrtext||'')+'\">');
												html.push('</td>');
												html.push('<td>');
												html.push('<input type=\"text\" style=\"width:120px;\" class=\"form-control\" value=\"'+(qrcode.money||'')+'\">');
												html.push('</td>');
												html.push('<td>');
												html.push('<input type=\"text\" style=\"width:160px;\" class=\"form-control\" value=\"'+(qrcode.remark||'')+'\">');
												html.push('</td>');
												html.push('<td>');
												html.push('<i style=\"cursor:pointer\" class="fa fa-trash"></i>');
												html.push('</td>');
												html.push('</tr>');
											}else {
												layer.msg('二维码图片['+fileName+']识别无效,请更换！');
											}
										}
										console.log(html.join(''));
										$(".qrlist").append(html.join(''));
									}
								}
							},
							onCancel : function(id, fileName) {
							},

							onUpload : function(id, fileName, xhr) {

							},
							onProgress : function(id, fileName, loaded, total) {
							},
							onError : function(id, fileName, reason) {

							},
							messages : {
								typeError : "{file} 不允许的文件类型.",
								sizeError : "{file} 文件太大, 只允许上传最大{sizeLimit}的文件.",
								minSizeError : "{file} 文件太小, 不允许上传小于{minSizeLimit}的文件.",
								emptyError : "{file}文件为空,请重新选择文件.",
								noFilesError : "没有选择文件.",
								onLeave : "正在上传文件,你确定要取消吗?."
							},
							showMessage : function(message) {
								layer.msg(message);
							}
						});
			}

			fileUploader($("#fileUpload"));
			
			

			function subitForm() {
				var index1 = layer.load(2, {
					shade : 0.01,
					time : 0
				});
				
				var dataList = [];
				
				$(".qrlist tr").each(function(){
					var inputs = $(this).find("input");
					var path   = inputs.eq(0).val();
					var qrtext   = inputs.eq(1).val();
					var money  =inputs.eq(2).val();
					var remark = inputs.eq(3).val();
					dataList.push({qrcodeUrl: path,qrcodeData: qrtext, money: money, remark: remark});
				});
				
				if(dataList.length == 0) {
					parent.layer.alert("请上传二维码");
					layer.close(index1);
					return;
				}
				
				
				for (var i = 0; i < dataList.length; i++) {
					var data = dataList[i];
					if(!data.qrcodeUrl) {
						parent.layer.alert("二维码不能为空");
						layer.close(index1);
						return;
					}
					if(!data.qrcodeData){
						parent.layer.alert("二维码内容无效");
						layer.close(index1);
						return;
					}
					if(!data.money) {
						parent.layer.alert("面值不能为空");
						layer.close(index1);
						return;
					}
				}
				
				
				$.post(basePath + "admin/collect_qrcode/saveAll", {channelId: channelId, data: JSON.stringify(dataList)}, function(res) {
					layer.close(index1);
					parent.layer.msg(res.msg);
					if (res.code == "00") {
						parent.layer.close(index);
					}

				}, 'json');
			}

			$(".btn-submit").click(function() {
				subitForm()
			});

			$(".btn-cancel").click(function() {
				parent.layer.close(index);
			});
			
			$(document).on("click", ".qrlist .fa-trash", function(){
				var object = $(this).parent().parent();
				var inputs = object.find("input");
				var path   = inputs.eq(0).val();
				$.post(basePath + "admin/collect_qrcode/deleteQrcodeFile", {path: path}, function(res){
					if(res.code == 1) {
						object.remove();
					}
				}, "json");
				
			});

		});
	</script>
</body>
</html>
