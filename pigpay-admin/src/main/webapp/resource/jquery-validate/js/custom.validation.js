/*
 *2016-07-01
 *
 * 基于 jquery validation表单自定义验证
 *
 */


	// 邮政编码验证
	jQuery.validator.addMethod("isZipCode", function(value, element) {
	    var tel = /^[0-9]{6}$/;
	    return this.optional(element) || (tel.test(value));
	}, "请正确填写您的邮政编码");
	
	//手机号验证,验证 1 开头的是一位号码
	$.validator.addMethod('mobile', function( value, element ){
	    return this.optional( element ) || /^1\d{10}$/.test( value );
	}, '请输入正确的手机号码');
	//手机号和电话验证,验证 1 开头的是一位号码
	$.validator.addMethod('mobileOrphone', function( value, element ){
	    return this.optional( element ) || /^((\+?86)|(\(\+86\)))?\d{3,4}-\d{7,8}(-\d{3,4})?$|^((\+?86)|(\(\+86\)))?1\d{10}$/.test( value );
	}, '请输入正确的电话号码');
	
	//账号的校验
	$.validator.addMethod('account', function( value, element ){
	    return this.optional( element ) || /^[a-zA-Z\d]\w{5,19}[a-zA-Z\d]$/.test( value );
	}, '请输入正确的账号');
	
	//姓名的校验
	$.validator.addMethod('merchantName', function( value, element ){
	    return this.optional( element ) || /^[_a-zA-Z0-9\u4E00-\u9FA5]{2,10}$/.test( value );
	}, '请输入正确的名字');
	
	//验证底价维护不能小于100
	$.validator.addMethod('onehundred', function( value, element ){
		var returnVal = false;  
 
        var reg1 = /^\+?[1-9][0-9]*$/i;
        if(reg1.test(value) && parseInt(value) > 99){
        	returnVal= true;
        } 
        return returnVal; 
	}, '底价金额不能小于100请输入整数');
	
	//验证底价不能小于80
	$.validator.addMethod('Twenty', function( value, element ){
		var returnVal = false;  
 
		var reg1 = /^\+?[1-9][0-9]*$/i;
        if(reg1.test(value) && parseInt(value) > 79){
        	returnVal = true;
        } 
        return returnVal; 
	}, '底价金额不能小于80请输入整数');
	
	//验证底价不能小于80
	$.validator.addMethod('sixty', function( value, element ){
		var returnVal = false;  
 
		var reg1 = /^\+?[1-9][0-9]*$/i;
        if(reg1.test(value) && parseInt(value) > 79){
        	returnVal= true;
        } 
        return returnVal; 
	}, '底价金额不能小于80请输入整数');

	// 验证值小数位数不能超过两位
	$.validator.addMethod("decimal", function(value, element) {
	var decimal = /^-?\d+(\.\d{1,2})?$/;
	return (decimal.test(value));
	
	},"请输入整数或两位小数");
	
	
	//低价佣金验证
	$.validator.addMethod('recommend', function( value, element ){
		var returnVal = false;  
 
		var reg1 = /^\d+(\.\d+)?$/i;
        if(reg1.test(value) && parseInt(value) >= 0  && parseInt(value) < 100){
        	returnVal= true;
        } 
        return returnVal; 
	}, '0<=推荐佣金<100即可');//不能小于4%
	
	$.validator.addMethod('authentication', function( value, element ){
		var returnVal = false;  
 
		var reg1 = /^\d+(\.\d+)?$/i;
        if(reg1.test(value) && parseInt(value) >= 0  && parseInt(value) < 100){
        	returnVal= true;
        } 
        return returnVal; 
	}, '0<=认证佣金<100即可');//不能小于5%
	
	$.validator.addMethod('cooperation', function( value, element ){
		var returnVal = false;  
 
		var reg1 = /^\d+(\.\d+)?$/i;
        if(reg1.test(value) && parseInt(value) >= 0  && parseInt(value) < 100){
        	returnVal= true;
        } 
        return returnVal; 
	}, '0<=合作佣金<100即可');//不能小于6%

	