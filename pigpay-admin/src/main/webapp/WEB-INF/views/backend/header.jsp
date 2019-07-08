<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include  file="baseUtil.jsp"%>
<!DOCTYPE html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">
<title>一闪支付 - 商户中心</title>
<link href="${rootpath }assets/css/bootstrap.min.css" rel="stylesheet">
<link href="${rootpath }assets/font-awesome/css/font-awesome.min.css" rel="stylesheet">
<link href="${rootpath }resource/zTree/css/zTreeStyle/zTreeStyle.css" rel="stylesheet" type="text/css">
<link href="${rootpath }assets/css/animate.css" rel="stylesheet">

<link href="${rootpath }assets/css/plugins/dataTables/datatables.min.css" rel="stylesheet">
<link href="${rootpath }assets/css/plugins/awesome-bootstrap-checkbox/awesome-bootstrap-checkbox.css" rel="stylesheet">
<link href="${rootpath }assets/css/plugins/datapicker/datepicker3.css" rel="stylesheet">
<link href="${rootpath }assets/css/plugins/daterangepicker/daterangepicker-bs3.css" rel="stylesheet">
<link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/bootstrap-table/1.12.1/bootstrap-table.min.css">

<link href="${rootpath}assets/validform/validform.css" rel="stylesheet" >
<link href="${rootpath }assets/css/fileuploader.css" rel="stylesheet">
<link href="${rootpath }assets/css/style.css" rel="stylesheet">
<link href="${rootpath }assets/css/custom.css" rel="stylesheet">
<script type="text/javascript">
	var rootpath = "${rootpath}";
	var basePath = "${basePath}";

	Date.prototype.format = function (fmt) {
	    var o = {
	        "M+": this.getMonth() + 1, //月份 
	        "d+": this.getDate(), //日 
	        "h+": this.getHours(), //小时 
	        "m+": this.getMinutes(), //分 
	        "s+": this.getSeconds(), //秒 
	        "q+": Math.floor((this.getMonth() + 3) / 3), //季度 
	        "S": this.getMilliseconds() //毫秒 
	    };
	    if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
	    for (var k in o)
	    if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
	    return fmt;
	}

	
</script>
</head>